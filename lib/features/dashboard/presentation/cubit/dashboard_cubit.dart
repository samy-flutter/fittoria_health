import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../profile_records/domain/repositories/profile_repository.dart';
import '../../../profile_records/data/models/profile_models.dart';
import '../../../appointments/domain/repositories/appointments_repository.dart';
import '../../../appointments/data/models/appointment.dart';
import '../../../fit/domain/repositories/fitness_repository.dart';
import '../../../fit/data/models/fitness_models.dart';
import '../../../../core/logging/app_logger.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final ProfileRepository _profileRepository;
  final AppointmentsRepository _appointmentsRepository;
  final FitnessRepository _fitnessRepository;

  DashboardCubit(
    this._profileRepository,
    this._appointmentsRepository,
    this._fitnessRepository,
  ) : super(DashboardInitial());

  Future<void> loadDashboardData() async {
    emit(DashboardLoading());
    AppLogger.i('[Dashboard] Loading Phase 2 dashboard data in parallel…');

    final results = await Future.wait([
      _profileRepository.getProfile(),
      _appointmentsRepository.getAppointments(),
      _fitnessRepository.getFitnessSummary(),
      _fitnessRepository.getOnboardingStatus(),
    ]);

    final profileResult = results[0] as Either<Failure, ProfileResponse>;
    final appointmentsResult = results[1] as Either<Failure, List<Appointment>>;
    final fitnessResult = results[2] as Either<Failure, FitnessSummary>;
    final onboardingResult = results[3] as Either<Failure, OnboardingStatus>;

    // If any of these absolutely critical calls fail, we emit an error for the dashboard.
    // In a real app, you might want to show partial data, but for now we follow the "all or nothing" parallel approach.
    bool hasError = false;
    String errorMessage = '';

    profileResult.fold((f) { hasError = true; errorMessage = f.message; }, (_) {});
    appointmentsResult.fold((f) { hasError = true; errorMessage = f.message; }, (_) {});
    fitnessResult.fold((f) { hasError = true; errorMessage = f.message; }, (_) {});
    onboardingResult.fold((f) { hasError = true; errorMessage = f.message; }, (_) {});

    if (hasError) {
      AppLogger.e('[Dashboard] Load failed with message: $errorMessage');
      emit(DashboardError(errorMessage));
      return;
    }

    final profileResponse = profileResult.fold((l) => throw Exception(), (r) => r);
    final appointments = appointmentsResult.fold((l) => throw Exception(), (r) => r);
    final fitnessSummary = fitnessResult.fold((l) => throw Exception(), (r) => r);
    final onboardingStatus = onboardingResult.fold((l) => throw Exception(), (r) => r);

    AppLogger.s('[Dashboard] Fetched Profile, Appointments, and Fitness Summary.');

    emit(DashboardLoaded(
      profile: profileResponse.patient,
      appointments: appointments,
      fitnessSummary: fitnessSummary,
      onboardingStatus: onboardingStatus,
    ));

    AppLogger.s('[Dashboard] State emitted: DashboardLoaded');
  }
}
