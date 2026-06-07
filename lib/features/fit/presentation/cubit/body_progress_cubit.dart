import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/fitness_repository.dart';
import '../../data/models/fitness_hub_models.dart';

abstract class BodyProgressState {}

class BodyProgressInitial extends BodyProgressState {}

class BodyProgressLoading extends BodyProgressState {}

class BodyProgressLoaded extends BodyProgressState {
  final FitBodyProgressData data;

  BodyProgressLoaded(this.data);
}

class BodyProgressError extends BodyProgressState {
  final String message;

  BodyProgressError(this.message);
}

class BodyProgressCubit extends Cubit<BodyProgressState> {
  final FitnessRepository _repository;

  BodyProgressCubit(this._repository) : super(BodyProgressInitial());

  Future<void> loadBodyProgress() async {
    emit(BodyProgressLoading());
    final result = await _repository.getBodyProgress();
    result.fold(
      (failure) => emit(BodyProgressError(failure.message)),
      (data) => emit(BodyProgressLoaded(data)),
    );
  }
}
