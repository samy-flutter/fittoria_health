import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/academy_models.dart';

abstract class AcademyRepository {
  Future<Either<Failure, List<AcademyVideo>>> getVideos({
    required String audience,
    String? query,
    String? category,
  });
  
  Future<Either<Failure, AcademyVideo>> toggleLike(int videoId);
}
