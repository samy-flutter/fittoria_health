import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;
import 'core/theme/app_theme.dart';
import 'core/logging/app_logger.dart';
import 'core/logging/app_bloc_observer.dart';
import 'core/theme/theme_cubit.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Wire structured BLoC logging
  Bloc.observer = const AppBlocObserver();
  AppLogger.i('Fittoria Patient App starting…');

  // Initialize dependency injection
  await di.init();
  AppLogger.s('DI container initialized');

  runApp(const FittoriaPatientApp());
}


class FittoriaPatientApp extends StatelessWidget {
  const FittoriaPatientApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = di.sl<AppRouter>();

    return BlocProvider(
      create: (_) => di.sl<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'Fittoria Health Portal',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: appRouter.router,
          );
        },
      ),
    );
  }
}

