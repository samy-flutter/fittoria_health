import 'dart:io';

void main() {
  final file = File('lib/features/dashboard/presentation/screens/dashboard_screen.dart');
  var lines = file.readAsLinesSync();

  final replacements = {
    'AppColors.lightBgSurface': 'isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface',
    'AppColors.lightBorder': 'isDark ? AppColors.darkBorder : AppColors.lightBorder',
    'AppColors.lightTextPrimary': 'isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary',
    'AppColors.lightTextSecondary': 'isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary',
    'AppColors.lightTextMuted': 'isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted',
    'AppColors.lightAmberLight': 'isDark ? AppColors.darkAmberLight : AppColors.lightAmberLight',
    'AppColors.lightAmberBorder': 'isDark ? AppColors.darkAmber : AppColors.lightAmberBorder',
    'AppColors.lightAmber': 'isDark ? AppColors.darkAmber : AppColors.lightAmber',
    'AppColors.lightTealLight': 'isDark ? AppColors.darkTealLight : AppColors.lightTealLight',
    'AppColors.lightTealBorder': 'isDark ? AppColors.darkTeal : AppColors.lightTealBorder',
    'AppColors.lightTeal': 'isDark ? AppColors.darkTeal : AppColors.lightTeal',
    'AppColors.lightBgMuted': 'isDark ? AppColors.darkBgMuted : AppColors.lightBgMuted',
    'AppColors.lightBgBase': 'isDark ? AppColors.darkBgBase : AppColors.lightBgBase',
    'AppColors.dangerBgLight': 'isDark ? AppColors.dangerBgDark : AppColors.dangerBgLight',
    'AppColors.danger': 'isDark ? AppColors.dangerDark : AppColors.danger',
    'AppColors.success': 'isDark ? AppColors.successDark : AppColors.success',
  };

  // 1. Inject isDark into every build method that doesn't have it
  for (var i = 0; i < lines.length; i++) {
    if (lines[i].contains('Widget build(BuildContext context) {')) {
      if (i + 1 < lines.length && !lines[i + 1].contains('isDark') && !lines[i + 2].contains('isDark')) {
        lines.insert(i + 1, '    final isDark = Theme.of(context).brightness == Brightness.dark;');
      }
    }
  }

  var content = lines.join('\n');

  // 3. Replace colors safely
  replacements.forEach((light, dynamicVal) {
    // Replace only if it's not already dynamic (e.g. not preceded by isDark ?)
    final regex = RegExp(r'(?<!isDark\s*\?\s*AppColors\.[a-zA-Z]{0,50}\s*:\s*)' + RegExp.escape(light));
    content = content.replaceAllMapped(regex, (match) {
      return '($dynamicVal)';
    });
  });

  // Since inserting a ternary operator might invalidate some `const` keywords:
  content = content.replaceAll(RegExp(r'const\s+BoxDecoration\('), 'BoxDecoration(');
  content = content.replaceAll(RegExp(r'const\s+Border\('), 'Border(');
  content = content.replaceAll(RegExp(r'const\s+BorderSide\('), 'BorderSide(');
  content = content.replaceAll(RegExp(r'const\s+Icon\('), 'Icon(');
  content = content.replaceAll(RegExp(r'const\s+SizedBox\('), 'SizedBox(');
  content = content.replaceAll(RegExp(r'const\s+EdgeInsets\('), 'EdgeInsets(');
  content = content.replaceAll(RegExp(r'const\s+Divider\('), 'Divider(');

  file.writeAsStringSync(content);
  print('Replaced remaining light colors.');
}
