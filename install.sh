#!/usr/bin/env bash
# Guided fresh installation on Raspberry Pi OS Lite (Debian 13 / Trixie).
set -euo pipefail
cd "$(dirname "$0")"
if [[ "$EUID" -eq 0 ]]; then
  echo 'Run bash install.sh as your normal Pi user, without sudo.' >&2
  exit 1
fi
trap 'echo "Installation stopped. Fix the error above and rerun bash install.sh. See docs/RESTAURANT_GUIDE.md." >&2' ERR
for menu_command in python3 apt-get sudo systemctl; do
  command -v "$menu_command" >/dev/null || { echo "Missing command: $menu_command. Use Raspberry Pi OS Lite." >&2; exit 1; }
done
python3 -c 'import sys; assert sys.version_info >= (3,11), "Python 3.11 or newer is required"'
if [[ ! -t 0 ]]; then
  echo 'Use an interactive terminal: this installer asks for your site name and administrator credentials.' >&2
  exit 1
fi
if [[ "$PWD" =~ [[:space:]] ]]; then
  echo 'Extract into a directory without spaces, for example ~/maxs-menu.' >&2
  exit 1
fi
if [[ -e data/users.json || -e data/menu-state.json ]]; then
  echo 'Existing installation detected. Use UPGRADING.md; this is a fresh-install script.' >&2
  exit 1
fi
printf '%s\n' 'Vilros Menu Boards — powered by Max’s Menu' 'Internet is needed for installation. The menus run locally afterward.'
sudo apt-get update
sudo apt-get install -y python3-venv python3-pip tzdata curl ca-certificates
bash setup.sh
if .venv/bin/python -c 'from models import Store; raise SystemExit(0 if Store().state()["settings"]["hotspot_enabled"] else 1)'; then
  sudo apt-get install -y hostapd dnsmasq-base
fi
sudo python3 install_service.py
printf '\n%s\n' 'Installation complete. Reserve this Pi’s IP address in your router.'
hostname -I
printf '%s\n' 'Editor: http://YOUR_PI_IP:8080/admin' 'TV 1:   http://YOUR_PI_IP:8080/display/screen1' 'TV 2:   http://YOUR_PI_IP:8080/display/screen2' 'TV 3:   http://YOUR_PI_IP:8080/display/screen3' 'Next: follow docs/RESTAURANT_GUIDE.md to configure and restart-test each TV.'
