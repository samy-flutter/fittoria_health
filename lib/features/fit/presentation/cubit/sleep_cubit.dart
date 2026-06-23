import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/fit_repository.dart';
import '../../data/models/fit_models.dart';
import '../../../../core/error/failures.dart';

abstract class SleepState {}
class SleepInitial extends SleepState {}
class SleepLoading extends SleepState {}
class SleepLoaded extends SleepState {
  final SleepData data;
  SleepLoaded(this.data);
}
class SleepError extends SleepState {
  final String message;
  SleepError(this.message);
}

class SleepCubit extends Cubit<SleepState> {
  final FitRepository repository;
  SleepCubit(this.repository) : super(SleepInitial());

  Future<void> load({bool silently = false}) async {
    if (!silently) emit(SleepLoading());
    final result = await repository.getSleep();
    result.fold(
      (Failure f) => emit(SleepError(f.message)),
      (SleepData d) => emit(SleepLoaded(d)),
    );
  }

  Future<void> log(DateTime date, int total, int rem, int light, int deep, int awake) async {
    await repository.logSleep(date, total, rem, light, deep, awake);
    await load(silently: true);
  }
}
