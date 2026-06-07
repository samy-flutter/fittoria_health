class FitDevice {
  final int id;
  final String provider;
  final String displayName;
  final String status;
  final String lastSyncAt;

  FitDevice({
    this.id = 0,
    this.provider = '',
    this.displayName = '',
    this.status = '',
    this.lastSyncAt = '',
  });

  factory FitDevice.fromJson(Map<String, dynamic> json) {
    return FitDevice(
      id: json['id'] as int? ?? 0,
      provider: json['provider'] as String? ?? '',
      displayName: json['display_name'] as String? ?? '',
      status: json['status'] as String? ?? '',
      lastSyncAt: json['last_sync_at'] as String? ?? '',
    );
  }
}

class FitGoalDetail {
  final int id;
  final String goalType;
  final double targetValue;
  final String period;
  final String sourceDevice;
  final double current;
  final int pct;

  FitGoalDetail({
    this.id = 0,
    this.goalType = '',
    this.targetValue = 0,
    this.period = '',
    this.sourceDevice = '',
    this.current = 0,
    this.pct = 0,
  });

  factory FitGoalDetail.fromJson(Map<String, dynamic> json) {
    return FitGoalDetail(
      id: json['id'] as int? ?? 0,
      goalType: json['goal_type'] as String? ?? '',
      targetValue: _parseDouble(json['target_value']),
      period: json['period'] as String? ?? '',
      sourceDevice: json['source_device'] as String? ?? '',
      current: _parseDouble(json['current']),
      pct: _parseInt(json['pct']),
    );
  }
}

int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

class FitChallengeDetail {
  final int id;
  final String title;
  final String description;
  final String challengeType;
  final double targetValue;
  final String unit;
  final int durationDays;
  final String icon;
  final double? currentValue;
  final String? status;
  final String? joinedAt;
  final int participants;
  final bool joined;
  final int pct;

  FitChallengeDetail({
    this.id = 0,
    this.title = '',
    this.description = '',
    this.challengeType = '',
    this.targetValue = 0,
    this.unit = '',
    this.durationDays = 0,
    this.icon = '',
    this.currentValue,
    this.status,
    this.joinedAt,
    this.participants = 0,
    this.joined = false,
    this.pct = 0,
  });

  factory FitChallengeDetail.fromJson(Map<String, dynamic> json) {
    return FitChallengeDetail(
      id: _parseInt(json['id']),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      challengeType: json['challenge_type'] as String? ?? '',
      targetValue: _parseDouble(json['target_value']),
      unit: json['unit'] as String? ?? '',
      durationDays: _parseInt(json['duration_days']),
      icon: json['icon'] as String? ?? '',
      currentValue: json['current_value'] != null ? _parseDouble(json['current_value']) : null,
      status: json['status'] as String?,
      joinedAt: json['joined_at'] as String?,
      participants: _parseInt(json['participants']),
      joined: json['joined'] as bool? ?? false,
      pct: _parseInt(json['pct']),
    );
  }
}

class FitBodyProgressData {
  final List<FitBodyProgressMetric> metrics;
  final FitBodyProgressMetric? latest;
  final double? weightDelta;
  final double? fatDelta;

  FitBodyProgressData({
    this.metrics = const [],
    this.latest,
    this.weightDelta,
    this.fatDelta,
  });

  factory FitBodyProgressData.fromJson(Map<String, dynamic> json) {
    return FitBodyProgressData(
      metrics: (json['metrics'] as List?)?.map((e) => FitBodyProgressMetric.fromJson(e)).toList() ?? [],
      latest: json['latest'] != null ? FitBodyProgressMetric.fromJson(json['latest']) : null,
      weightDelta: json['weightDelta'] != null ? _parseDouble(json['weightDelta']) : null,
      fatDelta: json['fatDelta'] != null ? _parseDouble(json['fatDelta']) : null,
    );
  }
}

class FitBodyProgressMetric {
  final int id;
  final String recordedDate;
  final double? weightKg;
  final double? bodyFatPct;
  final double? muscleMassKg;
  final double? bmi;
  final double? waistCm;
  final double? hipCm;
  final double? chestCm;
  final double? armCm;
  final double? thighCm;
  final String? notes;
  final String? recordedByName;

