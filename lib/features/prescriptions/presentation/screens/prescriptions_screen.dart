import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/prescriptions_cubit.dart';
import '../bloc/prescriptions_state.dart';
import '../../data/models/prescription.dart';

class PrescriptionsScreen extends StatefulWidget {
  const PrescriptionsScreen({super.key});

  @override
  State<PrescriptionsScreen> createState() => _PrescriptionsScreenState();
}

class _PrescriptionsScreenState extends State<PrescriptionsScreen> {
  final Set<int> _expandedIds = {};

  @override
  void initState() {
    super.initState();
    context.read<PrescriptionsCubit>().loadPrescriptions();
  }

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
      backgroundColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
      appBar: AppBar(
        title: const Text('My Prescriptions', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        foregroundColor: isDark ? Colors.white : AppColors.lightTextPrimary,
      ),
      body: BlocBuilder<PrescriptionsCubit, PrescriptionsState>(
        builder: (context, state) {
          if (state is PrescriptionsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.lightTeal),
            );
          }

          if (state is PrescriptionsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.danger),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load prescriptions',
                      style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<PrescriptionsCubit>().loadPrescriptions(),
                      style: ElevatedButton.styleFrom(
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

          if (state is PrescriptionsLoaded) {
            final list = state.prescriptions;

            if (list.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.medication_rounded, size: 64, color: isDark ? Colors.white24 : Colors.black26),
                      const SizedBox(height: 16),
                      Text(
                        'No Prescriptions Yet',
                        style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your e-prescriptions will appear here after your clinic consultations.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Auto-expand first prescription by default
            if (_expandedIds.isEmpty && list.isNotEmpty) {
              _expandedIds.add(list.first.id);
            }

            return RefreshIndicator(
              onRefresh: () => context.read<PrescriptionsCubit>().loadPrescriptions(),
              color: AppColors.lightTeal,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final rx = list[index];
                  final isExpanded = _expandedIds.contains(rx.id);
                  return _buildPrescriptionCard(rx, isExpanded, isDark);
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPrescriptionCard(Prescription rx, bool isExpanded, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderLg,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Toggle Area
          InkWell(
            onTap: () => _toggleExpanded(rx.id),
            borderRadius: isExpanded
                ? const BorderRadius.vertical(top: Radius.circular(16))
                : AppRadius.borderLg,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pill Icon Container
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.cTealBg,
                      border: Border.all(color: AppColors.cTealBorder),
                      borderRadius: AppRadius.borderLg,
                    ),
                    child: const Center(
                      child: Icon(Icons.medication_liquid_rounded, color: AppColors.lightTeal, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Doctor & Clinic Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Dr. ${rx.doctorName}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
                                borderRadius: AppRadius.borderCircular,
                              ),
                              child: Text(
                                '${rx.items.length} med${rx.items.length != 1 ? 's' : ''}',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        // Clinic Details
                        Row(
                          children: [
                            const Icon(Icons.business_rounded, size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                rx.clinicName,
                                style: const TextStyle(fontSize: 11.5, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.calendar_today_rounded, size: 11, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(rx.createdAt),
                              style: const TextStyle(fontSize: 11.5, color: Colors.grey),
                            ),
                          ],
                        ),
                        if (rx.diagnosis != null && rx.diagnosis!.trim().isNotEmpty) ...[
                          const SizedBox(height: 6),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 11.5,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'Dx: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: rx.diagnosis),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),

          // Expanded Content
          if (isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (rx.items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Center(
                        child: Text(
                          'No medicines in this prescription.',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    )
                  else
                    ...rx.items.map((item) => _buildMedicineRow(item, isDark)),

                  if (rx.notes != null && rx.notes!.trim().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.cBlueBg,
                        border: Border.all(color: AppColors.cBlueBorder),
                        borderRadius: AppRadius.borderMd,
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 11.5, color: AppColors.cBlue, height: 1.4),
                          children: [
                            const TextSpan(text: 'Note: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: rx.notes),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Print function triggered')),
                          );
                        },
                        icon: const Icon(Icons.print_rounded, size: 14),
                        label: const Text('Print'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? Colors.white : AppColors.lightTextPrimary,
                          side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Share function triggered')),
                          );
                        },
                        icon: const Icon(Icons.share_rounded, size: 14),
                        label: const Text('Share'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? Colors.white : AppColors.lightTextPrimary,
                          side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
                        ),
                      ),
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

  Widget _buildMedicineRow(PrescriptionItem item, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        borderRadius: AppRadius.borderMd,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.cTealBg,
              borderRadius: AppRadius.borderMd,
            ),
            child: const Center(
              child: Icon(Icons.medical_services_rounded, color: AppColors.lightTeal, size: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.drugName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                if (item.brandName != null && item.brandName!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.brandName!,
                    style: const TextStyle(fontSize: 10.5, color: Colors.grey),
                  ),
                ],
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    if (item.dosage != null && item.dosage!.isNotEmpty)
                      _buildChip(Icons.monitor_heart_rounded, item.dosage!, isDark),
                    if (item.frequency != null && item.frequency!.isNotEmpty)
                      _buildChip(Icons.access_time_rounded, item.frequency!, isDark),
                    if (item.duration != null && item.duration!.isNotEmpty)
                      _buildChip(Icons.calendar_today_rounded, item.duration!, isDark),
                    if (item.route != null && item.route!.isNotEmpty)
                      _buildChip(null, item.route!, isDark),
                  ],
                ),
                if (item.instructions != null && item.instructions!.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    '“${item.instructions}”',
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
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

  Widget _buildChip(IconData? icon, String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        borderRadius: AppRadius.borderCircular,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: Colors.grey),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
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
