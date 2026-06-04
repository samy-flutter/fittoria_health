import 'dart:io';

void main() {
  final file = File('lib/features/dashboard/presentation/screens/dashboard_screen.dart');
  var lines = file.readAsLinesSync();

  for (var i = 1; i < lines.length; i++) {
    final line = lines[i];
    final prevLine = lines[i - 1];

    if (line.contains('color: AppColors.light') && line.trim().endsWith(',')) {
      if (prevLine.contains('Icon(') || 
          prevLine.contains('GoogleFonts.') ||
          prevLine.contains('BorderSide(') ||
          prevLine.contains('Border.all(') ||
          line.contains('BorderSide(') ||
          line.contains('Border.all(') ||
          line.contains('Icon(') ||
          line.contains('GoogleFonts.')) {
        
        // Ensure it doesn't already have a closing parenthesis
        if (!line.contains(')')) {
          lines[i] = line.replaceFirst(RegExp(r',\s*$'), '),');
        }
      }
    }
  }

  // 1648 `size: 24, color: AppColors.lightTeal,`
  // let's also fix things that are on the same line.
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (line.contains('color: AppColors.light') && line.trim().endsWith(',')) {
       if (!line.contains(')')) {
          lines[i] = line.replaceFirst(RegExp(r',\s*$'), '),');
       }
    }
  }

  file.writeAsStringSync(lines.join('\n'));
  print('Fixed multiline syntax errors');
}
