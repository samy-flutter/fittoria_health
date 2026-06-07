import '../../data/models/academy_models.dart';

abstract class AcademyState {}

class AcademyInitial extends AcademyState {}

class AcademyLoading extends AcademyState {}

class AcademyLoaded extends AcademyState {
  final List<AcademyVideo> videos;
  final String searchQuery;
  final String category;

  final List<String> allCategories;

  AcademyLoaded({
    required this.videos,
    this.searchQuery = '',
    this.category = '',
    this.allCategories = const [],
  });

  AcademyLoaded copyWith({
    List<AcademyVideo>? videos,
    String? searchQuery,
    String? category,
    List<String>? allCategories,
  }) {
    return AcademyLoaded(
      videos: videos ?? this.videos,
      searchQuery: searchQuery ?? this.searchQuery,
      category: category ?? this.category,
      allCategories: allCategories ?? this.allCategories,
    );
  }
}

class AcademyError extends AcademyState {
  final String message;
  AcademyError(this.message);
}
