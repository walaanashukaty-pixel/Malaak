#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';
import zlib from 'node:zlib';
import { execFileSync } from 'node:child_process';
import { pathToFileURL } from 'node:url';

const root = path.resolve(path.dirname(new URL(import.meta.url).pathname), '..');
const srcRoot = path.join(root, 'supabase/functions/malaak-ai');
const outDir = path.join(root, 'build/malaak-edge-deploy');
fs.mkdirSync(outDir, { recursive: true });

const npmRoot = execFileSync('npm', ['root', '-g'], { encoding: 'utf8' }).trim();
const tsModule = await import(pathToFileURL(path.join(npmRoot, 'typescript/lib/typescript.js')).href);
const ts = tsModule.default ?? tsModule;

const files = [
  'types.ts',
  'fallback_interventions.ts',
  'observation.ts',
  'hypothesis_engine.ts',
  'formulation.ts',
  'journey_planner.ts',
  'progress_engine.ts',
  'router.ts',
  'catalog.ts',
  'coach.ts',
  'formulation_repository.ts',
  'journey_repository.ts',
  'index.ts',
];

const modules = {};
for (const file of files) {
  const source = fs.readFileSync(path.join(srcRoot, file), 'utf8');
  modules[`./${file}`] = ts.transpileModule(source, {
    compilerOptions: {
      target: ts.ScriptTarget.ES2022,
      module: ts.ModuleKind.CommonJS,
      esModuleInterop: true,
    },
  }).outputText;
}

let bundle = '// Generated deployment bundle from checked-in Malaak Edge source modules.\n';
bundle += 'const __mods = Object.create(null);\n';
for (const [id, code] of Object.entries(modules)) {
  bundle += `__mods[${JSON.stringify(id)}]=function(require,exports,module){\n${code}\n};\n`;
}
bundle += String.raw`
const __cache=Object.create(null);
function __resolve(from,spec){
  if(spec.startsWith('jsr:')) return spec;
  if(!spec.startsWith('.')) return spec;
  const base=from.split('/'); base.pop();
  for(const part of spec.split('/')){ if(part===''||part==='.') continue; if(part==='..') base.pop(); else base.push(part); }
  let id=base.join('/'); if(!id.startsWith('.')) id='./'+id; return id;
}
function __require(id,from='./index.ts'){
  const resolved=__resolve(from,id);
  if(resolved.startsWith('jsr:')) return {};
  if(__cache[resolved]) return __cache[resolved].exports;
  const fn=__mods[resolved]; if(!fn) throw new Error('Missing bundled module: '+resolved+' from '+from);
  const module={exports:{}}; __cache[resolved]=module;
  fn((spec)=>__require(spec,resolved),module.exports,module); return module.exports;
}
__require('./index.ts','./index.ts');
`;

const compressed = zlib.gzipSync(Buffer.from(bundle), { level: 9, mtime: 0 });
const b64 = compressed.toString('base64');
const loader = `// Generated deployment artifact. Source-of-truth remains the checked-in Malaak Edge modules.\nconst __b64 = ${JSON.stringify(b64)};\nconst __bytes = Uint8Array.from(atob(__b64), c => c.charCodeAt(0));\nconst __stream = new Blob([__bytes]).stream().pipeThrough(new DecompressionStream('gzip'));\nconst __code = await new Response(__stream).text();\n(0, eval)(__code);\n`;

fs.writeFileSync(path.join(outDir, 'index.ts'), loader);
fs.writeFileSync(path.join(outDir, 'bundle.js'), bundle);
fs.copyFileSync(path.join(srcRoot, 'deno.json'), path.join(outDir, 'deno.json'));
console.log(JSON.stringify({ modules: files.length, bundleBytes: Buffer.byteLength(bundle), loaderBytes: Buffer.byteLength(loader), outDir }, null, 2));
