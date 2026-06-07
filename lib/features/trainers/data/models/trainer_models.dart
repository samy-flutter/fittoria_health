class Trainer {
  final int id;
  final String fullName;
  final String? profilePic;
  final String? specialization;
  final int experienceYears;
  final int sessionsDone;
  final double rating;
  final String? bio;
  final double? sessionFee;

  Trainer({
    required this.id,
    required this.fullName,
    this.profilePic,
    this.specialization,
    required this.experienceYears,
    required this.sessionsDone,
    required this.rating,
    this.bio,
    this.sessionFee,
  });
}
