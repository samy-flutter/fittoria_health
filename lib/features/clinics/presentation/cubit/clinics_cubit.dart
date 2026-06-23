import '../../../../core/error/exception_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/clinics_repository.dart';
import '../../data/models/clinic.dart';

// --- State ---
abstract class ClinicsState {
  const ClinicsState();
}

class ClinicsInitial extends ClinicsState {}
class ClinicsLoading extends ClinicsState {}

class ClinicsLoaded extends ClinicsState {
  final List<Clinic> clinics;
  final String searchQuery;
  final String? activeTypeFilter;

  const ClinicsLoaded({
    required this.clinics,
    this.searchQuery = '',
    this.activeTypeFilter,
  });
}

class ClinicsError extends ClinicsState {
  final String message;
  const ClinicsError(this.message);
}

// --- Cubit ---
class ClinicsCubit extends Cubit<ClinicsState> {
  final ClinicsRepository _repository;

  String _currentQuery = '';
  String? _currentType;
  double? _lat;
  double? _lng;

  ClinicsCubit(this._repository) : super(ClinicsInitial());

  Future<void> loadClinics() async {
    emit(ClinicsLoading());
    try {
      final clinics = await _repository.searchClinics(
        query: _currentQuery.isNotEmpty ? _currentQuery : null,
        type: _currentType,
        lat: _lat,
        lng: _lng,
      );
      emit(ClinicsLoaded(
        clinics: clinics,
        searchQuery: _currentQuery,
        activeTypeFilter: _currentType,
      ));
    } catch (e) {
      emit(ClinicsError(ExceptionHandler.handle(e).message));
    }
  }

  void updateSearch(String query) {
    _currentQuery = query;
    loadClinics();
  }

  void setTypeFilter(String? type) {
    _currentType = _currentType == type ? null : type;
    loadClinics();
  }

  void setLocation(double lat, double lng) {
    _lat = lat;
    _lng = lng;
    loadClinics();
  }

  void clearLocation() {
    _lat = null;
    _lng = null;
    loadClinics();
  }
}
