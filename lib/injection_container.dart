import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/storage/preferences_helper.dart';
import 'core/storage/secure_storage.dart';
import 'core/network/auth_interceptor.dart';
import 'core/network/dio_client.dart';
import 'core/theme/theme_cubit.dart';
import 'routes/app_router.dart';

// Features - Auth
import 'features/auth/data/data_sources/auth_remote_data_source.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// Features - Appointments
import 'features/appointments/data/data_sources/appointments_remote_data_source.dart';
import 'features/appointments/domain/repositories/appointments_repository.dart';
import 'features/appointments/data/repositories/appointments_repository_impl.dart';
import 'features/appointments/presentation/bloc/appointments_bloc.dart';

// Features - Clinics
import 'features/clinics/data/data_sources/clinics_remote_data_source.dart';
import 'features/clinics/domain/repositories/clinics_repository.dart';
import 'features/clinics/data/repositories/clinics_repository_impl.dart';
import 'features/clinics/presentation/cubit/clinics_cubit.dart';

// Features - Booking
import 'features/booking/data/data_sources/booking_remote_data_source.dart';
import 'features/booking/domain/repositories/booking_repository.dart';
import 'features/booking/data/repositories/booking_repository_impl.dart';
import 'features/booking/presentation/bloc/booking_bloc.dart';

// Features - Lab
import 'features/lab/data/data_sources/lab_remote_data_source.dart';
import 'features/lab/domain/repositories/lab_repository.dart';
import 'features/lab/data/repositories/lab_repository_impl.dart';
import 'features/lab/presentation/bloc/lab_referrals_bloc.dart';
import 'features/lab/presentation/bloc/lab_reports_cubit.dart';

// Features - Profile & Records
import 'features/profile_records/data/data_sources/profile_remote_data_source.dart';
import 'features/profile_records/domain/repositories/profile_repository.dart';
import 'features/profile_records/data/repositories/profile_repository_impl.dart';
import 'features/profile_records/data/data_sources/records_remote_data_source.dart';
import 'features/profile_records/domain/repositories/records_repository.dart';
import 'features/profile_records/data/repositories/records_repository_impl.dart';
import 'features/profile/presentation/bloc/records_cubit.dart';
import 'features/profile/presentation/bloc/profile_cubit.dart';

// Features - Invoices
import 'features/invoices/data/data_sources/invoices_remote_data_source.dart';
import 'features/invoices/domain/repositories/invoices_repository.dart';
import 'features/invoices/data/repositories/invoices_repository_impl.dart';
import 'features/invoices/presentation/bloc/invoices_cubit.dart';

// Features - Prescriptions
import 'features/prescriptions/data/data_sources/prescriptions_remote_data_source.dart';
import 'features/prescriptions/domain/repositories/prescriptions_repository.dart';
import 'features/prescriptions/data/repositories/prescriptions_repository_impl.dart';
import 'features/prescriptions/presentation/bloc/prescriptions_cubit.dart';

import 'features/reports/data/data_sources/reports_remote_data_source.dart';
import 'features/reports/data/repositories/reports_repository_impl.dart';
import 'features/reports/domain/repositories/reports_repository.dart';
import 'features/reports/presentation/bloc/reports_cubit.dart';

import 'features/care/data/data_sources/care_remote_data_source.dart';
import 'features/care/data/repositories/care_repository_impl.dart';
import 'features/care/domain/repositories/care_repository.dart';
import 'features/care/presentation/cubit/gym_cubit.dart';
import 'features/care/presentation/cubit/fitness_details_cubit.dart';
import 'features/care/presentation/cubit/nutrition_details_cubit.dart';
import 'features/care/presentation/cubit/meetings_cubit.dart';

// Features - Dashboard
import 'features/dashboard/presentation/cubit/dashboard_cubit.dart';

// Features - Fitness
import 'features/fit/data/data_sources/fitness_remote_data_source.dart';
import 'features/fit/domain/repositories/fitness_repository.dart';
import 'features/fit/data/repositories/fitness_repository_impl.dart';
import 'features/fit/presentation/cubit/devices_cubit.dart';
import 'features/fit/presentation/cubit/goals_cubit.dart';
import 'features/fit/presentation/cubit/challenges_cubit.dart';
import 'features/fit/presentation/cubit/body_progress_cubit.dart';
import 'features/fit/presentation/cubit/workouts_cubit.dart';

