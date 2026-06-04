import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/storage/preferences_helper.dart';
import '../../../../injection_container.dart';

class PatientShellScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const PatientShellScreen({super.key, required this.navigationShell});

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
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

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
      appBar: navigationShell.currentIndex != 0
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
                          onTap: () =>
                              navigationShell.goBranch(3), // Profile tab
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
      body: navigationShell,
      bottomNavigationBar: _PatientBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onTap(context, index),
        isDark: isDark,
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
    final accent = isDark ? AppColors.darkTeal : AppColors.lightTeal;
    final muted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final bgActive = isDark
        ? AppColors.darkTeal.withValues(alpha: 0.15)
        : AppColors.lightTealLight;

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
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              children: [
                _buildNavItem(context, 0, 'Home', LucideIcons.layoutDashboard),
                _buildNavItem(context, 1, 'Find', LucideIcons.building2),
                // Placeholder for center FAB
                const Expanded(child: SizedBox()),
                _buildNavItem(context, 2, 'Visits', LucideIcons.stethoscope),
                _buildNavItem(context, 3, 'Me', LucideIcons.user),
              ],
            ),
            // Center Book FAB (matches -mt-6 floating behavior)
            Positioned(
              top: -24,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => context.push('/patient/book'),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          isDark
                              ? const Color(0xFF14B8A6)
                              : AppColors.lightTeal,
                          isDark
                              ? const Color(0xFF0D6E6E)
                              : const Color(0xFF0D6E6E),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF0D6E6E,
                          ).withValues(alpha: 0.35),
                          blurRadius: 20,
                          offset: const Offset(0, -2),
                        ),
                        BoxShadow(
                          color: const Color(0xFF0D6E6E).withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          LucideIcons.plus,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Book',
                          style: GoogleFonts.inter(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
