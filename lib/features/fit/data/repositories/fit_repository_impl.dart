import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/fit_repository.dart';
import '../models/fit_models.dart';

class FitRepositoryImpl implements FitRepository {
  List<ActivityLog> _activityLogs = [
    ActivityLog(steps: 6500, distanceKm: 4.2, caloriesKcal: 310, activeMinutes: 45, logDate: DateTime.now().subtract(const Duration(days: 0))),
    ActivityLog(steps: 8200, distanceKm: 5.5, caloriesKcal: 400, activeMinutes: 55, logDate: DateTime.now().subtract(const Duration(days: 1))),
    ActivityLog(steps: 10500, distanceKm: 7.1, caloriesKcal: 520, activeMinutes: 75, logDate: DateTime.now().subtract(const Duration(days: 2))),
    ActivityLog(steps: 4000, distanceKm: 2.5, caloriesKcal: 180, activeMinutes: 20, logDate: DateTime.now().subtract(const Duration(days: 3))),
    ActivityLog(steps: 12000, distanceKm: 8.5, caloriesKcal: 600, activeMinutes: 90, logDate: DateTime.now().subtract(const Duration(days: 4))),
  ];

  List<HeartRateReading> _heartRateReadings = [
    HeartRateReading(id: 1, bpm: 72, readingType: 'resting', measuredAt: DateTime.now().subtract(const Duration(hours: 1))),
    HeartRateReading(id: 2, bpm: 120, readingType: 'active', measuredAt: DateTime.now().subtract(const Duration(hours: 5))),
    HeartRateReading(id: 3, bpm: 85, readingType: 'spot', measuredAt: DateTime.now().subtract(const Duration(hours: 10))),
    HeartRateReading(id: 4, bpm: 68, readingType: 'resting', measuredAt: DateTime.now().subtract(const Duration(hours: 24))),
    HeartRateReading(id: 5, bpm: 145, readingType: 'active', measuredAt: DateTime.now().subtract(const Duration(hours: 28))),
  ];

  List<SleepLog> _sleepLogs = [
    SleepLog(id: 1, date: DateTime.now().subtract(const Duration(days: 1)), durationFormatted: '7h 15m', totalMinutes: 435, remMinutes: 90, lightMinutes: 210, deepMinutes: 105, awakeMinutes: 30),
    SleepLog(id: 2, date: DateTime.now().subtract(const Duration(days: 2)), durationFormatted: '6h 45m', totalMinutes: 405, remMinutes: 80, lightMinutes: 200, deepMinutes: 90, awakeMinutes: 35),
    SleepLog(id: 3, date: DateTime.now().subtract(const Duration(days: 3)), durationFormatted: '8h 10m', totalMinutes: 490, remMinutes: 110, lightMinutes: 220, deepMinutes: 140, awakeMinutes: 20),
    SleepLog(id: 4, date: DateTime.now().subtract(const Duration(days: 4)), durationFormatted: '5h 30m', totalMinutes: 330, remMinutes: 60, lightMinutes: 180, deepMinutes: 60, awakeMinutes: 30),
    SleepLog(id: 5, date: DateTime.now().subtract(const Duration(days: 5)), durationFormatted: '7h 30m', totalMinutes: 450, remMinutes: 100, lightMinutes: 210, deepMinutes: 120, awakeMinutes: 20),
  ];

  @override
  Future<Either<Failure, ActivityData>> getActivity({required String range}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    int totalSteps = _activityLogs.fold(0, (sum, item) => sum + item.steps);
    double totalDistance = _activityLogs.fold(0.0, (sum, item) => sum + item.distanceKm);
    int totalCalories = _activityLogs.fold(0, (sum, item) => sum + item.caloriesKcal);
    int totalActiveMinutes = _activityLogs.fold(0, (sum, item) => sum + item.activeMinutes);

    return Right(ActivityData(
      totals: ActivityLog(steps: totalSteps, distanceKm: totalDistance, caloriesKcal: totalCalories, activeMinutes: totalActiveMinutes, logDate: DateTime.now()),
      series: _activityLogs,
    ));
  }

  @override
  Future<Either<Failure, void>> logActivity(ActivityLog log) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _activityLogs.insert(0, log);
    return const Right(null);
  }

  @override
  Future<Either<Failure, HeartRateData>> getHeartRate() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return Right(HeartRateData(
      stats: HeartRateStats(restingBpm: 68, avgBpm: 75, maxBpm: 155),
      readings: _heartRateReadings,
    ));
  }

  @override
  Future<Either<Failure, void>> logHeartRate(int bpm, String readingType) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _heartRateReadings.insert(0, HeartRateReading(
      id: DateTime.now().millisecondsSinceEpoch,
      bpm: bpm,
      readingType: readingType,
      measuredAt: DateTime.now(),
    ));
    return const Right(null);
  }

  @override
  Future<Either<Failure, SleepData>> getSleep() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return Right(SleepData(
      avgDuration: '7h 2m',
      sleepScore: '84',
      history: _sleepLogs,
    ));
  }

  @override
  Future<Either<Failure, void>> logSleep(DateTime date, int total, int rem, int light, int deep, int awake) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final hours = total ~/ 60;
    final minutes = total % 60;
    _sleepLogs.insert(0, SleepLog(
      id: DateTime.now().millisecondsSinceEpoch,
      date: date,
      durationFormatted: '${hours}h ${minutes}m',
      totalMinutes: total,
      remMinutes: rem,
      lightMinutes: light,
      deepMinutes: deep,
      awakeMinutes: awake,
    ));
    return const Right(null);
  }
}
