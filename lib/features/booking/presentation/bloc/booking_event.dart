import '../../../clinics/data/models/clinic.dart';
import '../../data/data_sources/booking_remote_data_source.dart';

abstract class BookingEvent {
  const BookingEvent();
}

class InitBooking extends BookingEvent {
  final String? initialClinicId;
  const InitBooking({this.initialClinicId});
}

class LoadClinics extends BookingEvent {
  const LoadClinics();
}

class SelectClinic extends BookingEvent {
  final Clinic clinic;
  const SelectClinic(this.clinic);
}

class SelectDoctor extends BookingEvent {
  final ClinicDoctor doctor;
  const SelectDoctor(this.doctor);
}

class UpdateVisitType extends BookingEvent {
  final String visitType;
  const UpdateVisitType(this.visitType);
}

class UpdateDate extends BookingEvent {
  final String date;
  const UpdateDate(this.date);
}

class UpdateSlotStart extends BookingEvent {
  final String slotStart;
  const UpdateSlotStart(this.slotStart);
}

class UpdateComplaint extends BookingEvent {
  final String complaint;
  const UpdateComplaint(this.complaint);
}

class GoToStep extends BookingEvent {
  final int step;
  const GoToStep(this.step);
}

class SubmitBooking extends BookingEvent {
  const SubmitBooking();
}

class ResetBooking extends BookingEvent {
  const ResetBooking();
}
