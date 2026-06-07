import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../routes/route_names.dart';

class ProgramsScreen extends StatefulWidget {
  const ProgramsScreen({super.key});

  @override
  State<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  String _selectedCat = 'All Program';

  final List<String> _categories = ['All Program', 'Strength', 'Cardio', 'Wellness'];

  final List<Map<String, dynamic>> _programs = [
    {'id': 1, 'title': '30-Day Full Body Challenge', 'level': 'Intermediate', 'days': 30, 'perWeek': 5, 'cat': 'Strength', 'desc': 'Build strength, burn fat, and improve endurance.', 'emoji': '🔥'},
    {'id': 2, 'title': 'Muscle Builder', 'level': 'Intermediate', 'days': 14, 'perWeek': 4, 'cat': 'Strength', 'desc': 'Progressive overload program for lean muscle.', 'emoji': '💪'},
    {'id': 3, 'title': 'Fat Burn Boost', 'level': 'Beginner', 'days': 56, 'perWeek': 3, 'cat': 'Cardio', 'desc': 'High-intensity intervals to torch calories.', 'emoji': '⚡'},
    {'id': 4, 'title': 'Cardio Power', 'level': 'Advanced', 'days': 21, 'perWeek': 5, 'cat': 'Cardio', 'desc': 'Boost cardiovascular capacity and stamina.', 'emoji': '🏃'},
    {'id': 5, 'title': 'Yoga Flow & Flexibility', 'level': 'Beginner', 'days': 28, 'perWeek': 4, 'cat': 'Wellness', 'desc': 'Improve mobility, balance, and recovery.', 'emoji': '🧘'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _selectedCat == 'All Program' ? _programs : _programs.where((p) => p['cat'] == _selectedCat).toList();
    final featured = _programs[0];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
      appBar: AppBar(
        title: const Text('Programs'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.fitOrange.withValues(alpha: 0.1),
                      borderRadius: AppRadius.borderLg,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(LucideIcons.activity, color: AppColors.fitOrange),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Programs', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                        Text('Guided training plans', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _categories.length,
                itemBuilder: (ctx, i) {
                  final c = _categories[i];
                  final isSelected = _selectedCat == c;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCat = c),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.fitOrange : (isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        c,
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF2A2520), Color(0xFF4A3520)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: AppRadius.borderXl,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -10,
                      bottom: -10,
                      child: Text(featured['emoji'], style: const TextStyle(fontSize: 80, color: Colors.white24)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('FEATURED', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white70, letterSpacing: 2)),
                        const SizedBox(height: 8),
                        Text(featured['title'], style: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(featured['desc'], style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(LucideIcons.clock, color: Colors.white70, size: 14),
                            const SizedBox(width: 4),
                            Text('${featured['days']} days', style: GoogleFonts.inter(fontSize: 11, color: Colors.white70)),
                            const SizedBox(width: 16),
                            const Icon(LucideIcons.barChart3, color: Colors.white70, size: 14),
                            const SizedBox(width: 4),
                            Text('${featured['perWeek']}x/week', style: GoogleFonts.inter(fontSize: 11, color: Colors.white70)),
                            const SizedBox(width: 16),
                            const Icon(LucideIcons.flame, color: Colors.white70, size: 14),
                            const SizedBox(width: 4),
                            Text(featured['level'], style: GoogleFonts.inter(fontSize: 11, color: Colors.white70)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF2A2520),
                            shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
                          ),
                          onPressed: () => context.push(RouteNames.patientFitWorkouts),
                          child: Text('Start Program', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: filtered.map((p) {
                  return GestureDetector(
                    onTap: () => context.push(RouteNames.patientFitWorkouts),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
                        borderRadius: AppRadius.borderXl,
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
                              borderRadius: AppRadius.borderLg,
                            ),
                            alignment: Alignment.center,
                            child: Text(p['emoji'], style: const TextStyle(fontSize: 24)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p['title'], style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text('${p['days']} days', style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                                    const SizedBox(width: 8),
                                    Text('${p['perWeek']}x/week', style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                                    const SizedBox(width: 8),
                                    Text(p['level'], style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Icon(LucideIcons.chevronRight, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
