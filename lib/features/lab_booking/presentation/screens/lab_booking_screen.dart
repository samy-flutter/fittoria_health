import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../injection_container.dart';
import '../cubit/lab_booking_cubit.dart';
import '../cubit/lab_booking_state.dart';
import '../../data/models/lab_booking_model.dart';

class LabBookingScreen extends StatelessWidget {
  const LabBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LabBookingCubit>()..loadBookings(),
      child: const _LabBookingView(),
    );
  }
}

class _LabBookingView extends StatefulWidget {
  const _LabBookingView();

  @override
  State<_LabBookingView> createState() => _LabBookingViewState();
}

class _LabBookingViewState extends State<_LabBookingView> {
  bool _showForm = false;

  void _toggleForm(bool show) {
    setState(() {
      _showForm = show;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.fitOrange.withValues(alpha: 0.15),
                borderRadius: AppRadius.borderLg,
              ),
              child: const Icon(LucideIcons.flaskConical, color: AppColors.fitOrange, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book Lab Tests',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  'Home collection or clinic visit',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: BlocConsumer<LabBookingCubit, LabBookingState>(
        listener: (context, state) {
          if (state is LabBookingLoaded && state.createSuccess) {
            _toggleForm(false);
            context.read<LabBookingCubit>().resetSuccess();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Booking confirmed successfully', style: GoogleFonts.inter()),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LabBookingInitial || state is LabBookingLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.fitOrange));
          }
          if (state is LabBookingError) {
            return Center(child: Text(state.message, style: GoogleFonts.inter(color: Colors.red)));
          }

          if (state is LabBookingLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!_showForm)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.fitOrange,
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderXl),
                        ),
                        onPressed: () => _toggleForm(true),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(LucideIcons.plus, color: Colors.white, size: 16),
                            const SizedBox(width: 8),
                            Text('Book a New Test', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  if (_showForm) _BookingFormWidget(onCancel: () => _toggleForm(false)),
                  const SizedBox(height: 24),
                  Text('My Bookings', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                  const SizedBox(height: 12),
                  if (state.bookings.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text('No bookings yet.', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                      ),
                    )
                  else
                    ...state.bookings.map((b) => _buildBookingCard(b, isDark)),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBookingCard(LabBooking b, bool isDark) {
    Color getStatusColor(String status) {
      switch (status) {
        case 'requested': return Colors.orange;
        case 'confirmed': return Colors.blue;
        case 'collected': return Colors.purple;
        case 'reported': return Colors.green;
        case 'cancelled': return Colors.red;
        default: return Colors.grey;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(b.collectionMode == 'home' ? LucideIcons.home : LucideIcons.building2, size: 14, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  const SizedBox(width: 6),
                  Text(
                    b.collectionMode == 'home' ? 'Home Collection' : 'Clinic Visit',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: getStatusColor(b.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  b.status,
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: getStatusColor(b.status)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: b.testNames.map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(t, style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
            )).toList(),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.calendar, size: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                  const SizedBox(width: 4),
                  Text(
                    '${b.preferredDate.substring(0, 10)}${b.preferredSlot != null ? ' · ${b.preferredSlot}' : ''}',
                    style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                  ),
                ],
              ),
              if (b.totalAmount > 0)
                Text(
                  '₹${b.totalAmount.toInt()}',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.fitOrange),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BookingFormWidget extends StatefulWidget {
  final VoidCallback onCancel;

  const _BookingFormWidget({required this.onCancel});

  @override
  State<_BookingFormWidget> createState() => _BookingFormWidgetState();
}

class _BookingFormWidgetState extends State<_BookingFormWidget> {
  String _mode = 'home';
  final List<String> _selectedTests = [];
  String _date = '';
  String _slot = '';
  String _address = '';
  String _city = '';
  String _pincode = '';

  final List<Map<String, dynamic>> _commonTests = [
    {'name': 'Complete Blood Count (CBC)', 'price': 350},
    {'name': 'Lipid Profile', 'price': 600},
    {'name': 'Blood Sugar (Fasting)', 'price': 150},
    {'name': 'HbA1c (Diabetes)', 'price': 550},
    {'name': 'Thyroid Profile (T3 T4 TSH)', 'price': 650},
    {'name': 'Liver Function Test', 'price': 700},
    {'name': 'Kidney Function Test', 'price': 700},
    {'name': 'Vitamin D', 'price': 1200},
    {'name': 'Vitamin B12', 'price': 900},
    {'name': 'Full Body Checkup', 'price': 1999},
  ];

  final List<String> _slots = ['06:00-08:00', '08:00-10:00', '10:00-12:00', '16:00-18:00', '18:00-20:00'];

  double get _totalAmount {
    double total = 0;
    for (var test in _commonTests) {
      if (_selectedTests.contains(test['name'])) {
        total += (test['price'] as int).toDouble();
      }
    }
    return total;
  }

  void _submit() {
    if (_selectedTests.isEmpty || _date.isEmpty) return;
    if (_mode == 'home' && _address.isEmpty) return;

    context.read<LabBookingCubit>().createBooking(
          collectionMode: _mode,
          testNames: _selectedTests,
          preferredDate: _date,
          preferredSlot: _slot.isEmpty ? null : _slot,
          addressLine: _address,
          city: _city,
          pincode: _pincode,
          totalAmount: _totalAmount,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = context.watch<LabBookingCubit>().state;
    final isCreating = state is LabBookingLoaded && state.isCreating;
    
    final bool isValid = _selectedTests.isNotEmpty && _date.isNotEmpty && (_mode != 'home' || _address.isNotEmpty);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('New Lab Booking', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
              IconButton(
                icon: Icon(LucideIcons.x, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                onPressed: widget.onCancel,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _mode = 'home'),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _mode == 'home' ? AppColors.fitOrange.withValues(alpha: 0.1) : Colors.transparent,
                      borderRadius: AppRadius.borderXl,
                      border: Border.all(color: _mode == 'home' ? AppColors.fitOrange : (isDark ? AppColors.darkBorder : AppColors.lightBorder), width: 2),
                    ),
                    child: Column(
                      children: [
                        Icon(LucideIcons.home, size: 20, color: _mode == 'home' ? AppColors.fitOrange : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                        const SizedBox(height: 4),
                        Text('Home Collection', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: _mode == 'home' ? AppColors.fitOrange : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary))),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _mode = 'clinic'),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _mode == 'clinic' ? AppColors.fitOrange.withValues(alpha: 0.1) : Colors.transparent,
                      borderRadius: AppRadius.borderXl,
                      border: Border.all(color: _mode == 'clinic' ? AppColors.fitOrange : (isDark ? AppColors.darkBorder : AppColors.lightBorder), width: 2),
                    ),
                    child: Column(
                      children: [
                        Icon(LucideIcons.building2, size: 20, color: _mode == 'clinic' ? AppColors.fitOrange : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                        const SizedBox(height: 4),
                        Text('Clinic Visit', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: _mode == 'clinic' ? AppColors.fitOrange : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary))),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Select tests', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
          const SizedBox(height: 8),
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              borderRadius: AppRadius.borderLg,
            ),
            child: ListView.builder(
              itemCount: _commonTests.length,
              itemBuilder: (context, index) {
                final test = _commonTests[index];
                final on = _selectedTests.contains(test['name']);
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (on) {
                        _selectedTests.remove(test['name']);
                      } else {
                        _selectedTests.add(test['name']);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: on ? AppColors.fitOrange.withValues(alpha: 0.1) : Colors.transparent,
                      border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: on ? AppColors.fitOrange : Colors.transparent,
                                border: Border.all(color: on ? AppColors.fitOrange : (isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: on ? const Icon(LucideIcons.check, size: 12, color: Colors.white) : null,
                            ),
                            const SizedBox(width: 8),
                            Text(test['name'], style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                          ],
                        ),
                        Text('₹${test['price']}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                    const SizedBox(height: 4),
                    // Simplistic text field for date in Flutter (ideally use showDatePicker)
                    TextField(
                      onChanged: (val) => setState(() => _date = val),
                      style: GoogleFonts.inter(fontSize: 14, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                      decoration: InputDecoration(
                        hintText: 'YYYY-MM-DD',
                        hintStyle: GoogleFonts.inter(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 14),
                        border: OutlineInputBorder(borderRadius: AppRadius.borderLg, borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                        enabledBorder: OutlineInputBorder(borderRadius: AppRadius.borderLg, borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Slot', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        borderRadius: AppRadius.borderLg,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _slot.isEmpty ? null : _slot,
                          hint: Text('Any time', style: GoogleFonts.inter(fontSize: 14, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                          dropdownColor: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
                          items: _slots.map((s) => DropdownMenuItem(value: s, child: Text(s, style: GoogleFonts.inter(fontSize: 14, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)))).toList(),
                          onChanged: (val) => setState(() => _slot = val ?? ''),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_mode == 'home') ...[
            const SizedBox(height: 16),
            TextField(
              onChanged: (val) => setState(() => _address = val),
              style: GoogleFonts.inter(fontSize: 14, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              decoration: InputDecoration(
                hintText: 'Full address for collection',
                hintStyle: GoogleFonts.inter(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 14),
                border: OutlineInputBorder(borderRadius: AppRadius.borderLg, borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                enabledBorder: OutlineInputBorder(borderRadius: AppRadius.borderLg, borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) => setState(() => _city = val),
                    style: GoogleFonts.inter(fontSize: 14, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                    decoration: InputDecoration(
                      hintText: 'City',
                      hintStyle: GoogleFonts.inter(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 14),
                      border: OutlineInputBorder(borderRadius: AppRadius.borderLg, borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                      enabledBorder: OutlineInputBorder(borderRadius: AppRadius.borderLg, borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onChanged: (val) => setState(() => _pincode = val),
                    style: GoogleFonts.inter(fontSize: 14, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                    decoration: InputDecoration(
                      hintText: 'Pincode',
                      hintStyle: GoogleFonts.inter(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 14),
                      border: OutlineInputBorder(borderRadius: AppRadius.borderLg, borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                      enabledBorder: OutlineInputBorder(borderRadius: AppRadius.borderLg, borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total', style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                  Text('₹${_totalAmount.toInt()}', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.fitOrange)),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.fitOrange,
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.borderXl),
                  disabledBackgroundColor: AppColors.fitOrange.withValues(alpha: 0.5),
                ),
                onPressed: (!isValid || isCreating) ? null : _submit,
                child: isCreating
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.clock, color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Text('Confirm Booking', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
