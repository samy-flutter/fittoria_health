import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/ai_log_model.dart';

abstract class AiNutritionRepository {
  Future<Either<Failure, List<AiLog>>> getLogs();
  Future<Either<Failure, AiLog>> estimateAndLog(String foodName, String? imageUrl, String mealType);
}
