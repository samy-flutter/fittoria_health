import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/booking_repository.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository _repository;

  BookingBloc(this._repository) : super(BookingState.initial()) {
    on<InitBooking>(_onInitBooking);
    on<LoadClinics>(_onLoadClinics);
    on<SelectClinic>(_onSelectClinic);
    on<SelectDoctor>(_onSelectDoctor);
    on<UpdateVisitType>(_onUpdateVisitType);
    on<UpdateDate>(_onUpdateDate);
    on<UpdateSlotStart>(_onUpdateSlotStart);
    on<UpdateComplaint>(_onUpdateComplaint);
    on<GoToStep>(_onGoToStep);
    on<SubmitBooking>(_onSubmitBooking);
    on<ResetBooking>(_onResetBooking);
  }

  Future<void> _onInitBooking(InitBooking event, Emitter<BookingState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: () => null));
    try {
      final clinics = await _repository.getClinics();
      emit(state.copyWith(
        clinics: clinics,
        isLoading: false,
      ));

      if (event.initialClinicId != null) {
        final matched = clinics.where((c) => c.id.toString() == event.initialClinicId).toList();
        if (matched.isNotEmpty) {
          add(SelectClinic(matched.first));
        }
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: () => e.toString(),
      ));
    }
  }

  Future<void> _onLoadClinics(LoadClinics event, Emitter<BookingState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: () => null));
    try {
      final clinics = await _repository.getClinics();
      emit(state.copyWith(
        clinics: clinics,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: () => e.toString(),
      ));
    }
  }

  Future<void> _onSelectClinic(SelectClinic event, Emitter<BookingState> emit) async {
    emit(state.copyWith(
      selectedClinic: () => event.clinic,
      selectedDoctor: () => null,
      doctors: const [],
      isLoading: true,
      errorMessage: () => null,
      step: 2, // Auto advance to doctor select when clinic is chosen
    ));

    try {
      final doctors = await _repository.getDoctors(event.clinic.id);
      emit(state.copyWith(
        doctors: doctors,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: () => e.toString(),
      ));
    }
  }

  void _onSelectDoctor(SelectDoctor event, Emitter<BookingState> emit) {
    emit(state.copyWith(
      selectedDoctor: () => event.doctor,
      step: 3, // Auto advance to schedule selection
    ));
  }

  void _onUpdateVisitType(UpdateVisitType event, Emitter<BookingState> emit) {
    emit(state.copyWith(visitType: event.visitType));
  }

  void _onUpdateDate(UpdateDate event, Emitter<BookingState> emit) {
    emit(state.copyWith(date: event.date));
  }

  void _onUpdateSlotStart(UpdateSlotStart event, Emitter<BookingState> emit) {
    emit(state.copyWith(slotStart: event.slotStart));
  }

  void _onUpdateComplaint(UpdateComplaint event, Emitter<BookingState> emit) {
    emit(state.copyWith(complaint: event.complaint));
  }

  void _onGoToStep(GoToStep event, Emitter<BookingState> emit) {
    if (event.step >= 1 && event.step <= 4) {
      emit(state.copyWith(
        step: event.step,
        errorMessage: () => null,
      ));
    }
  }

  Future<void> _onSubmitBooking(SubmitBooking event, Emitter<BookingState> emit) async {
    if (state.selectedClinic == null || state.selectedDoctor == null) {
      emit(state.copyWith(errorMessage: () => 'Please select a clinic and a doctor first.'));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: () => null));

    try {
      final slotEndStr = _calculateSlotEnd(state.slotStart);
      final result = await _repository.bookAppointment(
        clinicId: state.selectedClinic!.id,
        doctorId: state.selectedDoctor!.id,
        appointmentDate: state.date,
        slotStart: '${state.slotStart}:00',
        slotEnd: slotEndStr,
        visitType: state.visitType,
        chiefComplaint: state.complaint,
      );

      emit(state.copyWith(
        isLoading: false,
        bookedResult: () => result,
        step: 5, // Show booked success screen
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: () => e.toString(),
      ));
    }
  }

  void _onResetBooking(ResetBooking event, Emitter<BookingState> emit) {
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    emit(BookingState(
      step: 1,
      clinics: state.clinics, // Retain loaded clinics to avoid refetching immediately
      doctors: const [],
      date: todayStr,
      slotStart: '10:00',
      visitType: 'in_clinic',
      complaint: '',
      isLoading: false,
    ));
  }

  String _calculateSlotEnd(String start) {
    try {
      final parts = start.split(':');
      final h = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final totalMinutes = h * 60 + m + 15;
      final endH = totalMinutes ~/ 60;
      final endM = totalMinutes % 60;
      return '${endH.toString().padLeft(2, '0')}:${endM.toString().padLeft(2, '0')}:00';
    } catch (_) {
      return '$start:00';
    }
  }
}
