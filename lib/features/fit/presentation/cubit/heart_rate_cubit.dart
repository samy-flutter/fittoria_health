import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/fit_repository.dart';
import '../../data/models/fit_models.dart';
import '../../../../core/error/failures.dart';

abstract class HeartRateState {}
class HeartRateInitial extends HeartRateState {}
class HeartRateLoading extends HeartRateState {}
class HeartRateLoaded extends HeartRateState {
  final HeartRateData data;
  HeartRateLoaded(this.data);
}
class HeartRateError extends HeartRateState {
  final String message;
  HeartRateError(this.message);
}

class HeartRateCubit extends Cubit<HeartRateState> {
  final FitRepository repository;
  HeartRateCubit(this.repository) : super(HeartRateInitial());

  Future<void> load() async {
    emit(HeartRateLoading());
    final result = await repository.getHeartRate();
    result.fold(
      (Failure f) => emit(HeartRateError(f.message)),
      (HeartRateData d) => emit(HeartRateLoaded(d)),
    );
  }

  Future<void> log(int bpm, String type) async {
    await repository.logHeartRate(bpm, type);
    await load();
  }
}
