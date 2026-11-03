# Daily menu-board checklist

Your manager should fill these in and keep the account password separately:

- Editor address: `http://________________:8080/admin`
- Screen 1 shows: ___________________
- Screen 2 shows: ___________________
- Screen 3 shows: ___________________
- Manager/contact: ___________________

## Opening

1. Turn on the TVs and confirm each shows the right menu and current prices.
2. Connect your phone or laptop to the menu network. Open the editor address.
3. Sign in with your own employee account. Choose the menu, change the item or price, and save.
4. Mark sold-out products unavailable, then save. Verify the physical screen updates in about five seconds.
5. If a save reports another editor changed the menu, reload and apply your edit again.

## During service

- Save after each change. Unsaved changes do not reach the TVs.
- Check the actual board after changing prices or availability.
- Ask a manager to change schedules, users, themes, or network settings.

## If a board stops updating

1. Check the TV input and player power. Check that the player uses the correct Wi-Fi network.
2. Open the editor on your phone. If it also fails, check the Pi's power and network cable.
3. Ask the manager to check `http://PI_IP:8080/health` and the saved player URL.
4. Use a printed menu until the live board is correct. Do not factory-reset the Pi or overwrite its files.

## Closing

Turn off the TVs on their normal schedule. Leave the Pi running. A manager should back up menu changes regularly; never unplug the Pi while it is writing data.
