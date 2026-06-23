import '../../../../core/error/exception_handler.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/ai_nutrition_repository.dart';
import '../models/ai_log_model.dart';

class AiNutritionRepositoryImpl implements AiNutritionRepository {
  final List<AiLog> _mockLogs = [
    AiLog(
      id: 1,
      imageUrl: null,
      detectedFood: 'oatmeal with berries',
      estCalories: 320,
      estProteinG: 8,
      estCarbsG: 55,
      estFatG: 6,
      confidence: 85,
      loggedAt: DateTime.now().toIso8601String(),
    )
  ];

  @override
  Future<Either<Failure, List<AiLog>>> getLogs() async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      return Right(List.from(_mockLogs));
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, AiLog>> estimateAndLog(String foodName, String? imageUrl, String mealType) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1200));
      final newLog = AiLog(
        id: DateTime.now().millisecondsSinceEpoch,
        imageUrl: imageUrl,
        detectedFood: foodName.toLowerCase(),
        estCalories: 450,
        estProteinG: 25,
        estCarbsG: 40,
        estFatG: 15,
        confidence: 92,
        loggedAt: DateTime.now().toIso8601String(),
      );
      _mockLogs.insert(0, newLog);
      return Right(newLog);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }
}
