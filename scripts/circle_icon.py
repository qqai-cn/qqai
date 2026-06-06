#!/usr/bin/env python3
"""从正方形 PNG 生成指定尺寸图标，可选圆形透明裁切。"""
from __future__ import annotations

import argparse
from pathlib import Path

from PIL import Image, ImageDraw


def render(source: Path, output: Path, size: int, circular: bool) -> None:
    img = Image.open(source).convert("RGBA")
    img = img.resize((size, size), Image.Resampling.LANCZOS)
    if circular:
        mask = Image.new("L", (size, size), 0)
        draw = ImageDraw.Draw(mask)
        draw.ellipse((0, 0, size - 1, size - 1), fill=255)
        rounded = Image.new("RGBA", (size, size), (0, 0, 0, 0))
        rounded.paste(img, (0, 0), mask)
        img = rounded
    output.parent.mkdir(parents=True, exist_ok=True)
    img.save(output, "PNG")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--size", type=int, required=True)
    parser.add_argument(
        "--circle",
        action="store_true",
        help="圆形裁切，圆外透明（适用于 favicon / 标签页）",
    )
    args = parser.parse_args()
    render(args.source, args.output, args.size, args.circle)


if __name__ == "__main__":
    main()
