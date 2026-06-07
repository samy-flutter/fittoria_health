import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/lab_booking_repository.dart';
import '../models/lab_booking_model.dart';

class LabBookingRepositoryImpl implements LabBookingRepository {
  final List<LabBooking> _mockBookings = [
    LabBooking(
      id: 1,
      collectionMode: 'home',
      testNames: ['Complete Blood Count (CBC)', 'Vitamin D'],
      preferredDate: DateTime.now().add(const Duration(days: 2)).toIso8601String(),
      preferredSlot: '08:00-10:00',
      totalAmount: 1550,
      status: 'confirmed',
      labName: 'Fittoria Labs',
    ),
  ];

  @override
  Future<Either<Failure, List<LabBooking>>> getBookings() async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      return Right(List.from(_mockBookings));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createBooking({
    required String collectionMode,
    required List<String> testNames,
    required String preferredDate,
    required String? preferredSlot,
    required String? addressLine,
    required String? city,
    required String? pincode,
    required double totalAmount,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      _mockBookings.insert(
        0,
        LabBooking(
          id: DateTime.now().millisecondsSinceEpoch,
          collectionMode: collectionMode,
          testNames: testNames,
          preferredDate: preferredDate,
          preferredSlot: preferredSlot,
          totalAmount: totalAmount,
          status: 'requested',
        ),
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
