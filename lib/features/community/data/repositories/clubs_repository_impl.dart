import '../../../../core/error/exception_handler.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../data_sources/clubs_remote_data_source.dart';
import '../models/club_models.dart';
import '../../domain/repositories/clubs_repository.dart';

class ClubsRepositoryImpl implements ClubsRepository {
  final ClubsRemoteDataSource _remoteDataSource;

  ClubsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<SocialClub>>> getClubs() async {
    try {
      final clubs = await _remoteDataSource.getClubs();
      return Right(clubs);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> toggleClubMembership(int clubId) async {
    try {
      await _remoteDataSource.toggleClubMembership(clubId);
      return const Right(null);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }
  @override
  Future<Either<Failure, List<ClubChatMessage>>> getClubChat(int clubId, {int after = 0}) async {
    try {
      final messages = await _remoteDataSource.getClubChat(clubId, after: after);
      return Right(messages);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> sendChatMessage(int clubId, String body) async {
    try {
      await _remoteDataSource.sendChatMessage(clubId, body);
      return const Right(null);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }
}
