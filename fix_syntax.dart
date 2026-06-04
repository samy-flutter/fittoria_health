import 'dart:io';

void main() {
  final file = File('lib/features/dashboard/presentation/screens/dashboard_screen.dart');
  var lines = file.readAsLinesSync();

  // Helper to replace text on a specific line (1-indexed)
  void fix(int lineNum, String from, String to) {
    if (lineNum <= lines.length) {
      lines[lineNum - 1] = lines[lineNum - 1].replaceAll(from, to);
    }
  }

  // 1450: The constructor being called isn't a const constructor.
  // wait, the error is at 1445 or 1446 actually, where it says: `border: Border(bottom: BorderSide(color: AppColors.lightBorder),`
  fix(1446, 'AppColors.lightBorder),', 'AppColors.lightBorder)),');
  
  // 1460: Too many positional arguments: 0 expected, but 3 found.
  // It's actually at 1458 `size: 16, color: AppColors.lightTextSecondary,`
  fix(1458, 'AppColors.lightTextSecondary,', 'AppColors.lightTextSecondary),');

  // 1502: `border: Border.all(color: AppColors.lightBorder,`
  fix(1502, 'AppColors.lightBorder,', 'AppColors.lightBorder),');

  // 1538 or so:
  // Let's just fix the rest using regex that adds missing closing parenthesis for `AppColors.light[A-Za-z]+,`
  for (var i = 0; i < lines.length; i++) {
    // If the line contains `color: AppColors.lightSomething,` but it is missing the `)` that it probably should have
    // for `Border.all`, `BorderSide`, `Icon`, etc.
    if (lines[i].contains('Border.all(color: AppColors.light') && !lines[i].contains(')')) {
      lines[i] = lines[i].replaceFirst(',', '),');
    }
    if (lines[i].contains('BorderSide(color: AppColors.light') && !lines[i].contains(')')) {
      lines[i] = lines[i].replaceFirst(',', '),');
    }
    if (lines[i].contains('Icon(') && lines[i].contains('color: AppColors.light') && !lines[i].contains(')')) {
      lines[i] = lines[i].replaceFirst(',', '),');
    }
  }

  // And let's fix _statusColors
  // It was at 1603: `return AppColors.lightAmberLight, AppColors.lightAmberBorder, AppColors.lightAmberHover;`
  for (var i = 1590; i < 1620; i++) {
    if (lines[i].contains('return AppColors.lightAmberLight, AppColors.lightAmberBorder, AppColors.lightAmberHover;')) {
      lines[i] = lines[i].replaceAll('return AppColors.lightAmberLight, AppColors.lightAmberBorder, AppColors.lightAmberHover;', 'return (AppColors.lightAmberLight, AppColors.lightAmberBorder, AppColors.lightAmberHover);');
    }
    if (lines[i].contains('return AppColors.lightTealLight, AppColors.lightTeal, AppColors.lightTeal;')) {
      lines[i] = lines[i].replaceAll('return AppColors.lightTealLight, AppColors.lightTeal, AppColors.lightTeal;', 'return (AppColors.lightTealLight, AppColors.lightTeal, AppColors.lightTeal);');
    }
  }

  // 1659: Expected to find ')'. Expected to find ','
  for (var i = 1640; i < 1670; i++) {
    if (lines[i].contains('Border.all(color: AppColors.light') && !lines[i].contains(')')) {
      lines[i] = lines[i].replaceFirst(',', '),');
    }
  }

  // 1790: The named parameter 'textAlign' isn't defined.
  // 1792: Too many positional arguments...
  for (var i = 1780; i < 1810; i++) {
    if (lines[i].contains('color: AppColors.lightTextMuted,') && lines[i - 1].contains('fontSize:') && !lines[i].contains(')')) {
      // This is inside GoogleFonts.inter() or similar.
      lines[i] = lines[i].replaceFirst(',', '),');
    }
  }

  file.writeAsStringSync(lines.join('\n'));
  print('Fixed syntax errors');
}
