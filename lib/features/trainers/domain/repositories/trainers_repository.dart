import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/trainer_models.dart';

abstract class TrainersRepository {
  Future<Either<Failure, List<Trainer>>> getTrainers({String query = ''});
  Future<Either<Failure, void>> bookTrainer(int trainerId, String sessionType, DateTime scheduledAt, String notes);
}


