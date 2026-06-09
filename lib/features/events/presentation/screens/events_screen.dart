import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../injection_container.dart';
import '../cubit/events_cubit.dart';
import '../cubit/events_state.dart';
import '../../data/models/event_models.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EventsCubit>()..loadEvents(),
      child: const _EventsView(),
    );
  }
}

class _EventsView extends StatelessWidget {
  const _EventsView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            LucideIcons.arrowLeft,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
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
              child: const Icon(
                LucideIcons.flag,
                color: AppColors.fitOrange,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Events',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  'Marathons, rides & treks',
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
          const SizedBox(height: 12),
          _EventFilters(),
          const SizedBox(height: 12),
          Expanded(
            child: BlocBuilder<EventsCubit, EventsState>(
              builder: (context, state) {
                if (state is EventsLoading || state is EventsInitial) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.fitOrange,
                    ),
                  );
                }
                if (state is EventsError) {
                  return Center(child: Text(state.message));
                }
                if (state is EventsLoaded) {
                  if (state.events.isEmpty) {
                    return Center(
                      child: Text(
                        'No events found.',
                        style: GoogleFonts.inter(
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    );
                  }
                  return RefreshIndicator(
                    color: AppColors.fitOrange,
                    onRefresh: () => context.read<EventsCubit>().loadEvents(
                      filter: state.filter,
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.events.length,
                      itemBuilder: (context, index) {
                        return _EventCard(event: state.events[index]);
                      },
                    ),
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

class _EventFilters extends StatelessWidget {
  final List<Map<String, String>> filters = [
    {'key': '', 'label': 'All'},
    {'key': 'marathon', 'label': 'Marathons'},
    {'key': 'run', 'label': 'Runs'},
    {'key': 'cycling', 'label': 'Cycling'},
    {'key': 'trekking', 'label': 'Treks'},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsCubit, EventsState>(
      builder: (context, state) {
        String currentFilter = '';
        if (state is EventsLoaded) currentFilter = state.filter;

        return SizedBox(
          height: 36,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final f = filters[index];
              final isSelected = currentFilter == f['key'];
              final isDark = Theme.of(context).brightness == Brightness.dark;

              return GestureDetector(
                onTap: () =>
                    context.read<EventsCubit>().loadEvents(filter: f['key']!),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.fitOrange
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.fitOrange
                          : (isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder),
                    ),
                  ),
                  child: Text(
                    f['label']!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _EventCard extends StatelessWidget {
  final FitEvent event;
  const _EventCard({required this.event});

  Map<String, dynamic> _getMeta(String type) {
    switch (type) {
      case 'marathon':
        return {
          'icon': LucideIcons.medal,
          'color': const Color(0xFFEF4444),
          'label': 'Marathon',
        };
      case 'run':
        return {
          'icon': LucideIcons.footprints,
          'color': AppColors.fitOrange,
          'label': 'Run',
        };
      case 'cycling':
        return {
          'icon': LucideIcons.bike,
          'color': const Color(0xFF3B82F6),
          'label': 'Cycling',
        };
      case 'trekking':
        return {
          'icon': LucideIcons.mountain,
          'color': const Color(0xFF22C55E),
          'label': 'Trekking',
        };
      case 'triathlon':
        return {
          'icon': LucideIcons.medal,
          'color': const Color(0xFFA78BFA),
          'label': 'Triathlon',
        };
      default:
        return {
          'icon': LucideIcons.flag,
          'color': const Color(0xFF6B7280),
          'label': 'Event',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final meta = _getMeta(event.eventType);
    final color = meta['color'] as Color;

    return GestureDetector(
      onTap: () {
        context.push('/patient/events/details', extra: event);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
          borderRadius: AppRadius.borderXl,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Container(
              height: 96,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                gradient: event.bannerUrl == null
                    ? LinearGradient(
                        colors: [color, color.withValues(alpha: 0.6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                image: event.bannerUrl != null
                    ? DecorationImage(
                        image: NetworkImage(event.bannerUrl!),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withValues(alpha: 0.2),
                          BlendMode.darken,
                        ),
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            meta['icon'] as IconData,
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            (meta['label'] as String).toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (event.registered)
                    Positioned(
                      top: 10,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              LucideIcons.check,
                              size: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Registered',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (event.distanceKm != null)
                    Positioned(
                      bottom: 8,
                      right: 12,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${event.distanceKm}',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'km',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.calendar,
                        size: 12,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd MMM yyyy').format(event.startAt),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        LucideIcons.mapPin,
                        size: 12,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        event.city,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        LucideIcons.users,
                        size: 12,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${event.registeredCount}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        event.registrationFee > 0
                            ? '₹${event.registrationFee.toInt()}'
                            : 'Free',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.fitOrange,
                        ),
                      ),
                      Icon(
                        LucideIcons.chevronRight,
                        size: 16,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ],
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
