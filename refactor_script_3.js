const fs = require('fs');
const path = require('path');

function walkDir(dir, callback) {
  fs.readdirSync(dir).forEach(f => {
    const dirPath = path.join(dir, f);
    const isDirectory = fs.statSync(dirPath).isDirectory();
    isDirectory ? walkDir(dirPath, callback) : callback(path.join(dir, f));
  });
}

const libDir = path.join('d:', 'fittoria', 'New folder', 'fittoria_patient_app', 'lib');
walkDir(libDir, function(filePath) {
  if (filePath.endsWith('.dart')) {
    let content = fs.readFileSync(filePath, 'utf8');
    let original = content;

    // A very loose regex that finds ScaffoldMessenger and extracts the Text(content)
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Failed to download.'),
    //     backgroundColor: Colors.red,
    //   ),
    // );
    const regex = /ScaffoldMessenger\.of\(context\)\.showSnackBar\(\s*SnackBar\(\s*content:\s*Text\(([^)]+)\)[^;]+;\s*/g;
    
    content = content.replace(regex, (match, textContent) => {
      if (textContent.toLowerCase().includes('success') || textContent.toLowerCase().includes('joined') || match.toLowerCase().includes('colors.green')) {
        return 'UIHelpers.showSuccessSnackBar(context, ' + textContent + ');\n';
      } else {
        return 'UIHelpers.showErrorSnackBar(context, ' + textContent + ');\n';
      }
    });

    if (content !== original) {
      if (!content.includes('UIHelpers')) {
        const parts = filePath.replace(/\\\\/g, '/').split('/lib/');
        if (parts.length > 1) {
          const depth = parts[1].split('/').length - 1;
          const importPath = '../'.repeat(depth) + 'core/utils/ui_helpers.dart';
          content = "import '" + importPath + "';\n" + content;
        }
      }
      fs.writeFileSync(filePath, content);
      console.log('Updated: ' + filePath);
    }
  }
});
console.log('Done');
