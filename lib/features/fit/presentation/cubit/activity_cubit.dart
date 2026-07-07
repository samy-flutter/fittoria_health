import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/fit_repository.dart';
import '../../data/models/fit_models.dart';
import '../../../../core/error/failures.dart';

abstract class ActivityState {}
class ActivityInitial extends ActivityState {}
class ActivityLoading extends ActivityState {}
class ActivityLoaded extends ActivityState {
  final ActivityData data;
  final String range;
  ActivityLoaded(this.data, this.range);
}
class ActivityError extends ActivityState {
  final String message;
  ActivityError(this.message);
}

class ActivityCubit extends Cubit<ActivityState> {
  final FitRepository repository;
  StreamSubscription<Either<Failure, ActivityData>>? _activitySubscription;

  ActivityCubit(this.repository) : super(ActivityInitial());

  @override
  Future<void> close() {
    _activitySubscription?.cancel();
    return super.close();
  }

  Future<void> load(String range, {bool silently = false}) async {
    if (!silently) emit(ActivityLoading());

    // Watch for real-time updates. The pedometer stream emits the current value immediately.
    _activitySubscription?.cancel();
    _activitySubscription = repository.watchActivity(range: range).listen((result) {
      result.fold(
        (Failure f) => emit(ActivityError(f.message)),
        (ActivityData d) => emit(ActivityLoaded(d, range)),
      );
    });
  }

  Future<void> log(ActivityLog logData, String currentRange) async {
    await repository.logActivity(logData);
    await load(currentRange, silently: true);
  }
}
