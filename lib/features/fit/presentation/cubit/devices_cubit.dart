import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/fitness_repository.dart';
import '../../data/models/fitness_hub_models.dart';

abstract class DevicesState {}

class DevicesInitial extends DevicesState {}

class DevicesLoading extends DevicesState {}

class DevicesLoaded extends DevicesState {
  final List<FitDevice> devices;

  DevicesLoaded(this.devices);
}

class DevicesError extends DevicesState {
  final String message;

  DevicesError(this.message);
}

class DevicesActionSuccess extends DevicesState {}

class DevicesCubit extends Cubit<DevicesState> {
  final FitnessRepository _repository;

  DevicesCubit(this._repository) : super(DevicesInitial());

  Future<void> loadDevices() async {
    emit(DevicesLoading());
    final result = await _repository.getDevices();
    result.fold(
      (failure) => emit(DevicesError(failure.message)),
      (data) => emit(DevicesLoaded(data)),
    );
  }

  Future<void> connectDevice(String provider, String displayName) async {
    final result = await _repository.connectDevice(provider, displayName);
    result.fold(
      (failure) => emit(DevicesError(failure.message)),
      (_) {
        emit(DevicesActionSuccess());
        loadDevices();
      },
    );
  }

  Future<void> disconnectDevice(String provider) async {
    final result = await _repository.disconnectDevice(provider);
    result.fold(
      (failure) => emit(DevicesError(failure.message)),
      (_) {
        emit(DevicesActionSuccess());
        loadDevices();
      },
    );
  }
}
