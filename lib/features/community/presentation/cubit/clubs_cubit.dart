import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/clubs_repository.dart';
import 'clubs_state.dart';

class ClubsCubit extends Cubit<ClubsState> {
  final ClubsRepository _repository;

  ClubsCubit(this._repository) : super(ClubsInitial());

  Future<void> loadClubs() async {
    emit(ClubsLoading());
    final result = await _repository.getClubs();
    result.fold(
      (failure) => emit(ClubsError(failure.message)),
      (clubs) => emit(ClubsLoaded(clubs: clubs)),
    );
  }

  Future<void> toggleMembership(int clubId) async {
    if (state is ClubsLoaded) {
      final currentState = state as ClubsLoaded;
      emit(currentState.copyWith(isToggling: true));

      final result = await _repository.toggleClubMembership(clubId);
      result.fold(
        (failure) {
          emit(ClubsError(failure.message));
          loadClubs(); // Reload to restore previous state
        },
        (_) {
          // Optimistically update the list
          final updatedClubs = currentState.clubs.map((club) {
            if (club.id == clubId) {
              return club.copyWith(
                joined: !club.joined,
                memberCount: club.joined ? club.memberCount - 1 : club.memberCount + 1,
              );
            }
            return club;
          }).toList();
          emit(ClubsLoaded(clubs: updatedClubs, isToggling: false));
        },
      );
    }
  }
}
