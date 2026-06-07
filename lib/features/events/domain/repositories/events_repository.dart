import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/event_models.dart';

abstract class EventsRepository {
  Future<Either<Failure, List<FitEvent>>> getEvents({String? type});
  Future<Either<Failure, void>> registerForEvent(int eventId);
}


