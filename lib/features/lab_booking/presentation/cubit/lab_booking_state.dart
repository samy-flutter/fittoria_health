import '../../data/models/lab_booking_model.dart';

abstract class LabBookingState {}

class LabBookingInitial extends LabBookingState {}

class LabBookingLoading extends LabBookingState {}

class LabBookingLoaded extends LabBookingState {
  final List<LabBooking> bookings;
  final bool isCreating;
  final bool createSuccess;

  LabBookingLoaded({
    required this.bookings,
    this.isCreating = false,
    this.createSuccess = false,
  });

  LabBookingLoaded copyWith({
    List<LabBooking>? bookings,
    bool? isCreating,
    bool? createSuccess,
  }) {
    return LabBookingLoaded(
      bookings: bookings ?? this.bookings,
      isCreating: isCreating ?? this.isCreating,
      createSuccess: createSuccess ?? this.createSuccess,
    );
  }
}

class LabBookingError extends LabBookingState {
  final String message;
  LabBookingError(this.message);
}
