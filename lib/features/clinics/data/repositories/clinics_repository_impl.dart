import '../../domain/repositories/clinics_repository.dart';
import '../data_sources/clinics_remote_data_source.dart';
import '../models/clinic.dart';

class ClinicsRepositoryImpl implements ClinicsRepository {
  final ClinicsRemoteDataSource _remoteDataSource;

  ClinicsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Clinic>> searchClinics({
    String? query,
    String? type,
    double? lat,
    double? lng,
  }) {
    return _remoteDataSource.searchClinics(
      query: query,
      type: type,
      lat: lat,
      lng: lng,
    );
  }
}
