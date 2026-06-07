import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/events_repository.dart';
import 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  final EventsRepository _repository;

  EventsCubit(this._repository) : super(EventsInitial());

  Future<void> loadEvents({String filter = ''}) async {
    emit(EventsLoading());
    final result = await _repository.getEvents(type: filter);
    result.fold(
      (failure) => emit(EventsError(failure.message)),
      (events) => emit(EventsLoaded(events: events, filter: filter)),
    );
  }
}
