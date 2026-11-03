# Build local restaurant menu boards with Raspberry Pi

Run up to ten menu screens from one Pi, edit prices from your phone and schedule breakfast and lunch. A guided Vilros installation of Michael Ogrinz's open-source Max's Menu, with no signage-software subscription.

Original software: **Michael Ogrinz / Ogrinz Labs**, MIT license. Vilros installation/documentation adaptation. See [UPSTREAM.md](../UPSTREAM.md).

**Download:** [complete installation ZIP](https://github.com/vilros/uskcode/raw/refs/heads/master/downloads/vilros-menu-boards.zip)

**Time:** 1–3 hours plus hardware acceptance testing

## What you need

- Raspberry Pi 3/4/5, suitable power supply, case/cooling and 32 GB+ microSD
- HDMI TVs and one compatible Android/Google TV player per display
- Local router/network, preferably Ethernet for the Pi
- Computer for imaging, SSH and file transfer; phone or laptop for editing
- Internet for initial installation and player setup

## 1. Plan the screens, hardware and budget

Choose a reliable local setup before buying or mounting displays.

1. This project packages Max's Menu by Michael Ogrinz / Ogrinz Labs, the MIT-licensed software from the linked video. Vilros adds a guided installer, downloadable package and this guide. The application version is 1.0.0-rc3; it is a release candidate, so complete the acceptance tests before restaurant use.
2. Use one Raspberry Pi 4 or Pi 5 with a suitable power supply, case/cooling and a 32 GB or larger microSD card. A Pi 3 can also serve menus. The Pi is the server; it does not need an HDMI cable to every TV.
3. For every TV, provide an HDMI input, an Android/Google TV player and its own power adapter. The video uses the onn. Full HD Google TV device. Test one player before ordering several; browser availability and automatic launch vary by firmware. Other devices, including Fire TV, are not assumed compatible.
4. Use Ethernet from the Pi to a router where possible. Players and the staff phone/laptop must be able to reach the Pi on the same local network. Guest Wi-Fi with client isolation can prevent this. A local router can keep working when its internet connection is down.
5. Planning example: three TVs at $300 each ($900), three players at $30 each ($90), plus a Pi kit, mounts, cables and tax. This is a budget illustration, not a current quote. Consumer TV commercial-use warranties vary; avoid OLED for static menus and check ventilation/portrait support.
6. Bench-test the complete system with one spare TV before wall mounting. Allow roughly 1–3 hours for a first installation, plus TV/player updates and final testing.

**Checkpoint:** You have one Pi, the right power supply, storage, a local network, and one compatible player per TV.

## 2. Prepare Raspberry Pi OS and remote access

Start with a clean, reachable Pi that belongs to you.

1. On your computer, open Raspberry Pi Imager. Select your board, Raspberry Pi OS Lite 64-bit (Trixie), and the intended microSD card. Writing the image erases the selected card; check its identity first.
2. In Imager customization, set hostname menuboard, create your own Pi OS username and strong password, enable SSH, and set your Wi-Fi country. Enter your Wi-Fi details if you will not use Ethernet. Record the OS credentials.
3. Insert the card, connect Ethernet if using it, then connect power. Wait for first boot. Find the Pi in the router device list. Try menuboard.local from your computer; use the numeric IP if local names do not resolve.
4. Open Terminal on macOS/Linux or PowerShell on Windows. Replace YOUR_PI_USER below. Accept the SSH fingerprint only after checking you are reaching your Pi. The Pi OS login is separate from the application administrator login you will create later.

```bash
ssh YOUR_PI_USER@menuboard.local
```

If the hostname fails, replace menuboard.local with the IP from your router.

**Checkpoint:** You see a command prompt on the Pi through SSH.

**Could not resolve hostname or connection timed out.** Use the numeric IP from your router. Check SSH was enabled and that the computer and Pi can reach each other; avoid isolated guest Wi-Fi.

## 3. Download the complete package and copy it to the Pi

Put the installation ZIP on your Pi without overwriting existing menus.

1. On your computer, use the Complete installation ZIP link in Files and next steps below. Save it as vilros-menu-boards.zip. It contains the application, local fonts, sample menus, scripts, tests, license and guides; no restaurant credentials or private data are included.
2. Open a second terminal on your computer and change into the directory where you saved the ZIP. Run the copy command below, replacing the username and address. This command runs on your computer, not inside the Pi SSH session.
3. If the Pi already contains a maxs-menu folder or a working menu system, stop and follow the repository UPGRADING.md guide. Do not unzip a fresh package over live menus.

```bash
scp vilros-menu-boards.zip YOUR_PI_USER@menuboard.local:~/
```

Use the same Pi OS username and hostname/IP as your SSH connection.

**Checkpoint:** The transfer completes and vilros-menu-boards.zip is in the Pi user’s home directory.

## 4. Run the guided installer

Install the server, sample menus and automatic Pi startup.

1. Return to your SSH session on the Pi and run the commands below as your normal Pi user. Do not run install.sh with sudo; it requests sudo only for the system changes it needs. Internet is needed for OS and Python packages.
2. When asked, enter the restaurant/site name and IANA time zone, for example America/New_York or America/Chicago. Choose no for the optional hotspot for the simplest existing-network setup.
3. Create the application administrator account. Use a unique password of at least 12 characters. There is no default admin password. Password prompts do not display what you type.
4. If you choose the optional hotspot, enter its SSID, strong Wi-Fi password, interface (usually wlan0) and country. The installer adds hotspot dependencies but does not switch you off the existing network.
5. The script installs dependencies, creates a Python virtual environment, runs setup, enables the bagel-menu startup service, checks health and prints your Pi addresses. If it fails, fix the reported error before continuing. An initialized installation must use the upgrade/repair instructions rather than repeating fresh setup.

```bash
sudo apt-get update
sudo apt-get install -y unzip
cd ~
test ! -e maxs-menu || { echo 'STOP: existing installation. See UPGRADING.md.'; exit 1; }
unzip vilros-menu-boards.zip
cd maxs-menu
bash install.sh
```

**Checkpoint:** The installer reports that the server is running and shows the editor and display URL patterns.

**The script reports an existing installation.** Keep its data. Download a system backup and follow UPGRADING.md; do not delete the existing folder to bypass this check.

**Package installation fails.** Restore internet/DNS access and read the reported apt or pip error. If data/users.json already exists, follow the repair instructions in the repository guide.

## 5. Reserve the Pi address and check server health

Give every player a stable address for the local server.

1. Run the check below on the Pi. A successful response includes status ok and application version 1.0.0-rc3. It proves the server responds, not that the TVs or schedules have been tested.
2. In your router, reserve the Pi’s current IPv4 address (DHCP reservation). Avoid manually choosing an address already used by another device. Use that reserved numeric address for the players; .local names are less reliable on some Android devices.
3. On a phone or laptop connected to the menu network, open http://YOUR_PI_IP:8080/admin and sign in with the application account. Disable a phone VPN or cellular fallback if it prevents access to the local network.
4. Do not forward port 8080 through your router. Keep administration on a trusted staff network; the default HTTP connection is local and unencrypted. If using VLANs, ask your network administrator to allow intended staff/player access to the Pi.

```bash
curl --fail http://127.0.0.1:8080/health
hostname -I
```

**Checkpoint:** The phone can open the editor and the router reservation matches the player address.

## 6. Configure one TV and Android player

Make the first TV show its assigned local menu.

1. Connect the player to the TV HDMI port and its supplied wall power adapter. Complete Google TV setup and updates using internet. Connect it to the same reachable local network as the Pi.
2. Install Fully Kiosk Browser & Lockdown from its official listing if available on your device, or use another compatible kiosk browser. Fully Kiosk is third-party software. Some features require a paid license; confirm the free features you need on the actual player before standardizing a kit.
3. Set the browser Start URL to http://YOUR_PI_IP:8080/display/screen1. Replace YOUR_PI_IP with the reserved Pi address. The display page does not need a staff login.
4. Enable available fullscreen, keep-screen-on and launch-on-boot options. Grant only the permissions needed for your setup. Disable the TV/player screen saver and sleep features as appropriate. TV power recovery and automatic browser launch depend on the hardware/firmware.
5. Use an LCD/LED display and landscape mode initially. If you mount a TV vertically, confirm the manufacturer allows it and keeps its vents clear; menu rotation is configured separately in the editor.

**Checkpoint:** TV 1 displays the sample menu without browser toolbars, and text is readable from the customer position.

**The player says the page cannot be reached.** Check its Wi-Fi network, Pi power, reserved IP and exact port 8080. Test the same URL on your phone. Avoid guest-network client isolation.

**The browser does not launch after restart.** Check the player’s app permissions, browser startup option and firmware support. Verify whether the required feature needs a paid license; do not assume every player supports unattended launch.

## 7. Build the restaurant menus and mark sold-out items

Publish readable, accurate menu boards without touching the TVs.

1. Open Edit Menus in the phone/laptop editor. Choose Menu 1, replace the sample products, descriptions and prices, and use Save & publish. The preview shows published content, not unsaved drafts.
2. Add section/header entries, order items, choose full-width or two-column placement, and leave prices blank where appropriate. Use Theme to choose a global style; the eleven themes share the same menu data.
3. Mark an item unavailable when sold out, save, and check the board. Restore availability and save when stock returns. Confirm the displayed behavior matches how you want customers to see unavailable products.
4. Use the preview’s crowding warning as a prompt to shorten descriptions or divide content across menus. Inspect every physical screen at its actual resolution. Do not shrink text until it is unreadable just to fit more products.
5. Administrators can set each menu’s rotation. Review the food-safety warning setting for your actual menu and local obligations; sample prices and wording must be replaced before opening.

**Checkpoint:** A price and availability change appears on the physical TV within about five seconds, and all demo content is replaced.

## 8. Add the other screens

Give each physical board a stable display address.

1. Repeat player setup for each TV. Use /display/screen2 for TV 2, /display/screen3 for TV 3, and continue through /display/screen10. Each URL includes http://YOUR_PI_IP:8080 before that path.
2. Without a schedule, screen1 shows Menu 1, screen2 shows Menu 2, and so on. Populate each corresponding menu in the editor. Several physical TVs can use the same screen address to match.
3. Example: TV 1 shows bagels, TV 2 breakfast sandwiches, and TV 3 coffee. Label each player with its screen number and record its URL so staff can recover it later.

**Checkpoint:** Each TV shows the intended menu and you can update one menu without changing the other boards.

## 9. Schedule breakfast and lunch

Switch the content while leaving each player’s URL unchanged.

1. As an administrator, open System and verify the restaurant time zone, then open Schedule and inspect the displayed Pi clock. The Pi’s clock, not the player’s clock, decides the active menu.
2. Create your breakfast and lunch menus first. Example: Menu 1 is breakfast and Menu 4 is lunch. For Screen 1, add a 07:00–11:00 rule displaying Menu 1 and an 11:00–15:00 rule displaying Menu 4. Save the schedule.
3. Repeat for other screens as needed. These are repeating daily time windows, not a weekday calendar. Avoid overlapping rules for the same screen. Outside its rules, a screen falls back to its matching menu number, so populate that fallback intentionally.
4. Test a real upcoming boundary using temporary rules, watching the physical TV and server clock. Restore the intended service hours afterward. A screen pointed at screen1 should change its content without changing its URL.
5. For operation without internet, verify time after a cold boot. A Pi without a working battery-backed real-time clock can have incorrect time after power loss. Set time accurately or provide a supported RTC; Pi 5 needs the appropriate RTC battery to retain time when unpowered.

**Checkpoint:** The menu switches at a tested boundary and the fallback menu is also correct.

## 10. Verify operation without internet

Separate internet independence from local-network reliability.

1. For the simplest offline operation, leave the local router, Wi-Fi and Pi running, then disconnect only the router’s internet/WAN connection. Pages and editing should keep working locally. Keep a spare printed menu available for a Pi, player or network failure.
2. The system has no cloud account or subscription requirement after installation. It still needs the Pi and a working local connection to load pages and receive changes. An already-open board may retain old content during a disconnection; it cannot receive updates while the Pi is unreachable.
3. Optional Pi hotspot: only use this if you configured it during setup and the Pi has a supported Wi-Fi adapter. The upstream hotspot backend uses 2.4 GHz. It is not a replacement for every restaurant network or a guarantee of coverage.
4. Keep a saved, active normal Wi-Fi connection before trial switching. In System choose Switch to Menu Hotspot, join the new SSID on your phone, open http://192.168.50.1:8080/system, and choose Keep this mode within three minutes. Otherwise the trial is designed to roll back. Keep local console access available when changing networks.
5. Connect each player to the hotspot and change its URL to http://192.168.50.1:8080/display/screen1 (or its assigned number). Some Google TV firmware treats offline Wi-Fi as broken. Use the repository ONN_WIFI_AUTOCONNECT.md guide if needed; it documents an optional ADB captive-portal setting and how to reverse it. Do not assume it works on every firmware.

**Checkpoint:** With WAN disconnected, the editor works and every TV receives a new price. Restore WAN afterward unless this is an intentionally offline installation.

## 11. Create staff accounts and save an off-Pi backup

Let staff maintain menus and give the manager a recovery copy.

1. In Users, create individual employee accounts for routine editing. Keep administrator access for managers who change themes, users, schedules and system settings. Do not share the Pi OS/SSH login with every editor.
2. Test an employee login: publish a menu change, then confirm administrator settings are restricted. Review History when you need to inspect prior publications or restore a menu collection as an administrator.
3. In System, download a system backup to your laptop and a separate private storage location. It contains sensitive account/settings material, and may contain the hotspot password. Keep it private and never upload it to GitHub.
4. An application backup is not an OS image. Recovery also needs Raspberry Pi OS, its network/SSH settings and a fresh application install. Test restore on a spare card before relying on the backup. The menu-only JSON download is a different, smaller backup.
5. Give staff the printable checklist linked below and fill in the actual editor URL, screen assignments and support contact. Take another backup after major menu or schedule changes.

**Checkpoint:** An employee can publish a routine change and the manager has a private backup stored away from the Pi.

## 12. Test power recovery before mounting the TVs

Prove the installation can recover during a real restaurant day.

1. Verify every item/price, sold-out setting, screen assignment and schedule on the real displays. Check readability from the customer area and leave the system running for a full service-length test.
2. Restart the Pi using sudo reboot and confirm its menu service returns automatically. Restart each player, then test Pi and players restarting together with the Pi taking longer to become available. Verify each browser retries and returns to its assigned URL.
3. To simulate a complete loss safely, shut down the Pi using sudo poweroff before removing power; then restore power to Pi, players and TVs together. Do not repeatedly pull power while the Pi writes. A UPS can reduce disruption and SD-card corruption risk.
4. Check the TVs return to the intended HDMI input and power state. Some TVs need manual power-on even when the Pi and players recover. Recheck the Pi clock and scheduled menu after a cold boot, especially offline.
5. Confirm WAN-loss operation, a real breakfast/lunch boundary, employee permissions, and spare-card backup restore. Record Pi model/OS, player model/firmware, browser version/licensing and results. Then mount the TVs using appropriate mounts and safe cable/power routing.

```bash
sudo reboot
```

Wait for the Pi to return, then check the editor and every physical TV.

**Checkpoint:** All hardware acceptance checks pass. Any manual TV power-on requirement is documented for opening staff.

## 13. Maintain, repair and update the system

Keep the menus recoverable without overwriting restaurant data.

1. For an unreachable editor, check Pi power, local network, reserved IP and port 8080 first. The health and service commands below help distinguish a stopped server from a TV/player problem.
2. If fresh setup completed but service installation failed, keep data/ and .menu.env. From the installation directory rerun bash setup.sh (which retains existing accounts), install hostapd and dnsmasq-base if hotspot mode was chosen, then run sudo python3 install_service.py. Inspect errors before retrying.
3. For planned updates, download a backup and read UPGRADING.md. Extract new code into a separate temporary directory and use the supplied upgrade process. Never extract a fresh package over live files or delete data/ to fix a startup error.
4. If an administrator forgets the application password, the Pi owner can run .venv/bin/python reset_admin.py from the installation directory and follow its prompts. This requires Pi access; it is not a public password-reset link.
5. Keep the Pi ventilated, maintain the OS during scheduled downtime, and retest player boot behavior after firmware/browser updates. If the live prices are uncertain, use printed menus until corrected.

```bash
curl --fail http://127.0.0.1:8080/health
systemctl status bagel-menu.service --no-pager
sudo journalctl -u bagel-menu.service -n 50 --no-pager
```

**Checkpoint:** The manager knows how to check server health, locate backups and follow the documented upgrade path.

## Files and references

- [Complete installation ZIP](https://github.com/vilros/uskcode/raw/refs/heads/master/downloads/vilros-menu-boards.zip)
- [Source code and maintenance guides](https://github.com/vilros/uskcode)
- [Printable staff checklist](https://github.com/vilros/uskcode/blob/master/docs/STAFF_CHEATSHEET.md)
- [Vilros Raspberry Pi kits](https://vilros.com/collections/raspberry-pi-kits)
- [Original Max's Menu by Michael Ogrinz (MIT)](https://github.com/mogrinz/maxs-menu)
- [Ogrinz Labs video walkthrough](https://www.youtube.com/watch?v=NY1F6ktmIh4)
