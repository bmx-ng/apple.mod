# Apple.GameKit

`Apple.GameKit` provides BlitzMax access to Apple's Game Center service on iOS
and macOS. The initial API covers local-player authentication, achievements,
leaderboards and the Game Center access point.

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

On macOS, Game Center is available to Mac App Store applications, not apps
distributed outside the store with Developer ID.
