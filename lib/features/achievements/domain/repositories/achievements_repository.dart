import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/achievement_models.dart';

abstract class AchievementsRepository {
  Future<Either<Failure, AchievementsData>> getAchievementsData();
}
