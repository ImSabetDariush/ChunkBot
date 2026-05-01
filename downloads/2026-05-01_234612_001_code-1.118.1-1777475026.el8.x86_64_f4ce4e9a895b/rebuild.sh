#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
cat "code-1.118.1-1777475026.el8.x86_64.rpm.part-"* > "code-1.118.1-1777475026.el8.x86_64.rpm"
sha256sum -c "code-1.118.1-1777475026.el8.x86_64.rpm.sha256"
