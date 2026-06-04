import '../../data/models/prescription.dart';

abstract class PrescriptionsRepository {
  Future<List<Prescription>> getPrescriptions();
}
