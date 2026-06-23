import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';
import '../../../profile_records/data/models/profile_models.dart';
import '../../../profile_records/data/models/records.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  int _currentTab = 0; // 0 = personal, 1 = health, 2 = emergency

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _medsController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyRelationController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  PatientProfile? _lastLoadedProfile;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _pincodeController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _allergiesController.dispose();
    _medsController.dispose();
    _emergencyNameController.dispose();
    _emergencyRelationController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  void _syncControllers(PatientProfile profile) {
    if (_lastLoadedProfile == profile) return;
    _lastLoadedProfile = profile;

    _nameController.text = profile.fullName;
    _emailController.text = profile.email ?? '';
    _dobController.text = profile.dateOfBirth?.split('T').first ?? '';
    _pincodeController.text = profile.pincode ?? '';
    _addressController.text = profile.addressLine1 ?? '';
    _cityController.text = profile.city ?? '';
    _stateController.text = profile.state ?? '';
    _heightController.text = profile.heightCm?.toString() ?? '';
    _weightController.text = profile.weightKg?.toString() ?? '';
    _allergiesController.text = profile.allergies ?? '';
    _medsController.text = profile.currentMedications ?? '';
    _emergencyNameController.text = profile.emergencyName ?? '';
    _emergencyRelationController.text = profile.emergencyRelation ?? '';
    _emergencyPhoneController.text = profile.emergencyPhone ?? '';
  }

  int _calculateCompleteness(PatientProfile p) {
    final fields = [
      p.fullName,
      p.phone,
      p.email,
      p.dateOfBirth,
      p.genderId,
      p.bloodGroupId,
      p.addressLine1,
      p.city,
      p.state,
      p.pincode,
      p.emergencyName,
      p.emergencyPhone,
      p.heightCm,
      p.weightKg,
    ];
    final filledCount = fields.where((f) {
      if (f == null) return false;
      if (f is String) return f.trim().isNotEmpty;
      return true;
    }).length;
    return ((filledCount / fields.length) * 100).round();
  }

  double? _calculateBmi(double? heightCm, double? weightKg) {
    if (heightCm == null || weightKg == null || heightCm <= 0 || weightKg <= 0) {
      return null;
    }
    return weightKg / ((heightCm / 100) * (heightCm / 100));
  }

  String _getBmiCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Color _getBmiColor(double bmi) {
    if (bmi < 18.5) return AppColors.cBlue;
    if (bmi < 25) return AppColors.success;
    if (bmi < 30) return AppColors.warning;
    return AppColors.danger;
  }

  Color _getBmiBg(double bmi) {
    if (bmi < 18.5) return AppColors.cBlueBg;
    if (bmi < 25) return AppColors.successBgLight;
    if (bmi < 30) return AppColors.warningBgLight;
    return AppColors.dangerBgLight;
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return 'PP';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: Icon(
            LucideIcons.chevronLeft,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'My Profile',
          style: AppTextStyles.h3.copyWith(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            if (state.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(
                        LucideIcons.checkCircle2,
                        color: AppColors.success,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(state.successMessage!)),
                    ],
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(
                        LucideIcons.alertCircle,
                        color: AppColors.danger,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(state.errorMessage!)),
                    ],
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.lightTeal),
            );
          }

          if (state is ProfileError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      LucideIcons.alertTriangle,
                      size: 48,
                      color: AppColors.danger,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load profile',
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () =>
                          context.read<ProfileCubit>().loadProfile(),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.lightTeal,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ProfileLoaded) {
            final p = state.editedPatient;
            _syncControllers(p);
            final completeness = _calculateCompleteness(p);
            final bmi = _calculateBmi(p.heightCm, p.weightKg);

            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProfileHeaderCard(p, completeness, isDark),
                          const SizedBox(height: 16),

                          _buildQuickStatsGrid(p, bmi, isDark),
                          const SizedBox(height: 16),

                          if (p.allergies != null &&
                              p.allergies!.trim().isNotEmpty) ...[
                            _buildAllergiesAlert(p.allergies!),
                            const SizedBox(height: 16),
                          ],

                          // Tab navigation pills
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildTabPill(
                                  0,
                                  'Personal',
                                  LucideIcons.user,
                                  isDark,
                                ),
                                const SizedBox(width: 8),
                                _buildTabPill(
                                  1,
                                  'Health',
                                  LucideIcons.heart,
                                  isDark,
                                ),
                                const SizedBox(width: 8),
                                _buildTabPill(
                                  2,
                                  'Emergency',
                                  LucideIcons.shield,
                                  isDark,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Tab Content
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkBgSurface
                                  : AppColors.lightBgSurface,
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder,
                              ),
                              borderRadius: AppRadius.borderLg,
                            ),
                            child: _currentTab == 0
                                ? _buildPersonalTab(
                                    p,
                                    state.response.genders,
                                    isDark,
                                  )
                                : _currentTab == 1
                                ? _buildHealthTab(
                                    p,
                                    state.response.bloodGroups,
                                    state.response.medicalHistory,
                                    bmi,
                                    isDark,
                                  )
                                : _buildEmergencyTab(p, isDark),
                          ),
                          const SizedBox(height: 80), // padding for bottom bar
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FilledButton.icon(
                  onPressed: state.isSaving
                      ? null
                      : () => _saveProfile(context),
                  icon: state.isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(LucideIcons.save, size: 16),
                  label: Text(
                    state.isSaving ? 'Saving...' : 'Save Changes',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: isDark
                        ? AppColors.darkTeal
                        : AppColors.lightTeal,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.borderMd,
                    ),
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTabPill(int index, String label, IconData icon, bool isDark) {
    final isSelected = _currentTab == index;
    return GestureDetector(
      onTap: () => setState(() => _currentTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.darkTealLight : AppColors.lightTealLight)
              : (isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (isDark
                      ? AppColors.darkTealBorder
                      : AppColors.lightTealBorder)
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected
                  ? AppColors.lightTeal
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected
                    ? AppColors.lightTeal
                    : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeaderCard(
    PatientProfile p,
    int completeness,
    bool isDark,
  ) {
    final initials = _getInitials(p.fullName);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderLg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            height: 80,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0A4F4F),
                  Color(0xFF073E3E),
                  Color(0xFF051C1C),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Stack(
              children: [
                Positioned(
                  right: 16,
                  top: 16,
                  child: Text(
                    'MY HEALTH PROFILE',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
              top: 0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.lightTeal, Color(0xFF073E3E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: AppRadius.borderLg,
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBgSurface
                            : AppColors.lightBgSurface,
                        width: 3,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 12,
                        runSpacing: 4,
                        children: [
                          if (p.fittoriaId != null)
                            Text(
                              'ID: ${p.fittoriaId}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontFamily: 'monospace',
                                color: Colors.grey,
                              ),
                            ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                LucideIcons.phone,
                                size: 10,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                p.phone,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Complete',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$completeness%',
                      style: const TextStyle(
                        color: AppColors.lightTeal,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 60,
                      height: 5,
                      child: ClipRRect(
                        borderRadius: AppRadius.borderCircular,
                        child: LinearProgressIndicator(
                          value: completeness / 100,
                          backgroundColor: Colors.grey.withAlpha(50),
                          color: AppColors.lightTeal,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsGrid(PatientProfile p, double? bmi, bool isDark) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 0.9,
      children: [
        _buildStatTile(
          'Blood Group',
          p.bloodGroupName ?? '—',
          LucideIcons.droplet,
          AppColors.danger,
          AppColors.dangerBgLight,
          isDark,
        ),
        _buildStatTile(
          'Gender',
          p.genderName ?? '—',
          LucideIcons.user,
          AppColors.cBlue,
          AppColors.cBlueBg,
          isDark,
        ),
        _buildStatTile(
          'BMI',
          bmi != null ? bmi.toStringAsFixed(1) : '—',
          LucideIcons.activity,
          AppColors.lightTeal,
          AppColors.lightTealLight,
          isDark,
        ),
        _buildStatTile(
          'Weight',
          p.weightKg != null ? '${p.weightKg} kg' : '—',
          LucideIcons.weight,
          AppColors.cPurple,
          AppColors.cPurpleBg,
          isDark,
        ),
      ],
    );
  }

  Widget _buildStatTile(
    String label,
    String value,
    IconData icon,
    Color color,
    Color bg,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        borderRadius: AppRadius.borderMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(child: Icon(icon, color: color, size: 12)),
          ),
          const SizedBox(height: 8),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 8.5,
              color: Colors.grey,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAllergiesAlert(String allergies) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.dangerBgLight,
        border: Border.all(color: AppColors.dangerBorderLight),
        borderRadius: AppRadius.borderLg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            LucideIcons.fileWarning,
            color: AppColors.danger,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Known Allergies',
                  style: TextStyle(
                    color: AppColors.danger,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  allergies,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.danger.withAlpha(200),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldWrapper(String label, Widget child, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 12, color: Colors.grey),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }

  InputDecoration _getInputDecoration(String hint, {bool disabled = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: disabled
          ? (isDark ? Colors.white10 : Colors.black.withAlpha(10))
          : (isDark ? AppColors.darkBgBase : AppColors.lightBgBase),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: AppRadius.borderMd,
        borderSide: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.borderMd,
        borderSide: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.borderMd,
        borderSide: const BorderSide(color: AppColors.lightTeal, width: 1.5),
      ),
    );
  }

  Widget _buildPersonalTab(
    PatientProfile p,
    List<LookupItem> genders,
    bool isDark,
  ) {
    return Column(
      children: [
        _buildFieldWrapper(
          'Full Name',
          TextFormField(
            controller: _nameController,
            decoration: _getInputDecoration('Enter full name'),
            onChanged: (val) => context.read<ProfileCubit>().updateField(
              p.copyWith(fullName: val),
            ),
          ),
          icon: LucideIcons.user,
        ),
        _buildFieldWrapper(
          'Mobile Number (Non-editable)',
          TextFormField(
            initialValue: p.phone,
            enabled: false,
            decoration: _getInputDecoration('Phone number', disabled: true),
          ),
          icon: LucideIcons.phone,
        ),
        _buildFieldWrapper(
          'Email Address',
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: _getInputDecoration('you@example.com'),
            onChanged: (val) => context.read<ProfileCubit>().updateField(
              p.copyWith(email: val.isEmpty ? null : val),
            ),
          ),
          icon: LucideIcons.mail,
        ),
        _buildFieldWrapper(
          'Date of Birth',
          TextFormField(
            controller: _dobController,
            readOnly: true,
            decoration: _getInputDecoration(
              'YYYY-MM-DD',
            ).copyWith(suffixIcon: const Icon(LucideIcons.calendar, size: 16)),
            onTap: () async {
              DateTime initialDate =
                  DateTime.tryParse(p.dateOfBirth ?? '') ?? DateTime(1990);
              final picked = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null && mounted) {
                final dobString = picked.toIso8601String().split('T').first;
                _dobController.text = dobString;
                // ignore: use_build_context_synchronously
                context.read<ProfileCubit>().updateField(
                  p.copyWith(dateOfBirth: dobString),
                );
              }
            },
          ),
          icon: LucideIcons.calendar,
        ),
        _buildFieldWrapper(
          'Gender',
          DropdownButtonFormField<int>(
            initialValue: p.genderId,
            dropdownColor: isDark
                ? AppColors.darkBgSurface
                : AppColors.lightBgSurface,
            decoration: _getInputDecoration('Select gender'),
            items: [
              const DropdownMenuItem<int>(
                value: null,
                child: Text('Select...'),
              ),
              ...genders.map(
                (g) => DropdownMenuItem<int>(value: g.id, child: Text(g.name)),
              ),
            ],
            onChanged: (val) {
              final matched = genders.where((g) => g.id == val);
              final name = matched.isNotEmpty ? matched.first.name : null;
              context.read<ProfileCubit>().updateField(
                p.copyWith(genderId: val, genderName: name),
              );
            },
          ),
          icon: LucideIcons.user,
        ),
        _buildFieldWrapper(
          'Pincode',
          TextFormField(
            controller: _pincodeController,
            keyboardType: TextInputType.number,
            decoration: _getInputDecoration('560001'),
            onChanged: (val) => context.read<ProfileCubit>().updateField(
              p.copyWith(pincode: val.isEmpty ? null : val),
            ),
          ),
          icon: LucideIcons.mapPin,
        ),
        _buildFieldWrapper(
          'Address Line 1',
          TextFormField(
            controller: _addressController,
            decoration: _getInputDecoration('Street, Area, Apartment'),
            onChanged: (val) => context.read<ProfileCubit>().updateField(
              p.copyWith(addressLine1: val.isEmpty ? null : val),
            ),
          ),
          icon: LucideIcons.mapPin,
        ),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                'City',
                TextFormField(
                  controller: _cityController,
                  decoration: _getInputDecoration('City'),
                  onChanged: (val) => context.read<ProfileCubit>().updateField(
                    p.copyWith(city: val.isEmpty ? null : val),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildFieldWrapper(
                'State',
                TextFormField(
                  controller: _stateController,
                  decoration: _getInputDecoration('State'),
                  onChanged: (val) => context.read<ProfileCubit>().updateField(
                    p.copyWith(state: val.isEmpty ? null : val),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHealthTab(
    PatientProfile p,
    List<LookupItem> bloodGroups,
    List<MedicalHistoryItem> history,
    double? bmi,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldWrapper(
          'Blood Group',
          DropdownButtonFormField<int>(
            initialValue: p.bloodGroupId,
            dropdownColor: isDark
                ? AppColors.darkBgSurface
                : AppColors.lightBgSurface,
            decoration: _getInputDecoration('Select blood group'),
            items: [
              const DropdownMenuItem<int>(
                value: null,
                child: Text('Select...'),
              ),
              ...bloodGroups.map(
                (b) => DropdownMenuItem<int>(value: b.id, child: Text(b.name)),
              ),
            ],
            onChanged: (val) {
              final matched = bloodGroups.where((b) => b.id == val);
              final name = matched.isNotEmpty ? matched.first.name : null;
              context.read<ProfileCubit>().updateField(
                p.copyWith(bloodGroupId: val, bloodGroupName: name),
              );
            },
          ),
          icon: LucideIcons.droplet,
        ),
        Row(
          children: [
            Expanded(
              child: _buildFieldWrapper(
                'Height (cm)',
                TextFormField(
                  controller: _heightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: _getInputDecoration('170.0'),
                  onChanged: (val) => context.read<ProfileCubit>().updateField(
                    p.copyWith(heightCm: double.tryParse(val)),
                  ),
                ),
                icon: LucideIcons.ruler,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildFieldWrapper(
                'Weight (kg)',
                TextFormField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: _getInputDecoration('65.0'),
                  onChanged: (val) => context.read<ProfileCubit>().updateField(
                    p.copyWith(weightKg: double.tryParse(val)),
                  ),
                ),
                icon: LucideIcons.weight,
              ),
            ),
          ],
        ),
        _buildFieldWrapper(
          'Known Allergies',
          TextFormField(
            controller: _allergiesController,
            maxLines: 2,
            decoration: _getInputDecoration('e.g. Penicillin, Peanuts'),
            onChanged: (val) => context.read<ProfileCubit>().updateField(
              p.copyWith(allergies: val.isEmpty ? null : val),
            ),
          ),
          icon: LucideIcons.alertCircle,
        ),
        _buildFieldWrapper(
          'Current Medications',
          TextFormField(
            controller: _medsController,
            maxLines: 2,
            decoration: _getInputDecoration('e.g. Metformin 500mg daily'),
            onChanged: (val) => context.read<ProfileCubit>().updateField(
              p.copyWith(currentMedications: val.isEmpty ? null : val),
            ),
          ),
          icon: LucideIcons.heart,
        ),
        if (bmi != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBgMuted : AppColors.lightBgMuted,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
              borderRadius: AppRadius.borderMd,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Body Mass Index',
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    Text(
                      bmi.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getBmiBg(bmi),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getBmiCategory(bmi),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _getBmiColor(bmi),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (history.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text(
            'Past Medical History',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          ...history.map(
            (h) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBgMuted : AppColors.lightBgMuted,
                borderRadius: AppRadius.borderMd,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    h.conditionName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  if (h.diagnosedAt != null)
                    Text(
                      'Diagnosed: ${h.diagnosedAt!.split('T').first}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  if (h.notes != null && h.notes!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      h.notes!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEmergencyTab(PatientProfile p, bool isDark) {
    return Column(
      children: [
        _buildFieldWrapper(
          'Contact Name',
          TextFormField(
            controller: _emergencyNameController,
            decoration: _getInputDecoration('Full name'),
            onChanged: (val) => context.read<ProfileCubit>().updateField(
              p.copyWith(emergencyName: val.isEmpty ? null : val),
            ),
          ),
          icon: LucideIcons.user,
        ),
        _buildFieldWrapper(
          'Relation',
          TextFormField(
            controller: _emergencyRelationController,
            decoration: _getInputDecoration('Spouse, Parent, etc.'),
            onChanged: (val) => context.read<ProfileCubit>().updateField(
              p.copyWith(emergencyRelation: val.isEmpty ? null : val),
            ),
          ),
        ),
        _buildFieldWrapper(
          'Contact Phone',
          TextFormField(
            controller: _emergencyPhoneController,
            keyboardType: TextInputType.phone,
            decoration: _getInputDecoration('9876543210'),
            onChanged: (val) => context.read<ProfileCubit>().updateField(
              p.copyWith(emergencyPhone: val.isEmpty ? null : val),
            ),
          ),
          icon: LucideIcons.phone,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.cBlueBg,
            border: Border.all(color: AppColors.cBlueBorder),
            borderRadius: AppRadius.borderMd,
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(LucideIcons.shield, size: 14, color: AppColors.cBlue),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Emergency contact will be reached during medical emergencies at a clinic visit.',
                  style: TextStyle(color: AppColors.cBlue, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _saveProfile(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileCubit>().saveProfile();
    }
  }
}
