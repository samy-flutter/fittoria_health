import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/fitness_repository.dart';
import '../../data/models/fitness_hub_models.dart';

abstract class ChallengesState {}

class ChallengesInitial extends ChallengesState {}

class ChallengesLoading extends ChallengesState {}

class ChallengesLoaded extends ChallengesState {
  final List<FitChallengeDetail> challenges;

  ChallengesLoaded(this.challenges);
}

class ChallengesError extends ChallengesState {
  final String message;

  ChallengesError(this.message);
}

class ChallengesActionSuccess extends ChallengesState {}

class ChallengesCubit extends Cubit<ChallengesState> {
  final FitnessRepository _repository;

  ChallengesCubit(this._repository) : super(ChallengesInitial());

  Future<void> loadChallenges() async {
    emit(ChallengesLoading());
    final result = await _repository.getChallenges();
    result.fold(
      (failure) => emit(ChallengesError(failure.message)),
      (data) => emit(ChallengesLoaded(data)),
    );
  }

  Future<void> joinChallenge(int challengeId) async {
    final result = await _repository.joinChallenge(challengeId);
    result.fold(
      (failure) => emit(ChallengesError(failure.message)),
      (_) {
        emit(ChallengesActionSuccess());
        loadChallenges();
      },
    );
  }
}
