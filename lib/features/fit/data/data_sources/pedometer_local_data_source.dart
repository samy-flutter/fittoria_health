import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/fit_models.dart';

abstract class LocalActivityDataSource {
  Future<bool> requestPermissions();
  Future<ActivityData?> getActivityData();
}

class PedometerLocalDataSourceImpl implements LocalActivityDataSource {
  final SharedPreferences _prefs;
  
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
      final activeMinutes = (stepsToday * 0.01).toInt();

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
      // Pedometer streams the current value almost immediately upon subscription
      return await Pedometer.stepCountStream.first.timeout(const Duration(seconds: 2));
    } catch (e) {
      return null;
    }
  }
}
