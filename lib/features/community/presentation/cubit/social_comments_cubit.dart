import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/social_repository.dart';
import 'social_comments_state.dart';

class SocialCommentsCubit extends Cubit<SocialCommentsState> {
  final SocialRepository _repository;

  SocialCommentsCubit(this._repository) : super(SocialCommentsInitial());

  Future<void> loadComments(int postId) async {
    emit(SocialCommentsLoading());
    final result = await _repository.getComments(postId);

    result.fold(
      (failure) => emit(SocialCommentsError(failure.message)),
      (comments) => emit(SocialCommentsLoaded(comments: comments)),
    );
  }

  Future<void> addComment(int postId, String body) async {
    if (state is! SocialCommentsLoaded) return;
    final currentState = state as SocialCommentsLoaded;

    emit(currentState.copyWith(isAddingComment: true));

    final result = await _repository.addComment(postId, body);

    result.fold(
      (failure) {
        // Revert loading state
        emit(currentState.copyWith(isAddingComment: false));
      },
      (_) {
        // Reload comments to get the new list with proper IDs and everything
        // Or we could silently optimistically add, but backend returns nothing right now.
        // Let's just reload.
        loadComments(postId);
      },
    );
  }
}
