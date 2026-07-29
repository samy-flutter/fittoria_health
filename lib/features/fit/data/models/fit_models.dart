class ActivityLog {
  final int steps;
  final double distanceKm;
  final int caloriesKcal;
  final double activeMinutes;
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
      distanceKm: double.tryParse(json['distance_km']?.toString() ?? '') ?? 0.0,
      caloriesKcal: json['calories_kcal'] ?? 0,
      activeMinutes: double.tryParse(json['active_minutes']?.toString() ?? '') ?? 0.0,
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
class NutritionData {
  final List<NutritionEntry> entries;
  final NutritionTotals totals;

  NutritionData({required this.entries, required this.totals});

  factory NutritionData.fromJson(Map<String, dynamic> json) {
    return NutritionData(
      entries: (json['entries'] as List?)?.map((e) => NutritionEntry.fromJson(e)).toList() ?? [],
      totals: NutritionTotals.fromJson(json['totals'] ?? {}),
    );
  }
}

class NutritionEntry {
  final int? id;
  final String mealType;
  final String foodName;
  final String? quantity;
  final int caloriesKcal;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final DateTime? loggedAt;

  NutritionEntry({
    this.id,
    required this.mealType,
    required this.foodName,
    this.quantity,
    required this.caloriesKcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    this.loggedAt,
  });

  factory NutritionEntry.fromJson(Map<String, dynamic> json) {
    return NutritionEntry(
      id: json['id'],
      mealType: json['meal_type'] ?? 'snack',
      foodName: json['food_name'] ?? 'Unknown',
      quantity: json['quantity']?.toString(),
      caloriesKcal: int.tryParse(json['calories_kcal']?.toString() ?? '') ?? 0,
      proteinG: int.tryParse(json['protein_g']?.toString() ?? '') ?? 0,
      carbsG: int.tryParse(json['carbs_g']?.toString() ?? '') ?? 0,
      fatG: int.tryParse(json['fat_g']?.toString() ?? '') ?? 0,
      loggedAt: json['logged_at'] != null ? DateTime.parse(json['logged_at']) : null,
    );
  }
}

class NutritionTotals {
  final int kcal;
  final int proteinG;
  final int carbsG;
  final int fatG;

  NutritionTotals({
    required this.kcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  factory NutritionTotals.fromJson(Map<String, dynamic> json) {
    return NutritionTotals(
      kcal: int.tryParse(json['kcal']?.toString() ?? '') ?? 0,
      proteinG: int.tryParse(json['protein_g']?.toString() ?? '') ?? 0,
      carbsG: int.tryParse(json['carbs_g']?.toString() ?? '') ?? 0,
      fatG: int.tryParse(json['fat_g']?.toString() ?? '') ?? 0,
    );
  }
}

class WaterData {
  final int totalMl;
  final List<WaterEntry> entries;
  final List<WaterWeekData> week;

  WaterData({required this.totalMl, required this.entries, required this.week});

  factory WaterData.fromJson(Map<String, dynamic> json) {
    return WaterData(
      totalMl: int.tryParse(json['total_ml']?.toString() ?? '') ?? 0,
      entries: (json['entries'] as List?)?.map((e) => WaterEntry.fromJson(e)).toList() ?? [],
      week: (json['week'] as List?)?.map((e) => WaterWeekData.fromJson(e)).toList() ?? [],
    );
  }
}

class WaterEntry {
  final int? id;
  final int ml;
  final DateTime? loggedAt;

  WaterEntry({this.id, required this.ml, this.loggedAt});

  factory WaterEntry.fromJson(Map<String, dynamic> json) {
    return WaterEntry(
      id: json['id'],
      ml: int.tryParse(json['ml']?.toString() ?? '') ?? 0,
      loggedAt: json['logged_at'] != null ? DateTime.parse(json['logged_at']) : null,
    );
  }
}

class WaterWeekData {
  final String logDate;
  final int ml;

  WaterWeekData({required this.logDate, required this.ml});

  factory WaterWeekData.fromJson(Map<String, dynamic> json) {
    return WaterWeekData(
      logDate: json['log_date'] ?? '',
      ml: int.tryParse(json['ml']?.toString() ?? '') ?? 0,
    );
  }
}

class MoodData {
  final List<MoodLog> logs;

  MoodData({required this.logs});

  factory MoodData.fromJson(Map<String, dynamic> json) {
    return MoodData(
      logs: (json['logs'] as List?)?.map((e) => MoodLog.fromJson(e)).toList() ?? [],
    );
  }
}

class MoodLog {
  final int? id;
  final String mood;
  final int? stressLevel;
  final int? energyLevel;
  final String? note;
  final DateTime? loggedAt;

  MoodLog({
    this.id,
    required this.mood,
    this.stressLevel,
    this.energyLevel,
    this.note,
    this.loggedAt,
  });

  factory MoodLog.fromJson(Map<String, dynamic> json) {
    return MoodLog(
      id: json['id'],
      mood: json['mood'] ?? 'okay',
      stressLevel: json['stress_level'],
      energyLevel: json['energy_level'],
      note: json['note'],
      loggedAt: json['logged_at'] != null ? DateTime.parse(json['logged_at']) : null,
    );
  }
}
