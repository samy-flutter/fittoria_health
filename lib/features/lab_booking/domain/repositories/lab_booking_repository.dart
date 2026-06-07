import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/lab_booking_model.dart';

abstract class LabBookingRepository {
  Future<Either<Failure, List<LabBooking>>> getBookings();
  Future<Either<Failure, void>> createBooking({
    required String collectionMode,
    required List<String> testNames,
    required String preferredDate,
    required String? preferredSlot,
    required String? addressLine,
    required String? city,
    required String? pincode,
    required double totalAmount,
  });
}
