import '../../data/models/achievement_models.dart';

abstract class AchievementsState {}

class AchievementsInitial extends AchievementsState {}

class AchievementsLoading extends AchievementsState {}

class AchievementsLoaded extends AchievementsState {
  final AchievementsData data;
  AchievementsLoaded(this.data);
}

class AchievementsError extends AchievementsState {
  final String message;
  AchievementsError(this.message);
}
