import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/care_repository.dart';
import '../../data/models/meetings_model.dart';

abstract class MeetingsState {}

class MeetingsInitial extends MeetingsState {}

class MeetingsLoading extends MeetingsState {}

class MeetingsLoaded extends MeetingsState {
  final MeetingsData data;

  MeetingsLoaded(this.data);
}

class MeetingsError extends MeetingsState {
  final String message;

  MeetingsError(this.message);
}

class MeetingsCubit extends Cubit<MeetingsState> {
  final CareRepository _repository;

  MeetingsCubit(this._repository) : super(MeetingsInitial());

  Future<void> loadMeetings() async {
    emit(MeetingsLoading());
    final result = await _repository.getMeetingsData();
    result.fold(
      (failure) => emit(MeetingsError(failure.message)),
      (data) => emit(MeetingsLoaded(data)),
    );
  }
}
