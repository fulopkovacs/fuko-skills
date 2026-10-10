#!/usr/bin/env bash
# Renders a Rive project into a transparent HEVC video.
#
#   GEN="python3 tools/generate.py" render.sh <project-dir> <total-frames-at-60fps> <out-name>
#
# GEN regenerates <project-dir>/scene.rml and must honour RIVE_BG (ARGB
# background) and RIVE_SCALE (render scale). Writes:
#   out/<out-name>.mov  HEVC with alpha (hvc1, Rec.709), 30fps, at SCALE (default 2)
#   out/<out-name>.mp4  H.264 on black at 1x, for a quick look
# Env: SCALE (default 2), JOBS (default 8), FORCE=1 to overwrite.
set -euo pipefail

PROJECT=${1:?project dir}
TOTAL=${2:?total frames at 60fps}
NAME=${3:?output name}
GEN=${GEN:?set GEN to the command that writes scene.rml}
SCALE=${SCALE:-2}
JOBS=${JOBS:-8}
FPS=30
STEP=$((60 / FPS))
FRAMES=$((TOTAL / STEP))
SECONDS_LONG=$(echo "scale=4; $TOTAL / 60" | bc)
TMP=render-$NAME

for f in "out/$NAME.mov" "out/$NAME.mp4"; do
  if [[ -e $f && ${FORCE:-0} != 1 ]]; then
    echo "$f exists; pick a new name or set FORCE=1" >&2
    exit 1
  fi
done
rm -rf "$TMP" && mkdir -p "$TMP/black" "$TMP/white" out

# Captures clear to an opaque colour: render on black and on white, then
# alpha = 1 - (white - black), colour = black / alpha.
pass() {
  RIVE_BG=$1 RIVE_SCALE=$SCALE $GEN >/dev/null
  rive "$PROJECT" --verify
  # output frame N = the scene after N*STEP steps of 1/60s
  seq 1 "$FRAMES" | xargs -P "$JOBS" -I{} sh -c \
    "rive '$PROJECT' --quiet --screenshot='$TMP/$2/'\$(printf 'f%04d' {}).png --advance=\$(({} * $STEP)) >/dev/null"
}
pass FF000000 black
pass FFFFFFFF white
RIVE_SCALE=1 $GEN >/dev/null   # leave the scene at its defaults

# Rec.709 tags go on the frames (setparams) before encoding; remuxing the
# HEVC afterwards breaks it for Apple's decoder.
ffmpeg -v error -n -framerate $FPS -i "$TMP/black/f%04d.png" \
  -framerate $FPS -i "$TMP/white/f%04d.png" -filter_complex \
  "[0]format=gbrp,split[b1][b2];[1]format=gbrp[w];
   [w][b1]blend=all_mode=difference,format=gray,negate,split[a1][a2];
   [b2][a1]unpremultiply=inplace=0[c];[c][a2]alphamerge,format=bgra,setparams=color_primaries=bt709:color_trc=bt709:colorspace=bt709[v]" \
  -map "[v]" -c:v hevc_videotoolbox -alpha_quality 0.9 -b:v 40M -tag:v hvc1 \
  -color_primaries bt709 -color_trc bt709 -colorspace bt709 \
  -t "$SECONDS_LONG" "out/$NAME.mov"

W=$(( $(ffprobe -v error -select_streams v:0 -show_entries stream=width -of csv=p=0 "out/$NAME.mov") / ${SCALE%.*} ))
ffmpeg -v error -n -framerate $FPS -i "$TMP/black/f%04d.png" \
  -vf "scale=$W:-2:flags=lanczos,format=yuv420p" -c:v libx264 -crf 16 -t "$SECONDS_LONG" \
  "out/$NAME.mp4"

rm -rf "$TMP"
echo "wrote out/$NAME.mov and out/$NAME.mp4"
