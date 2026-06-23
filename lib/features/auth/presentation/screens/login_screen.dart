import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/app_text_field.dart';
import '../../../../core/presentation/widgets/app_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/route_names.dart';
import '../../../../injection_container.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return BlocProvider<AuthBloc>(
      create: (_) => sl<AuthBloc>(),
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged in successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
              context.go(RouteNames.patientDashboard);
            } else if (state is AuthMfaRequired) {
              _showMfaDialog(context);
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24.0),
                      
                      // --- Brand Header Logo ---
                      Center(
                        child: Container(
                          width: 64.0,
                          height: 64.0,
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
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: const Icon(
                            LucideIcons.heart,
                            color: Colors.white,
                            size: 32.0,
                          ),
                        ),
                      ),
                      AppSpacing.heightLg,
                      Center(
                        child: Text(
                          'Fittoria Health',
                          style: AppTextStyles.h1.copyWith(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Patient Portal',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 48.0),
                      
                      // --- Welcome copy ---
                      Text(
                        'Welcome back 👋',
                        style: AppTextStyles.h2.copyWith(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSpacing.heightXs,
                      Text(
                        'Sign in to access your health portal.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      
                      const SizedBox(height: 32.0),
                      
                      // --- Identifier field (Phone or Email) ---
                      Text(
                        'Mobile Number or Email',
                        style: AppTextStyles.labelUppercase.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      AppSpacing.heightSm,
                      AppTextField(
                        controller: _identifierController,
                        label: '9876543210 or you@example.com',
                        prefixIcon: LucideIcons.phone,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter phone or email';
                          }
                          return null;
                        },
                      ),
                      
                      AppSpacing.heightLg,
                      
                      // --- Password field ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Password',
                            style: AppTextStyles.labelUppercase.copyWith(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.heightSm,
                      AppTextField(
                        controller: _passwordController,
                        label: 'Enter your password',
                        prefixIcon: LucideIcons.lock,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 24.0),
                      
                      // --- Error Feedback Banner ---
                      if (state is AuthError) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.dangerBgDark : AppColors.dangerBgLight,
                            border: Border.all(
                              color: isDark ? AppColors.dangerDark : AppColors.dangerBorderLight,
                              width: 1.0,
                            ),
                            borderRadius: AppRadius.borderMd,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                LucideIcons.alertCircle,
                                color: isDark ? AppColors.dangerDark : AppColors.danger,
                                size: 18.0,
                              ),
                              AppSpacing.widthSm,
                              Expanded(
                                child: Text(
                                  state.message,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: isDark ? AppColors.dangerDark : AppColors.danger,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),
                      ],
                      
                      // --- Submit Button ---
                      AppButton(
                        text: 'Sign In Securely',
                        isLoading: state is AuthLoading,
                        icon: LucideIcons.heart,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  LoginSubmitted(
                                    identifier: _identifierController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                          }
                        },
                      ),
                      
                      const SizedBox(height: 28.0),
                      
                      // --- Divider ---
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              'new to fittoria?',
                              style: AppTextStyles.labelUppercase.copyWith(
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                textBaseline: TextBaseline.alphabetic,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24.0),
                      
                      // --- Create Account Navigation ---
                      AppButton(
                        text: 'Create a Free Account',
                        type: ButtonType.outlined,
                        onPressed: () {
                          context.push(RouteNames.register);
                        },
                      ),
                      
                      const SizedBox(height: 32.0),
                      
                      // --- HIPAA Trust indicators ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.shield,
                            size: 12.0,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'HIPAA Secure',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              fontSize: 10.0,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '·',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                              fontSize: 10.0,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            LucideIcons.checkCircle2,
                            size: 12.0,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Encrypted',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              fontSize: 10.0,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '·',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                              fontSize: 10.0,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            LucideIcons.heart,
                            size: 12.0,
                            color: AppColors.danger, // Using danger for the rose red color
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Trusted',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              fontSize: 10.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showMfaDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('MFA Code Required'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Please check your authenticator mobile application to obtain the current verification code.'),
            SizedBox(height: 16.0),
            // Code entry can be built if MFA endpoint has dynamic input
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
