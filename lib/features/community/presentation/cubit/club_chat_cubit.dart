import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/clubs_repository.dart';
import 'club_chat_state.dart';
import '../../data/models/club_models.dart';

class ClubChatCubit extends Cubit<ClubChatState> {
  final ClubsRepository _repository;
  Timer? _pollingTimer;
  int _currentClubId = -1;

  ClubChatCubit(this._repository) : super(ClubChatInitial());

  void initChat(int clubId) {
    _currentClubId = clubId;
    _loadMessages();
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _pollMessages();
    });
  }

  Future<void> _loadMessages() async {
    emit(ClubChatLoading());
    final result = await _repository.getClubChat(_currentClubId);
    result.fold(
      (failure) => emit(ClubChatError(failure.message)),
      (messages) => emit(ClubChatLoaded(messages: messages)),
    );
  }

  Future<void> _pollMessages() async {
    if (state is! ClubChatLoaded) return;
    final currentState = state as ClubChatLoaded;
    
    // Determine the last message ID to poll for new ones
    int lastId = 0;
    if (currentState.messages.isNotEmpty) {
      lastId = currentState.messages.last.id;
    }

    // Emit polling state silently so we don't break UI input
    emit(currentState.copyWith(isPolling: true));

    final result = await _repository.getClubChat(_currentClubId, after: lastId);
    result.fold(
      (failure) {
        // Silently fail polling
        emit(currentState.copyWith(isPolling: false));
      },
      (newMessages) {
        if (newMessages.isNotEmpty) {
          // Append new messages
          final updatedMessages = List<ClubChatMessage>.from(currentState.messages)..addAll(newMessages);
          emit(currentState.copyWith(messages: updatedMessages, isPolling: false));
        } else {
          emit(currentState.copyWith(isPolling: false));
        }
      },
    );
  }

  Future<void> sendMessage(String body) async {
    if (state is! ClubChatLoaded) return;
    final currentState = state as ClubChatLoaded;

    // Optimistically, we could add a fake message, but since polling is active,
    // we'll just show a sending indicator.
    emit(currentState.copyWith(isSending: true));

    final result = await _repository.sendChatMessage(_currentClubId, body);
    result.fold(
      (failure) {
        emit(ClubChatError(failure.message));
        // Revert to previous state
        emit(currentState);
      },
      (_) {
        // Success. Let polling pick up the new message soon.
        emit(currentState.copyWith(isSending: false));
        _pollMessages(); // Immediately poll to fetch the newly sent message
      },
    );
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}
