import '../../data/models/community_models.dart';

abstract class CommunityRepository {
  Future<List<CommunityEvent>> getUpcomingEvents();
  Future<List<SocialPost>> getSocialFeed();
  Future<List<Challenge>> getActiveChallenges();
}
