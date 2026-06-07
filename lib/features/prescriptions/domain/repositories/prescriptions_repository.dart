import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/prescription.dart';

abstract class PrescriptionsRepository {
  Future<Either<Failure, List<Prescription>>> getPrescriptions();
}
