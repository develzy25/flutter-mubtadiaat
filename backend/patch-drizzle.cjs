const fs = require('fs');
const path = require('path');
const file = path.join(__dirname, 'node_modules', 'drizzle-kit', 'bin.cjs');
let content = fs.readFileSync(file, 'utf8');
content = content.replace(/process\.stdin\.isTTY/g, 'true');
content = content.replace(/process\.stdout\.isTTY/g, 'true');
fs.writeFileSync(file, content);
