import 'package:flutter_bloc/flutter_bloc.dart';
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
  ActivityCubit(this.repository) : super(ActivityInitial());

  Future<void> load(String range, {bool silently = false}) async {
    if (!silently) emit(ActivityLoading());
    final result = await repository.getActivity(range: range);
    result.fold(
      (Failure f) => emit(ActivityError(f.message)),
      (ActivityData d) => emit(ActivityLoaded(d, range)),
    );
  }

  Future<void> log(ActivityLog logData, String currentRange) async {
    await repository.logActivity(logData);
    await load(currentRange, silently: true);
  }
}
