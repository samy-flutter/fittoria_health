import '../../../profile_records/data/models/records.dart';

abstract class RecordsState {
  const RecordsState();
}

class RecordsInitial extends RecordsState {
  const RecordsInitial();
}

class RecordsLoading extends RecordsState {
  const RecordsLoading();
}

class RecordsLoaded extends RecordsState {
  final RecordsResponse records;
  const RecordsLoaded(this.records);
}

class RecordsError extends RecordsState {
  final String message;
  const RecordsError(this.message);
}
