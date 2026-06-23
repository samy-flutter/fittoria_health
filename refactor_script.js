const fs = require('fs');
const path = require('path');

function walkDir(dir, callback) {
  fs.readdirSync(dir).forEach(f => {
    const dirPath = path.join(dir, f);
    const isDirectory = fs.statSync(dirPath).isDirectory();
    isDirectory ? walkDir(dirPath, callback) : callback(path.join(dir, f));
  });
}

const libDir = path.join('d:', 'fittoria', 'New folder', 'fittoria_patient_app', 'lib', 'features');
walkDir(libDir, function(filePath) {
  if (filePath.endsWith('repository_impl.dart')) {
    let content = fs.readFileSync(filePath, 'utf8');
    let changed = false;

    const pattern3 = /\} catch \(e\) \{\s*return Left\(ServerFailure\(e\.toString\(\)\)\);\s*\}/g;
    if (pattern3.test(content)) {
      content = content.replace(pattern3, '} catch (e) {\n      return Left(ExceptionHandler.handle(e));\n    }');
      changed = true;
    }

    if (changed) {
      if (!content.includes('ExceptionHandler')) {
        const parts = filePath.replace(/\\\\/g, '/').split('/lib/');
        if (parts.length > 1) {
          const depth = parts[1].split('/').length - 1;
          const importPath = '../'.repeat(depth) + 'core/error/exception_handler.dart';
          content = "import '" + importPath + "';\n" + content;
        }
      }
      fs.writeFileSync(filePath, content);
      console.log('Updated: ' + filePath);
    }
  }
});
console.log('Done');
