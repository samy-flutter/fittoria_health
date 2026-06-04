import 'dart:io';

void main() {
  final file = File('lib/features/dashboard/presentation/screens/dashboard_screen.dart');
  var text = file.readAsStringSync();

  // Find all AppColors.lightXYZ
  final regex = RegExp(r'AppColors\.light([A-Za-z]+)');
  
  text = text.replaceAllMapped(regex, (match) {
    final name = match.group(1)!;
    final fullMatch = match.group(0)!;
    
    // We can check if it's already inside a ternary by looking at the previous characters.
    // If we simply replace it, we can do it, but to be safe, we just check if it's preceded by " : "
    final start = match.start;
    if (start >= 3) {
      final preceding = text.substring(start - 3, start);
      if (preceding == ' : ') {
        // It's already the false branch of a ternary, leave it alone.
        return fullMatch;
      }
    }
    
    return 'isDark ? AppColors.dark$name : AppColors.light$name';
  });

  file.writeAsStringSync(text);
  print('Second pass color fix done!');
}
