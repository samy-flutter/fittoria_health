import 'package:equatable/equatable.dart';
import '../../data/models/social_models.dart';

abstract class SocialState extends Equatable {
  const SocialState();

  @override
  List<Object?> get props => [];
}

class SocialInitial extends SocialState {}

class SocialLoading extends SocialState {}

class SocialLoaded extends SocialState {
  final List<SocialPost> posts;
  final bool isCreatingPost;
  final String feedType; // 'explore' or 'following'

  const SocialLoaded({
    required this.posts,
    this.isCreatingPost = false,
    this.feedType = 'explore',
  });

  SocialLoaded copyWith({
    List<SocialPost>? posts,
    bool? isCreatingPost,
    String? feedType,
  }) {
    return SocialLoaded(
      posts: posts ?? this.posts,
      isCreatingPost: isCreatingPost ?? this.isCreatingPost,
      feedType: feedType ?? this.feedType,
    );
  }

  @override
  List<Object?> get props => [posts, isCreatingPost, feedType];
}

class SocialError extends SocialState {
  final String message;

  const SocialError(this.message);

  @override
  List<Object> get props => [message];
}
