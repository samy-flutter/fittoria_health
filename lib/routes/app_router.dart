import 'package:fittoria_patient_app/features/shop/presentation/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../core/storage/preferences_helper.dart';
import 'route_names.dart';
import '../injection_container.dart';

// Screens
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/appointments/presentation/screens/appointments_screen.dart';
import '../features/booking/presentation/screens/booking_screen.dart';
import '../features/clinics/presentation/screens/clinics_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/profile/presentation/screens/records_screen.dart';
import '../features/lab/presentation/screens/lab_referrals_screen.dart';
import '../features/lab/presentation/screens/lab_referral_details_screen.dart';
import '../features/lab/presentation/screens/lab_reports_screen.dart';
import '../features/invoices/presentation/screens/invoices_screen.dart';
import '../features/prescriptions/presentation/screens/prescriptions_screen.dart';
import '../features/reports/presentation/screens/reports_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/shell/presentation/screens/patient_shell_screen.dart';
import '../features/fit/presentation/screens/fitness_hub_screen.dart';
import '../features/care/presentation/screens/care_hub_screen.dart';
import '../features/events/presentation/screens/events_screen.dart';
import '../features/events/presentation/screens/event_details_screen.dart';
import '../features/events/data/models/event_models.dart';
import '../features/trainers/presentation/screens/trainers_screen.dart';
import '../features/ai_nutrition/presentation/screens/ai_nutrition_screen.dart';
import '../features/achievements/presentation/screens/achievements_screen.dart';
import '../features/lab_booking/presentation/screens/lab_booking_screen.dart';
import '../features/shop/presentation/screens/shop_screen.dart';
import '../features/shop/presentation/screens/cart_screen.dart';
import '../features/shop/presentation/screens/checkout_screen.dart';
import '../features/shop/presentation/screens/orders_screen.dart';
import '../features/shop/presentation/screens/order_tracking_screen.dart';
import '../features/shop/presentation/screens/addresses_screen.dart';
import '../features/shop/presentation/screens/address_form_screen.dart';
import '../features/academy/presentation/screens/academy_screen.dart';
import '../features/academy/presentation/screens/academy_video_details_screen.dart';
import '../features/academy/data/models/academy_models.dart';
import '../features/community/presentation/screens/community_hub_screen.dart';
import '../features/community/presentation/screens/social_screen.dart';
import '../features/community/presentation/screens/clubs_screen.dart';
import '../features/community/presentation/screens/club_chat_screen.dart';
import '../features/more/presentation/screens/more_hub_screen.dart';
import '../features/fit/presentation/screens/log_data_screen.dart';
import '../features/fit/presentation/screens/activity_screen.dart';
import '../features/fit/presentation/screens/heart_rate_screen.dart';
import '../features/fit/presentation/screens/sleep_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/fit/presentation/screens/goals_screen.dart';
import '../features/fit/presentation/screens/challenges_screen.dart';
import '../features/care/presentation/screens/gym_details_screen.dart';
import '../features/care/presentation/screens/trainer_details_screen.dart';
import '../features/care/presentation/screens/dietitian_details_screen.dart';
import '../features/care/presentation/screens/video_meetings_screen.dart';
import '../features/fit/presentation/screens/water_screen.dart';
import '../features/fit/presentation/screens/mood_screen.dart';
import '../features/fit/presentation/screens/workouts_screen.dart';
import '../features/fit/presentation/screens/body_progress_screen.dart';
import '../features/fit/presentation/screens/nutrition_screen.dart';
import '../features/fit/presentation/screens/record_screen.dart';
import '../features/fit/presentation/screens/programs_screen.dart';
import '../features/fit/presentation/screens/devices_screen.dart';
import '../core/presentation/screens/placeholder_screen.dart';
// Cubits for BlocProvider wrapping
import '../features/profile/presentation/bloc/profile_cubit.dart';
import '../features/profile/presentation/bloc/records_cubit.dart';
import '../features/invoices/presentation/bloc/invoices_cubit.dart';
import '../features/prescriptions/presentation/bloc/prescriptions_cubit.dart';
import '../features/fit/presentation/cubit/activity_cubit.dart';
import '../features/fit/presentation/cubit/heart_rate_cubit.dart';
import '../features/fit/presentation/cubit/sleep_cubit.dart';
import '../features/fit/presentation/cubit/goals_cubit.dart';
import '../features/fit/presentation/cubit/challenges_cubit.dart';
import '../features/fit/presentation/cubit/body_progress_cubit.dart';
import '../features/fit/presentation/cubit/devices_cubit.dart';
import '../features/shop/presentation/cubit/addresses_cubit.dart';
import '../features/shop/data/models/shop_models.dart';
import '../core/logging/app_logger.dart';

class AppRouter {
  final PreferencesHelper _prefs;
  final AuthStatusNotifier authStatusNotifier;

  AppRouter(this._prefs, this.authStatusNotifier);

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  List<GoRoute> get _placeholderRoutes {
    final Map<String, String> placeholderMap = {
      RouteNames.patientShopCart: 'Cart',
      RouteNames.patientShopOrders: 'My Orders',
    };
    return placeholderMap.entries.map((e) {
      return GoRoute(
        path: e.key,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => PlaceholderScreen(title: e.value),
      );
    }).toList();
  }

  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.splash,
    refreshListenable: authStatusNotifier,
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = _prefs.isLoggedIn();
      final loc = state.matchedLocation;

      // Splash handles its own navigation — never redirect from it
      if (loc == RouteNames.splash) return null;

