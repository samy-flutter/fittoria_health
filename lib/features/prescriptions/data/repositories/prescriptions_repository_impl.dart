import '../../domain/repositories/prescriptions_repository.dart';
import '../data_sources/prescriptions_remote_data_source.dart';
import '../models/prescription.dart';

class PrescriptionsRepositoryImpl implements PrescriptionsRepository {
  final PrescriptionsRemoteDataSource _remoteDataSource;

  PrescriptionsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Prescription>> getPrescriptions() async {
    final response = await _remoteDataSource.getPrescriptions();
    return response.prescriptions;
  }
}
