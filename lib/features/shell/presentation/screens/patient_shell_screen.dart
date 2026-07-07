import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/storage/preferences_helper.dart';
import '../../../../routes/route_names.dart';
import '../../../../injection_container.dart';

class PatientShellScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const PatientShellScreen({super.key, required this.navigationShell});

  @override
  State<PatientShellScreen> createState() => _PatientShellScreenState();
}

class _PatientShellScreenState extends State<PatientShellScreen> {
  DateTime? _lastBackPressTime;

  void _onTap(BuildContext context, int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    final isDark = themeMode == ThemeMode.dark;

    final prefs = sl<PreferencesHelper>();
    final patientName = prefs.getPatientName() ?? 'Patient';
    final initials = patientName
        .split(' ')
        .take(2)
        .map((n) => n.isNotEmpty ? n[0].toUpperCase() : '')
        .join('');

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final router = GoRouter.of(context);
        if (router.canPop()) {
          router.pop();
          return;
        }

        if (widget.navigationShell.currentIndex != 0) {
          widget.navigationShell.goBranch(0);
          return;
        }

        final now = DateTime.now();
        if (_lastBackPressTime == null || now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
          _lastBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Press back again to exit',
                style: GoogleFonts.inter(color: Colors.white),
              ),
              backgroundColor: isDark ? AppColors.darkBgSurface : Colors.black87,
              duration: const Duration(seconds: 2),
            ),
          );
          return;
        }
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
        appBar: widget.navigationShell.currentIndex != 0
            ? null
            : PreferredSize(
              preferredSize: const Size.fromHeight(56.0),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      (isDark
                              ? AppColors.darkBgSurface
                              : AppColors.lightBgSurface)
                          .withValues(alpha: 0.95),
                  border: Border(
                    bottom: BorderSide(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                      width: 1,
                    ),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        // Welcome text & Username
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome, ',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                            Text(
                              patientName.split(' ').first,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Theme Toggle
                        IconButton(
                          icon: Icon(
                            isDark ? LucideIcons.sun : LucideIcons.moon,
                            size: 20,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                          onPressed: () {
                            context.read<ThemeCubit>().toggleTheme();
                          },
                        ),
                        const SizedBox(width: 4),
                        // Avatar
                        GestureDetector(
                          onTap: () => context.push(RouteNames.patientProfile),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0D6E6E), Color(0xFF14B8A6)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkTeal.withValues(alpha: 0.3)
                                    : AppColors.lightTeal.withValues(
                                        alpha: 0.3,
                                      ),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                initials,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      body: widget.navigationShell,
      bottomNavigationBar: _PatientBottomNav(
        currentIndex: widget.navigationShell.currentIndex,
        onTap: (index) => _onTap(context, index),
        isDark: isDark,
      ),
      ),
    );
  }
}

class _PatientBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isDark;

  const _PatientBottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.isDark,
  });

  Widget _buildNavItem(
    BuildContext context,
    int index,
    String label,
    IconData icon,
  ) {
    final isActive = currentIndex == index;
    final accent = AppColors.fitOrange;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final bgActive = AppColors.fitOrange.withValues(alpha: 0.15);

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top active indicator
            Container(
              height: 3,
              width: 32,
              decoration: BoxDecoration(
                color: isActive ? accent : Colors.transparent,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(3),
                ),
              ),
            ),
            const Spacer(),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 32,
              height: 28,
              decoration: BoxDecoration(
                color: isActive ? bgActive : Colors.transparent,
                borderRadius: AppRadius.borderMd,
              ),
              child: Center(
                child: AnimatedScale(
                  scale: isActive ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isActive ? accent : muted.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? accent : muted,
                height: 1,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64 + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: (isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface)
            .withValues(alpha: 0.96),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _buildNavItem(context, 0, 'Home', LucideIcons.layoutDashboard),
            _buildNavItem(context, 1, 'Fitness', LucideIcons.footprints),
            _buildNavItem(context, 2, 'Care', LucideIcons.heart),
            _buildNavItem(context, 3, 'Community', LucideIcons.users),
            _buildNavItem(context, 4, 'More', LucideIcons.moreHorizontal),
          ],
        ),
      ),
    );
  }
}
