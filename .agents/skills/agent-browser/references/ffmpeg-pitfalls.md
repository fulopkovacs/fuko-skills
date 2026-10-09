# ffmpeg pitfalls (agent-browser recording)

## WebM + H.264 fails

Some `agent-browser` builds pass `libx264` frames but the help text suggests a `.webm` path. WebM does not support H.264, so ffmpeg exits with code 1 and leaves a 0-byte file. Prefer `.mp4` for H.264 output.

Reproduced minimal case:

```sh
ffmpeg -hide_banner -f lavfi -i color=size=64x64:rate=1 -t 1 \
  -c:v libx264 -pix_fmt yuv420p -f webm -y /tmp/probe.webm
# [webm] Only VP8 or VP9 or AV1 video ... are supported for WebM.
```

## Odd frame dimensions fail with libx264

Headless captures can be e.g. 1280x577. libx264 requires even dimensions:

```
[libx264] height not divisible by 2 (1280x577)
```

Fix by padding to even dimensions at encode time (keeps original visible size, adds a 1px edge when odd):

```sh
-vf 'pad=ceil(iw/2)*2:ceil(ih/2)*2'
```

## Event-only `record` output is not wall-clock video

`agent-browser record start/stop` emits frames on events. Long waits collapse, so ffprobe can show 7 frames / 0.2s for a minute-long session. Do not present that as the full test. Re-capture with fixed-cadence CDP screenshots (see `scripts/continuous-capture.mjs`) and verify frame count ≈ elapsed × fps.
