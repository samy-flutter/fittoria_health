import '../../data/models/ai_log_model.dart';

abstract class AiNutritionState {}

class AiNutritionInitial extends AiNutritionState {}

class AiNutritionLoading extends AiNutritionState {}

class AiNutritionLoaded extends AiNutritionState {
  final List<AiLog> logs;
  final bool isEstimating;
  final AiLog? lastResult;

  AiNutritionLoaded({
    required this.logs,
    this.isEstimating = false,
    this.lastResult,
  });

  AiNutritionLoaded copyWith({
    List<AiLog>? logs,
    bool? isEstimating,
    AiLog? lastResult,
    bool clearResult = false,
  }) {
    return AiNutritionLoaded(
      logs: logs ?? this.logs,
      isEstimating: isEstimating ?? this.isEstimating,
      lastResult: clearResult ? null : (lastResult ?? this.lastResult),
    );
  }
}

class AiNutritionError extends AiNutritionState {
  final String message;
  AiNutritionError(this.message);
}
