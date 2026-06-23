import '../../../../core/error/exception_handler.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/reports_repository.dart';
import '../data_sources/reports_remote_data_source.dart';
import '../models/report_model.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsRemoteDataSource _remoteDataSource;

  ReportsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<ReportModel>>> getReports() async {
    try {
      final reports = await _remoteDataSource.getReports();
      return Right(reports);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }
}
