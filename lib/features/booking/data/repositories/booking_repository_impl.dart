import '../../domain/repositories/booking_repository.dart';
import '../data_sources/booking_remote_data_source.dart';
import '../../../clinics/data/models/clinic.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource _remoteDataSource;

  BookingRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Clinic>> getClinics() {
    return _remoteDataSource.getClinics();
  }

  @override
  Future<List<ClinicDoctor>> getDoctors(int clinicId) {
    return _remoteDataSource.getDoctors(clinicId);
  }

  @override
  Future<BookingResult> bookAppointment({
    required int clinicId,
    required int doctorId,
    required String appointmentDate,
    required String slotStart,
    required String slotEnd,
    required String visitType,
    String? chiefComplaint,
  }) {
    final payload = <String, dynamic>{
      'clinic_id': clinicId,
      'doctor_id': doctorId,
      'appointment_date': appointmentDate,
      'slot_start': slotStart,
      'slot_end': slotEnd,
      'visit_type': visitType,
    };
    if (chiefComplaint != null && chiefComplaint.trim().isNotEmpty) {
      payload['chief_complaint'] = chiefComplaint.trim();
    }
    return _remoteDataSource.bookAppointment(payload);
  }
}
