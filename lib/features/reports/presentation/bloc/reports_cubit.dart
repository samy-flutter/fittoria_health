import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/reports_repository.dart';
import '../../data/models/report_model.dart';

abstract class ReportsState {}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsLoaded extends ReportsState {
  final List<ReportModel> reports;

  ReportsLoaded(this.reports);
}

class ReportsError extends ReportsState {
  final String message;

  ReportsError(this.message);
}

class ReportsCubit extends Cubit<ReportsState> {
  final ReportsRepository _repository;

  ReportsCubit(this._repository) : super(ReportsInitial());

  Future<void> loadReports() async {
    emit(ReportsLoading());
    final result = await _repository.getReports();
    result.fold(
      (failure) => emit(ReportsError(failure.message)),
      (reports) => emit(ReportsLoaded(reports)),
    );
  }
}
