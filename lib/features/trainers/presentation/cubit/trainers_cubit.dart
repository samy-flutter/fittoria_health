import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/trainers_repository.dart';
import 'trainers_state.dart';

class TrainersCubit extends Cubit<TrainersState> {
  final TrainersRepository _repository;

  TrainersCubit(this._repository) : super(TrainersInitial());

  Future<void> loadTrainers({String query = ''}) async {
    emit(TrainersLoading());
    final result = await _repository.getTrainers(query: query);
    result.fold(
      (failure) => emit(TrainersError(failure.message)),
      (trainers) => emit(TrainersLoaded(trainers: trainers, query: query)),
    );
  }

  Future<void> searchTrainers(String query) async {
    if (state is TrainersLoaded) {
      final currentState = state as TrainersLoaded;
      emit(currentState.copyWith(query: query));
      final result = await _repository.getTrainers(query: query);
      result.fold(
        (failure) {}, // handle error gracefully in a real app
        (trainers) {
          if (!isClosed) emit(currentState.copyWith(trainers: trainers, query: query));
        },
      );
    } else {
      loadTrainers(query: query);
    }
  }

  Future<void> bookTrainer(int trainerId, String sessionType, DateTime scheduledAt, String notes) async {
    if (state is! TrainersLoaded) return;
    final currentState = state as TrainersLoaded;
    
    emit(currentState.copyWith(isBooking: true, bookingSuccess: false, bookingError: null));
    
    final result = await _repository.bookTrainer(trainerId, sessionType, scheduledAt, notes);
    result.fold(
      (failure) => emit(currentState.copyWith(isBooking: false, bookingError: failure.message)),
      (_) => emit(currentState.copyWith(isBooking: false, bookingSuccess: true)),
    );
  }

  void resetBookingState() {
    if (state is TrainersLoaded) {
      emit((state as TrainersLoaded).clearBookingState());
    }
  }
}
