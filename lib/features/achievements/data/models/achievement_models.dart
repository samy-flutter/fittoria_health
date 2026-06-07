class AchievementUser {
  final int id;
  final String fullName;
  final String? profilePic;
  final int points;

  AchievementUser({
    required this.id,
    required this.fullName,
    this.profilePic,
    required this.points,
  });

  factory AchievementUser.fromJson(Map<String, dynamic> json) {
    return AchievementUser(
      id: json['id'] as int? ?? 0,
      fullName: json['full_name'] as String? ?? 'User',
      profilePic: json['profile_pic'] as String?,
      points: (json['achievement_points'] as num?)?.toInt() ?? (json['points'] as num?)?.toInt() ?? 0,
    );
  }
}

class AchievementLedgerEntry {
  final int id;
  final String reason;
  final int points;
  final String createdAt;

  AchievementLedgerEntry({
    required this.id,
    required this.reason,
    required this.points,
    required this.createdAt,
  });

  factory AchievementLedgerEntry.fromJson(Map<String, dynamic> json) {
    return AchievementLedgerEntry(
      id: json['id'] as int,
      reason: json['reason'] as String? ?? 'Unknown',
      points: json['points'] as int? ?? 0,
      createdAt: json['created_at'] as String? ?? DateTime.now().toIso8601String(),
    );
  }
}

class AchievementsData {
  final int total;
  final int level;
  final int intoLevel;
  final int toNext;
  final int rank;
  final List<AchievementUser> leaderboard;
  final List<AchievementLedgerEntry> ledger;

  AchievementsData({
    required this.total,
    required this.level,
    required this.intoLevel,
    required this.toNext,
    required this.rank,
    required this.leaderboard,
    required this.ledger,
  });

  factory AchievementsData.fromJson(Map<String, dynamic> json) {
    return AchievementsData(
      total: json['total'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      intoLevel: json['intoLevel'] as int? ?? 0,
      toNext: json['toNext'] as int? ?? 500,
      rank: json['rank'] as int? ?? 0,
      leaderboard: (json['leaderboard'] as List?)?.map((e) => AchievementUser.fromJson(e)).toList() ?? [],
      ledger: (json['ledger'] as List?)?.map((e) => AchievementLedgerEntry.fromJson(e)).toList() ?? [],
    );
  }
}
