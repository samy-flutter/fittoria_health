class CommunityEvent {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String? imageUrl;
  final int participantsCount;

  CommunityEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    this.imageUrl,
    required this.participantsCount,
  });

  factory CommunityEvent.fromJson(Map<String, dynamic> json) {
    return CommunityEvent(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      location: json['location'] as String,
      imageUrl: json['image_url'] as String?,
      participantsCount: json['participants_count'] as int? ?? 0,
    );
  }
}

class SocialPost {
  final int id;
  final String authorName;
  final String? authorAvatar;
  final String content;
  final DateTime postedAt;
  final int likes;
  final int comments;

  SocialPost({
    required this.id,
    required this.authorName,
    this.authorAvatar,
    required this.content,
    required this.postedAt,
    required this.likes,
    required this.comments,
  });

  factory SocialPost.fromJson(Map<String, dynamic> json) {
    return SocialPost(
      id: json['id'] as int,
      authorName: json['author_name'] as String,
      authorAvatar: json['author_avatar'] as String?,
      content: json['content'] as String,
      postedAt: DateTime.parse(json['posted_at'] as String),
      likes: json['likes'] as int? ?? 0,
      comments: json['comments'] as int? ?? 0,
    );
  }
}

class Challenge {
  final int id;
  final String title;
  final String description;
  final String target;
  final int currentProgress;
  final int totalGoal;
  final String unit;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.target,
    required this.currentProgress,
    required this.totalGoal,
    required this.unit,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      target: json['target'] as String,
      currentProgress: json['current_progress'] as int? ?? 0,
      totalGoal: json['total_goal'] as int,
      unit: json['unit'] as String,
    );
  }
}
