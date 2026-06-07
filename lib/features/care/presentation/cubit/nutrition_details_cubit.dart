import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/care_repository.dart';
import '../../data/models/nutrition_details_model.dart';

abstract class NutritionDetailsState {}

class NutritionDetailsInitial extends NutritionDetailsState {}

class NutritionDetailsLoading extends NutritionDetailsState {}

class NutritionDetailsLoaded extends NutritionDetailsState {
  final NutritionDetailsData data;

  NutritionDetailsLoaded(this.data);
}

class NutritionDetailsError extends NutritionDetailsState {
  final String message;

  NutritionDetailsError(this.message);
}

class NutritionDetailsCubit extends Cubit<NutritionDetailsState> {
  final CareRepository _repository;

  NutritionDetailsCubit(this._repository) : super(NutritionDetailsInitial());

  Future<void> loadNutritionDetails() async {
    emit(NutritionDetailsLoading());
    final result = await _repository.getNutritionDetails();
    result.fold(
      (failure) => emit(NutritionDetailsError(failure.message)),
      (data) => emit(NutritionDetailsLoaded(data)),
    );
  }
}
