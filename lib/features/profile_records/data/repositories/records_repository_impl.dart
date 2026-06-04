import '../../domain/repositories/records_repository.dart';
import '../data_sources/records_remote_data_source.dart';
import '../models/records.dart';

class RecordsRepositoryImpl implements RecordsRepository {
  final RecordsRemoteDataSource _remoteDataSource;

  RecordsRepositoryImpl(this._remoteDataSource);

  @override
  Future<RecordsResponse> getRecords() {
    return _remoteDataSource.getRecords();
  }
}
