import '../../../../core/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/academy_models.dart';
import '../../../../injection_container.dart';
import '../../domain/repositories/academy_repository.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class AcademyVideoDetailsScreen extends StatefulWidget {
  final AcademyVideo video;

  const AcademyVideoDetailsScreen({super.key, required this.video});

  @override
  State<AcademyVideoDetailsScreen> createState() =>
      _AcademyVideoDetailsScreenState();
}

class _AcademyVideoDetailsScreenState extends State<AcademyVideoDetailsScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isPlayerInitialized = false;
  bool _isPlayerError = false;
  bool _isLiking = false;
  late bool _isLiked;
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.video.liked;
    _likeCount = widget.video.likeCount;
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      if (widget.video.videoUrl.isEmpty) {
        setState(() => _isPlayerError = true);
        return;
      }

      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.video.videoUrl),
      );
      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );

      setState(() {
        _isPlayerInitialized = true;
      });
    } catch (e) {
      debugPrint("Error initializing video player: $e");
      setState(() {
        _isPlayerError = true;
      });
    }
  }

  Future<void> _toggleLike() async {
    if (_isLiking) return;

    setState(() {
      _isLiking = true;
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });

    final result = await sl<AcademyRepository>().toggleLike(widget.video.id);
    
    if (!mounted) return;

    result.fold(
      (failure) {
        // Revert on failure
        setState(() {
          _isLiked = !_isLiked;
          _likeCount += _isLiked ? 1 : -1;
        });
        UIHelpers.showErrorSnackBar(context, failure.message);
      },
      (_) {}, // Success handled locally
    );

    setState(() {
      _isLiking = false;
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  String _formatDuration(int sec) {
    if (sec == 0) return '';
    final h = sec ~/ 3600;
    final m = (sec % 3600) ~/ 60;
    final s = sec % 60;
    if (h > 0) {
      return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final v = widget.video;

    final updatedVideo = widget.video.copyWith(
      liked: _isLiked,
      likeCount: _likeCount,
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, dynamic result) {
        if (didPop) return;
        context.pop(updatedVideo);
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text(
          'Video Details',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player Area
            Container(
              width: double.infinity,
              color: Colors.black,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: _isPlayerError
                    ? const Center(
                        child: Text(
                          'Video unavailable or invalid URL.',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : _isPlayerInitialized && _chewieController != null
                    ? Chewie(controller: _chewieController!)
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          if (v.thumbnailUrl.isNotEmpty)
                            Image.network(v.thumbnailUrl, fit: BoxFit.cover),
                          const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFEC4899),
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            // Video Info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (v.category.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEC4899).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        v.category,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFEC4899),
                        ),
                      ),
                    ),
                  Text(
                    v.title,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            LucideIcons.eye,
                            size: 16,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${v.viewCount} views',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          Icon(
                            LucideIcons.clock,
                            size: 16,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _formatDuration(v.durationSec),
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _toggleLike,
                        child: Row(
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                              child: Icon(
                                _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                                key: ValueKey<bool>(_isLiked),
                                size: 18,
                                color: _isLiked
                                    ? const Color(0xFFEC4899)
                                    : (isDark
                                          ? AppColors.darkTextMuted
                                          : AppColors.lightTextMuted),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$_likeCount',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: _isLiked
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: _isLiked
                                    ? const Color(0xFFEC4899)
                                    : (isDark
                                          ? AppColors.darkTextMuted
                                          : AppColors.lightTextMuted),
                              ),
                            ),
                            if (_isLiking) ...[
                              const SizedBox(width: 8),
                              const SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFEC4899)),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Divider(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    v.description.isNotEmpty
                        ? v.description
                        : 'No description provided for this video.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      height: 1.5,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
