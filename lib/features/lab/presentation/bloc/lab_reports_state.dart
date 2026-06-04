import '../../data/models/lab_report.dart';

abstract class LabReportsState {
  const LabReportsState();
}

class LabReportsInitial extends LabReportsState {
  const LabReportsInitial();
}

class LabReportsLoading extends LabReportsState {
  const LabReportsLoading();
}

class LabReportsLoaded extends LabReportsState {
  final List<LabReport> reports;
  const LabReportsLoaded(this.reports);
}

class LabReportsError extends LabReportsState {
  final String message;
  const LabReportsError(this.message);
}
