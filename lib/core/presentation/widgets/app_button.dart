import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_text_styles.dart';

enum ButtonType { primary, outlined, accent }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonType type;
  final IconData? icon;
  final double? width;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.type = ButtonType.primary,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEnabled = onPressed != null && !isLoading;

    // Build gradient background for primary button to match premium Next.js look
    final buttonGradient = isEnabled
        ? (type == ButtonType.accent ? AppColors.amberShimmer : AppColors.tealShimmer)
        : null;

    final primaryBgColor = isEnabled
        ? (isDark ? AppColors.darkTeal : AppColors.lightTeal)
        : (isDark ? Colors.white10 : Colors.black12);

    final textColor = isEnabled
        ? (type == ButtonType.outlined
            ? (isDark ? AppColors.darkTeal : AppColors.lightTeal)
            : (type == ButtonType.accent ? Colors.white : (isDark ? AppColors.darkBgBase : Colors.white)))
        : (isDark ? Colors.white30 : Colors.black38);

    final borderSide = type == ButtonType.outlined
        ? BorderSide(
            color: isEnabled
                ? (isDark ? AppColors.darkTeal : AppColors.lightTeal)
                : (isDark ? Colors.white10 : Colors.black12),
            width: 1.5,
          )
        : BorderSide.none;

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 16.0,
            height: 16.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          ),
          const SizedBox(width: 10.0),
        ] else if (icon != null) ...[
          Icon(icon, size: 16.0, color: textColor),
          const SizedBox(width: 8.0),
        ],
        Text(
          text,
          style: AppTextStyles.buttonLarge.copyWith(color: textColor),
        ),
      ],
    );

    return SizedBox(
      width: width,
      height: 48.0,
      child: GestureDetector(
        onTap: isEnabled ? onPressed : null,
        child: AnimatedScale(
          scale: isEnabled ? 1.0 : 0.98,
          duration: const Duration(milliseconds: 100),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: AppRadius.borderMd,
              border: borderSide != BorderSide.none
                  ? Border.fromBorderSide(borderSide)
                  : null,
              gradient: type != ButtonType.outlined ? buttonGradient : null,
              color: type == ButtonType.outlined ? Colors.transparent : (buttonGradient == null ? primaryBgColor : null),
              boxShadow: isEnabled && type != ButtonType.outlined
                  ? [
                      BoxShadow(
                        color: (type == ButtonType.accent ? AppColors.warning : AppColors.lightTeal)
                            .withAlpha(61),
                        blurRadius: 16.0,
                        spreadRadius: 0.0,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : [],
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}
