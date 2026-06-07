import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../data/models/fitness_hub_models.dart';
import '../cubit/goals_cubit.dart';

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
      backgroundColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
      appBar: AppBar(
        title: const Text('All Goals'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus),
            onPressed: () => _showAddGoalDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<GoalsCubit, GoalsState>(
        builder: (context, state) {
          if (state is GoalsLoading || state is GoalsInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GoalsError) {
            return Center(child: Text(state.message));
          }
          if (state is GoalsLoaded) {
            final _goals = state.goals;
            if (_goals.isEmpty) {
              return Center(
                child: Text(
                  'No goals set.',
                  style: GoogleFonts.inter(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _goals.length,
              itemBuilder: (context, index) {
                final g = _goals[index];
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Goal'),
        content: const Text('Goal selection options will be available here.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.fitOrange),
            onPressed: () => Navigator.pop(context),
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _GoalDetailedCard extends StatelessWidget {
  final FitGoalDetail goal;

  const _GoalDetailedCard({required this.goal});

  IconData _getGoalIcon(String type) {
    switch (type) {
      case 'steps': return LucideIcons.footprints;
      case 'calories_burn': return LucideIcons.flame;
      case 'water_ml': return LucideIcons.droplets;
      case 'sleep_min': return LucideIcons.moon;
      default: return LucideIcons.target;
    }
  }

  String _getGoalLabel(String type) {
    switch (type) {
      case 'steps': return 'Daily Steps';
      case 'calories_burn': return 'Active Calories';
      case 'water_ml': return 'Hydration';
      case 'sleep_min': return 'Sleep Duration';
      default: return type.replaceAll('_', ' ');
    }
  }

  String _getGoalUnit(String type) {
    switch (type) {
      case 'steps': return 'steps';
      case 'calories_burn': return 'kcal';
      case 'water_ml': return 'ml';
      case 'sleep_min': return 'min';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
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
                child: Icon(_getGoalIcon(goal.goalType), color: AppColors.fitOrange, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGoalLabel(goal.goalType),
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      '${goal.current.toInt()} / ${goal.targetValue.toInt()} ${_getGoalUnit(goal.goalType)}',
                      style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    ),
                  ],
                ),
              ),
              Text(
                '${goal.pct}%',
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.fitOrange),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (goal.pct / 100).clamp(0.0, 1.0),
              backgroundColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
              color: AppColors.fitOrange,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
