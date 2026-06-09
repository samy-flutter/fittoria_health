import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../data/models/event_models.dart';
import '../cubit/events_cubit.dart';
import '../cubit/events_state.dart';

class EventDetailsScreen extends StatelessWidget {
  final FitEvent event;

  const EventDetailsScreen({
    super.key,
    required this.event,
  });

  Map<String, dynamic> _getMeta(String type) {
    switch (type) {
      case 'marathon': return {'icon': LucideIcons.medal, 'color': const Color(0xFFEF4444), 'label': 'Marathon'};
      case 'run': return {'icon': LucideIcons.footprints, 'color': AppColors.fitOrange, 'label': 'Run'};
      case 'cycling': return {'icon': LucideIcons.bike, 'color': const Color(0xFF3B82F6), 'label': 'Cycling'};
      case 'trekking': return {'icon': LucideIcons.mountain, 'color': const Color(0xFF22C55E), 'label': 'Trekking'};
      case 'triathlon': return {'icon': LucideIcons.medal, 'color': const Color(0xFFA78BFA), 'label': 'Triathlon'};
      default: return {'icon': LucideIcons.flag, 'color': const Color(0xFF6B7280), 'label': 'Event'};
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final meta = _getMeta(event.eventType);
    final color = meta['color'] as Color;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
            leading: IconButton(
              icon: Icon(LucideIcons.arrowLeft, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (event.bannerUrl != null)
                    Image.network(
                      event.bannerUrl!,
                      fit: BoxFit.cover,
                      color: Colors.black.withValues(alpha: 0.3),
                      colorBlendMode: BlendMode.darken,
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color, color.withValues(alpha: 0.6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(meta['icon'] as IconData, size: 14, color: Colors.white),
                              const SizedBox(width: 6),
                              Text(
                                (meta['label'] as String).toUpperCase(),
                                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          event.title,
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(
                    icon: LucideIcons.calendar,
                    title: 'Date & Time',
                    subtitle: DateFormat('EEEE, MMMM d, y • h:mm a').format(event.startAt),
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(
                    icon: LucideIcons.mapPin,
                    title: 'Location',
                    subtitle: '${event.venue}, ${event.city}',
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(
                    icon: LucideIcons.users,
                    title: 'Participants',
                    subtitle: '${event.registeredCount} / ${event.capacity} registered',
                  ),
                  if (event.distanceKm != null) ...[
                    const SizedBox(height: 16),
                    _InfoRow(
                      icon: LucideIcons.ruler,
                      title: 'Distance',
                      subtitle: '${event.distanceKm} km',
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text(
                    'About Event',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      height: 1.6,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 100), // Bottom padding for FAB area
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _RegisterBottomBar(event: event),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoRow({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.fitOrange.withValues(alpha: 0.1),
            borderRadius: AppRadius.borderLg,
          ),
          child: Icon(icon, color: AppColors.fitOrange, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RegisterBottomBar extends StatelessWidget {
  final FitEvent event;

  const _RegisterBottomBar({required this.event});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return BlocBuilder<EventsCubit, EventsState>(
      builder: (context, state) {
        bool isRegistered = event.registered;
        
        // Optimistic UI check: if state has updated events, we can find our event
        if (state is EventsLoaded) {
          final updatedEvent = state.events.cast<FitEvent?>().firstWhere(
            (e) => e?.id == event.id,
            orElse: () => null,
          );
          if (updatedEvent != null) {
            isRegistered = updatedEvent.registered;
          }
        }
        
        final isLoading = state is EventsLoading;

        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(context).padding.bottom + 16,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fee',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                  Text(
                    event.registrationFee > 0 ? '₹${event.registrationFee.toInt()}' : 'Free',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.fitOrange,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRegistered 
                        ? (isDark ? AppColors.darkBgBase : AppColors.lightBgBase)
                        : AppColors.fitOrange,
                    foregroundColor: isRegistered 
                        ? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                        : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.borderLg,
                      side: isRegistered 
                          ? BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)
                          : BorderSide.none,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: isRegistered || isLoading
                      ? null
                      : () {
                          context.read<EventsCubit>().registerForEvent(event.id);
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          isRegistered ? 'Registered' : 'Register Now',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
