# Apple modules for BlitzMax NG

Native integrations for Apple platform services.

## Modules

- [`Apple.GameKit`](gamekit.mod/README.md) provides Game Center authentication,
  server identity verification, players and friends, achievements,
  leaderboards, developer-defined challenges, game activities, iCloud saved
  games, real-time matchmaking and Apple's standard Game Center access point
  on iOS and macOS.

Install this repository as `mod/apple.mod` in a bcc2-based BlitzMax NG SDK:

```sh
git clone https://github.com/bmx-ng/apple.mod.git mod/apple.mod
```

Each service can require capabilities, entitlements and configuration in the
Apple Developer portal in addition to importing its BlitzMax module. See the
module documentation for the required application setup.
