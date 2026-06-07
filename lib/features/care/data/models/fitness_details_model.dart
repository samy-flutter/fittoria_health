class FitnessDetailsData {
  final FitnessTrainer? trainer;
  final List<FitnessPlan> plans;
  final FitnessPlan? activePlan;
  final List<WorkoutTracking> tracking;
  final List<TrainerReport> reports;

  FitnessDetailsData({
    this.trainer,
    this.plans = const [],
    this.activePlan,
    this.tracking = const [],
    this.reports = const [],
  });

  factory FitnessDetailsData.fromJson(Map<String, dynamic> json) {
    return FitnessDetailsData(
      trainer: json['trainer'] != null ? FitnessTrainer.fromJson(json['trainer']) : null,
      plans: (json['plans'] as List?)?.map((e) => FitnessPlan.fromJson(e)).toList() ?? [],
      activePlan: json['activePlan'] != null ? FitnessPlan.fromJson(json['activePlan']) : null,
      tracking: (json['tracking'] as List?)?.map((e) => WorkoutTracking.fromJson(e)).toList() ?? [],
      reports: (json['reports'] as List?)?.map((e) => TrainerReport.fromJson(e)).toList() ?? [],
    );
  }
}

class FitnessTrainer {
  final int id;
  final String status;
  final String trainerName;
  final String trainerPhone;
  final String specialization;
  final String bio;

  FitnessTrainer({
    required this.id,
    this.status = '',
    this.trainerName = '',
    this.trainerPhone = '',
    this.specialization = '',
    this.bio = '',
  });

  factory FitnessTrainer.fromJson(Map<String, dynamic> json) {
    return FitnessTrainer(
      id: json['id'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      trainerName: json['trainer_name'] as String? ?? '',
      trainerPhone: json['trainer_phone'] as String? ?? '',
      specialization: json['specialization'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
    );
  }
}

class FitnessPlan {
  final int id;
  final String title;
  final String description;
  final String status;
  final List<WorkoutExercise> exercises;

  FitnessPlan({
    required this.id,
    this.title = '',
    this.description = '',
    this.status = '',
    this.exercises = const [],
  });

  factory FitnessPlan.fromJson(Map<String, dynamic> json) {
    return FitnessPlan(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? '',
      exercises: (json['exercises'] as List?)?.map((e) => WorkoutExercise.fromJson(e)).toList() ?? [],
    );
  }
}

class WorkoutExercise {
  final String exerciseName;
  final String muscleGroup;
  final int sets;
  final int reps;

  WorkoutExercise({
    this.exerciseName = '',
    this.muscleGroup = '',
    this.sets = 0,
    this.reps = 0,
  });

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      exerciseName: json['exercise_name'] as String? ?? '',
      muscleGroup: json['muscle_group'] as String? ?? '',
      sets: json['sets'] as int? ?? 0,
      reps: json['reps'] as int? ?? 0,
    );
  }
}

class WorkoutTracking {
  final int id;
  final String trackingDate;
  final String exerciseName;
  final int compliance;

  WorkoutTracking({
    required this.id,
    this.trackingDate = '',
    this.exerciseName = '',
    this.compliance = 0,
  });

  factory WorkoutTracking.fromJson(Map<String, dynamic> json) {
    return WorkoutTracking(
      id: json['id'] as int? ?? 0,
      trackingDate: json['tracking_date'] as String? ?? '',
      exerciseName: json['exercise_name'] as String? ?? '',
      compliance: json['compliance'] as int? ?? 0,
    );
  }
}

class TrainerReport {
  final int id;
  final String title;
  final String createdAt;

  TrainerReport({
    required this.id,
    this.title = '',
    this.createdAt = '',
  });

  factory TrainerReport.fromJson(Map<String, dynamic> json) {
    return TrainerReport(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}
