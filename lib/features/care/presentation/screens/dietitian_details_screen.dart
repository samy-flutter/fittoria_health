import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../injection_container.dart';
import '../cubit/nutrition_details_cubit.dart';
import '../../data/models/nutrition_details_model.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class DietitianDetailsScreen extends StatelessWidget {
  const DietitianDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NutritionDetailsCubit>()..loadNutritionDetails(),
      child: const _DietitianDetailsScreenView(),
    );
  }
}

class _DietitianDetailsScreenView extends StatelessWidget {
  const _DietitianDetailsScreenView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('My Dietitian'),
        ),
      body: BlocBuilder<NutritionDetailsCubit, NutritionDetailsState>(
        builder: (context, state) {
          if (state is NutritionDetailsLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.fitOrange));
          }

          if (state is NutritionDetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.alertCircle, size: 48, color: AppColors.danger),
                  const SizedBox(height: 16),
                  Text('Failed to load dietitian details', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(state.message, style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<NutritionDetailsCubit>().loadNutritionDetails(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is NutritionDetailsLoaded) {
            final isEmpty = state.data.dietitian == null && state.data.activePlan == null && state.data.tracking.isEmpty;

            Widget content = Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildDietitianHeader(context, state.data.dietitian, isDark),
                const SizedBox(height: 32),
                if (state.data.dietitian != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildActionButton(LucideIcons.messageCircle, 'Message', isDark),
                      const SizedBox(width: 16),
                      _buildActionButton(LucideIcons.video, 'Meeting', isDark),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
                _buildActivePlan(state.data.activePlan, isDark),
                const SizedBox(height: 32),
                if (state.data.tracking.isNotEmpty) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Recent Log', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
                  ...state.data.tracking.map((t) => _buildTrackingCard(t, isDark)),
                ]
              ],
            );

            return RefreshIndicator(
              onRefresh: () => context.read<NutritionDetailsCubit>().loadNutritionDetails(),
              color: AppColors.fitOrange,
              child: isEmpty
                  ? CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: _buildDietitianHeader(context, state.data.dietitian, isDark),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: content,
                    ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDietitianHeader(BuildContext context, CareDietitian? dietitian, bool isDark) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFFFB7C37).withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(LucideIcons.salad, size: 48, color: Color(0xFFFB7C37)),
        ),
        const SizedBox(height: 16),
        Text(
          dietitian?.dietitianName ?? 'No Active Dietitian',
          style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          dietitian?.specialization ?? 'Get matched with a nutrition expert',
          style: GoogleFonts.inter(fontSize: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.fitOrange),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActivePlan(MealPlan? plan, bool isDark) {
    if (plan == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Active Plan', style: GoogleFonts.inter(fontSize: 14, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          const SizedBox(height: 8),
          Text(plan.title, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(plan.description, style: GoogleFonts.inter(fontSize: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMacroItem('Calories', '${plan.totalCalories} kcal', isDark),
              _buildMacroItem('Protein', '${plan.proteinG}g', isDark),
              _buildMacroItem('Carbs', '${plan.carbsG}g', isDark),
              _buildMacroItem('Fat', '${plan.fatG}g', isDark),
            ],
          ),
          const SizedBox(height: 24),
          if (plan.items.isNotEmpty) ...[
            Text('Meals', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...plan.items.map((m) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.fitOrange.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.utensils, size: 14, color: AppColors.fitOrange),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.mealType.toUpperCase(), style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.fitOrange)),
                        const SizedBox(height: 2),
                        Text(m.foodName, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                        Text('${m.portionSize} • ${m.calories} kcal', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ]
        ],
      ),
    );
  }

  Widget _buildMacroItem(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
      ],
    );
  }

  Widget _buildTrackingCard(MealTracking tracking, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tracking.mealType, style: GoogleFonts.inter(fontSize: 12, color: AppColors.fitOrange, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(tracking.foodConsumed.isEmpty ? 'Logged Meal' : tracking.foodConsumed, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(tracking.trackingDate.split('T').first, style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: tracking.compliance > 80 ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
              borderRadius: AppRadius.borderMd,
            ),
            child: Text(
              '${tracking.compliance}% Plan',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: tracking.compliance > 80 ? Colors.green : Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
