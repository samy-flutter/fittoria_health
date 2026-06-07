class FitnessSummary {
  final FitToday today;
  final List<FitGoal> goals;
  final FitVitals vitals;
  final List<FitChallenge> challenges;
  final FitCareTeam careTeam;
  final List<AcademyVideo> academyVideos;
  final List<FitWeekStep> weekSteps;

  FitnessSummary({
    required this.today,
    required this.goals,
    required this.vitals,
    required this.challenges,
    required this.careTeam,
    required this.academyVideos,
    required this.weekSteps,
  });

  factory FitnessSummary.fromJson(Map<String, dynamic> json) {
    return FitnessSummary(
      today: FitToday.fromJson(json['today'] ?? {}),
      goals: (json['goals'] as List?)?.map((e) => FitGoal.fromJson(e)).toList() ?? [],
      vitals: FitVitals.fromJson(json['vitals'] ?? {}),
      challenges: (json['challenges'] as List?)?.map((e) => FitChallenge.fromJson(e)).toList() ?? [],
      careTeam: FitCareTeam.fromJson(json['careTeam'] ?? {}),
      academyVideos: (json['academyVideos'] as List?)?.map((e) => AcademyVideo.fromJson(e)).toList() ?? [],
      weekSteps: (json['weekSteps'] as List?)?.map((e) => FitWeekStep.fromJson(e)).toList() ?? [],
    );
  }
}

class FitToday {
  final int steps;
  final double distanceKm;
  final int caloriesKcal;
  final int activeMinutes;
  final int waterMl;
  final int nutritionKcal;

  FitToday({
    this.steps = 0,
    this.distanceKm = 0,
    this.caloriesKcal = 0,
    this.activeMinutes = 0,
    this.waterMl = 0,
    this.nutritionKcal = 0,
  });

  factory FitToday.fromJson(Map<String, dynamic> json) {
    return FitToday(
      steps: _parseInt(json['steps']),
      distanceKm: _parseDouble(json['distance_km']),
      caloriesKcal: _parseInt(json['calories_kcal']),
      activeMinutes: _parseInt(json['active_minutes']),
      waterMl: _parseInt(json['water_ml']),
      nutritionKcal: _parseInt(json['nutrition']?['kcal']),
    );
  }
}

class FitGoal {
  final int id;
  final String goalType;
  final double targetValue;
  final double current;
  final int pct;

  FitGoal({
    this.id = 0,
    this.goalType = '',
    this.targetValue = 0,
    this.current = 0,
    this.pct = 0,
  });

  factory FitGoal.fromJson(Map<String, dynamic> json) {
    return FitGoal(
      id: _parseInt(json['id']),
      goalType: json['goal_type'] ?? '',
      targetValue: _parseDouble(json['target_value']),
      current: _parseDouble(json['current']),
      pct: _parseInt(json['pct']),
    );
  }
}

class FitVitals {
  final int? heartRateBpm;
  final int? sleepTotalMin;
  final String? mood;
  final int workoutsThisWeek;

  FitVitals({
    this.heartRateBpm,
    this.sleepTotalMin,
    this.mood,
    this.workoutsThisWeek = 0,
  });

  factory FitVitals.fromJson(Map<String, dynamic> json) {
    return FitVitals(
      heartRateBpm: _parseInt(json['heart_rate']?['bpm'], nullIfZero: true),
      sleepTotalMin: _parseInt(json['sleep']?['total_min'], nullIfZero: true),
      mood: json['mood']?['mood'],
      workoutsThisWeek: _parseInt(json['workouts_this_week']),
    );
  }
}

class FitChallenge {
  final int id;
  final String title;
  final double targetValue;
  final double currentValue;

  FitChallenge({
    this.id = 0,
    this.title = '',
    this.targetValue = 0,
    this.currentValue = 0,
  });

  factory FitChallenge.fromJson(Map<String, dynamic> json) {
    return FitChallenge(
      id: _parseInt(json['id']),
      title: json['title'] ?? '',
      targetValue: _parseDouble(json['target_value']),
      currentValue: _parseDouble(json['current_value']),
    );
  }
}

class FitCareTeam {
  final CareTeamGym? gym;
  final CareTeamTrainer? trainer;
  final CareTeamDietitian? dietitian;
  final CareTeamMeeting? nextMeeting;

  FitCareTeam({this.gym, this.trainer, this.dietitian, this.nextMeeting});

