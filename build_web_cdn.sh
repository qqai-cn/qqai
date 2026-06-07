#!/usr/bin/env bash
exec "$(dirname "$0")/build_web.sh" cdn "$@"
