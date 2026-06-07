import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_exceptions.dart';
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
      if (e is ApiException) {
        return Left(ServerFailure(e.message));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
