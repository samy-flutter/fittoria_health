import '../../../../core/utils/ui_helpers.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final int _totalPages = 5;
  bool _isSaving = false;

  // Next.js state equivalents
  String? _primaryGoal;
  String? _fitnessLevel;
  String? _activityFreq;
  String? _trainingMode;
  String _userCategory = 'general';

  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _medicalController = TextEditingController();

  final List<String> _stepTitles = ['Goal', 'Level', 'Body', 'Path', 'Health'];

  @override
  void dispose() {
    _pageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _medicalController.dispose();
    super.dispose();
  }

  Future<void> _nextPage() async {
    if (_currentIndex < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      setState(() => _isSaving = true);
      try {
        final payload = {
          'primary_goal': _primaryGoal,
          'fitness_level': _fitnessLevel,
          'activity_frequency': _activityFreq,
          'training_mode': _trainingMode,
          'user_category': _userCategory,
          'height_cm': _heightController.text.isNotEmpty ? _heightController.text : null,
          'weight_kg': _weightController.text.isNotEmpty ? _weightController.text : null,
          'medical_conditions': _medicalController.text.isNotEmpty ? _medicalController.text : null,
        };

        await sl<DioClient>().post(
          ApiEndpoints.onboarding,
          data: payload,
        );

        if (!mounted) return;
        Navigator.pop(context);
        UIHelpers.showSuccessSnackBar(context, 'Personalization saved! +25 Points');
} catch (e) {
        if (!mounted) return;
        setState(() => _isSaving = false);
        UIHelpers.showErrorSnackBar(context, 'Failed to save personalization');
}
    }
  }

  void _prevPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  bool _canProceed() {
    if (_currentIndex == 0) return _primaryGoal != null;
    if (_currentIndex == 1) return _fitnessLevel != null && _activityFreq != null;
    if (_currentIndex == 2) return true; // Height/Weight are optional
    if (_currentIndex == 3) return _trainingMode != null;
    if (_currentIndex == 4) return _userCategory == 'general' || (_userCategory == 'medical' && _medicalController.text.isNotEmpty);
    return false;
  }

  double? _calculateBMI() {
    if (_heightController.text.isEmpty || _weightController.text.isEmpty) return null;
    final h = double.tryParse(_heightController.text);
    final w = double.tryParse(_weightController.text);
    if (h == null || w == null || h <= 0) return null;
    return w / pow(h / 100, 2);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 12),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.fitOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(LucideIcons.sparkles, color: AppColors.fitOrange, size: 12),
                        const SizedBox(width: 6),
                        Text('Let\'s personalize Fittoria', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.fitOrange)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Tell us about you', style: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                  const SizedBox(height: 4),
                  Text('Step ${_currentIndex + 1} of $_totalPages · ${_stepTitles[_currentIndex]}', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                ],
              ),
            ),
            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: List.generate(_totalPages, (index) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: index == _totalPages - 1 ? 0 : 6),
                      height: 6,
                      decoration: BoxDecoration(
                        color: index <= _currentIndex ? AppColors.fitOrange : (isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  );
                }),
              ),
            ),
            // Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentIndex = index),
                children: [
                  _buildGoalStep(isDark),
                  _buildLevelStep(isDark),
                  _buildBodyStep(isDark),
                  _buildPathStep(isDark),
                  _buildHealthStep(isDark),
                ],
              ),
            ),
            // Nav buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (_currentIndex > 0)
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.borderLg,
                            side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          ),
                          elevation: 0,
                          minimumSize: const Size(0, 48),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onPressed: _prevPage,
                        child: Row(
                          children: [
                            const Icon(LucideIcons.arrowLeft, size: 16),
                            const SizedBox(width: 8),
                            Text('Back', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.fitOrange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
                        elevation: _currentIndex == _totalPages - 1 ? 8 : 0,
                        shadowColor: AppColors.fitOrange.withValues(alpha: 0.5),
                        minimumSize: const Size(0, 48),
                      ),
                      onPressed: _canProceed() && !_isSaving ? _nextPage : null,
                      child: _isSaving 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_currentIndex == _totalPages - 1) const Icon(LucideIcons.check, size: 16),
                          if (_currentIndex == _totalPages - 1) const SizedBox(width: 8),
                          Text(_currentIndex == _totalPages - 1 ? 'Finish Setup' : 'Continue', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                          if (_currentIndex != _totalPages - 1) const SizedBox(width: 8),
                          if (_currentIndex != _totalPages - 1) const Icon(LucideIcons.arrowRight, size: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalStep(bool isDark) {
    final goals = [
      {'key': 'weight_loss', 'label': 'Weight Loss', 'icon': LucideIcons.trendingDown, 'color': const Color(0xFFEF4444)},
      {'key': 'muscle_gain', 'label': 'Muscle Gain', 'icon': LucideIcons.dumbbell, 'color': const Color(0xFF22C55E)},
      {'key': 'endurance', 'label': 'Endurance', 'icon': LucideIcons.activity, 'color': const Color(0xFF3B82F6)},
      {'key': 'flexibility', 'label': 'Flexibility', 'icon': LucideIcons.zap, 'color': const Color(0xFFA78BFA)},
      {'key': 'general_fitness', 'label': 'General Fitness', 'icon': LucideIcons.heartPulse, 'color': AppColors.fitOrange},
      {'key': 'rehab', 'label': 'Recovery / Rehab', 'icon': LucideIcons.stethoscope, 'color': const Color(0xFF00D4B4)},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('What\'s your main goal?', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          const SizedBox(height: 4),
          Text('We\'ll tailor your plan & shop around it.', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: goals.map((g) {
              final isSelected = _primaryGoal == g['key'];
              final color = g['color'] as Color;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _primaryGoal = g['key'] as String),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withValues(alpha: 0.1) : (isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface),
                    borderRadius: AppRadius.borderXl,
                    border: Border.all(color: isSelected ? color : (isDark ? AppColors.darkBorder : AppColors.lightBorder), width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                        child: Icon(g['icon'] as IconData, color: color, size: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(g['label'] as String, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelStep(bool isDark) {
    final levels = [
      {'key': 'beginner', 'label': 'Beginner', 'desc': 'New to working out'},
      {'key': 'intermediate', 'label': 'Intermediate', 'desc': 'Train a few times a week'},
      {'key': 'advanced', 'label': 'Advanced', 'desc': 'Consistent & experienced'},
    ];

    final freqs = [
      {'key': 'sedentary', 'label': 'Sedentary', 'desc': 'Little to no exercise'},
      {'key': 'light', 'label': 'Lightly active', 'desc': '1-2 days / week'},
      {'key': 'moderate', 'label': 'Moderate', 'desc': '3-4 days / week'},
      {'key': 'active', 'label': 'Active', 'desc': '5-6 days / week'},
      {'key': 'very_active', 'label': 'Very Active', 'desc': 'Daily / athlete'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your fitness level', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          const SizedBox(height: 16),
          ...levels.map((l) {
            final isSelected = _fitnessLevel == l['key'];
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _fitnessLevel = l['key']),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.fitOrange.withValues(alpha: 0.1) : (isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface),
                  borderRadius: AppRadius.borderXl,
                  border: Border.all(color: isSelected ? AppColors.fitOrange : (isDark ? AppColors.darkBorder : AppColors.lightBorder), width: 2),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l['label']!, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                          Text(l['desc']!, style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                        ],
                      ),
                    ),
                    if (isSelected) const Icon(LucideIcons.check, color: AppColors.fitOrange, size: 20),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 32),
          Text('How active are you?', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: freqs.map((f) {
              final isSelected = _activityFreq == f['key'];
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _activityFreq = f['key']),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.fitOrange : Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: isSelected ? AppColors.fitOrange : (isDark ? AppColors.darkBorder : AppColors.lightBorder), width: 2),
                  ),
                  child: Text(
                    f['label']!,
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyStep(bool isDark) {
    final bmi = _calculateBMI();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Body basics', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          const SizedBox(height: 4),
          Text('Helps calculate calories & BMI. Optional.', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Height (cm)', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                    const SizedBox(height: 8),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                      child: TextField(
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.inter(fontSize: 14),
                        decoration: const InputDecoration(border: InputBorder.none, hintText: '170'),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Weight (kg)', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                    const SizedBox(height: 8),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                      child: TextField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.inter(fontSize: 14),
                        decoration: const InputDecoration(border: InputBorder.none, hintText: '65'),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (bmi != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.fitOrange.withValues(alpha: 0.1),
                borderRadius: AppRadius.borderXl,
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.flame, color: AppColors.fitOrange, size: 24),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your BMI', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                      Text(bmi.toStringAsFixed(1), style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPathStep(bool isDark) {
    final modes = [
      {'key': 'online', 'label': 'Online', 'desc': '1-on-1 video & group batches', 'icon': LucideIcons.video},
      {'key': 'offline', 'label': 'Offline', 'desc': 'Gym + assigned trainer & dietitian', 'icon': LucideIcons.building2},
      {'key': 'hybrid', 'label': 'Hybrid', 'desc': 'Best of both worlds', 'icon': LucideIcons.repeat},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('How do you want to train?', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          const SizedBox(height: 4),
          Text('Pick a path — you can change it later.', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          const SizedBox(height: 24),
          ...modes.map((m) {
            final isSelected = _trainingMode == m['key'];
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _trainingMode = m['key'] as String),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.fitOrange.withValues(alpha: 0.1) : (isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface),
                  borderRadius: AppRadius.borderXl,
                  border: Border.all(color: isSelected ? AppColors.fitOrange : (isDark ? AppColors.darkBorder : AppColors.lightBorder), width: 2),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.fitOrange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Icon(m['icon'] as IconData, color: AppColors.fitOrange, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m['label'] as String, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                          Text(m['desc'] as String, style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                        ],
                      ),
                    ),
                    if (isSelected) const Icon(LucideIcons.check, color: AppColors.fitOrange, size: 20),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHealthStep(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Any health conditions?', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
          const SizedBox(height: 4),
          Text('If you have a medical condition, we\'ll flag your account for custom, supervised plans.', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _userCategory = 'general'),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _userCategory == 'general' ? const Color(0xFF22C55E).withValues(alpha: 0.1) : (isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface),
                      borderRadius: AppRadius.borderXl,
                      border: Border.all(color: _userCategory == 'general' ? const Color(0xFF22C55E) : (isDark ? AppColors.darkBorder : AppColors.lightBorder), width: 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(LucideIcons.heartPulse, color: Color(0xFF22C55E), size: 20),
                        const SizedBox(height: 12),
                        Text('General', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                        const SizedBox(height: 4),
                        Text('No major conditions', style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _userCategory = 'medical'),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _userCategory == 'medical' ? const Color(0xFFEF4444).withValues(alpha: 0.1) : (isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface),
                      borderRadius: AppRadius.borderXl,
                      border: Border.all(color: _userCategory == 'medical' ? const Color(0xFFEF4444) : (isDark ? AppColors.darkBorder : AppColors.lightBorder), width: 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(LucideIcons.stethoscope, color: Color(0xFFEF4444), size: 20),
                        const SizedBox(height: 12),
                        Text('Medical', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                        const SizedBox(height: 4),
                        Text('Custom supervised plans', style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_userCategory == 'medical') ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
                borderRadius: AppRadius.borderXl,
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: TextField(
                controller: _medicalController,
                maxLines: 3,
                style: GoogleFonts.inter(fontSize: 14),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'e.g. diabetes, hypertension, knee injury…',
                  hintStyle: GoogleFonts.inter(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
