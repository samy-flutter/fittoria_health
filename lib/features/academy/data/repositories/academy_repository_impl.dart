import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/academy_repository.dart';
import '../data_sources/academy_remote_data_source.dart';
import '../models/academy_models.dart';
import '../../../../core/network/api_exceptions.dart';

class AcademyRepositoryImpl implements AcademyRepository {
  final AcademyRemoteDataSource _remoteDataSource;

  AcademyRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<AcademyVideo>>> getVideos({
    required String audience,
    String? query,
    String? category,
  }) async {
    try {
      final videos = await _remoteDataSource.getVideos(
        audience: audience,
        query: query,
        category: category,
      );
      return Right(videos);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AcademyVideo>> toggleLike(int videoId) async {
    try {
      final result = await _remoteDataSource.toggleLike(videoId);
      return Right(AcademyVideo(
        id: videoId,
        title: '',
        description: '',
        thumbnailUrl: '',
        videoUrl: '',
        durationSec: 0,
        viewCount: 0,
        likeCount: result['likeCount'] as int? ?? 0,
        category: '',
        liked: result['liked'] == true,
      ));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

