import 'dart:io';

void main() {
  final file = File('lib/features/dashboard/presentation/screens/dashboard_screen.dart');
  var text = file.readAsStringSync();

  // Revert all ternary replacements
  final regex = RegExp(r'\(?isDark \? AppColors\.dark([A-Za-z]+) : AppColors\.light\1\)?');
  text = text.replaceAllMapped(regex, (match) {
    return 'AppColors.light${match.group(1)}';
  });

  file.writeAsStringSync(text);
  print('Reverted colors successfully!');
}
