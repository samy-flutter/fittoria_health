import 'package:equatable/equatable.dart';
import '../../data/models/event_models.dart';

abstract class EventsState extends Equatable {
  const EventsState();
  @override
  List<Object> get props => [];
}

class EventsInitial extends EventsState {}

class EventsLoading extends EventsState {}

class EventsLoaded extends EventsState {
  final List<FitEvent> events;
  final String filter;

  const EventsLoaded({required this.events, this.filter = ''});

  @override
  List<Object> get props => [events, filter];
}

class EventsError extends EventsState {
  final String message;
  const EventsError(this.message);

  @override
  List<Object> get props => [message];
}
