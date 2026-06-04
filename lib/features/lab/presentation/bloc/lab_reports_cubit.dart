import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/lab_repository.dart';
import 'lab_reports_state.dart';

class LabReportsCubit extends Cubit<LabReportsState> {
  final LabRepository _repository;

  LabReportsCubit(this._repository) : super(const LabReportsInitial());

  Future<void> loadLabReports() async {
    emit(const LabReportsLoading());
    try {
      final reports = await _repository.getLabReports();
      emit(LabReportsLoaded(reports));
    } catch (e) {
      emit(LabReportsError(e.toString()));
    }
  }
}
