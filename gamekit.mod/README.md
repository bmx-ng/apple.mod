# Apple.GameKit

`Apple.GameKit` provides BlitzMax access to Apple's Game Center service on iOS
and macOS. The API covers local-player authentication, achievements,
leaderboards, leaderboard sets, resource artwork and the Game Center access
point.

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

The generated BlitzMax Xcode project does not yet preserve capabilities across
a rebuild, so step 3 currently needs to be repeated after regenerating it.

Call `TGameCenter.Shared().Start(listener)` near application startup. GameKit
may invoke the authentication callback more than once as the player's account
state changes.

Implement `IGameCenterListener` for authentication and gameplay operations.
An object can additionally implement `IGameCenterMetadataListener` to receive
achievement descriptions, leaderboard metadata, leaderboard sets and PNG
artwork. Keeping the metadata listener optional allows existing listeners to
continue using only the core API.

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
