import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../cubit/body_progress_cubit.dart';
import '../../data/models/fitness_hub_models.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class BodyProgressScreen extends StatefulWidget {
  const BodyProgressScreen({super.key});

  @override
  State<BodyProgressScreen> createState() => _BodyProgressScreenState();
}

class _BodyProgressScreenState extends State<BodyProgressScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BodyProgressCubit>().loadBodyProgress();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const accentColor = Color(0xFFA855F7);

    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Body Progress'),
        ),
      body: BlocBuilder<BodyProgressCubit, BodyProgressState>(
        builder: (context, state) {
          if (state is BodyProgressLoading || state is BodyProgressInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BodyProgressError) {
            return Center(child: Text(state.message));
          }

          FitBodyProgressData data = FitBodyProgressData();
          if (state is BodyProgressLoaded) {
            data = state.data;
          }

          final latest = data.latest;
          if (latest == null) {
            return Center(
              child: Text('No body progress data available.', style: GoogleFonts.inter(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: AppRadius.borderLg,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(LucideIcons.scale, color: accentColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Body Progress', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                      Text('Measurements & fitness metrics over time', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
                borderRadius: AppRadius.borderXl,
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Latest Measurement', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(latest.recordedDate.split('T').first, style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                      children: [
                        _buildStat(isDark, 'WEIGHT', latest.weightKg?.toString() ?? '-', 'kg', data.weightDelta, false),
                        _buildStat(isDark, 'BODY FAT', latest.bodyFatPct?.toString() ?? '-', '%', data.fatDelta, true),
                        _buildStat(isDark, 'MUSCLE MASS', latest.muscleMassKg?.toString() ?? '-', 'kg', null, false),
                        _buildStat(isDark, 'BMI', latest.bmi?.toString() ?? '-', '', null, false),
                        _buildStat(isDark, 'WAIST', latest.waistCm?.toString() ?? '-', 'cm', null, true),
                        _buildStat(isDark, 'HIP', latest.hipCm?.toString() ?? '-', 'cm', null, true),
                        _buildStat(isDark, 'CHEST', latest.chestCm?.toString() ?? '-', 'cm', null, false),
                        _buildStat(isDark, 'ARM', latest.armCm?.toString() ?? '-', 'cm', null, false),
                        _buildStat(isDark, 'THIGH', latest.thighCm?.toString() ?? '-', 'cm', null, false),
                      ],
                    ),
                  ),
                  if (latest.recordedByName != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                      child: Text('Recorded by ${latest.recordedByName}', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
                borderRadius: AppRadius.borderXl,
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('History', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                  const Divider(height: 1),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingTextStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                      dataTextStyle: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                      columns: const [
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Weight')),
                        DataColumn(label: Text('Body Fat')),
                        DataColumn(label: Text('Muscle')),
                        DataColumn(label: Text('BMI')),
                        DataColumn(label: Text('Waist')),
                      ],
                      rows: data.metrics.map((m) {
                        return _buildRow(
                          isDark,
                          m.recordedDate.split('T').first,
                          '${m.weightKg ?? '-'} kg',
                          null, // Delta not easily available per row without heavy logic
                          '${m.bodyFatPct ?? '-'}%',
                          '${m.muscleMassKg ?? '-'} kg',
                          '${m.bmi ?? '-'}',
                          '${m.waistCm ?? '-'} cm',
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'Note: Body progress measurements are recorded by your trainer or dietitian during consultations.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
              ),
            ),
          ],
        ),
      );
      },
      ),
    );
  }

  Widget _buildStat(bool isDark, String label, String value, String unit, double? delta, bool lowerIsBetter) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
              if (unit.isNotEmpty) Padding(
                padding: const EdgeInsets.only(bottom: 2, left: 2),
                child: Text(unit, style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
              ),
            ],
          ),
          if (delta != null) ...[
            const SizedBox(height: 4),
            _buildDeltaIndicator(delta, lowerIsBetter),
          ],
        ],
      ),
    );
  }

  Widget _buildDeltaIndicator(double delta, bool lowerIsBetter) {
    final isPositive = delta > 0;
    final isNeutral = delta == 0;
    final isGood = isNeutral ? false : lowerIsBetter ? !isPositive : isPositive;
    
    final color = isNeutral ? Colors.grey : isGood ? Colors.green : Colors.red;
    final icon = isNeutral ? LucideIcons.minus : isPositive ? LucideIcons.trendingUp : LucideIcons.trendingDown;

    return Row(
      children: [
        Icon(icon, size: 10, color: color),
        const SizedBox(width: 2),
        Text('${isPositive ? '+' : ''}$delta', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  DataRow _buildRow(bool isDark, String date, String weight, String? weightDelta, String fat, String muscle, String bmi, String waist) {
    return DataRow(
      cells: [
        DataCell(Text(date, style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted))),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(weight, style: const TextStyle(fontWeight: FontWeight.bold)),
              if (weightDelta != null) ...[
                const SizedBox(width: 4),
                Text(weightDelta, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ],
          ),
        ),
        DataCell(Text(fat)),
        DataCell(Text(muscle)),
        DataCell(Text(bmi)),
        DataCell(Text(waist)),
      ],
    );
  }
}
