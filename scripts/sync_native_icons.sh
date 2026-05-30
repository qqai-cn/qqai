#!/usr/bin/env bash
# 从 web/icons/icon-1024.png 生成 Android / iOS / macOS / Windows 启动图标。
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

SOURCE="web/icons/icon-1024.png"
if [[ ! -f "$SOURCE" ]]; then
  echo "Missing web icon source: $SOURCE" >&2
  exit 1
fi

flutter pub get
dart run flutter_launcher_icons

echo "Native launcher icons synced from $SOURCE"
