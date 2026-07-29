import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../injection_container.dart';
import '../cubit/trainers_cubit.dart';
import '../cubit/trainers_state.dart';
import '../../data/models/trainer_models.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class TrainersScreen extends StatelessWidget {
  const TrainersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TrainersCubit>()..loadTrainers(),
      child: const _TrainersView(),
    );
  }
}

class _TrainersView extends StatefulWidget {
  const _TrainersView();

  @override
  State<_TrainersView> createState() => _TrainersViewState();
}

class _TrainersViewState extends State<_TrainersView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.fitOrange.withValues(alpha: 0.15),
                borderRadius: AppRadius.borderLg,
              ),
              child: const Icon(
                LucideIcons.dumbbell,
                color: AppColors.fitOrange,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trainers',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  'Find your perfect match',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (v) =>
                        context.read<TrainersCubit>().searchTrainers(v),
                    style: GoogleFonts.inter(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search by name or specialization...',
                      hintStyle: GoogleFonts.inter(
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                      prefixIcon: Icon(
                        LucideIcons.search,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.borderXl,
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: AppRadius.borderXl,
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: AppRadius.borderXl,
                        borderSide: const BorderSide(
                          color: AppColors.fitOrange,
                        ),
                      ),
                      filled: true,
                      fillColor: isDark
                          ? AppColors.darkBgSurface
                          : AppColors.lightBgSurface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.fitOrange,
                    borderRadius: AppRadius.borderXl,
                  ),
                  child: IconButton(
                    icon: const Icon(LucideIcons.search, color: Colors.white),
                    onPressed: () => context
                        .read<TrainersCubit>()
                        .searchTrainers(_searchController.text),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<TrainersCubit, TrainersState>(
              builder: (context, state) {
                if (state is TrainersLoading || state is TrainersInitial) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.fitOrange,
                    ),
                  );
                }
                if (state is TrainersError) {
                  return Center(child: Text(state.message));
                }
                if (state is TrainersLoaded) {
                  if (state.trainers.isEmpty) {
                    return Center(
                      child: Text(
                        'No trainers found.',
                        style: GoogleFonts.inter(
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.trainers.length,
                    itemBuilder: (context, index) {
                      return _TrainerCard(trainer: state.trainers[index]);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TrainerCard extends StatelessWidget {
  final Trainer trainer;
  const _TrainerCard({required this.trainer});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final initial = trainer.fullName.isNotEmpty
        ? trainer.fullName[0].toUpperCase()
        : 'T';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  gradient: LinearGradient(
                    colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            trainer.fullName,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (trainer.sessionFee != null)
                          Text(
                            '₹${trainer.sessionFee!.toInt()}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.fitOrange,
                            ),
                          ),
                      ],
                    ),
                    Text(
                      trainer.specialization ?? 'Fitness Trainer',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if (trainer.experienceYears > 0) ...[
                          Icon(
                            LucideIcons.award,
                            size: 12,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${trainer.experienceYears}y exp',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Icon(
                          LucideIcons.star,
                          size: 12,
                          color: const Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${trainer.rating}',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          LucideIcons.check,
                          size: 12,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${trainer.sessionsDone} sessions',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                    if (trainer.bio != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        trainer.bio!,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.fitOrange,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.borderXl),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            onPressed: () {
              _showBookingSheet(context, trainer);
            },

            icon: const Icon(
              LucideIcons.calendar,
              size: 16,
              color: Colors.white,
            ),
            label: Text(
              'Book a Session',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingSheet(BuildContext parentContext, Trainer trainer) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      builder: (context) {
        return BlocProvider.value(
          value: parentContext.read<TrainersCubit>()..resetBookingState(),
          child: _BookingSheet(trainer: trainer),
        );
      },
    );
  }
}

class _BookingSheet extends StatefulWidget {
  final Trainer trainer;
  const _BookingSheet({required this.trainer});

  @override
  State<_BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<_BookingSheet> {
  String _sessionType = 'online_1on1';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _notesController = TextEditingController();

  final List<Map<String, dynamic>> _sessionTypes = [
    {'key': 'online_1on1', 'label': 'Online 1-on-1', 'icon': LucideIcons.video},
    {'key': 'in_person', 'label': 'In Person', 'icon': LucideIcons.mapPin},
    {
      'key': 'consultation',
      'label': 'Consultation',
      'icon': LucideIcons.messageCircle,
    },
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: BlocBuilder<TrainersCubit, TrainersState>(
          builder: (context, state) {
            bool isLoading = false;
            bool isSuccess = false;

            if (state is TrainersLoaded) {
              isLoading = state.isBooking;
              isSuccess = state.bookingSuccess;
            }

            if (isSuccess) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.check,
                      color: Colors.green,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Session requested!',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.trainer.fullName} will confirm shortly.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.fitOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.borderXl,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Done',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Book ${widget.trainer.fullName}',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        LucideIcons.x,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Session type',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: _sessionTypes.map((s) {
                    final isSelected = _sessionType == s['key'];
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _sessionType = s['key']),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.fitOrange.withValues(alpha: 0.1)
                                : Colors.transparent,
                            borderRadius: AppRadius.borderXl,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.fitOrange
                                  : (isDark
                                        ? AppColors.darkBorder
                                        : AppColors.lightBorder),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                s['icon'] as IconData,
                                size: 16,
                                color: isSelected
                                    ? AppColors.fitOrange
                                    : (isDark
                                          ? AppColors.darkTextMuted
                                          : AppColors.lightTextMuted),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                s['label'],
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () async {
                              final dt = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now().add(
                                  const Duration(days: 1),
                                ),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 30),
                                ),
                              );
                              if (dt != null)
                                setState(() => _selectedDate = dt);
                            },
                            child: Container(
                              height: 44,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.darkBgBase
                                    : AppColors.lightBgBase,
                                borderRadius: AppRadius.borderXl,
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder,
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _selectedDate == null
                                    ? 'Select Date'
                                    : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: _selectedDate == null
                                      ? (isDark
                                            ? AppColors.darkTextMuted
                                            : AppColors.lightTextMuted)
                                      : (isDark
                                            ? AppColors.darkTextPrimary
                                            : AppColors.lightTextPrimary),
                                ),
                              ),
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
                          Text(
                            'Time',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () async {
                              final t = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (t != null) setState(() => _selectedTime = t);
                            },
                            child: Container(
                              height: 44,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.darkBgBase
                                    : AppColors.lightBgBase,
                                borderRadius: AppRadius.borderXl,
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder,
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _selectedTime == null
                                    ? 'Select Time'
                                    : _selectedTime!.format(context),
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: _selectedTime == null
                                      ? (isDark
                                            ? AppColors.darkTextMuted
                                            : AppColors.lightTextMuted)
                                      : (isDark
                                            ? AppColors.darkTextPrimary
                                            : AppColors.lightTextPrimary),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _notesController,
                  maxLines: 2,
                  style: GoogleFonts.inter(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Anything the trainer should know? (optional)',
                    hintStyle: GoogleFonts.inter(
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.borderXl,
                      borderSide: BorderSide(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppRadius.borderXl,
                      borderSide: BorderSide(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppRadius.borderXl,
                      borderSide: const BorderSide(color: AppColors.fitOrange),
                    ),
                    filled: true,
                    fillColor: isDark
                        ? AppColors.darkBgBase
                        : AppColors.lightBgBase,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.fitOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.borderXl,
                      ),
                    ),
                    onPressed:
                        isLoading ||
                            _selectedDate == null ||
                            _selectedTime == null
                        ? null
                        : () {
                            final dt = DateTime(
                              _selectedDate!.year,
                              _selectedDate!.month,
                              _selectedDate!.day,
                              _selectedTime!.hour,
                              _selectedTime!.minute,
                            );
                            context.read<TrainersCubit>().bookTrainer(
                              widget.trainer.id,
                              _sessionType,
                              dt,
                              _notesController.text,
                            );
                          },
                    child: isLoading
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
                                LucideIcons.clock,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.trainer.sessionFee != null
                                    ? 'Request · ₹${widget.trainer.sessionFee!.toInt()}'
                                    : 'Request Session',
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
            );
          },
        ),
      ),
    );
  }
}
