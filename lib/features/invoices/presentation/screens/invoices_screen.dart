import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/invoices_cubit.dart';
import '../bloc/invoices_state.dart';
import '../../data/models/invoice.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<InvoicesCubit>().loadInvoices();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
      appBar: AppBar(
        title: const Text('My Invoices', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        foregroundColor: isDark ? Colors.white : AppColors.lightTextPrimary,
      ),
      body: BlocListener<InvoicesCubit, InvoicesState>(
        listener: (context, state) {
          if (state is InvoicesLoaded) {
            if (state.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.successMessage!),
                  backgroundColor: AppColors.success,
                ),
              );
              context.read<InvoicesCubit>().clearMessages();
            }
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: AppColors.danger,
                ),
              );
              context.read<InvoicesCubit>().clearMessages();
            }
          }
        },
        child: BlocBuilder<InvoicesCubit, InvoicesState>(
          builder: (context, state) {
            if (state is InvoicesLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.lightTeal),
              );
            }

            if (state is InvoicesError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.danger),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load invoices',
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
                        onPressed: () => context.read<InvoicesCubit>().loadInvoices(),
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

            if (state is InvoicesLoaded) {
              final list = state.invoices;

              if (list.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long_rounded, size: 64, color: isDark ? Colors.white24 : Colors.black26),
                        const SizedBox(height: 16),
                        Text(
                          'No Invoices Yet',
                          style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Invoices will appear here after your clinic consultations.',
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

              // Compute KPIs
              final double total = list.fold<double>(0.0, (sum, i) => sum + i.totalAmount);
              final double paid = list
                  .where((i) => i.paymentStatus.toLowerCase() == 'paid')
                  .fold<double>(0.0, (sum, i) => sum + i.totalAmount);
              final double pending = list
                  .where((i) => i.paymentStatus.toLowerCase() == 'pending')
                  .fold<double>(0.0, (sum, i) => sum + i.totalAmount);

              return RefreshIndicator(
                onRefresh: () => context.read<InvoicesCubit>().loadInvoices(),
                color: AppColors.lightTeal,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  children: [
                    // KPI Grid
                    _buildKpiGrid(total, paid, pending, isDark),
                    const SizedBox(height: 20),

                    // Title
                    Text(
                      'All Invoices',
                      style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    // Invoices list
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final inv = list[index];
                        final isPdfLoading = state.pdfLoadingId == inv.id;
                        return _buildInvoiceCard(inv, isPdfLoading, isDark);
                      },
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildKpiGrid(double total, double paid, double pending, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildKpiCard(
            'Total Billed',
            '₹${total.toStringAsFixed(0)}',
            Icons.account_balance_wallet_rounded,
            isDark ? Colors.white : AppColors.lightTextPrimary,
            isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
            isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildKpiCard(
            'Paid',
            '₹${paid.toStringAsFixed(0)}',
            Icons.check_circle_outline_rounded,
            AppColors.success,
            AppColors.cGreenBg,
            AppColors.cGreenBorder,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildKpiCard(
            'Pending',
            '₹${pending.toStringAsFixed(0)}',
            Icons.hourglass_empty_rounded,
            AppColors.warning,
            AppColors.cAmberBg,
            AppColors.cAmberBorder,
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCard(
    String label,
    String value,
    IconData icon,
    Color color,
    Color bg,
    Color border,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: AppRadius.borderMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceCard(PatientInvoice inv, bool isPdfLoading, bool isDark) {
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
          // Header content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.cAmberBg,
                    border: Border.all(color: AppColors.cAmberBorder),
                    borderRadius: AppRadius.borderLg,
                  ),
                  child: const Center(
                    child: Icon(Icons.receipt_rounded, color: AppColors.warning, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                // Invoice Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            inv.invoiceNo,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildStatusBadge(inv.paymentStatus),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Clinic
                      Row(
                        children: [
                          const Icon(Icons.business_rounded, size: 12, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              inv.clinicName,
                              style: const TextStyle(fontSize: 11.5, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Cost & Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${inv.totalAmount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(inv.createdAt),
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Footer / download actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${inv.itemsCount} item${inv.itemsCount != 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 32,
                  child: ElevatedButton.icon(
                    onPressed: isPdfLoading ? null : () => context.read<InvoicesCubit>().downloadPdf(inv.id),
                    icon: isPdfLoading
                        ? const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.download_rounded, size: 14),
                    label: Text(isPdfLoading ? 'Loading...' : 'PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppColors.darkTeal : AppColors.lightTeal,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      textStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color border;
    Color text;
    String label = status.toUpperCase();

    switch (status.toLowerCase()) {
      case 'paid':
        bg = AppColors.cGreenBg;
        border = AppColors.cGreenBorder;
        text = AppColors.success;
        label = 'Paid';
        break;
      case 'pending':
        bg = AppColors.cAmberBg;
        border = AppColors.cAmberBorder;
        text = AppColors.warning;
        label = 'Pending';
        break;
      case 'partial':
        bg = AppColors.cBlueBg;
        border = AppColors.cBlueBorder;
        text = AppColors.cBlue;
        label = 'Partial';
        break;
      case 'cancelled':
        bg = AppColors.cRedBg;
        border = AppColors.cRedBorder;
        text = AppColors.danger;
        label = 'Cancelled';
        break;
      default:
        bg = AppColors.cGreyBg;
        border = AppColors.cGreyBorder;
        text = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: AppRadius.borderCircular,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.bold,
          color: text,
        ),
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
