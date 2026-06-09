import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/club_models.dart';

abstract class ClubsRepository {
  Future<Either<Failure, List<SocialClub>>> getClubs();
  Future<Either<Failure, void>> toggleClubMembership(int clubId);
  Future<Either<Failure, List<ClubChatMessage>>> getClubChat(int clubId, {int after = 0});
  Future<Either<Failure, void>> sendChatMessage(int clubId, String body);
}
