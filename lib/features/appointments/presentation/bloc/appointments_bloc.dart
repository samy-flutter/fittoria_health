import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/appointments_repository.dart';
import '../../data/models/appointment.dart';
import 'appointments_event.dart';
import 'appointments_state.dart';

class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  final AppointmentsRepository _repository;

  AppointmentsBloc(this._repository) : super(AppointmentsInitial()) {
    on<LoadAppointments>(_onLoadAppointments);
    on<CancelAppointment>(_onCancelAppointment);
    on<ChangeFilter>(_onChangeFilter);
  }

  Future<void> _onLoadAppointments(
    LoadAppointments event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(AppointmentsLoading());
    final result = await _repository.getAppointments();
    
    result.fold(
      (failure) => emit(AppointmentsError(failure.message)),
      (appointments) => emit(_buildLoadedState(appointments, AppointmentFilter.all)),
    );
  }

  Future<void> _onCancelAppointment(
    CancelAppointment event,
    Emitter<AppointmentsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AppointmentsLoaded) return;

    emit(currentState.copyWith(cancellingId: event.appointmentId));

    final cancelResult = await _repository.cancelAppointment(event.appointmentId);
    
    await cancelResult.fold(
      (failure) async {
        emit(currentState.copyWith(clearCancellingId: true));
        emit(AppointmentsError(failure.message));
      },
      (_) async {
        // Reload to get fresh data
        final refreshResult = await _repository.getAppointments();
        refreshResult.fold(
          (failure) => emit(AppointmentsError(failure.message)),
          (appointments) => emit(_buildLoadedState(appointments, currentState.activeFilter)),
        );
      },
    );
  }

  void _onChangeFilter(
    ChangeFilter event,
    Emitter<AppointmentsState> emit,
  ) {
    final currentState = state;
    if (currentState is! AppointmentsLoaded) return;

    emit(_buildLoadedState(currentState.allAppointments, event.filter));
  }

  AppointmentsLoaded _buildLoadedState(
    List<Appointment> all,
    AppointmentFilter filter,
  ) {
    final filtered = _applyFilter(all, filter);
    final counts = {
      AppointmentFilter.all: all.length,
      AppointmentFilter.upcoming: all
          .where((a) => ['scheduled', 'waiting', 'in_consultation'].contains(a.status))
          .length,
      AppointmentFilter.completed: all.where((a) => a.status == 'completed').length,
      AppointmentFilter.cancelled: all
          .where((a) => ['cancelled', 'no_show'].contains(a.status))
          .length,
    };

    return AppointmentsLoaded(
      allAppointments: all,
      filteredAppointments: filtered,
      activeFilter: filter,
      counts: counts,
    );
  }

  List<Appointment> _applyFilter(List<Appointment> all, AppointmentFilter filter) {
    switch (filter) {
      case AppointmentFilter.upcoming:
        return all.where((a) => ['scheduled', 'waiting', 'in_consultation'].contains(a.status)).toList();
      case AppointmentFilter.completed:
        return all.where((a) => a.status == 'completed').toList();
      case AppointmentFilter.cancelled:
        return all.where((a) => ['cancelled', 'no_show'].contains(a.status)).toList();
      case AppointmentFilter.all:
        return all;
    }
  }
}
