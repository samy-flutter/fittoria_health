class AiLog {
  final int id;
  final String? imageUrl;
  final String detectedFood;
  final int estCalories;
  final int estProteinG;
  final int estCarbsG;
  final int estFatG;
  final int confidence;
  final String loggedAt;

  AiLog({
    required this.id,
    this.imageUrl,
    required this.detectedFood,
    required this.estCalories,
    required this.estProteinG,
    required this.estCarbsG,
    required this.estFatG,
    required this.confidence,
    required this.loggedAt,
  });
}
