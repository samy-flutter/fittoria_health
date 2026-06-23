import '../../../../core/utils/ui_helpers.dart';
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
import '../../../../core/widgets/custom_app_bar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreed = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return BlocProvider<AuthBloc>(
      create: (_) => sl<AuthBloc>(),
      child: Scaffold(
        appBar: CustomAppBar(
          ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              UIHelpers.showErrorSnackBar(context, state.message);
// Navigate back to Login screen
              context.pushReplacement(RouteNames.login);
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // --- Welcome Header ---
                      Text(
                        'Create Account 🌟',
                        style: AppTextStyles.h1.copyWith(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSpacing.heightXs,
                      Text(
                        'Sign up to get access to 500+ clinics & top doctors.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      
                      const SizedBox(height: 32.0),
                      
                      // --- Full Name field ---
                      Text(
                        'Full Name',
                        style: AppTextStyles.labelUppercase.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      AppSpacing.heightSm,
                      AppTextField(
                        controller: _nameController,
                        label: 'Enter your full name',
                        prefixIcon: Icons.person_outline_rounded,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      
                      AppSpacing.heightLg,
                      
                      // --- Phone Number field ---
                      Text(
                        'Mobile Number',
                        style: AppTextStyles.labelUppercase.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      AppSpacing.heightSm,
                      AppTextField(
                        controller: _phoneController,
                        label: '10-digit mobile number',
                        prefixIcon: Icons.phone_android_rounded,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter mobile number';
                          }
                          if (value.trim().length < 10) {
                            return 'Mobile number must be 10 digits';
                          }
                          return null;
                        },
                      ),
                      
                      AppSpacing.heightLg,
                      
                      // --- Email Address field ---
                      Text(
                        'Email Address',
                        style: AppTextStyles.labelUppercase.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      AppSpacing.heightSm,
                      AppTextField(
                        controller: _emailController,
                        label: 'you@example.com',
                        prefixIcon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      
                      AppSpacing.heightLg,
                      
                      // --- Password field ---
                      Text(
                        'Password',
                        style: AppTextStyles.labelUppercase.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      AppSpacing.heightSm,
                      AppTextField(
                        controller: _passwordController,
                        label: 'Minimum 6 characters',
                        prefixIcon: Icons.lock_outline_rounded,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 20.0),
                      
                      // --- Agreement Checkbox ---
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child: Checkbox(
                              value: _agreed,
                              activeColor: isDark ? AppColors.darkTeal : AppColors.lightTeal,
                              checkColor: isDark ? AppColors.darkBgBase : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _agreed = val ?? false;
                                });
                              },
                            ),
                          ),
                          AppSpacing.widthSm,
                          Expanded(
                            child: Text(
                              'I agree to the Terms of Service & Privacy Policy.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ),
                        ],
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
                                Icons.error_outline_rounded,
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
                      
                      // --- Register Button ---
                      AppButton(
                        text: 'Register Account',
                        isLoading: state is AuthLoading,
                        icon: Icons.person_add_rounded,
                        onPressed: () {
                          if (!_agreed) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please accept the Terms & Privacy Policy to register.'),
                                backgroundColor: AppColors.warning,
                              ),
                            );
                            return;
                          }
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  RegisterSubmitted(
                                    fullName: _nameController.text,
                                    phone: _phoneController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                          }
                        },
                      ),
                      
                      const SizedBox(height: 32.0),
                      
                      // --- Return to Login Navigation ---
                      Center(
                        child: Text.rich(
                          TextSpan(
                            text: 'Already have an account? ',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                            children: [
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () {
                                    context.pushReplacement(RouteNames.login);
                                  },
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                      color: isDark ? AppColors.darkTeal : AppColors.lightTeal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
}
