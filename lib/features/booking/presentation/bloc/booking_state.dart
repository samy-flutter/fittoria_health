import '../../../clinics/data/models/clinic.dart';
import '../../data/data_sources/booking_remote_data_source.dart';

class BookingState {
  final int step;
  final List<Clinic> clinics;
  final List<ClinicDoctor> doctors;
  final Clinic? selectedClinic;
  final ClinicDoctor? selectedDoctor;
  final String date;
  final String slotStart;
  final String visitType;
  final String complaint;
  final bool isLoading;
  final BookingResult? bookedResult;
  final String? errorMessage;

  const BookingState({
    required this.step,
    required this.clinics,
    required this.doctors,
    this.selectedClinic,
    this.selectedDoctor,
    required this.date,
    required this.slotStart,
    required this.visitType,
    required this.complaint,
    required this.isLoading,
    this.bookedResult,
    this.errorMessage,
  });

  factory BookingState.initial() {
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    return BookingState(
      step: 1,
      clinics: const [],
      doctors: const [],
      date: todayStr,
      slotStart: '10:00',
      visitType: 'in_clinic',
      complaint: '',
      isLoading: false,
    );
  }

  BookingState copyWith({
    int? step,
    List<Clinic>? clinics,
    List<ClinicDoctor>? doctors,
    Clinic? Function()? selectedClinic,
    ClinicDoctor? Function()? selectedDoctor,
    String? date,
    String? slotStart,
    String? visitType,
    String? complaint,
    bool? isLoading,
    BookingResult? Function()? bookedResult,
    String? Function()? errorMessage,
  }) {
    return BookingState(
      step: step ?? this.step,
      clinics: clinics ?? this.clinics,
      doctors: doctors ?? this.doctors,
      selectedClinic: selectedClinic != null ? selectedClinic() : this.selectedClinic,
      selectedDoctor: selectedDoctor != null ? selectedDoctor() : this.selectedDoctor,
      date: date ?? this.date,
      slotStart: slotStart ?? this.slotStart,
      visitType: visitType ?? this.visitType,
      complaint: complaint ?? this.complaint,
      isLoading: isLoading ?? this.isLoading,
      bookedResult: bookedResult != null ? bookedResult() : this.bookedResult,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
