import '../../../../core/error/exception_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../profile_records/domain/repositories/records_repository.dart';
import 'records_state.dart';

class RecordsCubit extends Cubit<RecordsState> {
  final RecordsRepository _repository;

  RecordsCubit(this._repository) : super(const RecordsInitial());

  Future<void> loadRecords() async {
    emit(const RecordsLoading());
    try {
      final records = await _repository.getRecords();
      emit(RecordsLoaded(records));
    } catch (e) {
      emit(RecordsError(ExceptionHandler.handle(e).message));
    }
  }
}
