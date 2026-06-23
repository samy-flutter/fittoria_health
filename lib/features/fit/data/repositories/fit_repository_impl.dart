import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/fit_repository.dart';
import '../models/fit_models.dart';
import '../data_sources/pedometer_local_data_source.dart';

class FitRepositoryImpl implements FitRepository {
  final LocalActivityDataSource healthDataSource;

  FitRepositoryImpl({required this.healthDataSource});

  final List<HeartRateReading> _heartRateReadings = [
    HeartRateReading(id: 1, bpm: 72, readingType: 'resting', measuredAt: DateTime.now().subtract(const Duration(hours: 1))),
    HeartRateReading(id: 2, bpm: 120, readingType: 'active', measuredAt: DateTime.now().subtract(const Duration(hours: 5))),
    HeartRateReading(id: 3, bpm: 85, readingType: 'spot', measuredAt: DateTime.now().subtract(const Duration(hours: 10))),
    HeartRateReading(id: 4, bpm: 68, readingType: 'resting', measuredAt: DateTime.now().subtract(const Duration(hours: 24))),
    HeartRateReading(id: 5, bpm: 145, readingType: 'active', measuredAt: DateTime.now().subtract(const Duration(hours: 28))),
  ];

  final List<SleepLog> _sleepLogs = [
    SleepLog(id: 1, date: DateTime.now().subtract(const Duration(days: 1)), durationFormatted: '7h 15m', totalMinutes: 435, remMinutes: 90, lightMinutes: 210, deepMinutes: 105, awakeMinutes: 30),
    SleepLog(id: 2, date: DateTime.now().subtract(const Duration(days: 2)), durationFormatted: '6h 45m', totalMinutes: 405, remMinutes: 80, lightMinutes: 200, deepMinutes: 90, awakeMinutes: 35),
    SleepLog(id: 3, date: DateTime.now().subtract(const Duration(days: 3)), durationFormatted: '8h 10m', totalMinutes: 490, remMinutes: 110, lightMinutes: 220, deepMinutes: 140, awakeMinutes: 20),
    SleepLog(id: 4, date: DateTime.now().subtract(const Duration(days: 4)), durationFormatted: '5h 30m', totalMinutes: 330, remMinutes: 60, lightMinutes: 180, deepMinutes: 60, awakeMinutes: 30),
    SleepLog(id: 5, date: DateTime.now().subtract(const Duration(days: 5)), durationFormatted: '7h 30m', totalMinutes: 450, remMinutes: 100, lightMinutes: 210, deepMinutes: 120, awakeMinutes: 20),
  ];

  @override
  Future<Either<Failure, ActivityData>> getActivity({required String range}) async {
    try {
      final data = await healthDataSource.getActivityData();
      if (data == null) {
        return Left(ServerFailure("Could not fetch activity data."));
      }

      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logActivity(ActivityLog log) async {
    // Note: Health Connect doesn't easily allow raw writes of complex aggregated logs without multiple granular data points.
    // This is currently a stub for manual entry.
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
