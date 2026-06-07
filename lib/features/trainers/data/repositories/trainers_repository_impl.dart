import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/trainers_repository.dart';
import '../models/trainer_models.dart';

class TrainersRepositoryImpl implements TrainersRepository {
  final List<Trainer> _mockTrainers = [
    Trainer(
      id: 1,
      fullName: 'David Beckham',
      specialization: 'Strength & Conditioning',
      experienceYears: 8,
      sessionsDone: 420,
      rating: 4.9,
      bio: 'Expert in weight lifting and muscle building.',
      sessionFee: 1500,
    ),
    Trainer(
      id: 2,
      fullName: 'Serena W',
      specialization: 'HIIT & Cardio',
      experienceYears: 5,
      sessionsDone: 310,
      rating: 4.7,
      bio: 'High intensity workouts for maximum calorie burn.',
      sessionFee: 1000,
    ),
  ];

  @override
  Future<Either<Failure, List<Trainer>>> getTrainers({String query = ''}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      if (query.isNotEmpty) {
        final lower = query.toLowerCase();
        return Right(_mockTrainers.where((t) => t.fullName.toLowerCase().contains(lower) || (t.specialization?.toLowerCase().contains(lower) ?? false)).toList());
      }
      return Right(List.from(_mockTrainers));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> bookTrainer(int trainerId, String sessionType, DateTime scheduledAt, String notes) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      // Simulating a successful booking
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
