import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/route_names.dart';
import '../../../../injection_container.dart';
import '../bloc/lab_referrals_bloc.dart';
import '../bloc/lab_referrals_event.dart';
import '../bloc/lab_referrals_state.dart';
import '../../data/models/lab_referral.dart';
import '../../../../core/widgets/custom_app_bar.dart';

final Map<String, int> _statusSteps = {
  'pending_lab': 1,
  'lab_responded': 2,
  'confirmed': 3,
  'sample_collected': 4,
  'processing': 5,
  'completed': 6,
  'cancelled': 0,
};

final Map<String, String> _statusLabels = {
  'pending_lab': 'Waiting for Lab',
  'lab_responded': 'Lab Responded',
  'confirmed': 'Confirmed',
  'sample_collected': 'Sample Collected',
  'processing': 'Processing',
  'completed': 'Report Ready',
  'cancelled': 'Cancelled',
};

class LabReferralsScreen extends StatelessWidget {
  const LabReferralsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LabReferralsBloc>(
      create: (_) => sl<LabReferralsBloc>()..add(const LoadLabReferrals()),
      child: const _LabReferralsBody(),
    );
  }
}

class _LabReferralsBody extends StatefulWidget {
  const _LabReferralsBody();

  @override
  State<_LabReferralsBody> createState() => _LabReferralsBodyState();
}