// Features - Community
import 'features/community/data/data_sources/social_remote_data_source.dart';
import 'features/community/domain/repositories/social_repository.dart';
import 'features/community/data/repositories/social_repository_impl.dart';
import 'features/community/presentation/cubit/social_cubit.dart';
import 'features/community/presentation/cubit/social_comments_cubit.dart';
import 'features/community/data/data_sources/clubs_remote_data_source.dart';
import 'features/community/domain/repositories/clubs_repository.dart';
import 'features/community/data/repositories/clubs_repository_impl.dart';
import 'features/community/presentation/cubit/clubs_cubit.dart';
import 'features/community/presentation/cubit/club_chat_cubit.dart';
// Features - Events
import 'features/events/data/data_sources/events_remote_data_source.dart';
import 'features/events/domain/repositories/events_repository.dart';
import 'features/events/data/repositories/events_repository_impl.dart';
import 'features/events/presentation/cubit/events_cubit.dart';

// Features - Trainers
import 'features/trainers/domain/repositories/trainers_repository.dart';
import 'features/trainers/data/repositories/trainers_repository_impl.dart';
import 'features/trainers/presentation/cubit/trainers_cubit.dart';

// Features - AI Nutrition
import 'features/ai_nutrition/domain/repositories/ai_nutrition_repository.dart';
import 'features/ai_nutrition/data/repositories/ai_nutrition_repository_impl.dart';
import 'features/ai_nutrition/presentation/cubit/ai_nutrition_cubit.dart';

// Features - Achievements
import 'features/achievements/data/data_sources/achievements_remote_data_source.dart';
import 'features/achievements/domain/repositories/achievements_repository.dart';
import 'features/achievements/data/repositories/achievements_repository_impl.dart';
import 'features/achievements/presentation/cubit/achievements_cubit.dart';

// Features - Lab Booking
import 'features/lab_booking/domain/repositories/lab_booking_repository.dart';
import 'features/lab_booking/data/repositories/lab_booking_repository_impl.dart';
import 'features/lab_booking/presentation/cubit/lab_booking_cubit.dart';

// Features - Shop
import 'features/shop/domain/repositories/shop_repository.dart';
import 'features/shop/data/repositories/shop_repository_impl.dart';
import 'features/shop/presentation/cubit/shop_cubit.dart';

