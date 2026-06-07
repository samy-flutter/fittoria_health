import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  String _selectedType = 'running';
  bool _isTracking = false;
  bool _isFinished = false;
  bool _isSaved = false;

  final List<Map<String, dynamic>> _types = [
    {'key': 'running', 'label': 'Run', 'icon': LucideIcons.footprints},
    {'key': 'walking', 'label': 'Walk', 'icon': LucideIcons.footprints},
    {'key': 'cycling', 'label': 'Cycle', 'icon': LucideIcons.bike},
  ];

  void _stopTracking() {
    setState(() {
      _isTracking = false;
      _isFinished = true;
    });
  }

  void _saveActivity() {
    setState(() {
      _isSaved = true;
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
      appBar: AppBar(
        title: const Text('Record Activity'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.fitOrange.withValues(alpha: 0.1),
                    borderRadius: AppRadius.borderLg,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(LucideIcons.mapPin, color: AppColors.fitOrange),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Record Activity', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                      Text('GPS-tracked — no manual entry', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (!_isTracking && !_isFinished)
              Row(
                children: _types.map((t) {
                  final isSelected = _selectedType == t['key'];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedType = t['key']),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.fitOrange.withValues(alpha: 0.1) : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isSelected ? AppColors.fitOrange : (isDark ? AppColors.darkBorder : AppColors.lightBorder), width: 2),
                        ),
                        child: Column(
                          children: [
                            Icon(t['icon'], color: isSelected ? AppColors.fitOrange : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                            const SizedBox(height: 8),
                            Text(t['label'], style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? AppColors.fitOrange : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted))),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            if (!_isSaved) ...[
              const SizedBox(height: 24),
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
                  borderRadius: AppRadius.borderXl,
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/map_placeholder.png'), // Assume we have a placeholder or just use a color
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: Alignment.center,
                child: _isTracking
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(30)),
                        child: Text('Tracking Active...', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
                      )
                    : (!_isFinished ? const Icon(LucideIcons.map, size: 64, color: Colors.grey) : const SizedBox.shrink()),
              ),
            ],
            if (_isSaved)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
                  borderRadius: AppRadius.borderXl,
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.15), shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: const Icon(LucideIcons.check, color: Colors.green, size: 28),
                    ),
                    const SizedBox(height: 16),
                    Text('Activity saved! 🎉', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('+20 points earned', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                  ],
                ),
              ),
            if (_isFinished && !_isSaved) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
                  borderRadius: AppRadius.borderXl,
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatVal('Distance', '5.20 km', isDark),
                        _buildStatVal('Duration', '25m 14s', isDark),
                        _buildStatVal('Avg Pace', '4:51/km', isDark),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.fitOrange,
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
                        ),
                        onPressed: _saveActivity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(LucideIcons.check, color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text('Save Activity · +20 pts', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (!_isFinished && !_isSaved) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isTracking ? Colors.red : AppColors.fitOrange,
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.borderXl),
                  ),
                  onPressed: () {
                    if (_isTracking) {
                      _stopTracking();
                    } else {
                      setState(() => _isTracking = true);
                    }
                  },
                  child: Text(
                    _isTracking ? 'Stop Tracking' : 'Start Tracking',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatVal(String label, String val, bool isDark) {
    return Column(
      children: [
        Text(val, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
        Text(label, style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
      ],
    );
  }
}
