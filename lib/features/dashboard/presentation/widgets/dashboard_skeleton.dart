import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';

class DashboardSkeleton extends StatefulWidget {
  const DashboardSkeleton({super.key});

  @override
  State<DashboardSkeleton> createState() => _DashboardSkeletonState();
}

class _DashboardSkeletonState extends State<DashboardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<Color?> _colorAnimationDark;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.grey.shade200,
      end: Colors.grey.shade300,
    ).animate(_controller);

    _colorAnimationDark = ColorTween(
      begin: Colors.grey.shade800,
      end: Colors.grey.shade700,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final animation = isDark ? _colorAnimationDark : _colorAnimation;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Row(
                children: [
                  _SkeletonBox(
                    animation: animation,
                    width: 44,
                    height: 44,
                    isCircle: true,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SkeletonBox(animation: animation, width: 80, height: 12),
                      const SizedBox(height: 8),
                      _SkeletonBox(
                        animation: animation,
                        width: 120,
                        height: 16,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Hero
              _SkeletonBox(
                animation: animation,
                width: double.infinity,
                height: 150,
              ),
              const SizedBox(height: 20),

              // Chart
              _SkeletonBox(
                animation: animation,
                width: double.infinity,
                height: 170,
              ),
              const SizedBox(height: 20),

              // List items
              _SkeletonBox(
                animation: animation,
                width: double.infinity,
                height: 72,
              ),
              const SizedBox(height: 12),
              _SkeletonBox(
                animation: animation,
                width: double.infinity,
                height: 72,
              ),
              const SizedBox(height: 12),
              _SkeletonBox(
                animation: animation,
                width: double.infinity,
                height: 72,
              ),
              const SizedBox(height: 20),

              // Grid items
              Row(
                children: [
                  Expanded(
                    child: _SkeletonBox(animation: animation, height: 80),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SkeletonBox(animation: animation, height: 80),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _SkeletonBox(animation: animation, height: 80),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SkeletonBox(animation: animation, height: 80),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final Animation<Color?> animation;
  final double? width;
  final double height;
  final bool isCircle;

  const _SkeletonBox({
    required this.animation,
    this.width,
    required this.height,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: animation.value,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : AppRadius.borderXl,
      ),
    );
  }
}
