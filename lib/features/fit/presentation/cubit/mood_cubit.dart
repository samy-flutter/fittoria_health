import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/fitness_repository.dart';
import '../../data/models/fit_models.dart';
import '../../../../core/error/failures.dart';

abstract class MoodState {}
class MoodInitial extends MoodState {}
class MoodLoading extends MoodState {}
class MoodLoaded extends MoodState {
  final MoodData data;
  MoodLoaded(this.data);
}
class MoodError extends MoodState {
  final String message;
  MoodError(this.message);
}

class MoodCubit extends Cubit<MoodState> {
  final FitnessRepository repository;
  MoodCubit(this.repository) : super(MoodInitial());

  Future<void> load({bool silently = false}) async {
    if (!silently) emit(MoodLoading());
    final result = await repository.getMood();
    result.fold(
      (Failure f) => emit(MoodError(f.message)),
      (MoodData d) => emit(MoodLoaded(d)),
    );
  }

  Future<void> logMood(String mood, int stress, int energy, String note) async {
    await repository.logMood(mood, stress, energy, note);
    await load(silently: true);
  }
}
