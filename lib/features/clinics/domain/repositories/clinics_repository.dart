import '../../data/models/clinic.dart';

abstract class ClinicsRepository {
  Future<List<Clinic>> searchClinics({
    String? query,
    String? type,
    double? lat,
    double? lng,
  });
}