// Features - Academy
import 'features/academy/data/data_sources/academy_remote_data_source.dart';
import 'features/academy/domain/repositories/academy_repository.dart';
import 'features/academy/data/repositories/academy_repository_impl.dart';
import 'features/academy/presentation/cubit/academy_cubit.dart';
import 'features/fit/domain/repositories/fit_repository.dart';
import 'features/fit/data/repositories/fit_repository_impl.dart';
import 'features/fit/presentation/cubit/activity_cubit.dart';
import 'features/fit/presentation/cubit/heart_rate_cubit.dart';
import 'features/fit/presentation/cubit/sleep_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- External Dependencies ---
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  
  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  sl.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);

  // --- Core Services & Helpers ---
  sl.registerLazySingleton<PreferencesHelper>(() => PreferencesHelper(sl()));
  sl.registerLazySingleton<SecureStorage>(() => SecureStorage(sl()));
  
  // Auth state notifier for routing rebuilds
  sl.registerLazySingleton<AuthStatusNotifier>(() => AuthStatusNotifier(sl()));

  // --- Network Layer ---
  sl.registerLazySingleton<AuthInterceptor>(() => AuthInterceptor(sl(), sl()));
  sl.registerLazySingleton<DioClient>(() => DioClient(sl()));

  // --- Routing & Theme ---
  sl.registerLazySingleton<AppRouter>(() => AppRouter(sl(), sl()));
  sl.registerFactory(() => ThemeCubit(sl()));

  // --- Features ---
  
  // Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl(), sl(), sl()));
  sl.registerFactory(() => AuthBloc(sl()));

  // Appointments
  sl.registerLazySingleton<AppointmentsRemoteDataSource>(() => AppointmentsRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AppointmentsRepository>(() => AppointmentsRepositoryImpl(sl()));
  sl.registerFactory(() => AppointmentsBloc(sl()));

  // Clinics
  sl.registerLazySingleton<ClinicsRemoteDataSource>(() => ClinicsRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ClinicsRepository>(() => ClinicsRepositoryImpl(sl()));
  sl.registerFactory(() => ClinicsCubit(sl()));

  // Booking
  sl.registerLazySingleton<BookingRemoteDataSource>(() => BookingRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<BookingRepository>(() => BookingRepositoryImpl(sl()));
  sl.registerFactory(() => BookingBloc(sl()));

  // Lab
  sl.registerLazySingleton<LabRemoteDataSource>(() => LabRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<LabRepository>(() => LabRepositoryImpl(sl()));
  sl.registerFactory(() => LabReferralsBloc(sl()));
  sl.registerFactory(() => LabReportsCubit(sl()));

  // Profile & Records
  sl.registerLazySingleton<ProfileRemoteDataSource>(() => ProfileRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(sl()));
  sl.registerLazySingleton<RecordsRemoteDataSource>(() => RecordsRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<RecordsRepository>(() => RecordsRepositoryImpl(sl()));
  sl.registerFactory(() => RecordsCubit(sl()));
  sl.registerFactory(() => ProfileCubit(sl()));

  // Fit Hub
  sl.registerFactory(() => DevicesCubit(sl()));
  sl.registerFactory(() => GoalsCubit(sl()));
  sl.registerFactory(() => ChallengesCubit(sl()));
  sl.registerFactory(() => BodyProgressCubit(sl()));
  sl.registerFactory(() => WorkoutsCubit(sl()));

  // Invoices
  sl.registerLazySingleton<InvoicesRemoteDataSource>(() => InvoicesRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<InvoicesRepository>(() => InvoicesRepositoryImpl(sl()));
  sl.registerFactory(() => InvoicesCubit(sl()));

  // Prescriptions
  sl.registerLazySingleton<PrescriptionsRemoteDataSource>(
      () => PrescriptionsRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ReportsRemoteDataSource>(
      () => ReportsRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<CareRemoteDataSource>(
      () => CareRemoteDataSourceImpl(sl()));

  // Repositories
  sl.registerLazySingleton<PrescriptionsRepository>(() => PrescriptionsRepositoryImpl(sl()));
  sl.registerLazySingleton<ReportsRepository>(() => ReportsRepositoryImpl(sl()));
  sl.registerLazySingleton<CareRepository>(() => CareRepositoryImpl(sl()));
  sl.registerFactory(() => PrescriptionsCubit(sl()));
  sl.registerFactory(() => ReportsCubit(sl()));
  sl.registerFactory(() => GymCubit(sl()));
  sl.registerFactory(() => FitnessDetailsCubit(sl()));
  sl.registerFactory(() => NutritionDetailsCubit(sl()));
  sl.registerFactory(() => MeetingsCubit(sl()));

  // Data Sources
  sl.registerLazySingleton<FitnessRemoteDataSource>(() => FitnessRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<FitnessRepository>(() => FitnessRepositoryImpl(sl()));

  // Dashboard — receives profile, appointments, fitness repositories
  sl.registerFactory(() => DashboardCubit(sl(), sl(), sl()));

  // Community  // Social / Community
  sl.registerLazySingleton<SocialRemoteDataSource>(() => SocialRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<SocialRepository>(() => SocialRepositoryImpl(sl()));
  sl.registerFactory(() => SocialCubit(sl()));
  sl.registerFactory(() => SocialCommentsCubit(sl()));

  sl.registerLazySingleton<ClubsRemoteDataSource>(() => ClubsRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ClubsRepository>(() => ClubsRepositoryImpl(sl()));
  sl.registerFactory(() => ClubsCubit(sl()));
  sl.registerFactory(() => ClubChatCubit(sl()));

  // Events
  sl.registerLazySingleton<EventsRemoteDataSource>(() => EventsRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<EventsRepository>(() => EventsRepositoryImpl(sl()));
  sl.registerFactory(() => EventsCubit(sl()));

  // Trainers
  sl.registerLazySingleton<TrainersRepository>(() => TrainersRepositoryImpl());
  sl.registerFactory(() => TrainersCubit(sl()));

  // AI Nutrition
  sl.registerLazySingleton<AiNutritionRepository>(() => AiNutritionRepositoryImpl());
  sl.registerFactory(() => AiNutritionCubit(sl()));

  // Achievements
  sl.registerLazySingleton<AchievementsRemoteDataSource>(() => AchievementsRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AchievementsRepository>(() => AchievementsRepositoryImpl(sl()));
  sl.registerFactory(() => AchievementsCubit(sl()));

  // Lab Booking
  sl.registerLazySingleton<LabBookingRepository>(() => LabBookingRepositoryImpl());
  sl.registerFactory(() => LabBookingCubit(sl()));

  // Shop
  sl.registerLazySingleton<ShopRepository>(() => ShopRepositoryImpl());
  sl.registerFactory(() => ShopCubit(sl()));

  // Academy
  sl.registerLazySingleton<AcademyRemoteDataSource>(() => AcademyRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AcademyRepository>(() => AcademyRepositoryImpl(sl()));
  sl.registerFactory(() => AcademyCubit(repository: sl(), audience: 'patient'));

  // Fit
  sl.registerLazySingleton<FitRepository>(() => FitRepositoryImpl());
  sl.registerFactory(() => ActivityCubit(sl()));
  sl.registerFactory(() => HeartRateCubit(sl()));
  sl.registerFactory(() => SleepCubit(sl()));
}
