import '../../data/models/records.dart';

abstract class RecordsRepository {
  Future<RecordsResponse> getRecords();
}
