#!/usr/bin/env bash
# Gaming happens only on the desktop; laptops and macOS skip Steam.
set -euo pipefail
[[ "$(hostnamectl chassis 2>/dev/null)" == desktop ]] || exit 0
flatpak info --user com.valvesoftware.Steam >/dev/null 2>&1 && exit 0
flatpak install --user --noninteractive flathub com.valvesoftware.Steam
