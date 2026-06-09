class SocialClub {
  final int id;
  final String name;
  final String description;
  final String category;
  final String coverColor;
  final int memberCount;
  final bool joined;

  SocialClub({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.coverColor,
    required this.memberCount,
    required this.joined,
  });

  factory SocialClub.fromJson(Map<String, dynamic> json) {
    return SocialClub(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      coverColor: json['cover_color'] as String? ?? '#E8843C',
      memberCount: json['member_count'] as int? ?? 0,
      joined: json['joined'] as bool? ?? false,
    );
  }

  SocialClub copyWith({
    int? id,
    String? name,
    String? description,
    String? category,
    String? coverColor,
    int? memberCount,
    bool? joined,
  }) {
    return SocialClub(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      coverColor: coverColor ?? this.coverColor,
      memberCount: memberCount ?? this.memberCount,
      joined: joined ?? this.joined,
    );
  }
}

class ClubChatMessage {
  final int id;
  final String body;
  final DateTime createdAt;
  final int senderPatientId;
  final String senderName;
  final String? senderPic;
  final bool isMine;

  ClubChatMessage({
    required this.id,
    required this.body,
    required this.createdAt,
    required this.senderPatientId,
    required this.senderName,
    this.senderPic,
    required this.isMine,
  });

  factory ClubChatMessage.fromJson(Map<String, dynamic> json) {
    return ClubChatMessage(
      id: json['id'] as int,
      body: json['body'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      senderPatientId: json['sender_patient_id'] as int? ?? 0,
      senderName: json['sender_name'] as String? ?? 'Unknown',
      senderPic: json['sender_pic'] as String?,
      isMine: json['isMine'] as bool? ?? false,
    );
  }
}
