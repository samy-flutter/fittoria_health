import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/prescriptions_repository.dart';
import 'prescriptions_state.dart';

class PrescriptionsCubit extends Cubit<PrescriptionsState> {
  final PrescriptionsRepository _repository;

  PrescriptionsCubit(this._repository) : super(const PrescriptionsInitial());

  Future<void> loadPrescriptions() async {
    emit(const PrescriptionsLoading());
    final result = await _repository.getPrescriptions();
    
    result.fold(
      (failure) => emit(PrescriptionsError(failure.message)),
      (prescriptions) => emit(PrescriptionsLoaded(prescriptions)),
    );
  }
}
