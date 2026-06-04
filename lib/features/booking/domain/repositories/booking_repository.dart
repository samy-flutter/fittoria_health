import '../../../clinics/data/models/clinic.dart';
import '../../data/data_sources/booking_remote_data_source.dart';

abstract class BookingRepository {
  Future<List<Clinic>> getClinics();
  Future<List<ClinicDoctor>> getDoctors(int clinicId);
  Future<BookingResult> bookAppointment({
    required int clinicId,
    required int doctorId,
    required String appointmentDate,
    required String slotStart,
    required String slotEnd,
    required String visitType,
    String? chiefComplaint,
  });
}
