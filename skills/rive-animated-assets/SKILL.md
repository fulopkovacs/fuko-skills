---
name: rive-animated-assets
description: Make animated video assets (overlays, lower thirds, terminal recreations, outros) with the Rive CLI and render them as small HEVC files with a transparent background, ready for DaVinci Resolve or Final Cut. Only use when the user explicitly invokes this skill by name; never load it automatically.
disable-model-invocation: true
license: MIT
compatibility: opencode
metadata:
  audience: video creators
---

# Rive animated assets

Build the animation as a Rive project, capture it frame by frame, and encode
**HEVC with alpha**: transparent, about 5–20 MB for 10 s (ProRes 4444 is
~1 GB for the same clip).

## 0. Check the requirements first

Before doing anything else, run:

```sh
uname -s                                    # must print Darwin (macOS)
command -v rive ffmpeg ffprobe bc
ffmpeg -hide_banner -encoders | grep hevc_videotoolbox
```

If any check fails, **stop and tell the user** what's missing and how to get
it. Don't start building or look for workarounds:

- Not macOS: this pipeline needs VideoToolbox for HEVC with alpha. Say so;
  ProRes 4444 is the cross-platform alternative, but it's ~50× bigger.
- `rive` missing: install the Rive CLI (`rive doctor` checks the setup).
- `ffmpeg`/`ffprobe` missing, or no `hevc_videotoolbox`: `brew install ffmpeg`.

## 1. Build the scene

- Scaffold with `rive create`, then read `rive docs` before writing RML.
- Generate `scene.rml` from a script (Python is fine) instead of hand-writing
  it: positions, timings and keyframes are easier as code, and you can
  re-render after every tweak.
- Lay out at the delivery size (e.g. 1080×1920 for 9:16) and key at 60 fps.
- The script must honour two env vars, so `scripts/render.sh` can drive it:
  - `RIVE_BG`: the artboard background fill, ARGB (default `00000000`).
  - `RIVE_SCALE`: wrap everything in a node scaled by this, and multiply the
    artboard size by it (default `1`).
- Check every change: `rive <dir> --verify`, `rive inspect <dir> --summary`,
  then look at frames: `rive <dir> --screenshot=f.png --advance=<frame>`.

Gotchas that cost time:

- The first declared child draws on top.
- Keyframes without an interpolator are hold keys (good for text swaps).
- `Feather` only renders on a stroke, not on a fill.
- Color emoji (Apple Color Emoji) don't render as text; extract the PNG from
  the font's `sbix` table and place it as an image.
- Subset fonts (`pyftsubset`) to the characters you use.
- Keep the background transparent: no glows or haze outside the subject, or
  the editor shows them as a tinted box.

## 2. Render

Run [`scripts/render.sh`](scripts/render.sh):

```sh
GEN="python3 tools/generate.py" scripts/render.sh <project-dir> <total-frames-at-60fps> <out-name>
```

What it does, and why:

1. **Transparency:** captures always clear to an opaque colour, so every
   frame is rendered twice, on black and on white. The alpha is derived from
   the difference between the two.
2. **30 fps:** captures every second 60 fps frame. That's plenty for overlays
   and halves the render time.
3. **2× resolution:** HEVC with alpha only supports 4:2:0, which stores colour
   at half resolution. Thin coloured text looks washed out at 1×. At 2×
   (2160×3840), colour is full resolution once scaled onto a 1080p timeline.
4. **Rec.709 tags, set on the frames before encoding.** Remuxing the HEVC
   afterwards (even `-c copy`) leaves a file Apple's decoder refuses to open.
5. **Never overwrites:** it refuses if `out/<name>.mov` exists. Use a new name
   for every version.

Outputs: `out/<name>.mov` (HEVC + alpha) and `out/<name>.mp4` (on black, for
a quick look).

## 3. Verify

- `ffprobe` the `.mov`: expect `hevc`, `hvc1`, 30 fps, `bt709`.
- Check the alpha with an **Apple decoder** (AVFoundation, QuickTime).
  ffmpeg's own HEVC decoder ignores the alpha layer, so the file looks
  opaque there even though it isn't.
- Composite a frame over a solid colour and look at it: background fully
  transparent, shadows soft, colours not faded.

## 4. Hand over

Tell the user, every time:

> **In DaVinci Resolve, the clip may look washed out.** Fix it per clip:
> Media Pool → right-click the clip → **Clip Attributes… → Video → Data
> Levels → Video**. Then scale the 2× clip to fit a 1080×1920 timeline (50%).

Also mention: the alpha only works in Apple-decoder apps (Resolve, Final Cut
and Premiere on macOS, QuickTime); and list what you invented (placeholder
text, filled-in copy), so they can correct it.
