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

    const errRegex1 = /ScaffoldMessenger\.of\(context\)\.showSnackBar\(\s*SnackBar\(\s*content:\s*Text\(([^)]+)\),\s*backgroundColor:\s*Colors\.red,?\s*\),?\s*\);/g;
    content = content.replace(errRegex1, 'UIHelpers.showErrorSnackBar(context, $1);');

    const errRegex2 = /ScaffoldMessenger\.of\(context\)\.showSnackBar\(SnackBar\(content:\s*Text\(([^)]+)\)\)\);/g;
    content = content.replace(errRegex2, (match, p1) => {
      if (p1.toLowerCase().includes('success') || p1.toLowerCase().includes('joined')) {
        return 'UIHelpers.showSuccessSnackBar(context, ' + p1 + ');';
      }
      return 'UIHelpers.showErrorSnackBar(context, ' + p1 + ');';
    });

    const errRegex3 = /ScaffoldMessenger\.of\(context\)\.showSnackBar\(const SnackBar\(content:\s*Text\(([^)]+)\)\)\);/g;
    content = content.replace(errRegex3, (match, p1) => {
      if (p1.toLowerCase().includes('success') || p1.toLowerCase().includes('joined')) {
        return 'UIHelpers.showSuccessSnackBar(context, ' + p1 + ');';
      }
      return 'UIHelpers.showErrorSnackBar(context, ' + p1 + ');';
    });

    const errRegex4 = /ScaffoldMessenger\.of\(context\)\.showSnackBar\(\s*SnackBar\(\s*content:\s*Text\(([^)]+)\),\s*backgroundColor:\s*Colors\.red,\s*behavior:\s*SnackBarBehavior\.floating,?\s*\),?\s*\);/g;
    content = content.replace(errRegex4, 'UIHelpers.showErrorSnackBar(context, $1);');
    
    const errRegex5 = /ScaffoldMessenger\.of\(context\)\.showSnackBar\(\s*SnackBar\(\s*content:\s*Text\(([^)]+)\),?\s*\),?\s*\);/g;
    content = content.replace(errRegex5, 'UIHelpers.showErrorSnackBar(context, $1);');

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
