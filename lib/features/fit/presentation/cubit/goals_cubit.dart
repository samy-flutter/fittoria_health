import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/fitness_repository.dart';
import '../../data/models/fitness_hub_models.dart';

abstract class GoalsState {}

class GoalsInitial extends GoalsState {}

class GoalsLoading extends GoalsState {}

class GoalsLoaded extends GoalsState {
  final List<FitGoalDetail> goals;

  GoalsLoaded(this.goals);
}

class GoalsError extends GoalsState {
  final String message;

  GoalsError(this.message);
}

class GoalsCubit extends Cubit<GoalsState> {
  final FitnessRepository _repository;

  GoalsCubit(this._repository) : super(GoalsInitial());

  Future<void> loadGoals() async {
    emit(GoalsLoading());
    final result = await _repository.getGoals();
    result.fold(
      (failure) => emit(GoalsError(failure.message)),
      (data) => emit(GoalsLoaded(data)),
    );
  }

  Future<void> addGoal(String type, int target, String period) async {
    final result = await _repository.addGoal(type, target, period);
    result.fold(
      (failure) {
        emit(GoalsError(failure.message));
        loadGoals();
      },
      (_) => loadGoals(),
    );
  }

  Future<void> deleteGoal(int goalId) async {
    final result = await _repository.deleteGoal(goalId);
    result.fold(
      (failure) {
        emit(GoalsError(failure.message));
        loadGoals();
      },
      (_) => loadGoals(),
    );
  }
}
