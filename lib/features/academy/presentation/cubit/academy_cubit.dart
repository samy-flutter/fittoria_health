import 'package:fittoria_patient_app/features/academy/data/models/academy_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/academy_repository.dart';
import 'academy_state.dart';

class AcademyCubit extends Cubit<AcademyState> {
  final AcademyRepository repository;
  final String audience;

  AcademyCubit({required this.repository, required this.audience})
    : super(AcademyInitial());

  Future<void> loadVideos({String? query, String? category}) async {
    final currentState = state is AcademyLoaded ? state as AcademyLoaded : null;
    final currentQuery = query ?? currentState?.searchQuery ?? '';
    final currentCat = category ?? currentState?.category ?? '';

    if (currentState == null) {
      emit(AcademyLoading());
    }

    final result = await repository.getVideos(
      audience: audience,
      query: currentQuery,
      category: currentCat,
    );

    result.fold((failure) => emit(AcademyError(failure.message)), (videos) {
      List<String> allCats = currentState?.allCategories ?? [];
      if (allCats.isEmpty && currentQuery.isEmpty && currentCat.isEmpty) {
        allCats = videos.map((v) => v.category).toSet().toList();
      }
      emit(
        AcademyLoaded(
          videos: videos,
          searchQuery: currentQuery,
          category: currentCat,
          allCategories: allCats,
        ),
      );
    });
  }

  Future<void> toggleLike(int videoId) async {
    if (state is AcademyLoaded) {
      final currentState = state as AcademyLoaded;
      final result = await repository.toggleLike(videoId);
      result.fold(
        (failure) {
          // Do nothing or show toast
        },
        (updatedVideo) {
          final updatedVideos = currentState.videos.map((v) {
            if (v.id == videoId) {
              return v.copyWith(
                liked: updatedVideo.liked,
                likeCount: updatedVideo.likeCount,
              );
            }
            return v;
          }).toList();
          emit(currentState.copyWith(videos: updatedVideos));
        },
      );
    }
  }

  void updateVideoLocally(AcademyVideo updatedVideo) {
    if (state is AcademyLoaded) {
      final currentState = state as AcademyLoaded;
      final updatedVideos = currentState.videos.map((v) {
        if (v.id == updatedVideo.id) {
          return updatedVideo;
        }
        return v;
      }).toList();
      emit(currentState.copyWith(videos: updatedVideos));
    }
  }
}
