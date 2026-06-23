import '../../../../core/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../injection_container.dart';
import '../bloc/lab_referrals_bloc.dart';
import '../bloc/lab_referrals_event.dart';
import '../bloc/lab_referrals_state.dart';
import '../../data/models/lab_referral.dart';
import '../../../../core/widgets/custom_app_bar.dart';

final List<Map<String, String>> _statusSteps = [
  {'key': 'pending_lab', 'label': 'Requested'},
  {'key': 'lab_responded', 'label': 'Lab Responded'},
  {'key': 'confirmed', 'label': 'Confirmed'},
  {'key': 'sample_collected', 'label': 'Sample Collected'},
  {'key': 'processing', 'label': 'Processing'},
  {'key': 'completed', 'label': 'Report Ready'},
];

final Map<String, String> _statusLabels = {
  'pending_lab': 'Waiting for Lab',
  'lab_responded': 'Lab Has Responded',
  'confirmed': 'Booking Confirmed',
  'sample_collected': 'Sample Collected',
  'processing': 'Processing',
  'completed': 'Report Ready',
  'cancelled': 'Cancelled',
};

final Map<String, Color> _statusColors = {
  'pending_lab': Colors.orange,
  'lab_responded': Colors.lightBlue,
  'confirmed': Colors.green,
  'sample_collected': Colors.purple,
  'processing': Colors.lightBlue,
  'completed': Colors.green,
  'cancelled': Colors.red,
};

class LabReferralDetailsScreen extends StatelessWidget {
  final int referralId;

  const LabReferralDetailsScreen({
    super.key,
    required this.referralId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LabReferralsBloc>(
      create: (_) => sl<LabReferralsBloc>()..add(LoadLabReferralDetails(referralId)),
      child: _LabReferralDetailsBody(referralId: referralId),
    );
  }
}

class _LabReferralDetailsBody extends StatelessWidget {
  final int referralId;

  const _LabReferralDetailsBody({required this.referralId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Referral Details',
          style: AppTextStyles.h3.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocConsumer<LabReferralsBloc, LabReferralsState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            UIHelpers.showErrorSnackBar(context, state.errorMessage!);
}
          if (state.successMessage != null) {
            UIHelpers.showSuccessSnackBar(context, state.successMessage!);
}
        },
        builder: (context, state) {
          if (state.isLoading && state.selectedReferral == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.lightTeal),
            );
          }

