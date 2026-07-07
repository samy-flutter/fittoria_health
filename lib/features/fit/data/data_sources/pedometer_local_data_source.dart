import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/fit_models.dart';

abstract class LocalActivityDataSource {
  Future<bool> requestPermissions();
  Future<ActivityData?> getActivityData();
  Stream<ActivityData> watchActivityData();
}

class PedometerLocalDataSourceImpl implements LocalActivityDataSource {
  final SharedPreferences _prefs;
  Stream<StepCount>? _sharedStream;
  
  PedometerLocalDataSourceImpl(this._prefs);

  @override
  Future<bool> requestPermissions() async {
    PermissionStatus status = await Permission.activityRecognition.request();
    return status == PermissionStatus.granted;
  }

  @override
  Future<ActivityData?> getActivityData() async {
    final hasPermission = await requestPermissions();
    if (!hasPermission) return null;

    try {
      final stepCount = await _getSingleStepCount();
      if (stepCount == null) return null;

      final now = DateTime.now();
      final todayKey = 'steps_start_${now.year}_${now.month}_${now.day}';
      
      int baseline = _prefs.getInt(todayKey) ?? -1;
      
      // If we don't have a baseline for today or if the device rebooted (stepCount.steps < baseline)
      if (baseline == -1 || stepCount.steps < baseline) {
        baseline = stepCount.steps;
        await _prefs.setInt(todayKey, baseline);
      }

      int stepsToday = stepCount.steps - baseline;
      
      // Prevent negative steps just in case
      if (stepsToday < 0) stepsToday = 0;

      // Create synthetic metrics
      final distanceKm = stepsToday * 0.000762;
      final caloriesKcal = (stepsToday * 0.04).toInt();
      final activeMinutes = stepsToday * 0.01;

      return ActivityData(
        totals: ActivityLog(
          steps: stepsToday,
          distanceKm: distanceKm,
          caloriesKcal: caloriesKcal,
          activeMinutes: activeMinutes,
          logDate: now,
        ),
        // Pedometer doesn't provide history natively, so we just return today's data as a single series point
        series: [
          ActivityLog(
            steps: stepsToday,
            distanceKm: distanceKm,
            caloriesKcal: caloriesKcal,
            activeMinutes: activeMinutes,
            logDate: now,
          )
        ],
      );
    } catch (e) {
      return null;
    }
  }

  Future<StepCount?> _getSingleStepCount() async {
    try {
      _sharedStream ??= Pedometer.stepCountStream.asBroadcastStream();
      return await _sharedStream!.first.timeout(const Duration(seconds: 2));
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<ActivityData> watchActivityData() async* {
    final hasPermission = await requestPermissions();
    if (!hasPermission) return;

    _sharedStream ??= Pedometer.stepCountStream.asBroadcastStream();

    final now = DateTime.now();
    final todayKey = 'steps_start_${now.year}_${now.month}_${now.day}';
    final latestKey = 'steps_latest';

    int baseline = _prefs.getInt(todayKey) ?? -1;
    int latestSteps = _prefs.getInt(latestKey) ?? baseline;

    ActivityData createActivityData(int currentSteps) {
      if (baseline == -1 || currentSteps < baseline) {
        baseline = currentSteps;
        _prefs.setInt(todayKey, baseline);
      }
      
      _prefs.setInt(latestKey, currentSteps);

      int stepsToday = currentSteps - baseline;
      if (stepsToday < 0) stepsToday = 0;

      final distanceKm = stepsToday * 0.000762;
      final caloriesKcal = (stepsToday * 0.04).toInt();
      final activeMinutes = stepsToday * 0.01;

      // Save today's total
      final todayTotalKey = 'steps_total_${now.year}_${now.month}_${now.day}';
      _prefs.setInt(todayTotalKey, stepsToday);

      // Generate 7-day series
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

      // Add today
      series.add(ActivityLog(
        steps: stepsToday,
        distanceKm: distanceKm,
        caloriesKcal: caloriesKcal,
        activeMinutes: activeMinutes,
        logDate: now,
      ));

      return ActivityData(
        totals: ActivityLog(
          steps: stepsToday,
          distanceKm: distanceKm,
          caloriesKcal: caloriesKcal,
          activeMinutes: activeMinutes,
          logDate: now,
        ),
        series: series,
      );
    }

    // Yield cached value instantly if we have one, otherwise yield 0
    yield createActivityData(latestSteps != -1 ? latestSteps : 0);

    yield* _sharedStream!.map((stepCount) {
      return createActivityData(stepCount.steps);
    });
  }
}
