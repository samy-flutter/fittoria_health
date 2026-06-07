import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/report_model.dart';

abstract class ReportsRepository {
  Future<Either<Failure, List<ReportModel>>> getReports();
}
