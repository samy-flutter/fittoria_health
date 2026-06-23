import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../injection_container.dart';
import '../cubit/ai_nutrition_cubit.dart';
import '../cubit/ai_nutrition_state.dart';
import '../../data/models/ai_log_model.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class AiNutritionScreen extends StatelessWidget {
  const AiNutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AiNutritionCubit>()..loadLogs(),
      child: const _AiNutritionView(),
    );
  }
}

class _AiNutritionView extends StatefulWidget {
  const _AiNutritionView();

  @override
  State<_AiNutritionView> createState() => _AiNutritionViewState();
}

class _AiNutritionViewState extends State<_AiNutritionView> {
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  String _mealType = 'snack';

  final List<String> _meals = ['breakfast', 'lunch', 'dinner', 'snack'];

  @override
  void initState() {
    super.initState();
    _foodController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _foodController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _estimate(BuildContext context) {
    if (_foodController.text.trim().isEmpty) return;
    context.read<AiNutritionCubit>().estimateAndLog(
          _foodController.text.trim(),
          _imageController.text.trim().isEmpty ? null : _imageController.text.trim(),
          _mealType,
        );
    FocusScope.of(context).unfocus();
    _foodController.clear();
    _imageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.fitOrange.withValues(alpha: 0.15),
                borderRadius: AppRadius.borderLg,
              ),
              child: const Icon(LucideIcons.sparkles, color: AppColors.fitOrange, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Nutritionist',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  'Snap or describe your meal',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: BlocBuilder<AiNutritionCubit, AiNutritionState>(
        builder: (context, state) {
          if (state is AiNutritionInitial || state is AiNutritionLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.fitOrange));
          }
          if (state is AiNutritionError) {
            return Center(child: Text(state.message, style: GoogleFonts.inter(color: Colors.red)));
          }

          if (state is AiNutritionLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEstimatorCard(context, state, isDark),
                  const SizedBox(height: 20),
                  if (state.lastResult != null) ...[
                    _buildResultCard(state.lastResult!, isDark),
                    const SizedBox(height: 20),
                  ],
                  Row(
                    children: [
                      const Icon(LucideIcons.apple, size: 16, color: Color(0xFF22C55E)),
                      const SizedBox(width: 8),
                      Text('Recent Estimates', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (state.logs.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text('No meals analyzed yet.', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                      ),
                    )
                  else
                    ...state.logs.map((log) => _buildLogItem(log, isDark)),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEstimatorCard(BuildContext context, AiNutritionLoaded state, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.sparkles, size: 14, color: AppColors.fitOrange),
              const SizedBox(width: 8),
              Text(
                "Describe your meal — we'll estimate the macros",
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.fitOrange),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _foodController,
            style: GoogleFonts.inter(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'e.g. "chicken biryani" or "2 idli with sambar"',
              hintStyle: GoogleFonts.inter(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 14),
              border: OutlineInputBorder(borderRadius: AppRadius.borderXl, borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
              enabledBorder: OutlineInputBorder(borderRadius: AppRadius.borderXl, borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
              focusedBorder: OutlineInputBorder(borderRadius: AppRadius.borderXl, borderSide: const BorderSide(color: AppColors.fitOrange)),
              filled: true,
              fillColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _imageController,
            style: GoogleFonts.inter(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Photo URL (optional)',
              hintStyle: GoogleFonts.inter(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 14),
              prefixIcon: Icon(LucideIcons.camera, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
              border: OutlineInputBorder(borderRadius: AppRadius.borderXl, borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
              enabledBorder: OutlineInputBorder(borderRadius: AppRadius.borderXl, borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
              focusedBorder: OutlineInputBorder(borderRadius: AppRadius.borderXl, borderSide: const BorderSide(color: AppColors.fitOrange)),
              filled: true,
              fillColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _meals.map((m) {
              final isSelected = _mealType == m;
              return GestureDetector(
                onTap: () => setState(() => _mealType = m),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.fitOrange : Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    m[0].toUpperCase() + m.substring(1),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.fitOrange,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.borderXl),
                disabledBackgroundColor: AppColors.fitOrange.withValues(alpha: 0.5),
              ),
              onPressed: state.isEstimating || _foodController.text.trim().isEmpty ? null : () => _estimate(context),
              child: state.isEstimating
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.sparkles, color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        Text('Estimate & Log', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(AiLog result, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: AppColors.fitOrange),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.fitOrange.withValues(alpha: 0.1),
                  borderRadius: AppRadius.borderLg,
                ),
                child: const Icon(LucideIcons.check, color: AppColors.fitOrange, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.detectedFood[0].toUpperCase() + result.detectedFood.substring(1),
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                    ),
                    Text(
                      'Logged · ${result.confidence}% confidence',
                      style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildMacroItem('Calories', result.estCalories.toString(), 'kcal', AppColors.fitOrange, isDark),
              const SizedBox(width: 8),
              _buildMacroItem('Protein', result.estProteinG.toString(), 'g', const Color(0xFF22C55E), isDark),
              const SizedBox(width: 8),
              _buildMacroItem('Carbs', result.estCarbsG.toString(), 'g', const Color(0xFF3B82F6), isDark),
              const SizedBox(width: 8),
              _buildMacroItem('Fat', result.estFatG.toString(), 'g', const Color(0xFFF59E0B), isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroItem(String label, String val, String unit, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: AppRadius.borderLg,
        ),
        child: Column(
          children: [
            Text(
              val,
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 9, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogItem(AiLog log, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
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
              color: AppColors.fitOrange.withValues(alpha: 0.1),
              borderRadius: AppRadius.borderLg,
              image: log.imageUrl != null ? DecorationImage(image: NetworkImage(log.imageUrl!), fit: BoxFit.cover) : null,
            ),
            child: log.imageUrl == null ? const Icon(LucideIcons.flame, color: AppColors.fitOrange, size: 20) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.detectedFood[0].toUpperCase() + log.detectedFood.substring(1),
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text('P ${log.estProteinG}g', style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                    const SizedBox(width: 8),
                    Text('C ${log.estCarbsG}g', style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                    const SizedBox(width: 8),
                    Text('F ${log.estFatG}g', style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${log.estCalories}',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.fitOrange),
              ),
              Text(
                'kcal',
                style: GoogleFonts.inter(fontSize: 9, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
