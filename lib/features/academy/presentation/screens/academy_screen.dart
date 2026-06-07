import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../injection_container.dart';
import '../cubit/academy_cubit.dart';
import '../cubit/academy_state.dart';
import '../../data/models/academy_models.dart';

class AcademyScreen extends StatelessWidget {
  const AcademyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AcademyCubit>()..loadVideos(),
      child: const _AcademyView(),
    );
  }
}

class _AcademyView extends StatelessWidget {
  const _AcademyView();

  String _formatDuration(int sec) {
    if (sec == 0) return '';
    final h = sec ~/ 3600;
    final m = (sec % 3600) ~/ 60;
    final s = sec % 60;
    if (h > 0) return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  int _progressPct(AcademyVideo v) {
    if (v.durationSec == 0 || v.watchedSec == 0) return 0;
    return ((v.watchedSec / v.durationSec) * 100).round().clamp(0, 100);
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
                color: const Color(0xFFEC4899).withValues(alpha: 0.12), // Matching #EC4899 accent for patient
                borderRadius: AppRadius.borderLg,
              ),
              child: const Icon(LucideIcons.video, color: Color(0xFFEC4899), size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fittoria Academy',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  'Expert videos for you',
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
      body: BlocBuilder<AcademyCubit, AcademyState>(
        builder: (context, state) {
          if (state is AcademyInitial || (state is AcademyLoading && context.read<AcademyCubit>().state is! AcademyLoaded)) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFEC4899)));
          }
          if (state is AcademyError) {
            return Center(child: Text(state.message, style: GoogleFonts.inter(color: Colors.red)));
          }

          if (state is AcademyLoaded) {
            final categories = state.allCategories;

            return RefreshIndicator(
              onRefresh: () => context.read<AcademyCubit>().loadVideos(),
              color: const Color(0xFFEC4899),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
                                    borderRadius: AppRadius.borderLg,
                                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Row(
                                    children: [
                                      Icon(LucideIcons.search, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: TextFormField(
                                          initialValue: state.searchQuery,
                                          onChanged: (val) => context.read<AcademyCubit>().loadVideos(query: val),
                                          style: GoogleFonts.inter(fontSize: 14, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                          decoration: InputDecoration(
                                            hintText: 'Search videos...',
                                            hintStyle: GoogleFonts.inter(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted, fontSize: 14),
                                            border: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (categories.isNotEmpty) ...[
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 40,
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
                                      borderRadius: AppRadius.borderLg,
                                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        value: state.category.isEmpty ? '' : state.category,
                                        dropdownColor: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
                                        items: [
                                          DropdownMenuItem(value: '', child: Text('All Categories', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary))),
                                          ...categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)))),
                                        ],
                                        onChanged: (val) => context.read<AcademyCubit>().loadVideos(category: val),
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state.videos.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(LucideIcons.video, size: 40, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                              const SizedBox(height: 12),
                              Text('No videos available yet', style: GoogleFonts.inter(fontSize: 14, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.72,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final v = state.videos[index];
                            final pct = _progressPct(v);
                            return GestureDetector(
                              onTap: () {
                                // In real app, push to video player
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
                                  borderRadius: AppRadius.borderXl,
                                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Thumbnail
                                    AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Container(
                                            color: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
                                            child: v.thumbnailUrl.isNotEmpty
                                                ? Image.network(v.thumbnailUrl, fit: BoxFit.cover)
                                                : Center(child: Icon(LucideIcons.video, size: 32, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                                          ),
                                          if (v.durationSec > 0)
                                            Positioned(
                                              bottom: 8,
                                              right: 8,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.75), borderRadius: BorderRadius.circular(4)),
                                                child: Text(_formatDuration(v.durationSec), style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                                              ),
                                            ),
                                          if (v.completed)
                                            Positioned(
                                              top: 8,
                                              left: 8,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(999)),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Icon(LucideIcons.checkCircle2, size: 10, color: Colors.white),
                                                    const SizedBox(width: 4),
                                                    Text('Done', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          if (pct > 0 && !v.completed)
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              height: 4,
                                              child: Container(
                                                color: Colors.black.withValues(alpha: 0.3),
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  width: (pct / 100) * MediaQuery.of(context).size.width, // Rough approx
                                                  color: const Color(0xFFEC4899),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    // Info
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              v.title,
                                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            if (v.category.isNotEmpty)
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFEC4899).withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(999),
                                                ),
                                                child: Text(v.category, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFFEC4899))),
                                              ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(LucideIcons.eye, size: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                                    const SizedBox(width: 4),
                                                    Text(v.viewCount.toString(), style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                                                  ],
                                                ),
                                                GestureDetector(
                                                  onTap: () => context.read<AcademyCubit>().toggleLike(v.id),
                                                  child: Row(
                                                    children: [
                                                      Icon(LucideIcons.thumbsUp, size: 12, color: v.liked ? const Color(0xFFEC4899) : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                                                      const SizedBox(width: 4),
                                                      Text(v.likeCount.toString(), style: GoogleFonts.inter(fontSize: 10, fontWeight: v.liked ? FontWeight.bold : FontWeight.normal, color: v.liked ? const Color(0xFFEC4899) : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted))),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: state.videos.length,
                        ),
                      ),
                    ),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