  factory FitCareTeam.fromJson(Map<String, dynamic> json) {
    return FitCareTeam(
      gym: json['gym'] != null ? CareTeamGym.fromJson(json['gym']) : null,
      trainer: json['trainer'] != null ? CareTeamTrainer.fromJson(json['trainer']) : null,
      dietitian: json['dietitian'] != null ? CareTeamDietitian.fromJson(json['dietitian']) : null,
      nextMeeting: json['nextMeeting'] != null ? CareTeamMeeting.fromJson(json['nextMeeting']) : null,
    );
  }
}

class CareTeamGym {
  final String gymName;
  final String status;
  final String planName;
  final String endDate;
  final String trainerName;
  final String dietitianName;

  CareTeamGym({
    this.gymName = '',
    this.status = '',
    this.planName = '',
    this.endDate = '',
    this.trainerName = '',
    this.dietitianName = '',
  });

  factory CareTeamGym.fromJson(Map<String, dynamic> json) {
    return CareTeamGym(
      gymName: json['gym_name'] ?? '',
      status: json['status'] ?? '',
      planName: json['plan_name'] ?? '',
      endDate: json['end_date'] ?? '',
      trainerName: json['trainer_name'] ?? '',
      dietitianName: json['dietitian_name'] ?? '',
    );
  }
}

class CareTeamTrainer {
  final String trainerName;
  final String specialization;
  final String trainerPhone;

  CareTeamTrainer({this.trainerName = '', this.specialization = '', this.trainerPhone = ''});

  factory CareTeamTrainer.fromJson(Map<String, dynamic> json) {
    return CareTeamTrainer(
      trainerName: json['trainer_name'] ?? '',
      specialization: json['specialization'] ?? '',
      trainerPhone: json['trainer_phone'] ?? '',
    );
  }
}

class CareTeamDietitian {
  final String dietitianName;
  final String specialization;
  final String dietitianPhone;

  CareTeamDietitian({this.dietitianName = '', this.specialization = '', this.dietitianPhone = ''});

  factory CareTeamDietitian.fromJson(Map<String, dynamic> json) {
    return CareTeamDietitian(
      dietitianName: json['dietitian_name'] ?? '',
      specialization: json['specialization'] ?? '',
      dietitianPhone: json['dietitian_phone'] ?? '',
    );
  }
}

class CareTeamMeeting {
  final String title;
  final String staffName;
  final String scheduledAt;
  final String meetingUrl;

  CareTeamMeeting({this.title = '', this.staffName = '', this.scheduledAt = '', this.meetingUrl = ''});

  factory CareTeamMeeting.fromJson(Map<String, dynamic> json) {
    return CareTeamMeeting(
      title: json['title'] ?? '',
      staffName: json['staff_name'] ?? '',
      scheduledAt: json['scheduled_at'] ?? '',
      meetingUrl: json['meeting_url'] ?? '',
    );
  }
}

class AcademyVideo {
  final int id;
  final String title;
  final String category;
  final int durationSec;
  final int viewCount;
  final String thumbnailUrl;

  AcademyVideo({
    this.id = 0,
    this.title = '',
    this.category = '',
    this.durationSec = 0,
    this.viewCount = 0,
    this.thumbnailUrl = '',
  });

  factory AcademyVideo.fromJson(Map<String, dynamic> json) {
    return AcademyVideo(
      id: _parseInt(json['id']),
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      durationSec: _parseInt(json['duration_sec']),
      viewCount: _parseInt(json['view_count']),
      thumbnailUrl: json['thumbnail_url'] ?? '',
    );
  }
}

class FitWeekStep {
  final String date;
  final int steps;

  FitWeekStep({this.date = '', this.steps = 0});

  factory FitWeekStep.fromJson(Map<String, dynamic> json) {
    return FitWeekStep(
      date: json['date'] ?? '',
      steps: _parseInt(json['steps']),
    );
  }
}

class OnboardingStatus {
  final bool completed;
  final int points;

  OnboardingStatus({this.completed = false, this.points = 0});

  factory OnboardingStatus.fromJson(Map<String, dynamic> json) {
    return OnboardingStatus(
      completed: json['completed'] == true,
      points: _parseInt(json['profile']?['achievement_points']),
    );
  }
}

int _parseInt(dynamic value, {bool nullIfZero = false}) {
  if (value == null) return 0;
  if (value is int) return nullIfZero && value == 0 ? 0 : value;
  if (value is double) return value.toInt();
  if (value is String) {
    final parsed = int.tryParse(value) ?? 0;
    return nullIfZero && parsed == 0 ? 0 : parsed;
  }
  return 0;
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}
