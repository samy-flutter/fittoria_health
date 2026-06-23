const fs = require('fs');
const path = require('path');

function processFile(filePath) {
  let content = fs.readFileSync(filePath, 'utf8');
  if (!content.includes('appBar: AppBar(') && !content.includes('appBar:  AppBar(')) return;

  // Calculate relative path to lib/core/widgets/custom_app_bar.dart
  const libCoreWidgets = path.resolve('lib/core/widgets/custom_app_bar.dart');
  const fileDir = path.dirname(path.resolve(filePath));
  let relPath = path.relative(fileDir, libCoreWidgets).replace(/\\/g, '/');
  
  if (!content.includes('custom_app_bar.dart')) {
    const importStatement = `import '${relPath}';\n`;
    const lastImportIndex = content.lastIndexOf('import ');
    if (lastImportIndex !== -1) {
      const endOfLastImport = content.indexOf('\n', lastImportIndex) + 1;
      content = content.substring(0, endOfLastImport) + importStatement + content.substring(endOfLastImport);
    } else {
      content = importStatement + content;
    }
  }

  // Rename AppBar to CustomAppBar
  content = content.replace(/appBar:\s*AppBar\(/g, 'appBar: CustomAppBar(');

  // Remove elevation
  content = content.replace(/\belevation:\s*[0-9.]+,\s*/g, '');

  // Remove backgroundColor
  content = content.replace(/\bbackgroundColor:\s*[^,]*(?:,[^,]*)*?,\s*/g, (match) => {
    if (match.includes('Colors.transparent') || match.includes('AppColors.lightBg') || match.includes('AppColors.darkBg')) {
      return '';
    }
    return match; // keep if it's something highly custom
  });

  // Remove boilerplate leading block
  let index = 0;
  while ((index = content.indexOf('leading: IconButton(', index)) !== -1) {
    let braces = 0;
    let end = index + 'leading: IconButton('.length;
    let found = false;
    for (let i = end; i < content.length; i++) {
      if (content[i] === '(') braces++;
      if (content[i] === ')') {
        if (braces === 0) {
          end = i + 1;
          found = true;
          break;
        }
        braces--;
      }
    }
    if (found) {
      const leadingBlock = content.substring(index, end);
      if (leadingBlock.includes('LucideIcons.arrowLeft') || leadingBlock.includes('Icons.arrow_back')) {
         // also remove trailing comma and whitespace
         let finalEnd = end;
         while (finalEnd < content.length && (content[finalEnd] === ',' || content[finalEnd] === ' ' || content[finalEnd] === '\n' || content[finalEnd] === '\r')) {
           finalEnd++;
         }
         content = content.substring(0, index) + content.substring(finalEnd);
         continue; // Don't increment index, we just shrunk the string
      }
    }
    index++;
  }

  fs.writeFileSync(filePath, content);
  console.log('Migrated ' + filePath);
}

function walkSync(dir) {
  const files = fs.readdirSync(dir);
  for (const file of files) {
    const filePath = path.join(dir, file);
    const stat = fs.statSync(filePath);
    if (stat.isDirectory()) {
      walkSync(filePath);
    } else if (filePath.endsWith('.dart')) {
      processFile(filePath);
    }
  }
}

walkSync('lib/features');
walkSync('lib/core/presentation');
