---
name: agent-browser
description: Drive websites with agent-browser and produce trustworthy continuous video evidence. Always load this skill when the user mentions agent-browser, browser recording, browser video, screenshots, filling or clicking pages, or debugging why a browser recording is only a few frames long.
license: MIT
compatibility: opencode
metadata:
  audience: developers
---

# Agent Browser

Use `agent-browser` for real browser interaction. Prefer dedicated subcommands over shell scraping, and never present an event-collapsed clip as a full recording.

## Sessions and basics

- Isolate work with `--session <name>` on every call.
- Discover state before acting:
  `agent-browser --session <name> get url`
  `agent-browser --session <name> snapshot -i`
- Authenticate BEFORE recording. Keep login screens out of the video. Never save credentials in files.
- Chain dependent steps with `&&` in one shell call; snapshot refs (`@e1`) can shift after navigation, so re-snapshot after `open`, `reload`, or `click`.

## Why `record start/stop` misleads

`agent-browser record start <path> / stop` captures event frames, not wall-clock video. Waits collapse, so a minute-long test can export as 7 frames / 0.2s. That is expected behavior of that subcommand, not a full recording.

- Use `record` only for quick demos where collapsed timing is fine.
- For any test where duration matters, use continuous CDP capture below.
- Never "fix" a short clip by stretching it with `setpts` alone. Re-capture continuously instead.

## Helpful probes

```sh
agent-browser record --help
agent-browser --session <name> get cdp-url
curl -s http://127.0.0.1:<port>/json/list
```

The CDP endpoint list shows every page target with `webSocketDebuggerUrl`. Connect to the marked active page (see capture script), not the first target blindly.

## Continuous capture (required for timed tests)

Use `scripts/continuous-capture.mjs`. It captures with CDP `Page.captureScreenshot` at a fixed cadence (default 5fps), preserving real elapsed time:

1. Mark the page under test so the script finds the right target:
   `agent-browser --session <name> eval 'window.__liveCapture=true'`
2. Start the script in the background BEFORE interacting.
3. Perform the real interactions with `agent-browser` (fill, click, wait, scroll).
4. Stop promptly via the stop file or its built-in completion detection. Keep interaction minimal while recording.
5. The script writes per-frame JPEGs, a ffmpeg concat file with real per-frame durations, and a timing JSON with elapsed time and frame count.

Encode the raw video preserving cadence:

```sh
/usr/bin/ffmpeg -v error -f concat -safe 0 -i <prefix>.concat \
  -vf 'pad=ceil(iw/2)*2:ceil(ih/2)*2' -r 5 \
  -c:v libx264 -pix_fmt yuv420p -movflags +faststart <raw>.mp4
```

Export a slower copy with `scripts/export-slower.sh` (uses `setpts=N*PTS`, default 10x).

See `references/ffmpeg-pitfalls.md` for why `.mp4` and even-dimension padding matter.

## Verification (do not skip)

1. `ffprobe` raw and final: duration, size, frame count must be consistent (raw duration ≈ actual elapsed time; slowed duration ≈ raw × factor).
2. Decode check: `/usr/bin/ffmpeg -v error -i <file> -f null -` must succeed.
3. Inspect start/middle/end frames: confirm the prompt was submitted and the complete answer is visible.
4. Report raw duration, final duration, frame counts, and video paths. If continuous capture was unavailable, say so honestly instead of shipping a stretched event clip.
