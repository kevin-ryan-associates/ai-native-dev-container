#!/usr/bin/env node
const { spawnSync } = require('child_process');
const path = require('path');
const fs = require('fs');

const pkgRoot = path.resolve(__dirname, '..');
const script = path.join(pkgRoot, 'ainative');

if (!fs.existsSync(script)) {
  console.error(`ainative: launcher script missing at ${script}`);
  process.exit(1);
}

const result = spawnSync(script, process.argv.slice(2), {
  stdio: 'inherit',
  env: { ...process.env, AINATIVE_HOME: pkgRoot },
});

if (result.status !== null) {
  process.exit(result.status);
}
if (result.signal) {
  process.exit(128);
}
process.exit(1);