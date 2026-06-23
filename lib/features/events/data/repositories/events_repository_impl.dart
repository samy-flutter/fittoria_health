import '../../../../core/error/exception_handler.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
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
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> registerForEvent(int eventId) async {
    try {
      await _remoteDataSource.registerForEvent(eventId);
      return const Right(null);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }
}
