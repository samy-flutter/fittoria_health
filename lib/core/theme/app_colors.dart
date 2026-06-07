import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // --- Light Theme Colors ---
  static const Color lightBgBase = Color(0xFFF7FAFA);
  static const Color lightBgSurface = Color(0xFFFFFFFF);
  static const Color lightBgMuted = Color(0xFFEEF5F5);

  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightTextMuted = Color(0xFF9CA3AF);

  static const Color lightBorder = Color(0xFFD1E8E8);

  static const Color lightTeal = Color(0xFF0D6E6E);
  static const Color lightTealHover = Color(0xFF095A5A);
  static const Color lightTealLight = Color(0xFFE0F4F4);
  static const Color lightTealBorder = Color(0xFFA7D9D9);
  static const Color lightCyan = Color(0xFF14B8A6);

  static const Color lightAmber = Color(0xFFE8A045);
  static const Color lightAmberHover = Color(0xFFD4892E);
  static const Color lightAmberLight = Color(0xFFFEF3E2);
  static const Color lightAmberBorder = Color(0xFFF5C68A);

  static const Color fitOrange = Color(0xFFE8843C);

  // --- Dark Theme Colors ---
  static const Color darkBgBase = Color(0xFF060E1E);
  static const Color darkBgSurface = Color(0xFF0D1B2E);
  static const Color darkBgMuted = Color(0xFF122036);

  static const Color darkTextPrimary = Color(0xFFF0F6FF);
  static const Color darkTextSecondary = Color(0xFF7A9BB5);
  static const Color darkTextMuted = Color(0xFF4A6A85);

  static const Color darkBorder = Color(0x2600D4B4); // rgba(0, 212, 180, 0.15)

  static const Color darkTeal = Color(0xFF00D4B4);
  static const Color darkTealHover = Color(0xFF00B89E);
  static const Color darkTealLight = Color(0x1F00D4B4); // rgba(0, 212, 180, 0.12)
  static const Color darkTealBorder = Color(0x4D00D4B4); // rgba(0, 212, 180, 0.3)

  static const Color darkAmber = Color(0xFFE8A045);
  static const Color darkAmberHover = Color(0xFFD4892E);
  static const Color darkAmberLight = Color(0x1FE8A045); // rgba(232, 160, 69, 0.12)

  // --- Common Status Colors ---
  static const Color success = Color(0xFF16A34A);
  static const Color successBgLight = Color(0xFFDCFCE7);
  static const Color successBorderLight = Color(0xFF86EFAC);

  static const Color successDark = Color(0xFF22C55E);
  static const Color successBgDark = Color(0x1F22C55E);

  static const Color warning = Color(0xFFE8A045);
  static const Color warningBgLight = Color(0xFFFEF9C3);
  static const Color warningBorderLight = Color(0xFFFDE047);

  static const Color danger = Color(0xFFDC2626);
  static const Color dangerBgLight = Color(0xFFFEE2E2);
  static const Color dangerBorderLight = Color(0xFFFCA5A5);

  static const Color dangerDark = Color(0xFFF87171);
  static const Color dangerBgDark = Color(0x1FEF4444);

  // --- Semantic Color Palettes (Multi-purpose) ---
  static const Color cBlue = Color(0xFF1D4ED8);
  static const Color cBlueBg = Color(0xFFDBEAFE);
  static const Color cBlueBorder = Color(0xFF93C5FD);

  static const Color cPurple = Color(0xFF7E22CE);
  static const Color cPurpleBg = Color(0xFFF3E8FF);
  static const Color cPurpleBorder = Color(0xFFD8B4FE);

  static const Color cRose = Color(0xFFBE123C);
  static const Color cRoseBg = Color(0xFFFFE4E6);
  static const Color cRoseBorder = Color(0xFFFDA4AF);

  static const Color cSlate = Color(0xFF475569);
  static const Color cSlateBg = Color(0xFFF1F5F9);
  static const Color cSlateBorder = Color(0xFFCBD5E1);

  // Teal variations
  static const Color cTeal = Color(0xFF0D6E6E);
  static const Color cTealBg = Color(0xFFE0F4F4);
  static const Color cTealBorder = Color(0xFFA7D9D9);

  // Red variations
  static const Color cRed = Color(0xFFDC2626);
  static const Color cRedBg = Color(0xFFFEE2E2);
  static const Color cRedBorder = Color(0xFFFCA5A5);

  // Amber variations
  static const Color cAmber = Color(0xFFE8A045);
  static const Color cAmberBg = Color(0xFFFEF3E2);
  static const Color cAmberBorder = Color(0xFFF5C68A);

  // Grey variations
  static const Color cGreyBg = Color(0xFFF3F4F6);
  static const Color cGreyBorder = Color(0xFFE5E7EB);

  // Green variations
  static const Color cGreen = Color(0xFF16A34A);
  static const Color cGreenBg = Color(0xFFDCFCE7);
  static const Color cGreenBorder = Color(0xFF86EFAC);

  // Info blue (used for Labs / Reports)
  static const Color info = Color(0xFF0284C7);
  static const Color infoBg = Color(0xFFE0F2FE);
  static const Color infoBorder = Color(0xFF7DD3FC);

  // Shimmer gradients
  static const Gradient amberShimmer = LinearGradient(
    colors: [Color(0xFFE8A045), Color(0xFFF0B060), Color(0xFFE8A045), Color(0xFFD4892E)],
    stops: [0.0, 0.4, 0.6, 1.0],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
  );

  static const Gradient tealShimmer = LinearGradient(
    colors: [Color(0xFF00D4B4), Color(0xFF00E8C8), Color(0xFF00D4B4), Color(0xFF00B89E)],
    stops: [0.0, 0.4, 0.6, 1.0],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
  );
}
