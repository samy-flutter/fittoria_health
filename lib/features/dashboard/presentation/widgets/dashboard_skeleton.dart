import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';

class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Smooth Next.js style colors for Shimmer
    final baseColor = isDark ? AppColors.darkBgMuted : AppColors.lightBgMuted;
    final highlightColor = isDark ? AppColors.darkBgSurface : Colors.white;
    final surfaceColor = isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface;

    Widget shimmerWrap(Widget child) {
      return Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: child,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Greeting (No card background, just items)
          shimmerWrap(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const _SkeletonBox(
                      width: 44,
                      height: 44,
                      isCircle: true,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _SkeletonBox(width: 80, height: 12),
                        SizedBox(height: 8),
                        _SkeletonBox(width: 120, height: 18),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: const [
                    _SkeletonBox(width: 60, height: 40, borderRadius: 20),
                    SizedBox(width: 8),
                    _SkeletonBox(width: 70, height: 40, borderRadius: 20),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. Onboarding Prompt
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: AppRadius.borderXl,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: shimmerWrap(
              Row(
                children: [
                  const _SkeletonBox(width: 44, height: 44, borderRadius: 12),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _SkeletonBox(width: 160, height: 14),
                        SizedBox(height: 6),
                        _SkeletonBox(width: 220, height: 10),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 3. Activity Hero
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: AppRadius.borderXl,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: shimmerWrap(
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _SkeletonBox(width: 110, height: 12),
                      _SkeletonBox(width: 50, height: 12),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const _SkeletonBox(width: 92, height: 92, isCircle: true),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(children: const [ _SkeletonBox(width: 40, height: 10), SizedBox(height: 6), _SkeletonBox(width: 40, height: 18) ]),
                            Column(children: const [ _SkeletonBox(width: 40, height: 10), SizedBox(height: 6), _SkeletonBox(width: 40, height: 18) ]),
                            Column(children: const [ _SkeletonBox(width: 40, height: 10), SizedBox(height: 6), _SkeletonBox(width: 40, height: 18) ]),
                          ]
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 4. Weekly Steps Chart
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: AppRadius.borderXl,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: shimmerWrap(
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _SkeletonBox(width: 130, height: 14),
                      _SkeletonBox(width: 50, height: 12),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (int i = 0; i < 7; i++)
                        Column(
                          children: [
                            _SkeletonBox(width: 24, height: 30.0 + (i * 15 % 60), borderRadius: 4),
                            const SizedBox(height: 8),
                            const _SkeletonBox(width: 20, height: 10),
                          ],
                        )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 5. Care Team Section
          shimmerWrap(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _SkeletonBox(width: 120, height: 14),
                    _SkeletonBox(width: 50, height: 12),
                  ],
                ),
                const SizedBox(height: 12),
                const _SkeletonBox(width: double.infinity, height: 72),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Expanded(child: _SkeletonBox(height: 72)),
                    SizedBox(width: 12),
                    Expanded(child: _SkeletonBox(height: 72)),
                  ],
                ),
                const SizedBox(height: 12),
                const _SkeletonBox(width: double.infinity, height: 72),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final bool isCircle;
  final double borderRadius;

  const _SkeletonBox({
    this.width,
    required this.height,
    this.isCircle = false,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white, // Opaque color so Shimmer can mask it
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(borderRadius),
      ),
    );
  }
}
