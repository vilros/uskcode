# Vilros package validation

Source: Max's Menu commit e73d244d2dfdb8db23a627168a5b8c0e5182ae4c, application 1.0.0-rc3.

## Package checks

- Python compile checks and shell syntax validation.
- Build the installation ZIP, verify its manifest, test archive integrity and reproducibility.
- Check local CSS font/asset references resolve to bundled files.
- Confirm the guided installer, restaurant guide, staff checklist, source/license and local fonts are included.
- No data/, .menu.env, private account files or environment settings in the ZIP.

The GitHub Application checks workflow runs the upstream unit suite. The release workflow also runs that suite before publishing a versioned ZIP. Consult the workflow result on the exact commit; inclusion of a workflow is not itself a passing test.

## Hardware acceptance still required

No physical Raspberry Pi, TV or Android player was attached to the packaging environment. Do not interpret software checks as a hardware compatibility guarantee. Follow the full guide for fresh SD-card installation, browser startup and reconnect behavior, readability, simultaneous reboot, WAN loss, clock retention, schedule boundaries and spare-card backup restoration. Record actual hardware/firmware/browser versions and any paid browser features used.

The packaging environment cannot install the Flask/Waitress dependencies through its package/network configuration. Full application checks are therefore run by GitHub Actions rather than claimed as a local pass.
