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

  Future<void> registerForEvent(int eventId) async {
    // If we're already loaded, keep track of current state
    final currentState = state;
    String currentFilter = '';
    if (currentState is EventsLoaded) {
      currentFilter = currentState.filter;
    }

    // Call API
    final result = await _repository.registerForEvent(eventId);
    
    // Refresh list if success
    result.fold(
      (failure) => null, // We could emit a failure state if needed, but for now we just silently fail or we could show a toast from UI using a specific state. Let's just reload on success.
      (_) {
        loadEvents(filter: currentFilter);
      },
    );
  }
}
