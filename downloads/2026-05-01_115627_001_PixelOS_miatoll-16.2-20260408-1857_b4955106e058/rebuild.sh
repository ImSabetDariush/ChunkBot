#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
cat "PixelOS_miatoll-16.2-20260408-1857.zip.part-"* > "PixelOS_miatoll-16.2-20260408-1857.zip"
sha256sum -c "PixelOS_miatoll-16.2-20260408-1857.zip.sha256"
