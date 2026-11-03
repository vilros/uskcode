# Attribution and provenance

This is Vilros's installation and documentation distribution of **Max's Menu** by **Michael Ogrinz / Ogrinz Labs**. It is an adaptation of his published project, not an independently invented implementation.

- Original project: https://github.com/mogrinz/maxs-menu
- Video: https://www.youtube.com/watch?v=NY1F6ktmIh4
- Source snapshot: `e73d244d2dfdb8db23a627168a5b8c0e5182ae4c` (application version `1.0.0-rc3`).
- Original MIT license and copyright are retained in LICENSE.
- Bundled font licenses are retained under static/fonts. Fully Kiosk is separate software.

Vilros additions: `install.sh`, restaurant and staff guides, this README, package-validation checks, a clean ZIP download, and a release workflow targeting this repository. The application, authentication, menus, schedules, networking and backup implementation remain from the upstream snapshot.

The Cormorant Garamond font is distributed as the smaller regular WOFF2 file from https://github.com/CatharsisFonts/Cormorant/blob/master/fonts/webfonts/CormorantGaramond-Regular.woff2 under its existing SIL Open Font License. Its CSS source and the release builder have been adjusted accordingly. Other bundled fonts are unchanged.

The upstream application is a release candidate. Software checks do not establish compatibility with a particular Pi, SD card, TV, player firmware or third-party browser. Complete the guide's hardware acceptance checklist before restaurant deployment.
