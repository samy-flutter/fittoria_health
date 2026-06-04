import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography system matching the Next.js design system:
/// - `--font-sans`: DM Sans (primary, headings)
/// - `--font-body`: Inter (body text, UI labels)
/// - `--font-ui`:   Space Grotesk (section labels, uppercase)
/// - `--font-mono`: JetBrains Mono (code cells)
class AppTextStyles {
  AppTextStyles._();

  // Font family references (for theme fontFamily property)
  static String get fontSans => GoogleFonts.dmSans().fontFamily!;
  static String get fontBody => GoogleFonts.inter().fontFamily!;
  static String get fontSpace => GoogleFonts.spaceGrotesk().fontFamily!;

  // --- Display Styles (DM Sans Bold, large) ---
  static TextStyle get displayLarge => GoogleFonts.dmSans(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        height: 1.1,
        letterSpacing: -1.0,
      );

  static TextStyle get displayMedium => GoogleFonts.dmSans(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: -0.5,
      );

  static TextStyle get displaySmall => GoogleFonts.dmSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  // --- Heading Styles (DM Sans) ---
  static TextStyle get h1 => GoogleFonts.dmSans(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.3,
      );

  static TextStyle get h2 => GoogleFonts.dmSans(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -0.2,
      );

  static TextStyle get h3 => GoogleFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  // --- Body Styles (Inter) ---
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.45,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  // --- UI Labels (Space Grotesk) ---
  static TextStyle get labelUppercase => GoogleFonts.spaceGrotesk(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      );

  static TextStyle get sectionLabel => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
      );

  // --- Button Styles (DM Sans) ---
  static TextStyle get buttonLarge => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      );

  static TextStyle get buttonMedium => GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.1,
      );

  static TextStyle get buttonSmall => GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      );

  // --- Code (monospace) ---
  static TextStyle get codeCell => GoogleFonts.jetBrainsMono(
        fontSize: 12,
        height: 1.2,
      );
}
