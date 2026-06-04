import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../auth/domain/repositories/auth_repository.dart';
import '../../injection_container.dart';

/// Production splash screen that matches the Login screen branding.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _taglineFade;
  late Animation<double> _dotFade;
  late Animation<double> _exitFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Logo scale: starts small, springs to full size
    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.elasticOut),
      ),
    );

    // Logo fade in
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );

    // Tagline fades in after logo
    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
      ),
    );

    // Dot row fades in last
    _dotFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 0.80, curve: Curves.easeOut),
      ),
    );

    // Entire screen fades out before navigation
    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.85, 1.0, curve: Curves.easeIn),
      ),
    );

    _startFlow();
  }

  Future<void> _startFlow() async {
    // Start animation and check auth status concurrently
    final authFuture = sl<AuthRepository>().checkAuthStatus();
    
    await _controller.forward();
    if (!mounted) return;

    final isValid = await authFuture;
    if (!mounted) return;

    if (isValid) {
      context.go('/patient');
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _exitFade,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // ── Center content ───────────────────────────────────────────
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo mark
                        FadeTransition(
                          opacity: _logoFade,
                          child: ScaleTransition(
                            scale: _logoScale,
                            child: _buildLogoMark(),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Brand name
                        FadeTransition(
                          opacity: _logoFade,
                          child: ScaleTransition(
                            scale: _logoScale,
                            child: _buildBrandName(isDark),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Tagline
                        FadeTransition(
                          opacity: _taglineFade,
                          child: Text(
                            'Your Health, Our Priority',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Animated loading dots
                        FadeTransition(
                          opacity: _dotFade,
                          child: _LoadingDots(isDark: isDark),
                        ),
                      ],
                    ),
                  ),

                  // ── Version label (bottom-center) ────────────────────────────
                  Positioned(
                    bottom: 32,
                    left: 0,
                    right: 0,
                    child: FadeTransition(
                      opacity: _taglineFade,
                      child: Text(
                        'Fittoria Health Portal  v1.0',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogoMark() {
    return Container(
      width: 80.0,
      height: 80.0,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.lightTeal, AppColors.lightCyan],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.borderXl,
        boxShadow: [
          BoxShadow(
            color: AppColors.lightTeal.withAlpha(76),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: const Icon(
        LucideIcons.heart,
        color: Colors.white,
        size: 40.0,
      ),
    );
  }

  Widget _buildBrandName(bool isDark) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Fittoria',
            style: GoogleFonts.dmSans(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              letterSpacing: -0.5,
            ),
          ),
          TextSpan(
            text: ' Health',
            style: GoogleFonts.dmSans(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTeal : AppColors.lightTeal,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Three animated pulsing dots as a loading indicator.
class _LoadingDots extends StatefulWidget {
  final bool isDark;
  const _LoadingDots({required this.isDark});

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with TickerProviderStateMixin {
  final List<AnimationController> _dotControllers = [];
  final List<Animation<double>> _dotAnims = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 3; i++) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
      final anim = Tween<double>(begin: 0.35, end: 1.0).animate(
        CurvedAnimation(parent: ctrl, curve: Curves.easeInOut),
      );
      _dotControllers.add(ctrl);
      _dotAnims.add(anim);

      Future.delayed(Duration(milliseconds: i * 180), () {
        if (mounted) ctrl.repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _dotControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.isDark ? AppColors.darkTeal : AppColors.lightTeal;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _dotAnims[i],
          builder: (_, __) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: activeColor.withValues(alpha: _dotAnims[i].value),
            ),
          ),
        );
      }),
    );
  }
}
