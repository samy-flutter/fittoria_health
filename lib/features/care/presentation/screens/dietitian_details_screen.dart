import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

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
      appBar: const CustomAppBar(title: Text('Nutrition')),
      body: BlocBuilder<NutritionDetailsCubit, NutritionDetailsState>(
        builder: (context, state) {
          if (state is NutritionDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.success),
            );
          }

          if (state is NutritionDetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    LucideIcons.alertCircle,
                    size: 48,
                    color: AppColors.danger,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load nutrition data',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<NutritionDetailsCubit>()
                        .loadNutritionDetails(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is NutritionDetailsLoaded) {
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<NutritionDetailsCubit>().loadNutritionDetails(),
              color: AppColors.success,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header matching CRM
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.successBgLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            LucideIcons.salad,
                            size: 20,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nutrition',
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                              Text(
                                'Meal plans, tracking & dietitian guidance',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.darkTextMuted
                                      : AppColors.lightTextMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Dietitian Card
                    if (state.data.dietitian != null)
                      _buildDietitianCard(
                        context,
                        state.data.dietitian!,
                        isDark,
                      )
                    else
                      _buildEmptyDietitianCard(isDark),

                    // Active Meal Plan
                    if (state.data.activePlan != null) ...[
                      const SizedBox(height: 20),
                      _buildActivePlan(state.data.activePlan!, isDark),
                    ] else if (state.data.plans.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _buildPlansList(state.data.plans, isDark),
                    ],

                    // Recent Tracking
                    if (state.data.tracking.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _buildFoodLog(state.data.tracking, isDark),
                    ],

                    // Reports
                    if (state.data.reports.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _buildReports(state.data.reports, isDark),
                    ],

                    if (state.data.dietitian == null &&
                        state.data.plans.isEmpty &&
                        state.data.tracking.isEmpty) ...[
                      const SizedBox(height: 20),
                      _buildCompletelyEmptyState(isDark),
                    ],
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDietitianCard(
    BuildContext context,
    CareDietitian dietitian,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.successBgLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              LucideIcons.user,
              size: 24,
              color: AppColors.success,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      dietitian.dietitianName,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.successBgLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Active Dietitian',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
                if (dietitian.specialization.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      dietitian.specialization,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                if (dietitian.bio.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      dietitian.bio,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ),
                if (dietitian.programStart.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.calendar,
                        size: 12,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${_formatDate(dietitian.programStart)}${dietitian.programEnd.isNotEmpty ? ' — ${_formatDate(dietitian.programEnd)}' : ''}",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ],
                if (dietitian.dietitianPhone.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final url = Uri.parse('tel:${dietitian.dietitianPhone}');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                    child: Text(
                      'Call Dietitian',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.success,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDietitianCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          Icon(
            LucideIcons.user,
            size: 32,
            color: isDark
                ? AppColors.darkTextMuted.withValues(alpha: 0.3)
                : AppColors.lightTextMuted.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 8),
          Text(
            'No dietitian assigned yet',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivePlan(MealPlan plan, bool isDark) {
    final Map<String, List<MealItem>> grouped = {};
    for (var item in plan.items) {
      if (!grouped.containsKey(item.mealType)) grouped[item.mealType] = [];
      grouped[item.mealType]!.add(item);
    }

    const mealOrder = [
      'breakfast',
      'morning_snack',
      'lunch',
      'afternoon_snack',
      'dinner',
      'bedtime_snack',
    ];
    const mealLabels = {
      'breakfast': 'Breakfast',
      'morning_snack': 'Morning Snack',
      'lunch': 'Lunch',
      'afternoon_snack': 'Afternoon Snack',
      'dinner': 'Dinner',
      'bedtime_snack': 'Bedtime Snack',
    };

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.title,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (plan.description.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            plan.description,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successBgLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Active Plan',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (plan.totalCalories > 0 ||
              plan.proteinG > 0 ||
              plan.carbsG > 0 ||
              plan.fatG > 0)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (plan.totalCalories > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '${plan.totalCalories} kcal / day',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  if (plan.proteinG > 0)
                    _buildMacroBar(
                      'Protein',
                      plan.proteinG,
                      200,
                      AppColors.cBlue,
                      isDark,
                    ),
                  if (plan.carbsG > 0)
                    _buildMacroBar(
                      'Carbs',
                      plan.carbsG,
                      400,
                      AppColors.fitOrange,
                      isDark,
                    ),
                  if (plan.fatG > 0)
                    _buildMacroBar(
                      'Fat',
                      plan.fatG,
                      100,
                      AppColors.danger,
                      isDark,
                    ),
                ],
              ),
            ),

          Divider(
            height: 1,
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),

          if (grouped.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'Meal items not added yet',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ),
            )
          else
            ...mealOrder.where((m) => grouped.containsKey(m)).map((mealType) {
              final label = mealLabels[mealType] ?? mealType;
              final items = grouped[mealType]!;
              final mealCal = items.fold<int>(
                0,
                (sum, item) => sum + item.calories,
              );

              return Theme(
                data: ThemeData(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Text(
                        '$label · ',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                      Text(
                        '${items.length} item${items.length != 1 ? 's' : ''}${mealCal > 0 ? ' · $mealCal kcal' : ''}',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                  iconColor: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                  collapsedIconColor: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                  childrenPadding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 12,
                  ),
                  children: items.map((item) {
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkBgMuted
                            : AppColors.lightBgMuted,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.foodName,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              if (item.calories > 0)
                                Text(
                                  '${item.calories} kcal',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: isDark
                                        ? AppColors.darkTextMuted
                                        : AppColors.lightTextMuted,
                                  ),
                                ),
                            ],
                          ),
                          if (item.portionSize.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                item.portionSize,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.darkTextMuted
                                      : AppColors.lightTextMuted,
                                ),
                              ),
                            ),
                          if (item.proteinG > 0 ||
                              item.carbsG > 0 ||
                              item.fatG > 0) ...[
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 12,
                              runSpacing: 4,
                              children: [
                                if (item.proteinG > 0)
                                  Text(
                                    'P: ${item.proteinG}g',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: isDark
                                          ? AppColors.darkTextMuted
                                          : AppColors.lightTextMuted,
                                    ),
                                  ),
                                if (item.carbsG > 0)
                                  Text(
                                    'C: ${item.carbsG}g',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: isDark
                                          ? AppColors.darkTextMuted
                                          : AppColors.lightTextMuted,
                                    ),
                                  ),
                                if (item.fatG > 0)
                                  Text(
                                    'F: ${item.fatG}g',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: isDark
                                          ? AppColors.darkTextMuted
                                          : AppColors.lightTextMuted,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                          if (item.instructions.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                item.instructions,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildMacroBar(
    String label,
    int value,
    int max,
    Color color,
    bool isDark,
  ) {
    double pct = (value / max).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              Text(
                '${value}g',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBgMuted : AppColors.lightBgMuted,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: pct,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlansList(List<MealPlan> plans, bool isDark) {
    return _buildListCard(
      title: 'Meal Plans',
      isDark: isDark,
      children: plans
          .map(
            (p) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.title,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          p.dietitianName.isNotEmpty ? p.dietitianName : '—',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildPlanStatusBadge(p.status),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildFoodLog(List<MealTracking> tracking, bool isDark) {
    const mealLabels = {
      'breakfast': 'Breakfast',
      'morning_snack': 'Morning Snack',
      'lunch': 'Lunch',
      'afternoon_snack': 'Afternoon Snack',
      'dinner': 'Dinner',
      'bedtime_snack': 'Bedtime Snack',
    };

    return _buildListCard(
      title: 'Food Log',
      isDark: isDark,
      children: tracking.take(8).map((t) {
        IconData icon;
        Color color;
        if (t.compliance == 'full') {
          icon = LucideIcons.checkCircle2;
          color = AppColors.success;
        } else if (t.compliance == 'partial') {
          icon = LucideIcons.alertCircle;
          color = AppColors.warning;
        } else {
          icon = LucideIcons.xCircle;
          color = AppColors.danger;
        }

        final title = t.foodConsumed.isNotEmpty
            ? t.foodConsumed
            : (mealLabels[t.mealType] ?? t.mealType);
        final subtitle =
            "${mealLabels[t.mealType] ?? t.mealType} · ${_formatDate(t.trackingDate)}";

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (t.calories != null)
                Text(
                  '${t.calories} kcal',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReports(List<DietitianReport> reports, bool isDark) {
    return _buildListCard(
      title: 'Dietitian Reports',
      isDark: isDark,
      children: reports
          .map(
            (r) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.title.isNotEmpty ? r.title : r.reportType,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (r.periodFrom.isNotEmpty)
                          Text(
                            "${_formatDate(r.periodFrom)}${r.periodTo.isNotEmpty ? ' — ${_formatDate(r.periodTo)}' : ''}",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      r.reportType,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildListCard({
    required String title,
    required bool isDark,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: 12,
            ),
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          ...children
              .expand(
                (w) => [
                  w,
                  Divider(
                    height: 1,
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ],
              )
              .toList()
            ..removeLast(),
        ],
      ),
    );
  }

  Widget _buildCompletelyEmptyState(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          Icon(
            LucideIcons.salad,
            size: 40,
            color: isDark
                ? AppColors.darkTextMuted.withValues(alpha: 0.2)
                : AppColors.lightTextMuted.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 12),
          Text(
            'No nutrition data yet',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Once a dietitian assigns you a meal plan, it will appear here.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    if (status.toLowerCase() == 'completed') {
      bgColor = AppColors.cBlueBg;
      textColor = AppColors.cBlue;
    } else {
      bgColor = AppColors.cSlateBg;
      textColor = AppColors.cSlate;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  String _formatDate(String isoString) {
    if (isoString.isEmpty) return '';
    try {
      final dt = DateTime.parse(isoString);
      return "${dt.day}/${dt.month}/${dt.year}";
    } catch (_) {
      return isoString.split('T').first;
    }
  }
}
