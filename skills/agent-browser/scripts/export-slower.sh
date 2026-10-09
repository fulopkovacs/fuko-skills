#!/usr/bin/env bash
# Export a slower copy of a video: export-slower.sh <input> <output> [factor]
# Default factor is 10 (setpts=10*PTS).
set -euo pipefail
input="${1:?usage: export-slower.sh <input> <output> [factor]}"
output="${2:?usage: export-slower.sh <input> <output> [factor]}"
factor="${3:-10}"
/usr/bin/ffmpeg -v error -y -i "$input" -vf "setpts=${factor}*PTS" -an \
  -c:v libx264 -pix_fmt yuv420p -movflags +faststart "$output"
/usr/bin/ffmpeg -v error -i "$output" -f null -
ffprobe -v error -show_entries format=duration,size -of default=noprint_wrappers=1 "$output"