  FitBodyProgressMetric({
    this.id = 0,
    this.recordedDate = '',
    this.weightKg,
    this.bodyFatPct,
    this.muscleMassKg,
    this.bmi,
    this.waistCm,
    this.hipCm,
    this.chestCm,
    this.armCm,
    this.thighCm,
    this.notes,
    this.recordedByName,
  });

  factory FitBodyProgressMetric.fromJson(Map<String, dynamic> json) {
    return FitBodyProgressMetric(
      id: _parseInt(json['id']),
      recordedDate: json['recorded_date'] as String? ?? '',
      weightKg: json['weight_kg'] != null ? _parseDouble(json['weight_kg']) : null,
      bodyFatPct: json['body_fat_pct'] != null ? _parseDouble(json['body_fat_pct']) : null,
      muscleMassKg: json['muscle_mass_kg'] != null ? _parseDouble(json['muscle_mass_kg']) : null,
      bmi: json['bmi'] != null ? _parseDouble(json['bmi']) : null,
      waistCm: json['waist_cm'] != null ? _parseDouble(json['waist_cm']) : null,
      hipCm: json['hip_cm'] != null ? _parseDouble(json['hip_cm']) : null,
      chestCm: json['chest_cm'] != null ? _parseDouble(json['chest_cm']) : null,
      armCm: json['arm_cm'] != null ? _parseDouble(json['arm_cm']) : null,
      thighCm: json['thigh_cm'] != null ? _parseDouble(json['thigh_cm']) : null,
      notes: json['notes'] as String?,
      recordedByName: json['recorded_by_name'] as String?,
    );
  }
}

class FitWorkoutData {
  final List<FitWorkoutSession> workouts;
  final FitWorkoutStats stats;

  FitWorkoutData({
    this.workouts = const [],
    required this.stats,
  });

  factory FitWorkoutData.fromJson(Map<String, dynamic> json) {
    return FitWorkoutData(
      workouts: (json['workouts'] as List?)?.map((e) => FitWorkoutSession.fromJson(e)).toList() ?? [],
      stats: FitWorkoutStats.fromJson(json['stats'] ?? {}),
    );
  }
}

class FitWorkoutStats {
  final int total;
  final int minutes;
  final int calories;
  final double distanceKm;

  FitWorkoutStats({
    this.total = 0,
    this.minutes = 0,
    this.calories = 0,
    this.distanceKm = 0.0,
  });

  factory FitWorkoutStats.fromJson(Map<String, dynamic> json) {
    return FitWorkoutStats(
      total: _parseInt(json['total']),
      minutes: _parseInt(json['minutes']),
      calories: _parseInt(json['calories']),
      distanceKm: _parseDouble(json['distance_km']),
    );
  }
}

class FitWorkoutSession {
  final int id;
  final String workoutType;
  final String? title;
  final String startedAt;
  final int durationMin;
  final double distanceKm;
  final int caloriesKcal;
  final int? avgHeartRate;
  final int? maxHeartRate;
  final String? notes;

  FitWorkoutSession({
    this.id = 0,
    this.workoutType = '',
    this.title,
    this.startedAt = '',
    this.durationMin = 0,
    this.distanceKm = 0.0,
    this.caloriesKcal = 0,
    this.avgHeartRate,
    this.maxHeartRate,
    this.notes,
  });

  factory FitWorkoutSession.fromJson(Map<String, dynamic> json) {
    return FitWorkoutSession(
      id: _parseInt(json['id']),
      workoutType: json['workout_type'] as String? ?? '',
      title: json['title'] as String?,
      startedAt: json['started_at'] as String? ?? '',
      durationMin: _parseInt(json['duration_min']),
      distanceKm: _parseDouble(json['distance_km']),
      caloriesKcal: _parseInt(json['calories_kcal']),
      avgHeartRate: json['avg_heart_rate'] != null ? _parseInt(json['avg_heart_rate']) : null,
      maxHeartRate: json['max_heart_rate'] != null ? _parseInt(json['max_heart_rate']) : null,
      notes: json['notes'] as String?,
    );
  }
}
