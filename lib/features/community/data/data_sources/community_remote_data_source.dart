import 'package:dio/dio.dart';
import '../../domain/repositories/community_repository.dart';
import '../models/community_models.dart';

class CommunityRemoteDataSource implements CommunityRepository {
  final Dio dio;

  CommunityRemoteDataSource({required this.dio});

  @override
  Future<List<CommunityEvent>> getUpcomingEvents() async {
    try {
      final response = await dio.get('/patient/events');
      final data = response.data as List;
      return data.map((e) => CommunityEvent.fromJson(e)).toList();
    } catch (e) {
      // Return empty list or throw custom exception depending on app error handling strategy
      return [];
    }
  }

  @override
  Future<List<SocialPost>> getSocialFeed() async {
    try {
      final response = await dio.get('/patient/social');
      final data = response.data as List;
      return data.map((e) => SocialPost.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Challenge>> getActiveChallenges() async {
    try {
      final response = await dio.get('/patient/fit/challenges');
      final data = response.data as List;
      return data.map((e) => Challenge.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }
}
