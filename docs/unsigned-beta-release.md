# Atoll Island 0.1.1 unsigned beta

> **Important:** This beta is not signed or notarized with an Apple Developer
> ID. macOS will show a Gatekeeper warning. It is published as a prerelease for
> testing while the project does not participate in the paid Apple Developer
> Program.

## Fixed in 0.1.1

- Fixed repeated Codex hook failures caused by the managed Code Island bridge
  depending on frameworks that were unavailable after installation.
- Restored active-session detection for Codex sessions running inside terminal
  hosts such as Herdr.
- Added automatic repair for the managed bridge when upgrading from an older
  Atoll Island installation; users do not need to repeat Code Island setup.
- Added a release check that copies and runs the bridge outside the app bundle
  so this packaging failure cannot silently recur.

## Installation

1. Download the `UNSIGNED.dmg` and matching `.sha256` asset from this release.
2. Verify the checksum with `shasum -a 256 -c <checksum-file>`.
3. Drag Atoll Island to Applications.
4. In Applications, **Control-click** Atoll Island, choose **Open**, and confirm
   **Open** in the Gatekeeper dialog.

When upgrading, quit Atoll Island before replacing the existing copy in
Applications. Code Island's managed Codex integration will be checked and
repaired automatically on the next launch.

The checksum confirms that the download matches this release asset; it does not
independently establish that the software is safe. Source for the exact release
is attached automatically by GitHub and remains available in this repository.

## Included

- Atoll Island's independent bundle identity, so it can coexist with Atoll.
- Code Island as a persistent Atoll panel.
- Codex session monitoring with sanitized metadata only.
- Active Code Island priority over noncritical media and utility activities.
- Direct Code Island routing when the notch opens during active agent work.
- Origin-only approvals and answers.

## Known limitations

- Apple notarization and normal double-click installation are unavailable.
- Updates must be downloaded and installed manually.
- The initial Code Island integration supports Codex monitoring only.
- This remains an independent community fork, not an official Atoll or
  CodeIsland release.
