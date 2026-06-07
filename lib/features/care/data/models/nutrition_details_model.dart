class NutritionDetailsData {
  final CareDietitian? dietitian;
  final List<MealPlan> plans;
  final MealPlan? activePlan;
  final List<MealTracking> tracking;

  NutritionDetailsData({
    this.dietitian,
    this.plans = const [],
    this.activePlan,
    this.tracking = const [],
  });

  factory NutritionDetailsData.fromJson(Map<String, dynamic> json) {
    return NutritionDetailsData(
      dietitian: json['dietitian'] != null ? CareDietitian.fromJson(json['dietitian']) : null,
      plans: (json['plans'] as List?)?.map((e) => MealPlan.fromJson(e)).toList() ?? [],
      activePlan: json['activePlan'] != null ? MealPlan.fromJson(json['activePlan']) : null,
      tracking: (json['tracking'] as List?)?.map((e) => MealTracking.fromJson(e)).toList() ?? [],
    );
  }
}

class CareDietitian {
  final int id;
  final String status;
  final String dietitianName;
  final String dietitianPhone;
  final String specialization;
  final String bio;

  CareDietitian({
    required this.id,
    this.status = '',
    this.dietitianName = '',
    this.dietitianPhone = '',
    this.specialization = '',
    this.bio = '',
  });

  factory CareDietitian.fromJson(Map<String, dynamic> json) {
    return CareDietitian(
      id: json['id'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      dietitianName: json['dietitian_name'] as String? ?? '',
      dietitianPhone: json['dietitian_phone'] as String? ?? '',
      specialization: json['specialization'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
    );
  }
}

class MealPlan {
  final int id;
  final String title;
  final String description;
  final String status;
  final int totalCalories;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final List<MealItem> items;

  MealPlan({
    required this.id,
    this.title = '',
    this.description = '',
    this.status = '',
    this.totalCalories = 0,
    this.proteinG = 0,
    this.carbsG = 0,
    this.fatG = 0,
    this.items = const [],
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? '',
      totalCalories: json['total_calories'] as int? ?? 0,
      proteinG: json['protein_g'] as int? ?? 0,
      carbsG: json['carbs_g'] as int? ?? 0,
      fatG: json['fat_g'] as int? ?? 0,
      items: (json['items'] as List?)?.map((e) => MealItem.fromJson(e)).toList() ?? [],
    );
  }
}

class MealItem {
  final String mealType;
  final String foodName;
  final String portionSize;
  final int calories;

  MealItem({
    this.mealType = '',
    this.foodName = '',
    this.portionSize = '',
    this.calories = 0,
  });

  factory MealItem.fromJson(Map<String, dynamic> json) {
    return MealItem(
      mealType: json['meal_type'] as String? ?? '',
      foodName: json['food_name'] as String? ?? '',
      portionSize: json['portion_size'] as String? ?? '',
      calories: json['calories'] as int? ?? 0,
    );
  }
}

class MealTracking {
  final int id;
  final String trackingDate;
  final String mealType;
  final String foodConsumed;
  final int compliance;

  MealTracking({
    required this.id,
    this.trackingDate = '',
    this.mealType = '',
    this.foodConsumed = '',
    this.compliance = 0,
  });

  factory MealTracking.fromJson(Map<String, dynamic> json) {
    return MealTracking(
      id: json['id'] as int? ?? 0,
      trackingDate: json['tracking_date'] as String? ?? '',
      mealType: json['meal_type'] as String? ?? '',
      foodConsumed: json['food_consumed'] as String? ?? '',
      compliance: json['compliance'] as int? ?? 0,
    );
  }
}
