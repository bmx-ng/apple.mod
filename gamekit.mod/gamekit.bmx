SuperStrict

Rem
bbdoc: Apple GameKit and Game Center services.
End Rem
Module Apple.GameKit

ModuleInfo "Version: 0.1"
ModuleInfo "License: zlib/libpng"
ModuleInfo "Copyright: Wrapper - 2026 Bruce A Henderson"

?macos Or ios
ModuleInfo "CC_OPTS: -fobjc-arc"
Import "-framework Foundation"
Import "-framework GameKit"
Import "gamekit_apple.bmx"
Import "glue.m"
?

?ios
Import "-framework UIKit"
?

?macos And Not ios
Import "-framework AppKit"
?
