class SocialPost {
  final int id;
  final String authorName;
  final String? authorPic;
  final String body;
  final String postType; // e.g. workout, general, meal
  final List<String> mediaUrls;
  final int likes;
  final int commentsCount;
  final bool isLiked;
  final bool isSaved;
  final DateTime createdAt;

  SocialPost({
    required this.id,
    required this.authorName,
    this.authorPic,
    required this.body,
    required this.postType,
    required this.mediaUrls,
    required this.likes,
    required this.commentsCount,
    required this.isLiked,
    required this.isSaved,
    required this.createdAt,
  });

  SocialPost copyWith({
    int? id,
    String? authorName,
    String? authorPic,
    String? body,
    String? postType,
    List<String>? mediaUrls,
    int? likes,
    int? commentsCount,
    bool? isLiked,
    bool? isSaved,
    DateTime? createdAt,
  }) {
    return SocialPost(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorPic: authorPic ?? this.authorPic,
      body: body ?? this.body,
      postType: postType ?? this.postType,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      likes: likes ?? this.likes,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory SocialPost.fromJson(Map<String, dynamic> json) {
    return SocialPost(
      id: json['id'] as int,
      authorName: json['author_name'] as String,
      authorPic: json['author_pic'] as String?,
      body: json['body'] as String,
      postType: json['post_type'] as String? ?? 'general',
      mediaUrls: (json['media'] as List?)?.map((e) {
        if (e is Map<String, dynamic> && e['url'] != null) {
          return e['url'] as String;
        }
        return e.toString();
      }).toList() ?? [],
      likes: json['likes'] != null ? int.tryParse(json['likes'].toString()) ?? 0 : json['like_count'] != null ? int.tryParse(json['like_count'].toString()) ?? 0 : 0,
      commentsCount: json['comments_count'] != null ? int.tryParse(json['comments_count'].toString()) ?? 0 : json['comment_count'] != null ? int.tryParse(json['comment_count'].toString()) ?? 0 : 0,
      isLiked: json['is_liked'] == true || json['is_liked'] == 1 || json['liked'] == true || json['liked'] == 1,
      isSaved: json['is_saved'] == true || json['is_saved'] == 1 || json['saved'] == true || json['saved'] == 1,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class SocialComment {
  final int id;
  final String authorName;
  final String? authorPic;
  final String body;
  final DateTime createdAt;

  SocialComment({
    required this.id,
    required this.authorName,
    this.authorPic,
    required this.body,
    required this.createdAt,
  });

  factory SocialComment.fromJson(Map<String, dynamic> json) {
    return SocialComment(
      id: json['id'] as int,
      authorName: json['author_name'] as String,
      authorPic: json['author_pic'] as String?,
      body: json['body'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
