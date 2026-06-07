import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../injection_container.dart';
import '../cubit/meetings_cubit.dart';
import '../../data/models/meetings_model.dart';

class VideoMeetingsScreen extends StatelessWidget {
  const VideoMeetingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MeetingsCubit>()..loadMeetings(),
      child: const _VideoMeetingsScreenView(),
    );
  }
}

class _VideoMeetingsScreenView extends StatelessWidget {
  const _VideoMeetingsScreenView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
      appBar: AppBar(
        title: const Text('Consultations'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.calendarPlus),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Book Consultation Coming Soon')),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<MeetingsCubit, MeetingsState>(
        builder: (context, state) {
          if (state is MeetingsLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.fitOrange));
          }

          if (state is MeetingsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.alertCircle, size: 48, color: AppColors.danger),
                  const SizedBox(height: 16),
                  Text('Failed to load meetings', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(state.message, style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<MeetingsCubit>().loadMeetings(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is MeetingsLoaded) {
            final isEmpty = state.data.upcoming.isEmpty && state.data.past.isEmpty && state.data.webinars.isEmpty;

            return RefreshIndicator(
              onRefresh: () => context.read<MeetingsCubit>().loadMeetings(),
              color: AppColors.fitOrange,
              child: isEmpty
                  ? CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Text('No meetings found.', style: GoogleFonts.inter(fontSize: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      children: [
                        if (state.data.upcoming.isNotEmpty) ...[
                          Text('Upcoming', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          ...state.data.upcoming.map((m) => _buildMeetingCard(m, isDark)),
                          const SizedBox(height: 32),
                        ],
                        if (state.data.webinars.isNotEmpty) ...[
                          Text('Webinars', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          ...state.data.webinars.map((w) => _buildWebinarCard(w, isDark)),
                          const SizedBox(height: 32),
                        ],
                        if (state.data.past.isNotEmpty) ...[
                          Text('Past Meetings', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          ...state.data.past.map((m) => _buildMeetingCard(m, isDark)),
                        ],
                      ],
                    ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildMeetingCard(CareMeeting meeting, bool isDark) {
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
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: meeting.mode == 'video'
                      ? AppColors.fitOrange.withOpacity(0.1)
                      : Colors.blue.withOpacity(0.1),
                  borderRadius: AppRadius.borderLg,
                ),
                child: Icon(
                  meeting.mode == 'video' ? LucideIcons.video : LucideIcons.mapPin,
                  color: meeting.mode == 'video' ? AppColors.fitOrange : Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(meeting.title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(
                      '${meeting.scheduledAt.split('T').first} • ${meeting.staffRole}',
                      style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.clock, size: 14, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                  const SizedBox(width: 4),
                  Text('${meeting.durationMinutes} min', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                ],
              ),
              if (meeting.status == 'scheduled' && meeting.mode == 'video')
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                  ),
                  child: const Text('Join'),
                )
              else if (meeting.status == 'scheduled' && meeting.mode == 'in_person')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: AppRadius.borderMd,
                  ),
                  child: Text(
                    'IN PERSON',
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
                    borderRadius: AppRadius.borderMd,
                  ),
                  child: Text(
                    meeting.status.toUpperCase(),
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWebinarCard(CareWebinar webinar, bool isDark) {
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
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: AppRadius.borderLg,
                ),
                child: const Icon(LucideIcons.monitorPlay, color: Colors.purple),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(webinar.title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(
                      '${webinar.scheduledAt.split('T').first} • Host: ${webinar.hostName}',
                      style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.clock, size: 14, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                  const SizedBox(width: 4),
                  Text('${webinar.durationMinutes} min', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                ],
              ),
              if (webinar.status == 'live')
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                  ),
                  child: const Text('Join Live'),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: AppRadius.borderMd,
                  ),
                  child: Text(
                    webinar.status.toUpperCase(),
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.purple),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
