import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../injection_container.dart';
import '../bloc/lab_reports_cubit.dart';
import '../bloc/lab_reports_state.dart';
import '../../data/models/lab_report.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class LabReportsScreen extends StatelessWidget {
  const LabReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LabReportsCubit>(
      create: (_) => sl<LabReportsCubit>()..loadLabReports(),
      child: const _LabReportsBody(),
    );
  }
}

class _LabReportsBody extends StatefulWidget {
  const _LabReportsBody();

  @override
  State<_LabReportsBody> createState() => _LabReportsBodyState();
}

class _LabReportsBodyState extends State<_LabReportsBody> {
  final Set<int> _expandedIds = {};

  void _toggleExpanded(int id) {
    setState(() {
      if (_expandedIds.contains(id)) {
        _expandedIds.remove(id);
      } else {
        _expandedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: Icon(LucideIcons.chevronLeft,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Lab Reports',
              style: AppTextStyles.h3.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'View your test orders and results',
              style: AppTextStyles.bodySmall.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<LabReportsCubit, LabReportsState>(
        builder: (context, state) {
          if (state is LabReportsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.lightTeal),
            );
          }

          if (state is LabReportsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.alertTriangle, size: 48, color: AppColors.danger),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to Load Lab Reports',
                      style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => context.read<LabReportsCubit>().loadLabReports(),
                      style: FilledButton.styleFrom(
                        backgroundColor: isDark ? AppColors.darkTeal : AppColors.lightTeal,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is LabReportsLoaded) {
            final orders = state.reports;

            if (orders.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.flaskConical, size: 48, color: (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted).withAlpha(128)),
                      const SizedBox(height: 16),
                      Text(
                        'No lab reports yet',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Lab orders from consultations will appear here.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Auto expand the first order
            if (_expandedIds.isEmpty && orders.isNotEmpty) {
              _expandedIds.add(orders.first.id);
            }

            // Calculations
            int completedCount = orders.where((o) => o.status == 'completed').length;
            int pendingCount = orders.where((o) => o.status != 'completed').length;
            int abnormalCount = orders.fold<int>(
              0,
              (prev, order) => prev + order.items.where((i) => i.isAbnormal).length,
            );

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<LabReportsCubit>().loadLabReports();
              },
              color: AppColors.lightTeal,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Count grids
                    Row(
                      children: [
                        Expanded(
                          child: _buildCountCard(
                            'Completed',
                            completedCount,
                            LucideIcons.checkCircle2,
                            AppColors.successBgLight,
                            AppColors.success,
                            isDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildCountCard(
                            'Pending',
                            pendingCount,
                            LucideIcons.clock,
                            AppColors.warningBgLight,
                            AppColors.warning,
                            isDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildCountCard(
                            'Abnormal',
                            abnormalCount,
                            LucideIcons.alertTriangle,
                            AppColors.dangerBgLight,
                            AppColors.danger,
                            isDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orders.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, idx) {
                        final o = orders[idx];
                        final isExpanded = _expandedIds.contains(o.id);
                        return _buildOrderCard(context, o, isExpanded, isDark);
                      },
                    ),
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

  Widget _buildCountCard(
    String label,
    int count,
    IconData icon,
    Color bg,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : Colors.white,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: AppRadius.borderMd,
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.1),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    LabReport order,
    bool isExpanded,
    bool isDark,
  ) {
    final hasAbnormal = order.items.any((it) => it.isAbnormal);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : Colors.white,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header InkWell
          InkWell(
            onTap: () => _toggleExpanded(order.id),
            borderRadius: isExpanded
                ? const BorderRadius.vertical(top: Radius.circular(16))
                : AppRadius.borderLg,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.cPurpleBg,
                      border: Border.all(color: AppColors.cPurpleBorder),
                      borderRadius: AppRadius.borderLg,
                    ),
                    child: const Center(
                      child: Icon(LucideIcons.flaskConical, color: AppColors.cPurple, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              '${order.items.length} test${order.items.length != 1 ? 's' : ''}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            _buildStatusPill(order.status),
                            if (hasAbnormal) _buildAbnormalBadge(),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 12,
                          runSpacing: 4,
                          children: [
                            _buildMetaRow(LucideIcons.stethoscope, 'Dr. ${order.orderedByName}', isDark),
                            _buildMetaRow(LucideIcons.building2, order.clinicName, isDark),
                            _buildMetaRow(LucideIcons.calendar, _formatDate(order.orderedAt), isDark),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),

          // Expanded view list of test items
          if (isExpanded) ...[
            Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  if (order.items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: Text(
                          'No tests in this order.',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    )
                  else
                    ...order.items.map((it) => _buildTestItemRow(it, isDark)),
                  if (order.notes != null && order.notes!.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.cBlueBg,
                        border: Border.all(color: AppColors.cBlueBorder),
                        borderRadius: AppRadius.borderMd,
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 11.5, color: AppColors.cBlue),
                          children: [
                            const TextSpan(text: 'Notes: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: order.notes),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTestItemRow(LabReportItem it, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: it.isAbnormal
            ? AppColors.dangerBgLight.withAlpha(50)
            : (isDark ? AppColors.darkBgMuted : AppColors.lightBgMuted),
        border: Border.all(
          color: it.isAbnormal ? AppColors.dangerBorderLight : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        borderRadius: AppRadius.borderMd,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  it.testName,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, height: 1.2),
                ),
                if (it.testCode != null && it.testCode!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    it.testCode!,
                    style: TextStyle(fontSize: 10, fontFamily: 'monospace', color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (it.resultValue != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${it.resultValue!}${it.resultUnit != null ? " ${it.resultUnit!}" : ""}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                        color: it.isAbnormal ? AppColors.danger : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                      ),
                    ),
                    if (it.isAbnormal) ...[
                      const SizedBox(width: 4),
                      const Icon(LucideIcons.alertTriangle, size: 14, color: AppColors.danger),
                    ],
                  ],
                )
              else
                const Text(
                  'Pending',
                  style: TextStyle(fontSize: 12.5, color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              if (it.referenceRange != null) ...[
                const SizedBox(height: 2),
                Text(
                  'Ref: ${it.referenceRange!}',
                  style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    Color bg, text, border;
    switch (status) {
      case 'ordered':
        bg = AppColors.cBlueBg;
        border = AppColors.cBlueBorder;
        text = AppColors.cBlue;
        break;
      case 'collected':
        bg = AppColors.warningBgLight;
        border = AppColors.warningBorderLight;
        text = AppColors.warning;
        break;
      case 'processing':
        bg = AppColors.cPurpleBg;
        border = AppColors.cPurpleBorder;
        text = AppColors.cPurple;
        break;
      case 'completed':
        bg = AppColors.successBgLight;
        border = AppColors.successBorderLight;
        text = AppColors.success;
        break;
      default:
        bg = Colors.grey.withAlpha(20);
        border = Colors.grey.withAlpha(50);
        text = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.borderCircular,
        border: Border.all(color: border),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: text),
      ),
    );
  }

  Widget _buildAbnormalBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.dangerBgLight,
        borderRadius: AppRadius.borderCircular,
        border: Border.all(color: AppColors.dangerBorderLight),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.alertTriangle, size: 10, color: AppColors.danger),
          SizedBox(width: 3),
          Text(
            'Abnormal',
            style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.danger),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow(IconData icon, String text, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return raw;
    }
  }
}
