import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/care_repository.dart';
import '../../data/models/fitness_details_model.dart';

abstract class FitnessDetailsState {}

class FitnessDetailsInitial extends FitnessDetailsState {}

class FitnessDetailsLoading extends FitnessDetailsState {}

class FitnessDetailsLoaded extends FitnessDetailsState {
  final FitnessDetailsData data;

  FitnessDetailsLoaded(this.data);
}

class FitnessDetailsError extends FitnessDetailsState {
  final String message;

  FitnessDetailsError(this.message);
}

class FitnessDetailsCubit extends Cubit<FitnessDetailsState> {
  final CareRepository _repository;

  FitnessDetailsCubit(this._repository) : super(FitnessDetailsInitial());

  Future<void> loadFitnessDetails() async {
    emit(FitnessDetailsLoading());
    final result = await _repository.getFitnessDetails();
    result.fold(
      (failure) => emit(FitnessDetailsError(failure.message)),
      (data) => emit(FitnessDetailsLoaded(data)),
    );
  }
}
