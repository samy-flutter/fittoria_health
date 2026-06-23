import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/social_repository.dart';
import 'social_state.dart';

class SocialCubit extends Cubit<SocialState> {
  final SocialRepository _repository;

  SocialCubit(this._repository) : super(SocialInitial());

  Future<void> loadPosts({String? feedType}) async {
    final currentFeedType =
        feedType ??
        (state is SocialLoaded ? (state as SocialLoaded).feedType : 'explore');
    emit(SocialLoading());

    // In social_remote_data_source, getPosts takes feed. For explore we pass null, for following we pass 'following'
    final apiFeedParam = currentFeedType == 'following' ? 'following' : null;
    final result = await _repository.getPosts(feed: apiFeedParam);

    result.fold(
      (failure) => emit(SocialError(failure.message)),
      (posts) => emit(SocialLoaded(posts: posts, feedType: currentFeedType)),
    );
  }

  void setFeedType(String feedType) {
    if (state is SocialLoaded) {
      if ((state as SocialLoaded).feedType == feedType) return;
    }
    loadPosts(feedType: feedType);
  }

  Future<void> createPost(
    String body,
    String postType,
    List<String> mediaUrls,
  ) async {
    if (state is! SocialLoaded) return;
    final currentState = state as SocialLoaded;

    emit(currentState.copyWith(isCreatingPost: true));

    final result = await _repository.createPost(body, postType, mediaUrls);

    result.fold(
      (failure) {
        // Stop loading, maybe emit a temporary error state, but let's just revert
        emit(currentState.copyWith(isCreatingPost: false));
      },
      (newPost) {
        // Prepend the new post
        final updatedPosts = [newPost, ...currentState.posts];
        emit(currentState.copyWith(posts: updatedPosts, isCreatingPost: false));
      },
    );
  }

  Future<void> likePost(int postId) async {
    if (state is! SocialLoaded) return;
    final currentState = state as SocialLoaded;

    // Optimistic update
    final index = currentState.posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final posts = List.of(currentState.posts);
      final p = posts[index];
      posts[index] = p.copyWith(
        isLiked: !p.isLiked,
        likes: p.isLiked ? p.likes - 1 : p.likes + 1,
      );
      emit(currentState.copyWith(posts: posts));
    }

    final result = await _repository.likePost(postId);
    result.fold(
      (failure) {}, // Ignore errors for optimistic like
      (_) {
        // We already optimistically updated
      },
    );
  }

  Future<void> savePost(int postId) async {
    if (state is! SocialLoaded) return;
    final currentState = state as SocialLoaded;

    // Optimistic update
    final index = currentState.posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final posts = List.of(currentState.posts);
      final p = posts[index];
      posts[index] = p.copyWith(isSaved: !p.isSaved);
      emit(currentState.copyWith(posts: posts));
    }

    final result = await _repository.savePost(postId);
    result.fold(
      (failure) {}, // Ignore errors for optimistic save
      (_) {},
    );
  }
}
