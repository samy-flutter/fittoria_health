import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_exceptions.dart';
import '../data_sources/events_remote_data_source.dart';
import '../../domain/repositories/events_repository.dart';
import '../models/event_models.dart';

class EventsRepositoryImpl implements EventsRepository {
  final EventsRemoteDataSource _remoteDataSource;

  EventsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<FitEvent>>> getEvents({String? type}) async {
    try {
      final events = await _remoteDataSource.getEvents(type: type);
      return Right(events);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerForEvent(int eventId) async {
    try {
      await _remoteDataSource.registerForEvent(eventId);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