class _LabReferralsBodyState extends State<_LabReferralsBody> {
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
            Row(
              children: [
                Icon(LucideIcons.flaskConical, size: 18, color: isDark ? AppColors.darkTeal : AppColors.lightTeal),
                const SizedBox(width: 6),
                Text(
                  'Lab Referrals',
                  style: AppTextStyles.h3.copyWith(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              'Track your diagnostic test referrals',
              style: AppTextStyles.bodySmall.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: BlocConsumer<LabReferralsBloc, LabReferralsState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(LucideIcons.alertCircle, color: AppColors.danger, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.errorMessage!)),
                  ],
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(LucideIcons.checkCircle2, color: AppColors.success, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.successMessage!)),
                  ],
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.referrals.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.lightTeal),
            );
          }

          if (state.referrals.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.flaskConical, size: 48, color: (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted).withAlpha(128)),
                    const SizedBox(height: 16),
                    Text(
                      'No lab referrals yet',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Auto-expand the first referral if user hasn't selected any yet
          if (_expandedIds.isEmpty && state.referrals.isNotEmpty) {
            _expandedIds.add(state.referrals.first.id);
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<LabReferralsBloc>().add(const LoadLabReferrals());
            },
            color: AppColors.lightTeal,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.notifications.isNotEmpty) ...[
                    _buildNotificationsSection(state.notifications, isDark),
                    const SizedBox(height: 20),
                  ],
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.referrals.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, idx) {
                      final r = state.referrals[idx];
                      final isExpanded = _expandedIds.contains(r.id);
                      return _buildReferralCard(context, r, isExpanded, state.isActing, isDark);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationsSection(List<LabReferralNotification> notifications, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(LucideIcons.bell,
                size: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
            const SizedBox(width: 6),
            Text(
              'RECENT UPDATES',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...notifications.take(5).map((n) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkTealLight : AppColors.lightTealLight,
              borderRadius: AppRadius.borderLg,
              border: Border.all(
                color: isDark ? AppColors.darkTealBorder : AppColors.lightTealBorder,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  LucideIcons.bell,
                  size: 16,
                  color: isDark ? AppColors.darkTeal : AppColors.lightTeal,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        n.title,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        n.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDatetime(n.createdAt),
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildReferralCard(
    BuildContext context,
    LabReferral referral,
    bool isExpanded,
    bool isActing,
    bool isDark,
  ) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header Button
          InkWell(
            onTap: () => _toggleExpanded(referral.id),
            borderRadius: isExpanded
                ? const BorderRadius.vertical(top: Radius.circular(16))
                : AppRadius.borderLg,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              referral.testName,
                              style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Dr. ${referral.doctorName} · ${referral.clinicName}',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildServiceBadge(referral.serviceMode, isDark),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildProgressBar(referral.status, isDark),
                ],
              ),
            ),
          ),

          // In-card confirm actions (if lab has responded, quick confirm is shown)
          if (referral.status == 'lab_responded')
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  FilledButton.icon(
                    onPressed: isActing
                        ? null
                        : () => context
                            .read<LabReferralsBloc>()
                            .add(ConfirmReferralBooking(referral.id)),
                    icon: isActing
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(LucideIcons.checkCircle2, size: 14),
                    label: const Text('Confirm Booking', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    style: FilledButton.styleFrom(
                      backgroundColor: isDark ? AppColors.darkTeal : AppColors.lightTeal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('or', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      context.push(RouteNames.patientLabReferralDetails(referral.id));
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: isDark ? AppColors.darkTeal : AppColors.lightTeal,
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('View Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        SizedBox(width: 4),
                        Icon(LucideIcons.chevronRight, size: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Expanded Content
          if (isExpanded) ...[
            Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // View Details Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        context.push(RouteNames.patientLabReferralDetails(referral.id));
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark ? AppColors.darkTeal : AppColors.lightTeal,
                        backgroundColor: isDark ? AppColors.darkTealLight : AppColors.lightTealLight,
                        side: BorderSide(color: isDark ? AppColors.darkTealBorder : AppColors.lightTealBorder),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('View Full Details', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          Icon(LucideIcons.chevronRight, size: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Clinical instructions
                  if (referral.description != null && referral.description!.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBgMuted : AppColors.lightBgMuted,
                        borderRadius: AppRadius.borderMd,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Clinical Instructions',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            referral.description!,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Quoted price and Slot date (grid)
                  if (referral.quotedPrice != null || referral.slotDatetime != null) ...[
                    Row(
                      children: [
                        if (referral.quotedPrice != null)
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.successBgLight,
                                border: Border.all(color: AppColors.successBorderLight),
                                borderRadius: AppRadius.borderMd,
                              ),
                              child: Column(
                                children: [
                                  const Icon(LucideIcons.indianRupee, size: 16, color: AppColors.success),
                                  const SizedBox(height: 4),
                                  Text(
                                    '₹${referral.quotedPrice!.toStringAsFixed(0)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.success),
                                  ),
                                  const Text('Test Price', style: TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        if (referral.quotedPrice != null && referral.slotDatetime != null)
                          const SizedBox(width: 12),
                        if (referral.slotDatetime != null)
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.cBlueBg,
                                border: Border.all(color: AppColors.cBlueBorder),
                                borderRadius: AppRadius.borderMd,
                              ),
                              child: Column(
                                children: [
                                  const Icon(LucideIcons.calendarDays, size: 16, color: AppColors.cBlue),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatDateOnly(referral.slotDatetime!),
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.cBlue),
                                  ),
                                  Text(_formatTimeOnly(referral.slotDatetime!), style: TextStyle(fontSize: 10, color: AppColors.cBlue.withAlpha(180), fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                  
                  if (referral.slotNotes != null && referral.slotNotes!.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBgMuted : AppColors.lightBgMuted,
                        borderRadius: AppRadius.borderMd,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(LucideIcons.clock, size: 14, color: isDark ? AppColors.darkTeal : AppColors.lightTeal),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              referral.slotNotes!,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  
                  if (referral.serviceMode == 'home_collection' && referral.collectionAddress != null) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(LucideIcons.home, size: 14, color: AppColors.cPurple),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Collection at: ${[referral.collectionAddress, referral.collectionCity].where((e) => e != null && e.isNotEmpty).join(', ')}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Lab details card
                  if (referral.labName != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBgMuted : AppColors.lightBgMuted,
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        borderRadius: AppRadius.borderMd,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(LucideIcons.flaskConical, size: 14, color: isDark ? AppColors.darkTeal : AppColors.lightTeal),
                              const SizedBox(width: 6),
                              Text(
                                referral.labName!,
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                              ),
                            ],
                          ),
                          if (referral.labAddress != null) ...[
                            const SizedBox(height: 6),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(LucideIcons.mapPin, size: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    '${referral.labAddress!}, ${referral.labCity ?? ""}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (referral.labPhone != null) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(LucideIcons.phone, size: 12, color: isDark ? AppColors.darkTeal : AppColors.lightTeal),
                                const SizedBox(width: 6),
                                Text(
                                  referral.labPhone!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? AppColors.darkTeal : AppColors.lightTeal,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  if (referral.reportUrl != null) ...[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {/* url_launcher: launchUrl */},
                        icon: const Icon(LucideIcons.externalLink, size: 16),
                        label: const Text('View Report', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        style: FilledButton.styleFrom(
                          backgroundColor: isDark ? AppColors.darkTeal : AppColors.lightTeal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
                        ),
                      ),
                    ),
                  ] else if (referral.status == 'completed') ...[
                    Row(
                      children: [
                        const Icon(LucideIcons.checkCircle2, size: 16, color: AppColors.success),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Test completed. Contact the lab for your report.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildProgressBar(String status, bool isDark) {
    if (status == 'cancelled') {
      return Row(
        children: [
          Expanded(
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.dangerBgLight,
                borderRadius: AppRadius.borderCircular,
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    borderRadius: AppRadius.borderCircular,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Cancelled',
            style: TextStyle(color: AppColors.danger, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }

    final currentStep = _statusSteps[status] ?? 1;
    final totalSteps = 6;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            final active = index < currentStep;
            return Expanded(
              child: Container(
                height: 6,
                margin: EdgeInsets.only(right: index < totalSteps - 1 ? 4.0 : 0.0),
                decoration: BoxDecoration(
                  color: active
                      ? (isDark ? AppColors.darkTeal : AppColors.lightTeal)
                      : (isDark ? AppColors.darkBgMuted : AppColors.lightBgMuted),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 0.5),
                  borderRadius: AppRadius.borderCircular,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Text(
          'Step $currentStep/$totalSteps — ${_statusLabels[status] ?? status}',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceBadge(String mode, bool isDark) {
    final home = mode == 'home_collection';
    final label = home ? 'Home' : 'Walk-in';
    final icon = home ? LucideIcons.home : LucideIcons.mapPin;
    final bg = home ? AppColors.cPurpleBg : AppColors.cBlueBg;
    final border = home ? AppColors.cPurpleBorder : AppColors.cBlueBorder;
    final color = home ? AppColors.cPurple : AppColors.cBlue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDatetime(String raw) {
    try {
      final dt = DateTime.parse(raw);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final min = dt.minute.toString().padLeft(2, '0');
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return '${dt.day} ${months[dt.month - 1]}, $hour:$min $ampm';
    } catch (_) {
      return raw;
    }
  }

  String _formatDateOnly(String raw) {
    try {
      final dt = DateTime.parse(raw);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${dt.day} ${months[dt.month - 1]}';
    } catch (_) {
      return raw.substring(0, 10);
    }
  }

  String _formatTimeOnly(String raw) {
    try {
      final dt = DateTime.parse(raw);
      final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final min = dt.minute.toString().padLeft(2, '0');
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$min $ampm';
    } catch (_) {
      return raw;
    }
  }
}
