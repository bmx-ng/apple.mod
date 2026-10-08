# Apple.GameKit

`Apple.GameKit` provides BlitzMax access to Apple's Game Center service on iOS
and macOS. The API covers local-player authentication, players and friends,
achievements, leaderboards, iCloud saved games, resource artwork and the Game
Center access point.

The module contains no public API on non-Apple targets. This allows shared
projects to import it conditionally without compiling Apple-specific types or
native stubs into other platform builds.

The modern access-point and leaderboard APIs require iOS 14 or macOS 11. The
module can still be imported on older systems, but `IsAvailable()` returns
false and modern operations report an error.

## Application setup

Importing the module links `GameKit.framework`, but Apple also requires the
application to be configured for Game Center:

1. Enable Game Center for the explicit App ID in Certificates, Identifiers &
   Profiles.
2. Enable Game Center for the matching app in App Store Connect.
3. Add the Game Center capability to the generated Xcode target. This adds a
   signed `com.apple.developer.game-center` entitlement.
4. Define any achievement and leaderboard identifiers in App Store Connect.

Keep the entitlement plist with the application sources and set
`ios.entitlements` in the application's `.settings` file. bmk copies it into
the generated project and reconnects it on every build, so capabilities do not
need to be re-added after regeneration. The examples demonstrate this setup.
Their `com.example` bundle and iCloud container identifiers are placeholders;
replace them with identifiers registered to your Apple Developer account before
building for a device or using Game Center services.

Call `TGameCenter.Shared().Start(listener)` near application startup. GameKit
may invoke the authentication callback more than once as the player's account
state changes.

Implement `IGameCenterListener` for authentication and gameplay operations.
An object can additionally implement `IGameCenterMetadataListener` to receive
achievement descriptions, leaderboard metadata, leaderboard sets and PNG
artwork. Keeping the metadata listener optional allows existing listeners to
continue using only the core API.

Implement the optional `IGameCenterPlayerListener` for friends and player-photo
results. `LoadFriendsAuthorizationStatus()` checks the current permission without
showing a prompt. `LoadFriends()` can show Apple's permission prompt when the
status is not determined, so call it in response to an explicit menu action.
GameKit returns only friends who have also allowed this game to access their
friends list. `LoadPlayerPhoto()` returns small or normal profile artwork as PNG
bytes for players supplied by Game Center during the current session.

Friend-list access requires a purpose string in the application `Info.plist`:

```xml
<key>NSGKFriendListUsageDescription</key>
<string>See which of your Game Center friends also play this game.</string>
```

Choose wording that accurately describes the game's use of the data. Apple
requires this key even when only checking the authorization status. Friends
authorization requires iOS 14.5 or macOS 11.3; the rest of the module retains
its iOS 14/macOS 11 baseline.

If authorization becomes denied or restricted, discard any friend data the
game has stored. The module drops its in-memory friend objects automatically;
the application remains responsible for its own persisted data.

## Saved games

GameKit saved games are named, opaque byte arrays stored in the local player's
iCloud account. GameKit does not inspect or understand their contents. The game
owns its serialization format, schema versions, validation, migration,
compression and conflict policy. Keep saves compact and include enough format
information in the data to read older versions safely.

`SaveGame()` creates or replaces a named save, `FetchSavedGames()` returns its
metadata, `LoadSavedGame()` retrieves the bytes for a returned version, and
`DeleteSavedGames()` removes every version with a name. Implement
`IGameCenterSavedGameListener` to receive these results as well as remote-change
and conflict events.

Conflicts can occur when multiple devices change the same name while offline.
The conflict callback supplies all exact versions and a session-scoped conflict
identifier. Load the versions, choose or merge their bytes, and pass the final
data to `ResolveSavedGameConflict()`. Do not resolve by filename alone.

Saved games require the iCloud capability on the application target. In the
generated Xcode project:

1. Select the application target and choose the Apple Developer **Team** under
   Signing & Capabilities. Xcode cannot register or select an iCloud container
   until a team has been chosen.
2. Add the **iCloud** capability, enable **iCloud Documents**, and select or
   create the application's iCloud container. A conventional identifier is the
   bundle identifier prefixed with `iCloud.`, for example
   `iCloud.net.example.mygame`.
3. Keep the separate **Game Center** capability enabled. Adding iCloud must not
   remove the `com.apple.developer.game-center` entitlement.

Xcode writes the iCloud container and Cloud Documents entitlements and updates
the provisioning profile. Copy those entries into the source-controlled plist
named by `ios.entitlements`; the generated copy must not be treated as the
authoritative file. The player must also be signed into iCloud and have iCloud
Drive enabled.

`deviceName` may be a generic device description. Access to a person's custom
device name requires Apple's separately controlled user-assigned-device-name
entitlement and should not be assumed by a game.

`ShowAccessPoint()` and `HideAccessPoint()` explicitly control Apple's floating
Game Center widget. `IsAccessPointActive()` reports the requested state,
`IsAccessPointVisible()` reports whether it is actually on screen, and
`IsPresentingGameCenter()` reports whether it currently has Game Center UI
open. A game that only uses the widget on menus should reapply
`HideAccessPoint()` when gameplay resumes after an interruption.

Use `LoadAchievementDescriptions()` to retrieve localized achievement titles,
descriptions, point values and visibility. `LoadLeaderboards()` returns both
classic and recurring leaderboards; pass a leaderboard-set identifier to
restrict the result to that set. `LoadLeaderboardSets()` discovers the sets
configured for the game. Artwork for any of these resources is returned as PNG
bytes by `LoadResourceImage()`.

Some metadata depends on the installed OS. Achievement rarity is available
from iOS 17 and macOS 14, release state from iOS 18.4 and macOS 15.4, and the
leaderboard description and hidden state from iOS 26 and macOS 26. Fields use
safe empty, false or unknown values on earlier systems.

On macOS, Game Center is available to Mac App Store applications, not apps
distributed outside the store with Developer ID.
