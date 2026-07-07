import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../data/models/fitness_hub_models.dart';
import '../cubit/goals_cubit.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GoalsCubit>().loadGoals();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(title: const Text('All Goals')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.fitOrange,
        onPressed: () => _showAddGoalDialog(context),
        icon: const Icon(LucideIcons.plus, color: Colors.white),
        label: Text(
          'Add Goal',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<GoalsCubit, GoalsState>(
        listener: (context, state) {
          if (state is GoalsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GoalsLoading || state is GoalsInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GoalsError) {
            // Return empty widget while it reloads, since SnackBar is showing
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GoalsLoaded) {
            final goals = state.goals;
            if (goals.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.target,
                      color: isDark
                          ? AppColors.darkTextMuted.withValues(alpha: 0.2)
                          : AppColors.lightTextMuted.withValues(alpha: 0.2),
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No goals yet. Add one to start tracking.',
                      style: GoogleFonts.inter(
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final g = goals[index];
                return _GoalDetailedCard(goal: g);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    final goalsCubit = context.read<GoalsCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: goalsCubit,
        child: const _AddGoalBottomSheet(),
      ),
    );
  }
}

class _GoalDetailedCard extends StatelessWidget {
  final FitGoalDetail goal;

  const _GoalDetailedCard({required this.goal});

  IconData _getGoalIcon(String type) {
    switch (type) {
      case 'steps':
        return LucideIcons.footprints;
      case 'calories_burn':
        return LucideIcons.flame;
      case 'water_ml':
        return LucideIcons.droplets;
      case 'sleep_min':
        return LucideIcons.moon;
      default:
        return LucideIcons.target;
    }
  }

  String _getGoalLabel(String type) {
    switch (type) {
      case 'steps':
        return 'Daily Steps';
      case 'calories_burn':
        return 'Active Calories';
      case 'water_ml':
        return 'Hydration';
      case 'sleep_min':
        return 'Sleep Duration';
      default:
        return type.replaceAll('_', ' ');
    }
  }

  String _getGoalUnit(String type) {
    switch (type) {
      case 'steps':
        return 'steps';
      case 'calories_burn':
        return 'kcal';
      case 'water_ml':
        return 'ml';
      case 'sleep_min':
        return 'min';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final double calculatedPct = goal.targetValue > 0 
        ? ((goal.current / goal.targetValue) * 100).clamp(0.0, 100.0) 
        : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.fitOrange.withValues(alpha: 0.15),
                  borderRadius: AppRadius.borderLg,
                ),
                child: Icon(
                  _getGoalIcon(goal.goalType),
                  color: AppColors.fitOrange,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGoalLabel(goal.goalType),
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${goal.current.toInt()} / ${goal.targetValue.toInt()} ${_getGoalUnit(goal.goalType)}',
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
              Text(
                '${calculatedPct.toInt()}%',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.fitOrange,
                ),
              ),
              IconButton(
                icon: const Icon(LucideIcons.trash2, size: 20, color: Colors.redAccent),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: const Text('Delete Goal'),
                        content: const Text('Are you sure you want to delete this goal?'),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.of(dialogContext).pop(),
                          ),
                          TextButton(
                            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
                            onPressed: () {
                              context.read<GoalsCubit>().deleteGoal(goal.id);
                              Navigator.of(dialogContext).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: calculatedPct / 100,
              color: AppColors.fitOrange,
              backgroundColor: AppColors.fitOrange.withValues(alpha: 0.15),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddGoalBottomSheet extends StatefulWidget {
  const _AddGoalBottomSheet();

  @override
  State<_AddGoalBottomSheet> createState() => _AddGoalBottomSheetState();
}

class _AddGoalBottomSheetState extends State<_AddGoalBottomSheet> {
  final List<Map<String, dynamic>> goalTypes = [
    {
      'key': 'steps',
      'label': 'Daily Steps',
      'unit': 'steps',
      'icon': LucideIcons.footprints,
      'default': 10000,
      'period': 'daily',
    },
    {
      'key': 'calories_burn',
      'label': 'Calories Burned',
      'unit': 'kcal',
      'icon': LucideIcons.flame,
      'default': 500,
      'period': 'daily',
    },
    {
      'key': 'calories_intake',
      'label': 'Calorie Intake',
      'unit': 'kcal',
      'icon': LucideIcons.apple,
      'default': 2000,
      'period': 'daily',
    },
    {
      'key': 'active_minutes',
      'label': 'Active Minutes',
      'unit': 'min',
      'icon': LucideIcons.clock,
      'default': 60,
      'period': 'daily',
    },
    {
      'key': 'water_ml',
      'label': 'Water Intake',
      'unit': 'ml',
      'icon': LucideIcons.droplets,
      'default': 2500,
      'period': 'daily',
    },
    {
      'key': 'sleep_min',
      'label': 'Sleep',
      'unit': 'min',
      'icon': LucideIcons.moon,
      'default': 480,
      'period': 'daily',
    },
    {
      'key': 'workouts_week',
      'label': 'Workouts / Week',
      'unit': '',
      'icon': LucideIcons.dumbbell,
      'default': 4,
      'period': 'weekly',
    },
    {
      'key': 'weight_kg',
      'label': 'Target Weight',
      'unit': 'kg',
      'icon': LucideIcons.scale,
      'default': 70,
      'period': 'monthly',
    },
  ];

  late Map<String, dynamic> selectedType;
  late TextEditingController targetController;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    selectedType = goalTypes[0];
    targetController = TextEditingController(
      text: selectedType['default'].toString(),
    );
  }

  @override
  void dispose() {
    targetController.dispose();
    super.dispose();
  }

  void _onTypeSelected(Map<String, dynamic> type) {
    setState(() {
      selectedType = type;
      targetController.text = type['default'].toString();
    });
  }

  Future<void> _saveGoal() async {
    setState(() => isSaving = true);
    final target =
        int.tryParse(targetController.text) ?? selectedType['default'];
    await context.read<GoalsCubit>().addGoal(
      selectedType['key'],
      target as int,
      selectedType['period'],
    );
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add Goal',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(LucideIcons.x),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Goal Type',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 48,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: goalTypes.length,
            itemBuilder: (context, index) {
              final type = goalTypes[index];
              final isSelected = selectedType['key'] == type['key'];
              return GestureDetector(
                onTap: () => _onTypeSelected(type),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.fitOrange.withValues(alpha: 0.1)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.fitOrange
                          : (isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(type['icon'], size: 16, color: AppColors.fitOrange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          type['label'],
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Target (${selectedType['period']})',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: targetController,
                    keyboardType: TextInputType.number,

                    decoration: const InputDecoration(
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if ((selectedType['unit'] as String).isNotEmpty)
                  Text(
                    selectedType['unit'],
                    style: GoogleFonts.inter(
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.fitOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: isSaving ? null : _saveGoal,
              child: isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          LucideIcons.plus,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Save Goal',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
