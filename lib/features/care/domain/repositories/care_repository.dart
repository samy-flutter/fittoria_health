import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/gym_model.dart';
import '../../data/models/fitness_details_model.dart';
import '../../data/models/nutrition_details_model.dart';
import '../../data/models/meetings_model.dart';

abstract class CareRepository {
  Future<Either<Failure, GymData>> getGymData();
  Future<Either<Failure, FitnessDetailsData>> getFitnessDetails();
  Future<Either<Failure, NutritionDetailsData>> getNutritionDetails();
  Future<Either<Failure, MeetingsData>> getMeetingsData();
}
