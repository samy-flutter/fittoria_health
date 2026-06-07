class ActivityLog {
  final int steps;
  final double distanceKm;
  final int caloriesKcal;
  final int activeMinutes;
  final DateTime logDate;

  ActivityLog({
    required this.steps,
    required this.distanceKm,
    required this.caloriesKcal,
    required this.activeMinutes,
    required this.logDate,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      steps: json['steps'] ?? 0,
      distanceKm: (json['distance_km'] ?? 0).toDouble(),
      caloriesKcal: json['calories_kcal'] ?? 0,
      activeMinutes: json['active_minutes'] ?? 0,
      logDate: DateTime.parse(json['log_date']),
    );
  }
}

class ActivityData {
  final ActivityLog totals;
  final List<ActivityLog> series;

  ActivityData({required this.totals, required this.series});

  factory ActivityData.fromJson(Map<String, dynamic> json) {
    return ActivityData(
      totals: ActivityLog.fromJson(json['totals'] ?? {}),
      series: (json['series'] as List?)?.map((x) => ActivityLog.fromJson(x)).toList() ?? [],
    );
  }
}

class HeartRateReading {
  final int id;
  final int bpm;
  final String readingType;
  final DateTime measuredAt;

  HeartRateReading({
    required this.id,
    required this.bpm,
    required this.readingType,
    required this.measuredAt,
  });

  factory HeartRateReading.fromJson(Map<String, dynamic> json) {
    return HeartRateReading(
      id: json['id'] ?? 0,
      bpm: json['bpm'] ?? 0,
      readingType: json['reading_type'] ?? '',
      measuredAt: DateTime.parse(json['measured_at']),
    );
  }
}

class HeartRateStats {
  final int? restingBpm;
  final int? avgBpm;
  final int? maxBpm;

  HeartRateStats({this.restingBpm, this.avgBpm, this.maxBpm});

  factory HeartRateStats.fromJson(Map<String, dynamic> json) {
    return HeartRateStats(
      restingBpm: json['resting_bpm'],
      avgBpm: json['avg_bpm'],
      maxBpm: json['max_bpm'],
    );
  }
}

class HeartRateData {
  final HeartRateStats stats;
  final List<HeartRateReading> readings;

  HeartRateData({required this.stats, required this.readings});

  factory HeartRateData.fromJson(Map<String, dynamic> json) {
    return HeartRateData(
      stats: HeartRateStats.fromJson(json['stats'] ?? {}),
      readings: (json['readings'] as List?)?.map((x) => HeartRateReading.fromJson(x)).toList() ?? [],
    );
  }
}

class SleepLog {
  final int id;
  final DateTime date;
  final String durationFormatted;
  final int totalMinutes;
  final int remMinutes;
  final int lightMinutes;
  final int deepMinutes;
  final int awakeMinutes;

  SleepLog({
    required this.id,
    required this.date,
    required this.durationFormatted,
    required this.totalMinutes,
    required this.remMinutes,
    required this.lightMinutes,
    required this.deepMinutes,
    required this.awakeMinutes,
  });

  factory SleepLog.fromJson(Map<String, dynamic> json) {
    return SleepLog(
      id: json['id'] ?? 0,
      date: DateTime.parse(json['date']),
      durationFormatted: json['duration_formatted'] ?? '',
      totalMinutes: json['total_minutes'] ?? 0,
      remMinutes: json['rem_minutes'] ?? 0,
      lightMinutes: json['light_minutes'] ?? 0,
      deepMinutes: json['deep_minutes'] ?? 0,
      awakeMinutes: json['awake_minutes'] ?? 0,
    );
  }
}

class SleepData {
  final String avgDuration;
  final String sleepScore;
  final List<SleepLog> history;

  SleepData({required this.avgDuration, required this.sleepScore, required this.history});

  factory SleepData.fromJson(Map<String, dynamic> json) {
    return SleepData(
      avgDuration: json['avg_duration'] ?? '',
      sleepScore: json['sleep_score'] ?? '',
      history: (json['history'] as List?)?.map((x) => SleepLog.fromJson(x)).toList() ?? [],
    );
  }
}
