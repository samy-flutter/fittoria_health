import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/fit_models.dart';

abstract class FitRepository {
  Future<Either<Failure, ActivityData>> getActivity({required String range});
  Stream<Either<Failure, ActivityData>> watchActivity({required String range});
  Future<Either<Failure, void>> logActivity(ActivityLog log);

  Future<Either<Failure, HeartRateData>> getHeartRate();
  Future<Either<Failure, void>> logHeartRate(int bpm, String readingType);

  Future<Either<Failure, SleepData>> getSleep();
  Future<Either<Failure, void>> logSleep(DateTime date, int total, int rem, int light, int deep, int awake);
}
