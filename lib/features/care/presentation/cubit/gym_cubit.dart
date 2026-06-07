import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/care_repository.dart';
import '../../data/models/gym_model.dart';

abstract class GymState {}

class GymInitial extends GymState {}

class GymLoading extends GymState {}

class GymLoaded extends GymState {
  final GymData data;

  GymLoaded(this.data);
}

class GymError extends GymState {
  final String message;

  GymError(this.message);
}

class GymCubit extends Cubit<GymState> {
  final CareRepository _repository;

  GymCubit(this._repository) : super(GymInitial());

  Future<void> loadGymData() async {
    emit(GymLoading());
    final result = await _repository.getGymData();
    result.fold(
      (failure) => emit(GymError(failure.message)),
      (data) => emit(GymLoaded(data)),
    );
  }
}
