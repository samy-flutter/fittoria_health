import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/achievements_repository.dart';
import 'achievements_state.dart';

class AchievementsCubit extends Cubit<AchievementsState> {
  final AchievementsRepository repository;

  AchievementsCubit(this.repository) : super(AchievementsInitial());

  Future<void> loadAchievements() async {
    emit(AchievementsLoading());
    final result = await repository.getAchievementsData();
    result.fold(
      (failure) => emit(AchievementsError(failure.message)),
      (data) => emit(AchievementsLoaded(data)),
    );
  }
}
