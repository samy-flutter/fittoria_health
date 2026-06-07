import 'package:equatable/equatable.dart';
import '../../data/models/club_models.dart';

abstract class ClubsState extends Equatable {
  const ClubsState();

  @override
  List<Object?> get props => [];
}

class ClubsInitial extends ClubsState {}

class ClubsLoading extends ClubsState {}

class ClubsLoaded extends ClubsState {
  final List<SocialClub> clubs;
  final bool isToggling; // Used for showing a mini loading state when joining/leaving

  const ClubsLoaded({
    required this.clubs,
    this.isToggling = false,
  });

  @override
  List<Object?> get props => [clubs, isToggling];

  ClubsLoaded copyWith({
    List<SocialClub>? clubs,
    bool? isToggling,
  }) {
    return ClubsLoaded(
      clubs: clubs ?? this.clubs,
      isToggling: isToggling ?? this.isToggling,
    );
  }
}

class ClubsError extends ClubsState {
  final String message;

  const ClubsError(this.message);

  @override
  List<Object?> get props => [message];
}
