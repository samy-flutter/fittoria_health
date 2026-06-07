import 'package:equatable/equatable.dart';
import '../../data/models/social_models.dart';

abstract class SocialCommentsState extends Equatable {
  const SocialCommentsState();

  @override
  List<Object?> get props => [];
}

class SocialCommentsInitial extends SocialCommentsState {}

class SocialCommentsLoading extends SocialCommentsState {}

class SocialCommentsLoaded extends SocialCommentsState {
  final List<SocialComment> comments;
  final bool isAddingComment;

  const SocialCommentsLoaded({
    required this.comments,
    this.isAddingComment = false,
  });

  SocialCommentsLoaded copyWith({
    List<SocialComment>? comments,
    bool? isAddingComment,
  }) {
    return SocialCommentsLoaded(
      comments: comments ?? this.comments,
      isAddingComment: isAddingComment ?? this.isAddingComment,
    );
  }

  @override
  List<Object?> get props => [comments, isAddingComment];
}

class SocialCommentsError extends SocialCommentsState {
  final String message;

  const SocialCommentsError(this.message);

  @override
  List<Object> get props => [message];
}
