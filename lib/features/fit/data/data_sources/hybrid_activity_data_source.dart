import 'dart:async';
import 'package:health/health.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/fit_models.dart';
import 'pedometer_local_data_source.dart';

class HybridActivityDataSourceImpl implements LocalActivityDataSource {
  final SharedPreferences _prefs;
  final Health _health = Health();
  Stream<StepCount>? _sharedStream;

  HybridActivityDataSourceImpl(this._prefs);

  @override
  Future<bool> requestPermissions() async {
    var status = await Permission.activityRecognition.status;
    if (status.isDenied) {
      status = await Permission.activityRecognition.request();
    }
    return status.isGranted;
  }

  Future<ActivityData?> _fetchHealthApiData() async {
    try {
      _health.configure();
      final types = [HealthDataType.STEPS];
      bool requested = await _health.requestAuthorization(types);
      
      if (!requested) {
        print('Health API permission not granted');
        return null;
      }

      final now = DateTime.now();
      // Fetch the last 7 days of data
      final midnightToday = DateTime(now.year, now.month, now.day);
      final startTime = midnightToday.subtract(const Duration(days: 6));
      
      List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
        startTime: startTime,
        endTime: now,
        types: types,
      );

      healthData = Health().removeDuplicates(healthData);

      // Group steps by day
      final Map<DateTime, int> stepsByDay = {};
      for (int i = 0; i < 7; i++) {
        stepsByDay[midnightToday.subtract(Duration(days: i))] = 0;
      }

      for (var point in healthData) {
        final date = DateTime(point.dateFrom.year, point.dateFrom.month, point.dateFrom.day);
        if (stepsByDay.containsKey(date)) {
          final value = point.value as NumericHealthValue;
          stepsByDay[date] = stepsByDay[date]! + value.numericValue.toInt();
        }
      }

      final List<ActivityLog> series = [];
      int todaySteps = 0;

      for (int i = 6; i >= 0; i--) {
        final d = midnightToday.subtract(Duration(days: i));
        final steps = stepsByDay[d] ?? 0;
        
        if (i == 0) todaySteps = steps;

        series.add(ActivityLog(
          steps: steps,
          distanceKm: steps * 0.000762,
          caloriesKcal: (steps * 0.04).toInt(),
          activeMinutes: steps * 0.01,
          logDate: d,
        ));
      }

      return ActivityData(
        totals: ActivityLog(
          steps: todaySteps,
          distanceKm: todaySteps * 0.000762,
          caloriesKcal: (todaySteps * 0.04).toInt(),
          activeMinutes: todaySteps * 0.01,
          logDate: now,
        ),
        series: series,
      );

    } catch (e) {
      print('Error fetching Health API data: $e');
      return null;
    }
  }

  @override
  Future<ActivityData?> getActivityData() async {
    final stream = watchActivityData();
    return await stream.first;
  }

  @override
  Stream<ActivityData> watchActivityData() async* {
    final hasPedometerPermission = await requestPermissions();
    if (!hasPedometerPermission) return;

    // 1. Attempt to get historical data from Health Connect / HealthKit
    ActivityData? healthApiData = await _fetchHealthApiData();

    // 2. Setup the real-time hardware stream
    _sharedStream ??= Pedometer.stepCountStream.asBroadcastStream();

    final now = DateTime.now();
    final todayKey = 'steps_start_${now.year}_${now.month}_${now.day}';
    final latestKey = 'steps_latest';

    int hardwareBaseline = _prefs.getInt(todayKey) ?? -1;
    int latestHardwareSteps = _prefs.getInt(latestKey) ?? hardwareBaseline;

    // If Health API failed, we fallback entirely to local tracking
    if (healthApiData == null) {
      ActivityData createFallbackActivityData(int currentHardwareSteps) {
        if (hardwareBaseline == -1 || currentHardwareSteps < hardwareBaseline) {
          hardwareBaseline = currentHardwareSteps;
          _prefs.setInt(todayKey, hardwareBaseline);
        }
        _prefs.setInt(latestKey, currentHardwareSteps);

        int stepsToday = currentHardwareSteps - hardwareBaseline;
        if (stepsToday < 0) stepsToday = 0;

        final todayTotalKey = 'steps_total_${now.year}_${now.month}_${now.day}';
        _prefs.setInt(todayTotalKey, stepsToday);

        final List<ActivityLog> series = [];
        for (int i = 6; i >= 1; i--) {
          final d = now.subtract(Duration(days: i));
          final k = 'steps_total_${d.year}_${d.month}_${d.day}';
          final steps = _prefs.getInt(k) ?? 0;
          series.add(ActivityLog(
            steps: steps,
            distanceKm: steps * 0.000762,
            caloriesKcal: (steps * 0.04).toInt(),
            activeMinutes: steps * 0.01,
            logDate: d,
          ));
        }

        series.add(ActivityLog(
          steps: stepsToday,
          distanceKm: stepsToday * 0.000762,
          caloriesKcal: (stepsToday * 0.04).toInt(),
          activeMinutes: stepsToday * 0.01,
          logDate: now,
        ));

        return ActivityData(
          totals: series.last,
          series: series,
        );
      }

      yield createFallbackActivityData(latestHardwareSteps != -1 ? latestHardwareSteps : 0);
      yield* _sharedStream!.map((stepCount) => createFallbackActivityData(stepCount.steps));
      return;
    }

    // 3. Health API Succeeded!
    // We have beautiful history. We yield it immediately.
    yield healthApiData;

    // 4. Now we merge real-time hardware pedometer deltas on top of today's Health API data!
    final int baseHealthStepsToday = healthApiData.totals.steps;
    
    // We establish a hardware baseline at the moment we fetched the Health API data
    if (hardwareBaseline == -1 && latestHardwareSteps != -1) {
       hardwareBaseline = latestHardwareSteps; // We don't overwrite if it exists, to prevent jumping
    }

    ActivityData createMergedActivityData(int currentHardwareSteps) {
      if (hardwareBaseline == -1 || currentHardwareSteps < hardwareBaseline) {
        hardwareBaseline = currentHardwareSteps;
      }
      _prefs.setInt(latestKey, currentHardwareSteps);

      int hardwareDeltaToday = currentHardwareSteps - hardwareBaseline;
      if (hardwareDeltaToday < 0) hardwareDeltaToday = 0;

      // The true steps today is what Health Connect told us PLUS any steps taken right now
      int liveStepsToday = baseHealthStepsToday + hardwareDeltaToday;

      final List<ActivityLog> updatedSeries = List.from(healthApiData.series);
      updatedSeries[updatedSeries.length - 1] = ActivityLog(
        steps: liveStepsToday,
        distanceKm: liveStepsToday * 0.000762,
        caloriesKcal: (liveStepsToday * 0.04).toInt(),
        activeMinutes: liveStepsToday * 0.01,
        logDate: now,
      );

      return ActivityData(
        totals: updatedSeries.last,
        series: updatedSeries,
      );
    }

    yield* _sharedStream!.map((stepCount) => createMergedActivityData(stepCount.steps));
  }
}
