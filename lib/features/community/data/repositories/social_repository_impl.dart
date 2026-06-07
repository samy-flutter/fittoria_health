import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/social_repository.dart';
import '../models/social_models.dart';
import '../../../../core/network/api_exceptions.dart';
import '../data_sources/social_remote_data_source.dart';

class SocialRepositoryImpl implements SocialRepository {
  final SocialRemoteDataSource _remoteDataSource;

  SocialRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<SocialPost>>> getPosts({String? feed}) async {
    try {
      final posts = await _remoteDataSource.getPosts(feed: feed);
      return Right(posts);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SocialPost>> createPost(String body, String postType, List<String> mediaUrls) async {
    try {
      final post = await _remoteDataSource.createPost(body: body, postType: postType, mediaUrls: mediaUrls);
      return Right(post);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> likePost(int postId) async {
    try {
      await _remoteDataSource.likePost(postId);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> savePost(int postId) async {
    try {
      await _remoteDataSource.savePost(postId);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SocialComment>>> getComments(int postId) async {
    try {
      final comments = await _remoteDataSource.getComments(postId);
      return Right(comments);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addComment(int postId, String body) async {
    try {
      await _remoteDataSource.addComment(postId, body);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
