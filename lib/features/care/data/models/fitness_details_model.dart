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
  final String programStart;
  final String programEnd;

  FitnessTrainer({
    required this.id,
    this.status = '',
    this.trainerName = '',
    this.trainerPhone = '',
    this.specialization = '',
    this.bio = '',
    this.programStart = '',
    this.programEnd = '',
  });

  factory FitnessTrainer.fromJson(Map<String, dynamic> json) {
    return FitnessTrainer(
      id: json['id'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      trainerName: json['trainer_name'] as String? ?? '',
      trainerPhone: json['trainer_phone'] as String? ?? '',
      specialization: json['specialization'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      programStart: json['program_start'] as String? ?? '',
      programEnd: json['program_end'] as String? ?? '',
    );
  }
}

class FitnessPlan {
  final int id;
  final String title;
  final String description;
  final String goal;
  final String difficulty;
  final String startDate;
  final String endDate;
  final String status;
  final String trainerName;
  final List<WorkoutExercise> exercises;

  FitnessPlan({
    required this.id,
    this.title = '',
    this.description = '',
    this.goal = '',
    this.difficulty = '',
    this.startDate = '',
    this.endDate = '',
    this.status = '',
    this.trainerName = '',
    this.exercises = const [],
  });

  factory FitnessPlan.fromJson(Map<String, dynamic> json) {
    return FitnessPlan(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      goal: json['goal'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? '',
      startDate: json['start_date'] as String? ?? '',
      endDate: json['end_date'] as String? ?? '',
      status: json['status'] as String? ?? '',
      trainerName: json['trainer_name'] as String? ?? '',
      exercises: (json['exercises'] as List?)?.map((e) => WorkoutExercise.fromJson(e)).toList() ?? [],
    );
  }
}

class WorkoutExercise {
  final String exerciseName;
  final String muscleGroup;
  final int? sets;
  final String? reps;
  final double? weightKg;
  final int? durationMin;
  final int? restSec;
  final String instructions;
  final int? dayOfWeek;

  WorkoutExercise({
    this.exerciseName = '',
    this.muscleGroup = '',
    this.sets,
    this.reps,
    this.weightKg,
    this.durationMin,
    this.restSec,
    this.instructions = '',
    this.dayOfWeek,
  });

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      exerciseName: json['exercise_name'] as String? ?? '',
      muscleGroup: json['muscle_group'] as String? ?? '',
      sets: json['sets'] as int?,
      reps: json['reps']?.toString(),
      weightKg: json['weight_kg'] != null ? _parseDouble(json['weight_kg']) : null,
      durationMin: json['duration_min'] as int?,
      restSec: json['rest_sec'] as int?,
      instructions: json['instructions'] as String? ?? '',
      dayOfWeek: json['day_of_week'] as int?,
    );
  }
}

class WorkoutTracking {
  final int id;
  final String trackingDate;
  final String exerciseName;
  final int? setsDone;
  final String? repsDone;
  final String compliance;
  final String trainerFeedback;
  final String notes;

  WorkoutTracking({
    required this.id,
    this.trackingDate = '',
    this.exerciseName = '',
    this.setsDone,
    this.repsDone,
    this.compliance = '',
    this.trainerFeedback = '',
    this.notes = '',
  });

  factory WorkoutTracking.fromJson(Map<String, dynamic> json) {
    return WorkoutTracking(
      id: json['id'] as int? ?? 0,
      trackingDate: json['tracking_date'] as String? ?? '',
      exerciseName: json['exercise_name'] as String? ?? '',
      setsDone: json['sets_done'] as int?,
      repsDone: json['reps_done']?.toString(),
      compliance: json['compliance']?.toString() ?? '',
      trainerFeedback: json['trainer_feedback'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
    );
  }
}

class TrainerReport {
  final int id;
  final String reportType;
  final String title;
  final String periodFrom;
  final String periodTo;
  final String createdAt;

  TrainerReport({
    required this.id,
    this.reportType = '',
    this.title = '',
    this.periodFrom = '',
    this.periodTo = '',
    this.createdAt = '',
  });

  factory TrainerReport.fromJson(Map<String, dynamic> json) {
    return TrainerReport(
      id: json['id'] as int? ?? 0,
      reportType: json['report_type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      periodFrom: json['period_from'] as String? ?? '',
      periodTo: json['period_to'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}
