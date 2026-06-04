import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../routes/route_names.dart';
import '../../../../injection_container.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';

const List<String> _timeSlots = [
  '08:00', '08:30', '09:00', '09:30', '10:00', '10:30',
  '11:00', '11:30', '12:00', '14:00', '14:30', '15:00',
  '15:30', '16:00', '16:30', '17:00', '17:30', '18:00',
];

class BookingScreen extends StatelessWidget {
  final String? initialClinicId;

  const BookingScreen({super.key, this.initialClinicId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingBloc>(
      create: (_) => sl<BookingBloc>()..add(InitBooking(initialClinicId: initialClinicId)),
      child: const _BookingBody(),
    );
  }
}

class _BookingBody extends StatefulWidget {
  const _BookingBody();

  @override
  State<_BookingBody> createState() => _BookingBodyState();
}

class _BookingBodyState extends State<_BookingBody> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final initialStep = context.read<BookingBloc>().state.step;
    // initialStep is 1 or 2
    final initialPage = (initialStep > 0 && initialStep <= 4) ? initialStep - 1 : 0;
    _pageController = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
          icon: Icon(LucideIcons.chevronLeft,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Book Appointment',
          style: AppTextStyles.h3.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocConsumer<BookingBloc, BookingState>(
        listenWhen: (previous, current) => previous.step != current.step || previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.errorMessage != null) {
            UIHelpers.showErrorSnackBar(context, state.errorMessage!);
          }
          if (state.step <= 4 && _pageController.hasClients) {
            final targetPage = state.step - 1;
            if (_pageController.page?.round() != targetPage) {
              _pageController.animateToPage(
                targetPage,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          }
        },
        builder: (context, state) {
          if (state.step == 5 && state.bookedResult != null) {
            return _buildSuccessScreen(context, state, isDark);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Step ${state.step} of 4 — confirm your slot.',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildStepper(context, state, isDark),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(), // Controlled by Bloc
                  children: [
                    _buildStepWrapper(context, state, isDark, _buildClinicStep(context, state, isDark)),
                    _buildStepWrapper(context, state, isDark, _buildDoctorStep(context, state, isDark)),
                    _buildStepWrapper(context, state, isDark, _buildScheduleStep(context, state, isDark)),
                    _buildStepWrapper(context, state, isDark, _buildConfirmStep(context, state, isDark)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStepWrapper(BuildContext context, BookingState state, bool isDark, Widget child) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
          borderRadius: AppRadius.borderXl,
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: child,
      ),
    );
  }

  Widget _buildStepper(BuildContext context, BookingState state, bool isDark) {
    final steps = [
      (id: 1, label: 'Clinic', icon: LucideIcons.building2),
      (id: 2, label: 'Doctor', icon: LucideIcons.stethoscope),
      (id: 3, label: 'Schedule', icon: LucideIcons.calendarDays),
      (id: 4, label: 'Confirm', icon: LucideIcons.checkCircle2),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: List.generate(steps.length, (index) {
          final s = steps[index];
          final active = s.id == state.step;
          final done = s.id < state.step;

          Color bg, border, contentColor;
          if (active) {
            bg = isDark ? AppColors.darkTealLight : AppColors.lightTealLight;
            border = isDark ? AppColors.darkTealBorder : AppColors.lightTealBorder;
            contentColor = isDark ? AppColors.darkTeal : AppColors.lightTeal;
          } else if (done) {
            bg = AppColors.successBgLight;
            border = AppColors.successBorderLight;
            contentColor = AppColors.success;
          } else {
            bg = isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface;
            border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
            contentColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
          }

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: done ? () => context.read<BookingBloc>().add(GoToStep(s.id)) : null,
                    borderRadius: AppRadius.borderLg,
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: AppRadius.borderLg,
                        border: Border.all(color: border),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(s.icon, size: 16, color: contentColor),
                          const SizedBox(height: 2),
                          Text(
                            s.label,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: contentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (index < steps.length - 1)
                  Container(
                    width: 12,
                    height: 1,
                    color: done ? AppColors.success : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepHeading(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 18, color: isDark ? AppColors.darkTeal : AppColors.lightTeal),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildClinicStep(BuildContext context, BookingState state, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeading('Choose a Clinic', LucideIcons.building2, isDark),
        const SizedBox(height: 16),
        if (state.isLoading && state.clinics.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Center(child: CircularProgressIndicator(color: AppColors.lightTeal)),
          )
        else ...state.clinics.map((c) {
          final isSelected = state.selectedClinic?.id == c.id;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark ? AppColors.darkTealLight : AppColors.lightTealLight)
                  : (isDark ? AppColors.darkBgBase : AppColors.lightBgBase),
              borderRadius: AppRadius.borderXl,
              border: Border.all(
                color: isSelected
                    ? (isDark ? AppColors.darkTeal : AppColors.lightTeal)
                    : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                width: 1,
              ),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.lightTeal, AppColors.lightCyan],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppRadius.borderLg,
                ),
                child: Center(
                  child: Text(
                    c.name.substring(0, 2).toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
              title: Text(
                c.name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${c.city}, ${c.state}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${c.doctorCount ?? 0} doctors',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
              trailing: isSelected
                  ? const Icon(LucideIcons.checkCircle2, color: AppColors.lightTeal)
                  : null,
              onTap: () => context.read<BookingBloc>().add(SelectClinic(c)),
            ),
            ),
          );
        }),
        const SizedBox(height: 8),
        _buildNavButtons(
          context,
          canNext: state.selectedClinic != null,
          onNext: () => context.read<BookingBloc>().add(const GoToStep(2)),
          onBack: null,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildDoctorStep(BuildContext context, BookingState state, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeading('Choose a Doctor', LucideIcons.stethoscope, isDark),
        const SizedBox(height: 16),
        if (state.isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Center(child: CircularProgressIndicator(color: AppColors.lightTeal)),
          )
        else if (state.doctors.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Text(
                'Loading doctors...',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
            ),
          )
        else
          ...state.doctors.map((d) {
            final isSelected = state.selectedDoctor?.id == d.id;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? AppColors.darkTealLight : AppColors.lightTealLight)
                    : (isDark ? AppColors.darkBgBase : AppColors.lightBgBase),
                borderRadius: AppRadius.borderXl,
                border: Border.all(
                  color: isSelected
                      ? (isDark ? AppColors.darkTeal : AppColors.lightTeal)
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  width: 1,
                ),
              ),
              child: Material(
                type: MaterialType.transparency,
                child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.cPurpleBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.cPurpleBorder),
                  ),
                  child: const Center(
                    child: Text(
                      'Dr',
                      style: TextStyle(color: AppColors.cPurple, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
                title: Text(
                  'Dr. ${d.fullName}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (d.specialization != null)
                        Text(
                          d.specialization!,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      if (d.consultationFee != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          '₹${d.consultationFee!.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.lightTeal,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                trailing: isSelected
                    ? const Icon(LucideIcons.checkCircle2, color: AppColors.lightTeal)
                    : null,
                onTap: () => context.read<BookingBloc>().add(SelectDoctor(d)),
              ),
              ),
            );
          }),
        const SizedBox(height: 8),
        _buildNavButtons(
          context,
          canNext: state.selectedDoctor != null,
          onNext: () => context.read<BookingBloc>().add(const GoToStep(3)),
          onBack: () => context.read<BookingBloc>().add(const GoToStep(1)),
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildScheduleStep(BuildContext context, BookingState state, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeading('Pick Date & Time', LucideIcons.calendarDays, isDark),
        const SizedBox(height: 20),

        // --- Visit Type ---
        Text(
          'VISIT TYPE',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildVisitTypeButton(
                context,
                type: 'in_clinic',
                label: 'In Clinic',
                icon: LucideIcons.home,
                active: state.visitType == 'in_clinic',
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildVisitTypeButton(
                context,
                type: 'online',
                label: 'Online',
                icon: LucideIcons.video,
                active: state.visitType == 'online',
                isDark: isDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // --- Date Selection ---
        Text(
          'DATE',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final now = DateTime.now();
            final lastDate = now.add(const Duration(days: 30));
            final initialDate = DateTime.tryParse(state.date) ?? now;
            final chosen = await showDatePicker(
              context: context,
              initialDate: initialDate.isBefore(now) ? now : initialDate,
              firstDate: now,
              lastDate: lastDate,
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColors.lightTeal,
                      onPrimary: Colors.white,
                      onSurface: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (chosen != null && context.mounted) {
              final chosenStr = "${chosen.year}-${chosen.month.toString().padLeft(2, '0')}-${chosen.day.toString().padLeft(2, '0')}";
              context.read<BookingBloc>().add(UpdateDate(chosenStr));
            }
          },
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
              borderRadius: AppRadius.borderXl,
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Row(
              children: [
                Text(
                  state.date,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // --- Preferred Time Slot ---
        Text(
          'PREFERRED TIME',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.2,
          ),
          itemCount: _timeSlots.length,
          itemBuilder: (context, idx) {
            final t = _timeSlots[idx];
            final isSelected = state.slotStart == t;
            return GestureDetector(
              onTap: () => context.read<BookingBloc>().add(UpdateSlotStart(t)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? AppColors.darkTealLight : AppColors.lightTealLight)
                      : (isDark ? AppColors.darkBgBase : AppColors.lightBgBase),
                  borderRadius: AppRadius.borderXl,
                  border: Border.all(
                    color: isSelected
                        ? (isDark ? AppColors.darkTeal : AppColors.lightTeal)
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    t,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? (isDark ? AppColors.darkTeal : AppColors.lightTeal)
                          : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),

        // --- Complaint Input ---
        Text(
          'CHIEF COMPLAINT (OPTIONAL)',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          maxLines: 3,
          onChanged: (v) => context.read<BookingBloc>().add(UpdateComplaint(v)),
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'Describe symptoms e.g. Fever, headache since 2 days...',
            hintStyle: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
            filled: true,
            fillColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.borderXl,
              borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.borderXl,
              borderSide: BorderSide(color: isDark ? AppColors.darkTeal : AppColors.lightTeal),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(height: 24),

        _buildNavButtons(
          context,
          canNext: state.date.isNotEmpty && state.slotStart.isNotEmpty,
          onNext: () => context.read<BookingBloc>().add(const GoToStep(4)),
          onBack: () => context.read<BookingBloc>().add(const GoToStep(2)),
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildVisitTypeButton(
    BuildContext context, {
    required String type,
    required String label,
    required IconData icon,
    required bool active,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () => context.read<BookingBloc>().add(UpdateVisitType(type)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 44,
        decoration: BoxDecoration(
          color: active
              ? (isDark ? AppColors.darkTealLight : AppColors.lightTealLight)
              : (isDark ? AppColors.darkBgBase : AppColors.lightBgBase),
          borderRadius: AppRadius.borderXl,
          border: Border.all(
            color: active
                ? (isDark ? AppColors.darkTeal : AppColors.lightTeal)
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: active ? (isDark ? AppColors.darkTeal : AppColors.lightTeal) : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: active
                    ? (isDark ? AppColors.darkTeal : AppColors.lightTeal)
                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmStep(BuildContext context, BookingState state, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeading('Confirm Booking', LucideIcons.checkCircle2, isDark),
        const SizedBox(height: 16),

        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
            borderRadius: AppRadius.borderXl,
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Column(
            children: [
              _buildRow('Clinic', state.selectedClinic?.name ?? '—', isDark),
              Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              _buildRow('Location', state.selectedClinic != null ? '${state.selectedClinic!.city}, ${state.selectedClinic!.state}' : '—', isDark),
              Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              _buildRow('Doctor', 'Dr. ${state.selectedDoctor?.fullName ?? '—'}', isDark),
              if (state.selectedDoctor?.specialization != null) ...[
                Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                _buildRow('Specialization', state.selectedDoctor!.specialization!, isDark),
              ],
              if (state.selectedDoctor?.consultationFee != null) ...[
                Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                _buildRow('Fee', '₹${state.selectedDoctor!.consultationFee!.toStringAsFixed(0)}', isDark, isAccent: true),
              ],
              Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              _buildRow('Date', state.date, isDark),
              Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              _buildRow('Time', state.slotStart, isDark),
              Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              _buildRow('Visit Type', state.visitType == 'in_clinic' ? 'In Clinic' : 'Online', isDark),
              if (state.complaint.isNotEmpty) ...[
                Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                _buildRow('Complaint', state.complaint, isDark),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        if (state.visitType == 'in_clinic')
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.successBgLight,
              border: Border.all(color: AppColors.successBorderLight),
              borderRadius: AppRadius.borderXl,
            ),
            child: const Text(
              'You can pay after consultation at clinic.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.success,
              ),
            ),
          ),
        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              flex: 1,
              child: OutlinedButton.icon(
                onPressed: state.isLoading ? null : () => context.read<BookingBloc>().add(const GoToStep(3)),
                icon: const Icon(LucideIcons.chevronLeft, size: 16),
                label: const Text('Back', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.borderXl),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: FilledButton.icon(
                onPressed: state.isLoading ? null : () => context.read<BookingBloc>().add(const SubmitBooking()),
                icon: state.isLoading
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(LucideIcons.checkCircle2, size: 16),
                label: Text(state.isLoading ? 'Booking...' : 'Confirm', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                style: FilledButton.styleFrom(
                  backgroundColor: isDark ? AppColors.darkTeal : AppColors.lightTeal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.borderXl),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavButtons(
    BuildContext context, {
    required bool canNext,
    required VoidCallback onNext,
    VoidCallback? onBack,
    required bool isDark,
  }) {
    return Row(
      children: [
        if (onBack != null) ...[
          Expanded(
            flex: 1,
            child: OutlinedButton.icon(
              onPressed: onBack,
              icon: const Icon(LucideIcons.chevronLeft, size: 16),
              label: const Text('Back', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.borderXl),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          flex: onBack != null ? 2 : 1,
          child: FilledButton(
            onPressed: canNext ? onNext : null,
            style: FilledButton.styleFrom(
              backgroundColor: isDark ? AppColors.darkTeal : AppColors.lightTeal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.borderXl),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Continue', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(width: 8),
                const Icon(LucideIcons.chevronRight, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value, bool isDark, {bool isAccent = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isAccent
                    ? (isDark ? AppColors.darkTeal : AppColors.lightTeal)
                    : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessScreen(BuildContext context, BookingState state, bool isDark) {
    final result = state.bookedResult!;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.successBgLight,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.successBorderLight, width: 2),
              ),
              child: const Icon(LucideIcons.checkCircle2, color: AppColors.success, size: 40),
            ),
            const SizedBox(height: 20),
            Text(
              'Appointment Booked!',
              style: AppTextStyles.h2.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your slot is confirmed.',
              style: AppTextStyles.bodySmall.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 384),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
                borderRadius: AppRadius.borderXl,
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Column(
                children: [
                  _buildRow('Token #', result.tokenNo.toString().padLeft(3, '0'), isDark, isAccent: true),
                  Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  _buildRow('Clinic', state.selectedClinic?.name ?? '', isDark),
                  Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  _buildRow('Doctor', 'Dr. ${state.selectedDoctor?.fullName ?? ''}', isDark),
                  Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  _buildRow('Date', state.date, isDark),
                  Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  _buildRow('Time', state.slotStart, isDark),
                  Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  _buildRow('Type', state.visitType == 'in_clinic' ? 'In Clinic' : 'Online', isDark),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              constraints: const BoxConstraints(maxWidth: 384),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.read<BookingBloc>().add(const ResetBooking()),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderXl),
                      ),
                      child: const Text('Book Another', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        context.pushReplacement(RouteNames.patientAppointments);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: isDark ? AppColors.darkTeal : AppColors.lightTeal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderXl),
                        elevation: 0,
                      ),
                      child: const Text('My Appointments', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
