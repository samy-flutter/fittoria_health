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

// Features - Dashboard
import 'features/dashboard/presentation/cubit/dashboard_cubit.dart';

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

  // Invoices
  sl.registerLazySingleton<InvoicesRemoteDataSource>(() => InvoicesRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<InvoicesRepository>(() => InvoicesRepositoryImpl(sl()));
  sl.registerFactory(() => InvoicesCubit(sl()));

  // Prescriptions
  sl.registerLazySingleton<PrescriptionsRemoteDataSource>(() => PrescriptionsRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<PrescriptionsRepository>(() => PrescriptionsRepositoryImpl(sl()));
  sl.registerFactory(() => PrescriptionsCubit(sl()));

  // Dashboard — receives profile, appointments, invoices, clinics repositories
  sl.registerFactory(() => DashboardCubit(sl(), sl(), sl(), sl()));
}
