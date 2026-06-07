import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/social_models.dart';

abstract class SocialRepository {
  Future<Either<Failure, List<SocialPost>>> getPosts({String? feed});
  Future<Either<Failure, SocialPost>> createPost(String body, String postType, List<String> mediaUrls);
  Future<Either<Failure, void>> likePost(int postId);
  Future<Either<Failure, void>> savePost(int postId);
  Future<Either<Failure, List<SocialComment>>> getComments(int postId);
  Future<Either<Failure, void>> addComment(int postId, String body);
}
