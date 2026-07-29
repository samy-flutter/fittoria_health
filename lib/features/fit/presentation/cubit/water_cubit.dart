import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/fitness_repository.dart';
import '../../data/models/fit_models.dart';
import '../../../../core/error/failures.dart';

abstract class WaterState {}
class WaterInitial extends WaterState {}
class WaterLoading extends WaterState {}
class WaterLoaded extends WaterState {
  final WaterData data;
  WaterLoaded(this.data);
}
class WaterError extends WaterState {
  final String message;
  WaterError(this.message);
}

class WaterCubit extends Cubit<WaterState> {
  final FitnessRepository repository;
  WaterCubit(this.repository) : super(WaterInitial());

  Future<void> load(String date, {bool silently = false}) async {
    if (!silently) emit(WaterLoading());
    final result = await repository.getWater(date);
    result.fold(
      (Failure f) => emit(WaterError(f.message)),
      (WaterData d) => emit(WaterLoaded(d)),
    );
  }

  Future<void> logWater(String date, int ml) async {
    await repository.logWater(date, ml);
    await load(date, silently: true);
  }
}
