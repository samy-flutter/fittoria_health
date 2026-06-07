class AcademyVideo {
  final int id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String videoUrl;
  final int durationSec;
  final int viewCount;
  final int likeCount;
  final String category;
  final bool liked;
  final bool completed;
  final int watchedSec;

  AcademyVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.durationSec,
    required this.viewCount,
    required this.likeCount,
    required this.category,
    required this.liked,
    this.completed = false,
    this.watchedSec = 0,
  });

  factory AcademyVideo.fromJson(Map<String, dynamic> json) {
    return AcademyVideo(
      id: _parseInt(json['id']) ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      thumbnailUrl: json['thumbnail_url'] as String? ?? '',
      videoUrl: json['video_url'] as String? ?? '',
      durationSec: _parseInt(json['duration_sec']) ?? 0,
      viewCount: _parseInt(json['view_count']) ?? 0,
      likeCount: _parseInt(json['like_count']) ?? 0,
      category: json['category'] as String? ?? '',
      liked: json['liked'] == true || json['liked'] == 1,
      completed: json['completed'] == true || json['completed'] == 1,
      watchedSec: _parseInt(json['watched_sec']) ?? 0,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  AcademyVideo copyWith({
    int? likeCount,
    bool? liked,
  }) {
    return AcademyVideo(
      id: id,
      title: title,
      description: description,
      thumbnailUrl: thumbnailUrl,
      videoUrl: videoUrl,
      durationSec: durationSec,
      viewCount: viewCount,
      likeCount: likeCount ?? this.likeCount,
      category: category,
      liked: liked ?? this.liked,
      completed: completed,
      watchedSec: watchedSec,
    );
  }
}
