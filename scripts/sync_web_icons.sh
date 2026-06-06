#!/usr/bin/env bash
# 从 imgs/qqai_logo.png 生成 web/favicon 与 web/icons/*
# - 先居中裁正方形，避免横图压扁
# - favicon 系列做圆形透明裁切；PWA 安装图标保持方形
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

SOURCE="imgs/qqai_logo.png"
ICONS_DIR="web/icons"
VENV="$ROOT/.venv-web-icons"

if [[ ! -f "$SOURCE" ]]; then
  echo "Missing source logo: $SOURCE" >&2
  exit 1
fi

mkdir -p "$ICONS_DIR"

if ! "$VENV/bin/python" -c "import PIL" 2>/dev/null; then
  echo "Preparing icon venv ..."
  python3 -m venv "$VENV"
  "$VENV/bin/pip" install -q pillow
fi
PY="$VENV/bin/python"
CIRCLE_PY="$ROOT/scripts/circle_icon.py"

SQUARE_SRC="$(mktemp "${TMPDIR:-/tmp}/qqai-icon-square.XXXXXX.png")"
cleanup() { rm -f "$SQUARE_SRC"; }
trap cleanup EXIT

"$PY" << PY
from pathlib import Path
from PIL import Image

source = Path("$SOURCE")
out = Path("$SQUARE_SRC")
img = Image.open(source).convert("RGBA")
w, h = img.size
side = min(w, h)
left = (w - side) // 2
top = (h - side) // 2
img.crop((left, top, left + side, top + side)).save(out, "PNG")
print(f"Square crop: {w}x{h} -> {side}x{side}")
PY

gen_icon() {
  local size="$1"
  local out="$2"
  local circular="${3:-false}"
  local args=(--size "$size")
  if [[ "$circular" == "true" ]]; then
    args+=(--circle)
  fi
  "$PY" "$CIRCLE_PY" "$SQUARE_SRC" "$out" "${args[@]}"
}

echo "Generating web icons ..."
gen_icon 16 "$ICONS_DIR/favicon-16x16.png" true
gen_icon 32 "$ICONS_DIR/favicon-32x32.png" true
gen_icon 180 "$ICONS_DIR/apple-touch-icon.png" true
gen_icon 192 "$ICONS_DIR/icon-192.png" false
gen_icon 512 "$ICONS_DIR/icon-512.png" false
gen_icon 1024 "$ICONS_DIR/icon-1024.png" false

cp "$ICONS_DIR/icon-192.png" "$ICONS_DIR/Icon-maskable-192.png"
cp "$ICONS_DIR/icon-512.png" "$ICONS_DIR/Icon-maskable-512.png"
cp "$ICONS_DIR/icon-192.png" "imgs/qqai_site_icon.png"

cp "$ICONS_DIR/favicon-32x32.png" "$ICONS_DIR/favicon.png"
cp "$ICONS_DIR/favicon-32x32.png" "web/favicon.png"

"$PY" << 'PY'
import struct
from pathlib import Path

entries = []
for size, path in ((16, "web/icons/favicon-16x16.png"), (32, "web/icons/favicon-32x32.png")):
    png = Path(path).read_bytes()
    entries.append((size, png))

header = struct.pack("<HHH", 0, 1, len(entries))
offset = 6 + 16 * len(entries)
body = bytearray()
for size, png in entries:
    body.extend(struct.pack("<BBBBHHII", size, size, 0, 0, 1, 32, len(png), offset))
    offset += len(png)
for _, png in entries:
    body.extend(png)

Path("web/favicon.ico").write_bytes(header + body)
print("Wrote web/favicon.ico")
PY

echo "Web icons synced (favicon=circle, PWA=square)."