      final isAuthRoute = loc == RouteNames.login || loc == RouteNames.register || loc == RouteNames.forgotPassword;

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
      GoRoute(path: RouteNames.initial, redirect: (_, _) => RouteNames.splash),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return PatientShellScreen(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Dashboard (Home)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.patientDashboard,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          // Branch 1: Fitness Hub
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.patientFit,
                builder: (context, state) => const FitnessHubScreen(),
              ),
            ],
          ),
          // Branch 2: Care Hub
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.patientCare,
                builder: (context, state) => const CareHubScreen(),
              ),
              GoRoute(
                path: RouteNames.patientClinics,
                builder: (context, state) => const ClinicsScreen(),
              ),
              GoRoute(
                path: RouteNames.patientAppointments,
                builder: (context, state) => const AppointmentsScreen(),
              ),
            ],
          ),
          // Branch 3: Community Hub
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.patientCommunity,
                builder: (context, state) => const CommunityHubScreen(),
              ),
            ],
          ),
          // Branch 4: More Hub
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.patientMore,
                builder: (context, state) => const MoreHubScreen(),
              ),
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
        path: RouteNames.patientReports,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ReportsScreen(),
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
      GoRoute(
        path: RouteNames.patientSocial,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SocialScreen(),
      ),
      GoRoute(
        path: RouteNames.patientClubs,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ClubsScreen(),
      ),
      GoRoute(
        path: RouteNames.patientClubChat,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final clubId = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          final clubName = state.uri.queryParameters['name'] ?? 'Club Chat';
          return ClubChatScreen(clubId: clubId, clubName: clubName);
        },
      ),
      GoRoute(
        path: RouteNames.patientEvents,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EventsScreen(),
      ),
      GoRoute(
        path: RouteNames.patientEventDetails,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final event = state.extra as FitEvent?;
          if (event == null) {
            return const Scaffold(
              body: Center(child: Text('Event details not available.')),
            );
          }
          return EventDetailsScreen(event: event);
        },
      ),
      GoRoute(
        path: RouteNames.patientTrainers,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TrainersScreen(),
      ),
      GoRoute(
        path: RouteNames.patientAiNutrition,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AiNutritionScreen(),
      ),
      GoRoute(
        path: RouteNames.patientAchievements,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AchievementsScreen(),
      ),
      GoRoute(
        path: RouteNames.patientFitWater,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const WaterScreen(),
      ),
      GoRoute(
        path: RouteNames.patientFitNutrition,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NutritionScreen(),
      ),
      GoRoute(
        path: RouteNames.patientFitMood,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const MoodScreen(),
      ),
      GoRoute(
        path: RouteNames.patientFitWorkouts,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const WorkoutsScreen(),
      ),
      GoRoute(
        path: RouteNames.patientBodyProgress,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<BodyProgressCubit>(),
          child: const BodyProgressScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.patientFitRecord,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RecordScreen(),
      ),
      GoRoute(
        path: RouteNames.patientFitPrograms,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProgramsScreen(),
      ),
      GoRoute(
        path: RouteNames.patientFitDevices,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<DevicesCubit>(),
          child: const DevicesScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.patientLabBooking,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LabBookingScreen(),
      ),
      GoRoute(
        path: RouteNames.patientShop,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ShopScreen(),
      ),
      GoRoute(
        path: RouteNames.patientShopCart,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: RouteNames.patientShopCheckout,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: sl<CartCubit>()), // Use the same CartCubit
            BlocProvider.value(value: sl<AddressesCubit>()),
          ],
          child: const CheckoutScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.patientShopOrders,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: RouteNames.patientShopOrderTracking,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final idStr = state.pathParameters['id'];
          final id = int.tryParse(idStr ?? '') ?? 0;
          return OrderTrackingScreen(orderId: id);
        },
      ),
      GoRoute(
        path: RouteNames.patientShopAddresses,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => BlocProvider.value(
          value: sl<AddressesCubit>(),
          child: const AddressesScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.patientShopAddressForm,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final address = state.extra as ShopAddress?;
          return BlocProvider.value(
            value: sl<AddressesCubit>(),
            child: AddressFormScreen(existingAddress: address),
          );
        },
      ),
      GoRoute(
        path: RouteNames.patientAcademy,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AcademyScreen(),
      ),
      GoRoute(
        path: RouteNames.patientAcademyDetails,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final video = state.extra as AcademyVideo?;
          if (video == null) {
            return const Scaffold(
              body: Center(child: Text('Video details not available.')),
            );
          }
          return AcademyVideoDetailsScreen(video: video);
        },
      ),
      GoRoute(
        path: RouteNames.patientFitLog,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LogDataScreen(),
      ),
      GoRoute(
        path: RouteNames.patientFitActivity,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<ActivityCubit>(),
          child: const ActivityScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.patientFitHeartRate,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<HeartRateCubit>(),
          child: const HeartRateScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.patientFitSleep,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<SleepCubit>(),
          child: const SleepScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.patientOnboarding,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.patientFitGoals,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<GoalsCubit>(),
          child: const GoalsScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.patientChallenges,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<ChallengesCubit>(),
          child: const ChallengesScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.patientGym,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const GymDetailsScreen(),
      ),
      GoRoute(
        path: RouteNames.patientFitness,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TrainerDetailsScreen(),
      ),
      GoRoute(
        path: RouteNames.patientNutrition,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DietitianDetailsScreen(),
      ),
      GoRoute(
        path: RouteNames.patientMeetings,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const VideoMeetingsScreen(),
      ),
      ..._placeholderRoutes,
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
