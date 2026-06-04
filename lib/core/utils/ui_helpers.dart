import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

class UIHelpers {
  static void showErrorSnackBar(BuildContext context, String rawMessage) {
    // Sanitize technical errors to user-friendly messages
    String message = rawMessage;
    if (message.contains("type 'String' is not a subtype") || message.contains("type cast") || message.contains("FormatException")) {
      message = 'An unexpected error occurred while processing data. Please try again later.';
    } else if (message.contains("SocketException") || message.contains("Connection refused")) {
      message = 'Cannot connect to the server. Please check your internet connection.';
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(LucideIcons.alertCircle, color: AppColors.danger, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderLg,
            side: BorderSide(color: AppColors.danger.withValues(alpha: 0.3), width: 1),
          ),
          elevation: 4,
          duration: const Duration(seconds: 4),
        ),
      );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(LucideIcons.checkCircle, color: AppColors.success, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderLg,
            side: BorderSide(color: AppColors.success.withValues(alpha: 0.3), width: 1),
          ),
          elevation: 4,
          duration: const Duration(seconds: 3),
        ),
      );
  }
}
