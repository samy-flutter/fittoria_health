import 'package:equatable/equatable.dart';
import '../../data/models/club_models.dart';

abstract class ClubChatState extends Equatable {
  const ClubChatState();

  @override
  List<Object?> get props => [];
}

class ClubChatInitial extends ClubChatState {}

class ClubChatLoading extends ClubChatState {}

class ClubChatLoaded extends ClubChatState {
  final List<ClubChatMessage> messages;
  final bool isSending;
  final bool isPolling;

  const ClubChatLoaded({
    required this.messages,
    this.isSending = false,
    this.isPolling = false,
  });

  ClubChatLoaded copyWith({
    List<ClubChatMessage>? messages,
    bool? isSending,
    bool? isPolling,
  }) {
    return ClubChatLoaded(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      isPolling: isPolling ?? this.isPolling,
    );
  }

  @override
  List<Object?> get props => [messages, isSending, isPolling];
}

class ClubChatError extends ClubChatState {
  final String message;

  const ClubChatError(this.message);

  @override
  List<Object?> get props => [message];
}