          final r = state.selectedReferral;
          if (r == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.danger),
                    const SizedBox(height: 16),
                    const Text('Referral Not Found', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text('Go back'),
                    ),
                  ],
                ),
              ),
            );
          }

          final canConfirm = r.status == 'lab_responded';
          final canCancel = ['pending_lab', 'lab_responded', 'confirmed'].contains(r.status);

          return RefreshIndicator(
            onRefresh: () async {
              context.read<LabReferralsBloc>().add(LoadLabReferralDetails(referralId));
            },
            color: AppColors.lightTeal,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and service badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r.testName,
                              style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Referred on ${_formatDate(r.createdAt)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildServiceBadge(r.serviceMode),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Progress Stepper Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBgSurface : Colors.white,
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      borderRadius: AppRadius.borderLg,
                    ),
                    child: _buildProgressStepper(r.status, isDark),
                  ),
                  const SizedBox(height: 16),

                  // Action Buttons card
                  if (canConfirm || canCancel) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBgSurface : Colors.white,
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        borderRadius: AppRadius.borderLg,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'YOUR ACTIONS',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              if (canConfirm)
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: state.isActing
                                        ? null
                                        : () => _showConfirmDialog(context, 'confirm', isDark),
                                    icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
                                    label: const Text('Confirm Booking', style: TextStyle(fontWeight: FontWeight.bold)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isDark ? AppColors.darkTeal : AppColors.lightTeal,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
                                    ),
                                  ),
                                ),
                              if (canConfirm && canCancel) const SizedBox(width: 12),
                              if (canCancel)
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: state.isActing
                                        ? null
                                        : () => _showConfirmDialog(context, 'cancel', isDark),
                                    icon: const Icon(Icons.cancel_outlined, size: 16),
                                    label: const Text('Cancel Referral', style: TextStyle(fontWeight: FontWeight.bold)),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.danger,
                                      side: const BorderSide(color: AppColors.dangerBorderLight),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (canConfirm) ...[
                            const SizedBox(height: 10),
                            Text(
                              'The lab has proposed a price and slot. Please confirm to book the appointment.',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Price and proposed date slot
                  if (r.quotedPrice != null || r.slotDatetime != null) ...[
                    Row(
                      children: [
                        if (r.quotedPrice != null)
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.successBgLight,
                                border: Border.all(color: AppColors.successBorderLight),
                                borderRadius: AppRadius.borderLg,
                              ),
                              child: Column(
                                children: [
                                  const Icon(Icons.currency_rupee_rounded, size: 24, color: AppColors.success),
                                  const SizedBox(height: 6),
                                  Text(
                                    '₹${r.quotedPrice!.toStringAsFixed(0)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: AppColors.success),
                                  ),
                                  const Text('Quoted Price', style: TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        if (r.quotedPrice != null && r.slotDatetime != null)
                          const SizedBox(width: 12),
                        if (r.slotDatetime != null)
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.cBlueBg,
                                border: Border.all(color: AppColors.cBlueBorder),
                                borderRadius: AppRadius.borderLg,
                              ),
                              child: Column(
                                children: [
                                  const Icon(Icons.calendar_today_rounded, size: 24, color: AppColors.cBlue),
                                  const SizedBox(height: 6),
                                  Text(
                                    _formatDateOnly(r.slotDatetime!),
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.cBlue),
                                  ),
                                  Text(
                                    _formatTimeOnly(r.slotDatetime!),
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.cBlue),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text('Slot Datetime', style: TextStyle(fontSize: 11, color: AppColors.cBlue, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Slot notes instructions
                  if (r.slotNotes != null && r.slotNotes!.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBgSurface : Colors.white,
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        borderRadius: AppRadius.borderLg,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline_rounded,
                              size: 18, color: isDark ? AppColors.darkTeal : AppColors.lightTeal),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Instructions from Lab',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  r.slotNotes!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Clinical instructions
                  if (r.description != null && r.description!.isNotEmpty) ...[
                    _buildSectionHeader('CLINICAL INSTRUCTIONS', isDark),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBgSurface : Colors.white,
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        borderRadius: AppRadius.borderLg,
                      ),
                      child: Text(
                        r.description!,
                        style: TextStyle(
                          fontSize: 13.5,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Home collection address
                  if (r.serviceMode == 'home_collection' && r.collectionAddress != null) ...[
                    _buildSectionHeader('HOME COLLECTION ADDRESS', isDark),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBgSurface : Colors.white,
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        borderRadius: AppRadius.borderLg,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.home_filled, size: 18, color: AppColors.cPurple),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Collection Address',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  [r.collectionAddress, r.collectionCity, r.collectionPincode]
                                      .where((s) => s != null && s.isNotEmpty)
                                      .join(', '),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Lab details card
                  if (r.labName != null) ...[
                    _buildSectionHeader('LAB DETAILS', isDark),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBgSurface : Colors.white,
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        borderRadius: AppRadius.borderLg,
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
                                  color: isDark ? AppColors.darkTealLight : AppColors.lightTealLight,
                                  borderRadius: AppRadius.borderMd,
                                ),
                                child: Icon(Icons.science_rounded,
                                    color: isDark ? AppColors.darkTeal : AppColors.lightTeal, size: 18),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      r.labName!,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        if (r.nablAccredited == 1) ...[
                                          _buildTag('NABL Accredited', AppColors.cBlueBg, AppColors.cBlue),
                                          const SizedBox(width: 6),
                                        ],
                                        if (r.isoCertified == 1)
                                          _buildTag('ISO Certified', AppColors.successBgLight, AppColors.success),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(height: 1),
                          const SizedBox(height: 12),
                          if (r.labAddress != null)
                            _buildInfoRow(Icons.location_on_outlined, [r.labAddress, r.labCity].where((s) => s != null).join(', '), isDark),
                          if (r.labPhone != null) ...[
                            const SizedBox(height: 10),
                            _buildLinkRow(Icons.phone_outlined, r.labPhone!, 'tel:${r.labPhone}', isDark),
                          ],
                          if (r.labEmail != null) ...[
                            const SizedBox(height: 10),
                            _buildLinkRow(Icons.mail_outline_rounded, r.labEmail!, 'mailto:${r.labEmail}', isDark),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Referring doctor
                  _buildSectionHeader('REFERRED BY', isDark),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBgSurface : Colors.white,
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      borderRadius: AppRadius.borderLg,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: AppColors.cPurpleBg,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person_rounded, color: AppColors.cPurple, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dr. ${r.doctorName}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                r.clinicName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (r.clinicPhone != null)
                          IconButton(
                            onPressed: () => launchUrl(Uri.parse('tel:${r.clinicPhone}')),
                            icon: Icon(Icons.phone_outlined,
                                color: isDark ? AppColors.darkTeal : AppColors.lightTeal, size: 20),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Report viewer action
                  if (r.reportUrl != null) ...[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => launchUrl(Uri.parse(r.reportUrl!)),
                        icon: const Icon(Icons.open_in_new_rounded, size: 16),
                        label: const Text('View Your Report', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                        style: FilledButton.styleFrom(
                          backgroundColor: isDark ? AppColors.darkTeal : AppColors.lightTeal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (r.status == 'completed' && r.reportUrl == null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.successBgLight,
                        border: Border.all(color: AppColors.successBorderLight),
                        borderRadius: AppRadius.borderMd,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, color: AppColors.success, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Test completed. Contact the lab for your report.',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : AppColors.success,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Result notes
                  if (r.resultNotes != null && r.resultNotes!.isNotEmpty) ...[
                    _buildSectionHeader('RESULT NOTES', isDark),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBgSurface : Colors.white,
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        borderRadius: AppRadius.borderLg,
                      ),
                      child: Text(
                        r.resultNotes!,
                        style: TextStyle(
                          fontSize: 13.5,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Timeline / Notifications
                  if (state.notifications.isNotEmpty) ...[
                    _buildSectionHeader('ACTIVITY TIMELINE', isDark),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBgSurface : Colors.white,
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        borderRadius: AppRadius.borderLg,
                      ),
                      child: _buildTimeline(state.notifications, isDark),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeline(List<LabReferralNotification> notifications, bool isDark) {
    return Column(
      children: List.generate(notifications.length, (idx) {
        final n = notifications[idx];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkTealLight : AppColors.lightTealLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: isDark ? AppColors.darkTealBorder : AppColors.lightTealBorder, width: 1.5),
                  ),
                  child: Icon(Icons.notifications_none_rounded,
                      size: 11, color: isDark ? AppColors.darkTeal : AppColors.lightTeal),
                ),
                if (idx < notifications.length - 1)
                  Container(
                    width: 1.5,
                    height: 36,
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    n.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    n.body,
                    style: TextStyle(
                      fontSize: 11.5,
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
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildProgressStepper(String status, bool isDark) {
    if (status == 'cancelled') {
      return Row(
        children: [
          const Icon(Icons.cancel_outlined, color: AppColors.danger, size: 20),
          const SizedBox(width: 12),
          Text(
            'This referral has been cancelled.',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : AppColors.danger),
          ),
        ],
      );
    }

    final currentIdx = _statusSteps.indexWhere((s) => s['key'] == status);
    final statusColor = _statusColors[status] ?? Colors.grey;

    return Column(
      children: [
        // Grid progress line
        Row(
          children: List.generate(_statusSteps.length, (idx) {
            final active = idx <= currentIdx;
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: idx < _statusSteps.length - 1 ? 4.0 : 0.0),
                decoration: BoxDecoration(
                  color: active
                      ? (isDark ? AppColors.darkTeal : AppColors.lightTeal)
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  borderRadius: AppRadius.borderCircular,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        // Step bubble indices row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_statusSteps.length, (idx) {
            final isDone = idx < currentIdx;
            final isCurrent = idx == currentIdx;

            Color bg, contentColor;
            if (isDone || isCurrent) {
              bg = isDark ? AppColors.darkTeal : AppColors.lightTeal;
              contentColor = Colors.white;
            } else {
              bg = isDark ? AppColors.darkBgBase : AppColors.lightBgBase;
              contentColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
            }

            return Column(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: bg,
                    shape: BoxShape.circle,
                    border: isCurrent
                        ? Border.all(color: Colors.white, width: 1.5)
                        : null,
                    boxShadow: isCurrent
                        ? [BoxShadow(color: bg.withAlpha(80), blurRadius: 4, spreadRadius: 1)]
                        : null,
                  ),
                  child: Center(
                    child: isDone
                        ? const Icon(Icons.check_rounded, size: 12, color: Colors.white)
                        : Text(
                            '${idx + 1}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: contentColor,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _statusSteps[idx]['label']!,
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isCurrent
                        ? (isDark ? AppColors.darkTeal : AppColors.lightTeal)
                        : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                  ),
                ),
              ],
            );
          }),
        ),
        const SizedBox(height: 16),
        const Divider(height: 1),
        const SizedBox(height: 12),
        Text(
          _statusLabels[status] ?? status,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.5,
            color: statusColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
        ),
      ),
    );
  }

  Widget _buildServiceBadge(String mode) {
    final home = mode == 'home_collection';
    final label = home ? 'Home Collection' : 'Walk-in';
    final icon = home ? Icons.home_filled : Icons.location_on_rounded;
    final bg = home ? AppColors.cPurpleBg : AppColors.cBlueBg;
    final border = home ? AppColors.cPurpleBorder : AppColors.cBlueBorder;
    final color = home ? AppColors.cPurple : AppColors.cBlue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.borderCircular,
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color bg, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.borderSm,
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12.5, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildLinkRow(IconData icon, String text, String scheme, bool isDark) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(scheme)),
      child: Row(
        children: [
          Icon(icon, size: 15, color: isDark ? AppColors.darkTeal : AppColors.lightTeal),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.5,
              color: isDark ? AppColors.darkTeal : AppColors.lightTeal,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(BuildContext context, String mode, bool isDark) {
    final bloc = context.read<LabReferralsBloc>();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
          title: Text(
            mode == 'confirm' ? 'Confirm Booking?' : 'Cancel Referral?',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            mode == 'confirm'
                ? 'This will confirm your lab test booking. The lab will be notified.'
                : 'This will cancel your lab test referral. This cannot be undone.',
            style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Go Back',
                style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                if (mode == 'confirm') {
                  bloc.add(ConfirmReferralBooking(referralId));
                } else {
                  bloc.add(CancelReferralBooking(referralId));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: mode == 'confirm' ? (isDark ? AppColors.darkTeal : AppColors.lightTeal) : AppColors.danger,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
              ),
              child: Text(mode == 'confirm' ? 'Yes, Confirm' : 'Yes, Cancel'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      final months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
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
      return raw;
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

  String _formatDatetime(String raw) {
    try {
      final dt = DateTime.parse(raw);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final min = dt.minute.toString().padLeft(2, '0');
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return '${dt.day} ${months[dt.month - 1]} · $hour:$min $ampm';
    } catch (_) {
      return raw;
    }
  }
}
