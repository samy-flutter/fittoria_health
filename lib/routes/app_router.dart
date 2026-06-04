import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../core/storage/preferences_helper.dart';
import 'route_names.dart';
import '../injection_container.dart';

// Screens
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/appointments/presentation/screens/appointments_screen.dart';
import '../features/booking/presentation/screens/booking_screen.dart';
import '../features/clinics/presentation/screens/clinics_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/profile/presentation/screens/records_screen.dart';
import '../features/lab/presentation/screens/lab_referrals_screen.dart';
import '../features/lab/presentation/screens/lab_referral_details_screen.dart';
import '../features/lab/presentation/screens/lab_reports_screen.dart';
import '../features/prescriptions/presentation/screens/prescriptions_screen.dart';
import '../features/invoices/presentation/screens/invoices_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/shell/presentation/screens/patient_shell_screen.dart';
// Cubits for BlocProvider wrapping
import '../features/profile/presentation/bloc/profile_cubit.dart';
import '../features/profile/presentation/bloc/records_cubit.dart';
import '../features/invoices/presentation/bloc/invoices_cubit.dart';
import '../features/prescriptions/presentation/bloc/prescriptions_cubit.dart';
import '../core/logging/app_logger.dart';

class AppRouter {
  final PreferencesHelper _prefs;
  final AuthStatusNotifier authStatusNotifier;

  AppRouter(this._prefs, this.authStatusNotifier);

  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.splash,
    refreshListenable: authStatusNotifier,
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = _prefs.isLoggedIn();
      final loc = state.matchedLocation;

      // Splash handles its own navigation — never redirect from it
      if (loc == RouteNames.splash) return null;

      final isAuthRoute = loc == RouteNames.login || loc == RouteNames.register;

      if (!isLoggedIn) {
        if (loc == RouteNames.register) return null;
        if (isAuthRoute) return null;
        AppLogger.nav(loc, RouteNames.login);
        return RouteNames.login;
      }

      // Logged-in user trying to access auth screens
      if (isAuthRoute) {
        AppLogger.nav(loc, RouteNames.patientDashboard);
        return RouteNames.patientDashboard;
      }
      
      // If navigating explicitly to `/` (initial), force to splash to start lifecycle
      if (loc == RouteNames.initial) {
        return RouteNames.splash;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.initial,
        redirect: (_, _) => RouteNames.splash,
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return PatientShellScreen(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.patientDashboard,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          // Branch 1: Clinics (Find)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.patientClinics,
                builder: (context, state) => const ClinicsScreen(),
              ),
            ],
          ),
          // Branch 2: Appointments (Visits)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.patientAppointments,
                builder: (context, state) => const AppointmentsScreen(),
              ),
            ],
          ),
          // Branch 3: Profile (Me)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.patientProfile,
                builder: (context, state) => BlocProvider(
                  create: (_) => sl<ProfileCubit>(),
                  child: const ProfileScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.patientBook,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final clinicId = state.uri.queryParameters['clinicId'];
          return BookingScreen(initialClinicId: clinicId);
        },
      ),
      GoRoute(
        path: RouteNames.patientInvoices,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<InvoicesCubit>(),
          child: const InvoicesScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.patientLabReferrals,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LabReferralsScreen(),
      ),
      GoRoute(
        path: RouteNames.patientLabReports,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LabReportsScreen(),
      ),
      GoRoute(
        path: RouteNames.patientPrescriptions,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<PrescriptionsCubit>(),
          child: const PrescriptionsScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.patientRecords,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<RecordsCubit>(),
          child: const RecordsScreen(),
        ),
      ),
      GoRoute(
        path: '/patient/lab-referrals/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final idStr = state.pathParameters['id'];
          final id = int.tryParse(idStr ?? '') ?? 0;
          return LabReferralDetailsScreen(referralId: id);
        },
      ),
    ],
  );
}

class AuthStatusNotifier extends ChangeNotifier {
  final PreferencesHelper _prefs;

  AuthStatusNotifier(this._prefs);

  void updateLoginState(bool isLoggedIn) {
    _prefs.setIsLoggedIn(isLoggedIn).then((_) {
      notifyListeners();
    });
  }
}
