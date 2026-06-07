import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/social_models.dart';

abstract class SocialRemoteDataSource {
  Future<List<SocialPost>> getPosts({String? clubId, String? feed, String? authorId});
  Future<SocialPost> createPost({required String body, required String postType, required List<String> mediaUrls});
  Future<Map<String, dynamic>> likePost(int postId);
  Future<Map<String, dynamic>> savePost(int postId);
  Future<List<SocialComment>> getComments(int postId);
  Future<void> addComment(int postId, String body);
}

class SocialRemoteDataSourceImpl implements SocialRemoteDataSource {
  final DioClient _apiClient;

  SocialRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<SocialPost>> getPosts({String? clubId, String? feed, String? authorId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (clubId != null) queryParams['club'] = clubId;
      if (feed != null) queryParams['feed'] = feed;
      if (authorId != null) queryParams['author'] = authorId;

      final response = await _apiClient.get('/api/patient/social', queryParameters: queryParams);
      final data = response.data['posts'] as List?;
      return data?.map((e) => SocialPost.fromJson(e)).toList() ?? [];
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<SocialPost> createPost({required String body, required String postType, required List<String> mediaUrls}) async {
    try {
      final payload = {
        'postType': postType,
        'body': body,
        'media': mediaUrls.map((url) => {'url': url, 'mediaType': 'image'}).toList(),
      };
      final response = await _apiClient.post('/api/patient/social', data: payload);
      
      return SocialPost(
        id: response.data['id'] as int,
        authorName: 'You', // Backend doesn't return full object, we construct a dummy
        body: body,
        postType: postType,
        mediaUrls: mediaUrls,
        likes: 0,
        commentsCount: 0,
        isLiked: false,
        isSaved: false,
        createdAt: DateTime.now(),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> likePost(int postId) async {
    try {
      final response = await _apiClient.post('/api/patient/social/$postId/like');
      return response.data as Map<String, dynamic>;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> savePost(int postId) async {
    try {
      final response = await _apiClient.post('/api/patient/social/$postId/save');
      return response.data as Map<String, dynamic>;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<List<SocialComment>> getComments(int postId) async {
    try {
      final response = await _apiClient.get('/api/patient/social/$postId/comments');
      final data = response.data['comments'] as List?;
      return data?.map((e) => SocialComment.fromJson(e)).toList() ?? [];
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<void> addComment(int postId, String body) async {
    try {
      await _apiClient.post('/api/patient/social/$postId/comments', data: {'body': body});
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }
}
