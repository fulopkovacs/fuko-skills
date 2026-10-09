import fs from 'node:fs/promises';
import { performance } from 'node:perf_hooks';

/*
 * Fixed-cadence CDP screenshot capture.
 *
 * Usage:
 *   node continuous-capture.mjs <cdp-list-url> <marker-expr> <out-prefix> [fps] [max-frames]
 *
 * Example:
 *   node continuous-capture.mjs http://127.0.0.1:46879/json/list \
 *     'window.__liveCapture === true' /tmp/opencode/live-test 5 600
 *
 * Before running, mark the page under test:
 *   agent-browser --session <name> eval 'window.__liveCapture=true'
 *
 * Stop early by creating `<out-prefix>.stop`.
 * Writes: <out-prefix>-frames/*.jpg, <out-prefix>.concat, <out-prefix>-timing.json
 */

const [cdpListUrl, markerExpr, prefix, fpsArg, maxArg] = process.argv.slice(2);
if (!cdpListUrl || !markerExpr || !prefix) {
  console.error('Usage: node continuous-capture.mjs <cdp-list-url> <marker-expr> <out-prefix> [fps] [max-frames]');
  process.exit(1);
}
const fps = Number(fpsArg ?? 5);
const maxFrames = Number(maxArg ?? 600);
const dir = `${prefix}-frames`;
await fs.mkdir(dir, { recursive: true });

async function connect(url) {
  const ws = new WebSocket(url);
  await new Promise((resolve, reject) => { ws.onopen = resolve; ws.onerror = reject; });
  let id = 0;
  const pending = new Map();
  const events = [];
  ws.onmessage = event => {
    const data = JSON.parse(event.data);
    if (data.method) { events.push(data); return; }
    if (!pending.has(data.id)) return;
    const { resolve, reject } = pending.get(data.id);
    pending.delete(data.id);
    data.error ? reject(new Error(JSON.stringify(data.error))) : resolve(data.result);
  };
  return { ws, events, call: (method, params = {}) => new Promise((resolve, reject) => {
    pending.set(++id, { resolve, reject }); ws.send(JSON.stringify({ id, method, params }));
  }) };
}

const targets = await (await fetch(cdpListUrl)).json();
let client;
for (const target of targets.filter(t => t.type === 'page')) {
  const candidate = await connect(target.webSocketDebuggerUrl);
  const result = await candidate.call('Runtime.evaluate', { expression: markerExpr, returnByValue: true });
  if (result.result.value) { client = candidate; break; }
  candidate.ws.close();
}
if (!client) throw new Error('Marked active page not found');

const frames = [];
const start = performance.now();
console.log(`Continuous capture started at ${fps} fps`);
for (let n = 0; n < maxFrames; n++) {
  await new Promise(resolve => setTimeout(resolve, Math.max(0, start + n * (1000 / fps) - performance.now())));
  try { await fs.access(`${prefix}.stop`); break; } catch {}
  const timestamp = (performance.now() - start) / 1000;
  const { data } = await client.call('Page.captureScreenshot', { format: 'jpeg', quality: 85, captureBeyondViewport: false });
  const file = `${dir}/frame-${String(n).padStart(5, '0')}.jpg`;
  await fs.writeFile(file, Buffer.from(data, 'base64'));
  frames.push({ file, timestamp });
}
const elapsed = (performance.now() - start) / 1000;
let concat = '';
for (let i = 0; i < frames.length; i++) {
  concat += `file '${frames[i].file}'\nduration ${((frames[i + 1]?.timestamp ?? elapsed) - frames[i].timestamp).toFixed(6)}\n`;
}
concat += `file '${frames.at(-1).file}'\n`;
await fs.writeFile(`${prefix}.concat`, concat);
await fs.writeFile(`${prefix}-timing.json`, JSON.stringify({ elapsed, count: frames.length, frames }, null, 2));
client.ws.close();
console.log(JSON.stringify({ elapsed, frames: frames.length }));
