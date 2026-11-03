# Vilros Menu Boards

**Restaurant menu boards from one Raspberry Pi, with no signage-software subscription.** Edit items and prices from your phone or laptop; TVs refresh automatically.

This is a Vilros installation package for **[Max's Menu](https://github.com/mogrinz/maxs-menu)** by Michael Ogrinz / Ogrinz Labs, the MIT-licensed project in [this video](https://www.youtube.com/watch?v=NY1F6ktmIh4). Original authorship and license are preserved. See [UPSTREAM.md](UPSTREAM.md) for the exact source version and Vilros changes.

## Download and install

- [Download the complete installation ZIP](https://github.com/vilros/uskcode/raw/refs/heads/master/downloads/vilros-menu-boards.zip)
- [Full restaurant setup guide](docs/RESTAURANT_GUIDE.md)
- [Printable staff checklist](docs/STAFF_CHEATSHEET.md)
- [Releases](https://github.com/vilros/uskcode/releases)

Use a fresh **Raspberry Pi OS Lite 64-bit (Trixie)** installation on a Pi 4 or Pi 5. A Pi 3 can also serve the menus. Initial installation needs internet; operation needs a working local network.

Download the ZIP on your computer, copy it to your Pi with `scp`, and run these commands **on the Pi as your normal user**:

```bash
sudo apt-get update
sudo apt-get install -y unzip
cd ~
test ! -e maxs-menu || { echo 'Folder exists. Follow UPGRADING.md.'; exit 1; }
unzip vilros-menu-boards.zip
cd maxs-menu
bash install.sh
```

The guided installer installs dependencies, asks for your restaurant name, time zone and a new administrator login, loads example menus, and enables automatic startup. Choose **no** for the optional hotspot on your first installation unless you need it. There is no shared default password.

Open `http://YOUR_PI_IP:8080/admin` on your phone or laptop. Set each TV's kiosk browser to:

| TV | Start URL |
| --- | --- |
| 1 | `http://YOUR_PI_IP:8080/display/screen1` |
| 2 | `http://YOUR_PI_IP:8080/display/screen2` |
| 3 | `http://YOUR_PI_IP:8080/display/screen3` |

Addresses continue through `screen10`. Reserve the Pi's IP in your router. Each TV needs an Android/Google TV device with a compatible browser; see the guide for setup and reboot checks.

## Included

- Ten menu definitions and ten screen addresses; duplicate a screen on several TVs.
- Live menu editing, optional prices, sold-out items, sections and two-column layouts.
- Daily breakfast/lunch scheduling in your restaurant's time zone.
- Eleven themes and menu rotation for portrait displays.
- Separate administrator and employee accounts, edit history and backups.
- Local storage and optional offline Pi hotspot; no hosted account required.
- Automatic Pi service startup and a health endpoint at `/health`.
- All source code, assets, font licenses, installation scripts, upstream tests and guides.

## Hardware and cost

One Pi kit (board, suitable power supply, case/cooling and 32 GB or larger microSD), one TV and Android player per board, and a local router/network. A wired Pi connection is recommended. A three-screen planning example is $900 for three TVs plus $90 for three players plus your Pi kit, mounts, cables and tax. These are estimates, not current product quotes. Browse [Vilros Raspberry Pi kits](https://vilros.com/collections/raspberry-pi-kits).

## Before using it in a restaurant

This is a **guided install**, not a preflashed SD-card image. Player app installation, kiosk startup, local network setup and TV settings still require configuration. Fully Kiosk Browser is third-party software; available features and licensing vary. Verify the free features you need on one player before purchasing several. Internet loss is different from losing the Pi or Wi-Fi: boards need the Pi to load and receive updates.

The bundled application version is upstream `1.0.0-rc3`. See [VALIDATION_VILROS.md](VALIDATION_VILROS.md) for checks and remaining hardware acceptance tests. Do not expose port 8080 to the internet. Use a trusted restaurant network; this local HTTP setup does not encrypt traffic.

## Maintenance and development

```bash
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements.txt
.venv/bin/python -m unittest discover -s tests -v
.venv/bin/python -m compileall -q .
bash -n install.sh setup.sh upgrade.sh run.sh
python3 build_release.py ../vilros-menu-boards.zip
```

Use [UPGRADING.md](UPGRADING.md) for existing installations. See [USER_GUIDE.md](USER_GUIDE.md), [TROUBLESHOOTING.md](TROUBLESHOOTING.md), [ONN_WIFI_AUTOCONNECT.md](ONN_WIFI_AUTOCONNECT.md), and the unchanged [upstream README](UPSTREAM_README.md) for advanced configuration. Keep private backups off the Pi.

**License:** MIT for the application, with the original copyright retained; bundled fonts have separate SIL OFL notices. No affiliation or endorsement by the original author is implied.
