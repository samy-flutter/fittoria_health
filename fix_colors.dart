import 'dart:io';

void main() {
  final file = File('lib/features/dashboard/presentation/screens/dashboard_screen.dart');
  var text = file.readAsStringSync();

  final widgets = [
    '_PendingInvoiceAlert',
    '_SectionHeader',
    '_KpiGrid',
    '_KpiCard',
    '_ActionCard',
    '_AppointmentListTile',
    '_ServiceTile',
    '_ClinicListTile',
  ];

  for (final w in widgets) {
    // Only target the specific widget's build method
    final buildRegex = RegExp(r'class ' + w + r' extends (?:Stateless|Stateful)Widget \{.*?Widget build\(BuildContext context\) \{', dotAll: true);
    
    text = text.replaceAllMapped(buildRegex, (match) {
      final str = match.group(0)!;
      if (str.contains('final isDark =')) return str;
      return str.replaceFirst('Widget build(BuildContext context) {', 'Widget build(BuildContext context) {\n    final isDark = Theme.of(context).brightness == Brightness.dark;');
    });
  }

  // Helper to replace only un-ternarized colors
  String safeReplace(String source, String lightColor, String darkColor) {
    // Don't replace if it's already part of a ternary like `isDark ? dark : light`
    final regex = RegExp(r'(?<!:\s*)' + RegExp.escape(lightColor));
    return source.replaceAllMapped(regex, (m) {
      return '(isDark ? $darkColor : $lightColor)';
    });
  }

  text = safeReplace(text, 'AppColors.lightAmberLight', 'AppColors.darkAmberLight');
  text = safeReplace(text, 'AppColors.lightAmberBorder', 'AppColors.darkAmberBorder');
  text = safeReplace(text, 'AppColors.lightAmberHover', 'AppColors.darkAmberHover');
  text = safeReplace(text, 'AppColors.lightAmber', 'AppColors.darkAmber');
  text = safeReplace(text, 'AppColors.lightTextMuted', 'AppColors.darkTextMuted');
  text = safeReplace(text, 'AppColors.lightBgSurface', 'AppColors.darkBgSurface');
  text = safeReplace(text, 'AppColors.lightBorder', 'AppColors.darkBorder');
  text = safeReplace(text, 'AppColors.lightTextPrimary', 'AppColors.darkTextPrimary');
  text = safeReplace(text, 'AppColors.lightTextSecondary', 'AppColors.darkTextSecondary');
  text = safeReplace(text, 'AppColors.lightTealLight', 'AppColors.darkTealLight');
  text = safeReplace(text, 'AppColors.lightTeal', 'AppColors.darkTeal');
  text = safeReplace(text, 'AppColors.lightBgBase', 'AppColors.darkBgBase');

  file.writeAsStringSync(text);
  print('Dashboard colors updated successfully!');
}
