import 'package:equatable/equatable.dart';
import '../../data/models/trainer_models.dart';

abstract class TrainersState extends Equatable {
  const TrainersState();
  @override
  List<Object?> get props => [];
}

class TrainersInitial extends TrainersState {}

class TrainersLoading extends TrainersState {}

class TrainersLoaded extends TrainersState {
  final List<Trainer> trainers;
  final String query;
  final bool isBooking;
  final bool bookingSuccess;
  final String? bookingError;

  const TrainersLoaded({
    required this.trainers,
    this.query = '',
    this.isBooking = false,
    this.bookingSuccess = false,
    this.bookingError,
  });

  TrainersLoaded copyWith({
    List<Trainer>? trainers,
    String? query,
    bool? isBooking,
    bool? bookingSuccess,
    String? bookingError,
  }) {
    return TrainersLoaded(
      trainers: trainers ?? this.trainers,
      query: query ?? this.query,
      isBooking: isBooking ?? this.isBooking,
      bookingSuccess: bookingSuccess ?? this.bookingSuccess,
      bookingError: bookingError ?? this.bookingError, // Keep error or clear? We usually pass null to clear
    );
  }

  TrainersLoaded clearBookingState() {
    return TrainersLoaded(
      trainers: trainers,
      query: query,
      isBooking: false,
      bookingSuccess: false,
      bookingError: null,
    );
  }

  @override
  List<Object?> get props => [trainers, query, isBooking, bookingSuccess, bookingError];
}

class TrainersError extends TrainersState {
  final String message;
  const TrainersError(this.message);

  @override
  List<Object> get props => [message];
}
