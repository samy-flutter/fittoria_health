import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/fitness_repository.dart';
import '../../data/models/fit_models.dart';
import '../../../../core/error/failures.dart';

abstract class NutritionState {}
class NutritionInitial extends NutritionState {}
class NutritionLoading extends NutritionState {}
class NutritionLoaded extends NutritionState {
  final NutritionData data;
  NutritionLoaded(this.data);
}
class NutritionError extends NutritionState {
  final String message;
  NutritionError(this.message);
}

class NutritionCubit extends Cubit<NutritionState> {
  final FitnessRepository repository;
  NutritionCubit(this.repository) : super(NutritionInitial());

  Future<void> load(String date, {bool silently = false}) async {
    if (!silently) emit(NutritionLoading());
    final result = await repository.getNutrition(date);
    result.fold(
      (Failure f) => emit(NutritionError(f.message)),
      (NutritionData d) => emit(NutritionLoaded(d)),
    );
  }

  Future<void> logFood(String date, String mealType, String foodName, String quantity, int calories, int protein, int carbs, int fat) async {
    await repository.logNutrition(date, mealType, foodName, quantity, calories, protein, carbs, fat);
    await load(date, silently: true);
  }
}
