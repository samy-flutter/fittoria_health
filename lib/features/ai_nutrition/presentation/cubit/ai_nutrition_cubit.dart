import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/ai_nutrition_repository.dart';
import 'ai_nutrition_state.dart';

class AiNutritionCubit extends Cubit<AiNutritionState> {
  final AiNutritionRepository repository;

  AiNutritionCubit(this.repository) : super(AiNutritionInitial());

  Future<void> loadLogs() async {
    emit(AiNutritionLoading());
    final result = await repository.getLogs();
    result.fold(
      (failure) => emit(AiNutritionError(failure.message)),
      (logs) => emit(AiNutritionLoaded(logs: logs)),
    );
  }

  Future<void> estimateAndLog(String foodName, String? imageUrl, String mealType) async {
    if (state is AiNutritionLoaded) {
      final currentState = state as AiNutritionLoaded;
      emit(currentState.copyWith(isEstimating: true, clearResult: true));

      final result = await repository.estimateAndLog(foodName, imageUrl, mealType);
      
      result.fold(
        (failure) {
          emit(currentState.copyWith(isEstimating: false));
          // Could use a side-effect or error state to show a toast
        },
        (newLog) async {
          // Refresh logs after logging
          final logsResult = await repository.getLogs();
          logsResult.fold(
            (failure) => emit(currentState.copyWith(isEstimating: false, lastResult: newLog)),
            (logs) => emit(AiNutritionLoaded(logs: logs, lastResult: newLog)),
          );
        },
      );
    }
  }
}
