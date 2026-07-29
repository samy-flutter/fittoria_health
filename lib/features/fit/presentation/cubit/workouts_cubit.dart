import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/fitness_repository.dart';
import '../../data/models/fitness_hub_models.dart';

abstract class WorkoutsState {}

class WorkoutsInitial extends WorkoutsState {}

class WorkoutsLoading extends WorkoutsState {}

class WorkoutsLoaded extends WorkoutsState {
  final FitWorkoutData data;

  WorkoutsLoaded(this.data);
}

class WorkoutsError extends WorkoutsState {
  final String message;

  WorkoutsError(this.message);
}

class WorkoutsCubit extends Cubit<WorkoutsState> {
  final FitnessRepository _repository;

  WorkoutsCubit(this._repository) : super(WorkoutsInitial());

  Future<void> loadWorkouts({bool silently = false}) async {
    if (!silently) emit(WorkoutsLoading());
    final result = await _repository.getWorkouts();
    result.fold(
      (failure) => emit(WorkoutsError(failure.message)),
      (data) => emit(WorkoutsLoaded(data)),
    );
  }

  Future<void> log(String type, String? title, int durationMin, double distanceKm, int caloriesKcal, int? avgHr) async {
    await _repository.logWorkout(type, title, durationMin, distanceKm, caloriesKcal, avgHr);
    await loadWorkouts(silently: true);
  }
}
