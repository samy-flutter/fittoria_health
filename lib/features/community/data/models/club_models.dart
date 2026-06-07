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
