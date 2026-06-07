import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/lab_booking_repository.dart';
import 'lab_booking_state.dart';

class LabBookingCubit extends Cubit<LabBookingState> {
  final LabBookingRepository repository;

  LabBookingCubit(this.repository) : super(LabBookingInitial());

  Future<void> loadBookings() async {
    emit(LabBookingLoading());
    final result = await repository.getBookings();
    result.fold(
      (failure) => emit(LabBookingError(failure.message)),
      (bookings) => emit(LabBookingLoaded(bookings: bookings)),
    );
  }

  Future<void> createBooking({
    required String collectionMode,
    required List<String> testNames,
    required String preferredDate,
    required String? preferredSlot,
    required String? addressLine,
    required String? city,
    required String? pincode,
    required double totalAmount,
  }) async {
    if (state is LabBookingLoaded) {
      final currentState = state as LabBookingLoaded;
      emit(currentState.copyWith(isCreating: true, createSuccess: false));

      final result = await repository.createBooking(
        collectionMode: collectionMode,
        testNames: testNames,
        preferredDate: preferredDate,
        preferredSlot: preferredSlot,
        addressLine: addressLine,
        city: city,
        pincode: pincode,
        totalAmount: totalAmount,
      );

      result.fold(
        (failure) {
          emit(currentState.copyWith(isCreating: false));
          // Emit error via a separate state or side effect, but sticking to simple copyWith for now
        },
        (_) async {
          // Re-fetch bookings on success
          final bookingsResult = await repository.getBookings();
          bookingsResult.fold(
            (failure) => emit(currentState.copyWith(isCreating: false, createSuccess: true)),
            (bookings) => emit(LabBookingLoaded(bookings: bookings, createSuccess: true)),
          );
        },
      );
    }
  }

  void resetSuccess() {
    if (state is LabBookingLoaded) {
      emit((state as LabBookingLoaded).copyWith(createSuccess: false));
    }
  }
}
