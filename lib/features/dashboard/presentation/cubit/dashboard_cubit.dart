import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../profile_records/domain/repositories/profile_repository.dart';
import '../../../profile_records/data/models/profile_models.dart';
import '../../../appointments/domain/repositories/appointments_repository.dart';
import '../../../appointments/data/models/appointment.dart';
import '../../../fit/domain/repositories/fitness_repository.dart';
import '../../../fit/domain/repositories/fit_repository.dart';
import '../../../fit/data/models/fitness_models.dart';
import '../../../fit/data/models/fit_models.dart';
import '../../../../core/logging/app_logger.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final ProfileRepository _profileRepository;
  final AppointmentsRepository _appointmentsRepository;
  final FitnessRepository _fitnessRepository;
  final FitRepository _fitRepository;

  StreamSubscription<Either<Failure, ActivityData>>? _activitySubscription;

  DashboardCubit(
    this._profileRepository,
    this._appointmentsRepository,
    this._fitnessRepository,
    this._fitRepository,
  ) : super(DashboardInitial());

  @override
  Future<void> close() {
    _activitySubscription?.cancel();
    return super.close();
  }

  Future<void> refreshFitnessSummarySilent() async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      final result = await _fitnessRepository.getFitnessSummary();
      result.fold(
        (failure) {}, // Ignore errors to remain silent
        (summary) {
          if (!isClosed) {
            emit(DashboardLoaded(
              profile: currentState.profile,
              appointments: currentState.appointments,
              fitnessSummary: summary,
              onboardingStatus: currentState.onboardingStatus,
            ));
          }
        },
      );
    }
  }

  Future<void> loadDashboardData() async {
    emit(DashboardLoading());
    AppLogger.i('[Dashboard] Loading Phase 2 dashboard data in parallel…');

    final results = await Future.wait([
      _profileRepository.getProfile(),
      _appointmentsRepository.getAppointments(),
      _fitnessRepository.getFitnessSummary(),
      _fitnessRepository.getOnboardingStatus(),
      _fitRepository.getActivity(range: 'week'),
    ]);

    final profileResult = results[0] as Either<Failure, ProfileResponse>;
    final appointmentsResult = results[1] as Either<Failure, List<Appointment>>;
    final fitnessResult = results[2] as Either<Failure, FitnessSummary>;
    final onboardingResult = results[3] as Either<Failure, OnboardingStatus>;
    final activityResult = results[4] as Either<Failure, ActivityData>;

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
    FitnessSummary fitnessSummary = fitnessResult.fold((l) => throw Exception(), (r) => r);
    final onboardingStatus = onboardingResult.fold((l) => throw Exception(), (r) => r);
    final localActivityData = activityResult.fold((l) => null, (r) => r);

    // Merge real local device steps into the summary
    if (localActivityData != null) {
      final todayLocal = localActivityData.totals;
      
      // Update today's stats
      final updatedToday = FitToday(
        steps: todayLocal.steps,
        distanceKm: todayLocal.distanceKm,
        caloriesKcal: todayLocal.caloriesKcal,
        activeMinutes: todayLocal.activeMinutes,
        waterMl: fitnessSummary.today.waterMl,
        nutritionKcal: fitnessSummary.today.nutritionKcal,
      );

      // Create new weekSteps list from local series
      final List<FitWeekStep> updatedWeekSteps = [];
      if (localActivityData.series.isNotEmpty) {
          for (var s in localActivityData.series) {
            final day = s.logDate.day.toString().padLeft(2, '0');
            final month = s.logDate.month.toString().padLeft(2, '0');
            updatedWeekSteps.add(FitWeekStep(date: '${s.logDate.year}-$month-$day', steps: s.steps));
          }
      } else {
          updatedWeekSteps.addAll(fitnessSummary.weekSteps);
      }

      fitnessSummary = FitnessSummary(
        today: updatedToday,
        goals: fitnessSummary.goals,
        vitals: fitnessSummary.vitals,
        challenges: fitnessSummary.challenges,
        careTeam: fitnessSummary.careTeam,
        academyVideos: fitnessSummary.academyVideos,
        weekSteps: updatedWeekSteps, // Retain history, just update today
      );
    }

    AppLogger.s('[Dashboard] Fetched Profile, Appointments, and Fitness Summary.');

    emit(DashboardLoaded(
      profile: profileResponse.patient,
      appointments: appointments,
      fitnessSummary: fitnessSummary,
      onboardingStatus: onboardingStatus,
    ));

    AppLogger.s('[Dashboard] State emitted: DashboardLoaded');
    AppLogger.s('[Dashboard] State emitted: DashboardLoaded');

    // Subscribe to real-time pedometer updates
    _activitySubscription?.cancel();
    _activitySubscription = _fitRepository.watchActivity(range: 'week').listen((result) {
      result.fold(
        (failure) {
          // Do nothing, keep existing data
        },
        (activityData) {
          if (state is DashboardLoaded) {
            final currentState = state as DashboardLoaded;
            final currentSummary = currentState.fitnessSummary;
            final todayLocal = activityData.totals;

            final updatedToday = FitToday(
              steps: todayLocal.steps,
              distanceKm: todayLocal.distanceKm,
              caloriesKcal: todayLocal.caloriesKcal,
              activeMinutes: todayLocal.activeMinutes,
              waterMl: currentSummary.today.waterMl,
              nutritionKcal: currentSummary.today.nutritionKcal,
            );

            final List<FitWeekStep> updatedWeekSteps = [];
            if (activityData.series.isNotEmpty) {
                for (var s in activityData.series) {
                  final day = s.logDate.day.toString().padLeft(2, '0');
                  final month = s.logDate.month.toString().padLeft(2, '0');
                  updatedWeekSteps.add(FitWeekStep(date: '${s.logDate.year}-$month-$day', steps: s.steps));
                }
            } else {
                updatedWeekSteps.addAll(currentSummary.weekSteps);
            }

            final updatedSummary = FitnessSummary(
              today: updatedToday,
              goals: currentSummary.goals,
              vitals: currentSummary.vitals,
              challenges: currentSummary.challenges,
              careTeam: currentSummary.careTeam,
              academyVideos: currentSummary.academyVideos,
              weekSteps: updatedWeekSteps,
            );

            emit(DashboardLoaded(
              profile: currentState.profile,
              appointments: currentState.appointments,
              fitnessSummary: updatedSummary,
              onboardingStatus: currentState.onboardingStatus,
            ));
          }
        },
      );
    });
  }
}
