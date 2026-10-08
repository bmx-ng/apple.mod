SuperStrict

ModuleInfo "CC_OPTS: -fobjc-arc"

Import "-framework Foundation"
Import "-framework GameKit"
Import "glue.m"

?ios
Import "-framework UIKit"
?Not ios
Import "-framework AppKit"
?

Import BRL.Map

Rem
bbdoc: Game Center dashboard sections understood by #ShowGameCenter.
End Rem
Enum EGameCenterView
	Default = -1
	Leaderboards
	Achievements
	LocalPlayerProfile = 3
	Dashboard
	Friends
End Enum

Rem
bbdoc: Screen positions for the Game Center access point.
End Rem
Enum EGameCenterAccessPointLocation
	TopLeading
	TopTrailing
	BottomLeading
	BottomTrailing
End Enum

Rem
bbdoc: Player filter used when loading leaderboard entries.
End Rem
Enum EGameCenterPlayerScope
	Global
	FriendsOnly
End Enum

Rem
bbdoc: Time filter used when loading leaderboard entries.
End Rem
Enum EGameCenterTimeScope
	Today
	Week
	AllTime
End Enum

Rem
bbdoc: The persistence model used by a Game Center leaderboard.
End Rem
Enum EGameCenterLeaderboardType
	Classic
	Recurring
End Enum

Rem
bbdoc: The App Store Connect release state of a Game Center resource.
End Rem
Enum EGameCenterReleaseState
	Unknown
	Released
	Prereleased
End Enum

Rem
bbdoc: Game Center resources that can provide PNG artwork through #LoadResourceImage.
End Rem
Enum EGameCenterResourceKind
	Achievement
	Leaderboard
	LeaderboardSet
End Enum

Rem
bbdoc: Whether the local player permits this game to access their Game Center friends.
End Rem
Enum EGameCenterFriendsAuthorization
	NotDetermined
	Restricted
	Denied
	Authorized
End Enum

Rem
bbdoc: The size of Game Center player photo to request.
about: Apple chooses the exact pixel dimensions for each device.
End Rem
Enum EGameCenterPhotoSize
	Small
	Normal
End Enum

Rem
bbdoc: An error returned by GameKit.
End Rem
Type TGameCenterError
	Field domain:String
	Field code:Int
	Field message:String

	Function _Create:TGameCenterError(domain:String, code:Int, message:String)
		If Not domain Then Return Null
		Local error:TGameCenterError = New TGameCenterError
		error.domain = domain
		error.code = code
		error.message = message
		Return error
	End Function
End Type

Rem
bbdoc: A signed Game Center identity payload for verification by an application server.
about: Send every field to a trusted server promptly. The server, not the game client, must validate the Apple certificate and signature, require a recent timestamp, and prevent replay. For non-Apple-Arcade games Apple signs teamPlayerId, bundleIdentifier, timestamp in big-endian order, and salt.
End Rem
Type TGameCenterIdentityVerification
	Field gamePlayerId:String
	Field teamPlayerId:String
	Field bundleIdentifier:String
	Field publicKeyUrl:String
	Field signature:Byte[]
	Field salt:Byte[]
	Field timestamp:ULong

	Function _Create:TGameCenterIdentityVerification(gamePlayerId:String, teamPlayerId:String, bundleIdentifier:String, publicKeyUrl:String, signature:Byte[], salt:Byte[], timestamp:ULong)
		Local verification:TGameCenterIdentityVerification = New TGameCenterIdentityVerification
		verification.gamePlayerId = gamePlayerId
		verification.teamPlayerId = teamPlayerId
		verification.bundleIdentifier = bundleIdentifier
		verification.publicKeyUrl = publicKeyUrl
		verification.signature = signature
		verification.salt = salt
		verification.timestamp = timestamp
		Return verification
	End Function
End Type

Rem
bbdoc: Public information about a Game Center player.
End Rem
Type TGameCenterPlayer
	Field gamePlayerId:String
	Field teamPlayerId:String
	Field alias:String
	Field displayName:String
	Field underage:Int
	Field multiplayerRestricted:Int
	Field personalizedCommunicationRestricted:Int

	Function _Create:TGameCenterPlayer(gamePlayerId:String, teamPlayerId:String, alias:String, displayName:String, underage:Int = False, multiplayerRestricted:Int = False, personalizedCommunicationRestricted:Int = False)
		Local player:TGameCenterPlayer = New TGameCenterPlayer
		player.gamePlayerId = gamePlayerId
		player.teamPlayerId = teamPlayerId
		player.alias = alias
		player.displayName = displayName
		player.underage = underage
		player.multiplayerRestricted = multiplayerRestricted
		player.personalizedCommunicationRestricted = personalizedCommunicationRestricted
		Return player
	End Function
End Type

Rem
bbdoc: Players returned by a friends request.
End Rem
Type TGameCenterPlayerResult
	Field players:TGameCenterPlayer[]
End Type

Rem
bbdoc: Metadata for one version of a Game Center saved game.
about: Saved-game objects are valid for the current authenticated Game Center session. Use the object with #TGameCenter.LoadSavedGame rather than retaining it across application launches or account changes.
End Rem
Type TGameCenterSavedGame
	Field name:String
	Field deviceName:String
	Field modificationTime:Double
	Field _handle:Int

	Function _Create:TGameCenterSavedGame(handle:Int, name:String, deviceName:String, modificationTime:Double)
		Local savedGame:TGameCenterSavedGame = New TGameCenterSavedGame
		savedGame._handle = handle
		savedGame.name = name
		savedGame.deviceName = deviceName
		savedGame.modificationTime = modificationTime
		Return savedGame
	End Function
End Type

Rem
bbdoc: Saved-game versions returned by GameKit.
End Rem
Type TGameCenterSavedGameResult
	Field savedGames:TGameCenterSavedGame[]
End Type

Rem
bbdoc: Progress for one Game Center achievement.
End Rem
Type TGameCenterAchievement
	Field identifier:String
	Field percentComplete:Double
	Field completed:Int
	Field lastReportedTime:Double

	Function _Create:TGameCenterAchievement(identifier:String, percentComplete:Double, completed:Int, lastReportedTime:Double)
		Local achievement:TGameCenterAchievement = New TGameCenterAchievement
		achievement.identifier = identifier
		achievement.percentComplete = percentComplete
		achievement.completed = completed
		achievement.lastReportedTime = lastReportedTime
		Return achievement
	End Function
End Type

Rem
bbdoc: Achievements returned by a load request.
End Rem
Type TGameCenterAchievementResult
	Field achievements:TGameCenterAchievement[]
End Type

Rem
bbdoc: Localized metadata for an achievement configured in App Store Connect.
End Rem
Type TGameCenterAchievementDescription
	Field identifier:String
	Field groupIdentifier:String
	Field title:String
	Field achievedDescription:String
	Field unachievedDescription:String
	Field maximumPoints:Int
	Field hidden:Int
	Field replayable:Int
	Field rarityPercent:Double = -1.0
	Field releaseState:EGameCenterReleaseState

	Function _Create:TGameCenterAchievementDescription(identifier:String, groupIdentifier:String, title:String, achievedDescription:String, unachievedDescription:String, maximumPoints:Int, hidden:Int, replayable:Int, rarityPercent:Double, releaseState:EGameCenterReleaseState)
		Local description:TGameCenterAchievementDescription = New TGameCenterAchievementDescription
		description.identifier = identifier
		description.groupIdentifier = groupIdentifier
		description.title = title
		description.achievedDescription = achievedDescription
		description.unachievedDescription = unachievedDescription
		description.maximumPoints = maximumPoints
		description.hidden = hidden
		description.replayable = replayable
		description.rarityPercent = rarityPercent
		description.releaseState = releaseState
		Return description
	End Function
End Type

Rem
bbdoc: Achievement descriptions returned by a metadata request.
End Rem
Type TGameCenterAchievementDescriptionResult
	Field descriptions:TGameCenterAchievementDescription[]
End Type

Rem
bbdoc: Metadata for a classic or recurring leaderboard.
End Rem
Type TGameCenterLeaderboardInfo
	Field identifier:String
	Field groupIdentifier:String
	Field title:String
	Field leaderboardType:EGameCenterLeaderboardType
	Field startTime:Double
	Field nextStartTime:Double
	Field duration:Double
	Field description:String
	Field hidden:Int
	Field releaseState:EGameCenterReleaseState

	Function _Create:TGameCenterLeaderboardInfo(identifier:String, groupIdentifier:String, title:String, leaderboardType:EGameCenterLeaderboardType, startTime:Double, nextStartTime:Double, duration:Double, description:String, hidden:Int, releaseState:EGameCenterReleaseState)
		Local leaderboard:TGameCenterLeaderboardInfo = New TGameCenterLeaderboardInfo
		leaderboard.identifier = identifier
		leaderboard.groupIdentifier = groupIdentifier
		leaderboard.title = title
		leaderboard.leaderboardType = leaderboardType
		leaderboard.startTime = startTime
		leaderboard.nextStartTime = nextStartTime
		leaderboard.duration = duration
		leaderboard.description = description
		leaderboard.hidden = hidden
		leaderboard.releaseState = releaseState
		Return leaderboard
	End Function
End Type

Rem
bbdoc: Leaderboard metadata returned by a request.
End Rem
Type TGameCenterLeaderboardInfoResult
	Field setIdentifier:String
	Field leaderboards:TGameCenterLeaderboardInfo[]
End Type

Rem
bbdoc: A localized collection of related leaderboards.
End Rem
Type TGameCenterLeaderboardSet
	Field identifier:String
	Field groupIdentifier:String
	Field title:String

	Function _Create:TGameCenterLeaderboardSet(identifier:String, groupIdentifier:String, title:String)
		Local set:TGameCenterLeaderboardSet = New TGameCenterLeaderboardSet
		set.identifier = identifier
		set.groupIdentifier = groupIdentifier
		set.title = title
		Return set
	End Function
End Type

Rem
bbdoc: Leaderboard sets returned by a metadata request.
End Rem
Type TGameCenterLeaderboardSetResult
	Field sets:TGameCenterLeaderboardSet[]
End Type

Rem
bbdoc: One ranked entry returned by a Game Center leaderboard.
End Rem
Type TGameCenterLeaderboardEntry
	Field player:TGameCenterPlayer
	Field rank:Long
	Field score:Long
	Field formattedScore:String
	Field context:ULong
	Field date:Double

	Function _Create:TGameCenterLeaderboardEntry(player:TGameCenterPlayer, rank:Long, score:Long, formattedScore:String, context:ULong, date:Double)
		Local entry:TGameCenterLeaderboardEntry = New TGameCenterLeaderboardEntry
		entry.player = player
		entry.rank = rank
		entry.score = score
		entry.formattedScore = formattedScore
		entry.context = context
		entry.date = date
		Return entry
	End Function
End Type

Rem
bbdoc: Entries returned by a leaderboard request.
End Rem
Type TGameCenterLeaderboardResult
	Field identifier:String
	Field title:String
	Field totalPlayerCount:Long
	Field localPlayerEntry:TGameCenterLeaderboardEntry
	Field entries:TGameCenterLeaderboardEntry[]
End Type

Rem
bbdoc: Receives authentication and asynchronous GameKit results.
about: Completion callbacks are delivered on the application main thread.
End Rem
Interface IGameCenterListener
	Method OnGameCenterAuthenticationChanged(authenticated:Int, player:TGameCenterPlayer, error:TGameCenterError)
	Method OnGameCenterAchievementReported(requestId:Int, identifier:String, error:TGameCenterError)
	Method OnGameCenterAchievementsLoaded(requestId:Int, result:TGameCenterAchievementResult, error:TGameCenterError)
	Method OnGameCenterAchievementsReset(requestId:Int, error:TGameCenterError)
	Method OnGameCenterScoreSubmitted(requestId:Int, leaderboardIdentifier:String, score:Long, error:TGameCenterError)
	Method OnGameCenterLeaderboardLoaded(requestId:Int, leaderboard:TGameCenterLeaderboardResult, error:TGameCenterError)
	Method OnGameCenterViewDismissed(view:EGameCenterView)
End Interface

Rem
bbdoc: Optional listener for server-side Game Center identity verification payloads.
about: A listener object can implement this interface alongside #IGameCenterListener. Never treat the payload as verified in the game client; forward it to a trusted server for validation.
End Rem
Interface IGameCenterIdentityListener
	Method OnGameCenterIdentityVerificationFetched(requestId:Int, verification:TGameCenterIdentityVerification, error:TGameCenterError)
End Interface

Rem
bbdoc: Optional listener for achievement and leaderboard metadata.
about: A listener object can implement this interface alongside #IGameCenterListener to receive metadata and artwork results without changing clients that only use the core API.
End Rem
Interface IGameCenterMetadataListener
	Method OnGameCenterAchievementDescriptionsLoaded(requestId:Int, result:TGameCenterAchievementDescriptionResult, error:TGameCenterError)
	Method OnGameCenterLeaderboardsLoaded(requestId:Int, result:TGameCenterLeaderboardInfoResult, error:TGameCenterError)
	Method OnGameCenterLeaderboardSetsLoaded(requestId:Int, result:TGameCenterLeaderboardSetResult, error:TGameCenterError)
	Method OnGameCenterResourceImageLoaded(requestId:Int, kind:EGameCenterResourceKind, identifier:String, pngData:Byte[], error:TGameCenterError)
End Interface

Rem
bbdoc: Optional listener for Game Center friends and player photos.
about: Friend access requires an NSGKFriendListUsageDescription entry in the application's Info.plist. Calling #TGameCenter.LoadFriends can display Apple's permission prompt.
End Rem
Interface IGameCenterPlayerListener
	Method OnGameCenterFriendsAuthorizationLoaded(requestId:Int, status:EGameCenterFriendsAuthorization, error:TGameCenterError)
	Method OnGameCenterFriendsLoaded(requestId:Int, result:TGameCenterPlayerResult, error:TGameCenterError)
	Method OnGameCenterPlayerPhotoLoaded(requestId:Int, gamePlayerId:String, size:EGameCenterPhotoSize, pngData:Byte[], error:TGameCenterError)
End Interface

Rem
bbdoc: Optional listener for Game Center saved-game operations and iCloud change events.
about: Saved games require the iCloud capability with iCloud Documents enabled. Conflict and modification callbacks are unsolicited events and therefore do not have request identifiers.
End Rem
Interface IGameCenterSavedGameListener
	Method OnGameCenterSavedGamesFetched(requestId:Int, result:TGameCenterSavedGameResult, error:TGameCenterError)
	Method OnGameCenterSavedGameSaved(requestId:Int, savedGame:TGameCenterSavedGame, error:TGameCenterError)
	Method OnGameCenterSavedGameDataLoaded(requestId:Int, savedGame:TGameCenterSavedGame, data:Byte[], error:TGameCenterError)
	Method OnGameCenterSavedGamesDeleted(requestId:Int, name:String, error:TGameCenterError)
	Method OnGameCenterSavedGameConflict(conflictId:Int, result:TGameCenterSavedGameResult)
	Method OnGameCenterSavedGameConflictResolved(requestId:Int, conflictId:Int, result:TGameCenterSavedGameResult, error:TGameCenterError)
	Method OnGameCenterSavedGameModified(savedGame:TGameCenterSavedGame)
End Interface

Private

Type TAchievementLoad
	Field values:TGameCenterAchievement[]
	Field index:Int
End Type

Type TAchievementDescriptionLoad
	Field values:TGameCenterAchievementDescription[]
	Field index:Int
End Type

Type TLeaderboardInfoLoad
	Field result:TGameCenterLeaderboardInfoResult
	Field values:TGameCenterLeaderboardInfo[]
	Field index:Int
End Type

Type TLeaderboardSetLoad
	Field values:TGameCenterLeaderboardSet[]
	Field index:Int
End Type

Type TLeaderboardLoad
	Field result:TGameCenterLeaderboardResult
	Field values:TGameCenterLeaderboardEntry[]
	Field index:Int
End Type

Type TPlayerLoad
	Field values:TGameCenterPlayer[]
	Field index:Int
End Type

Type TSavedGameLoad
	Field values:TGameCenterSavedGame[]
	Field index:Int
End Type

Public

Rem
bbdoc: Access to the local player's Game Center service.
about: Call #Start near application startup. Game Center must also be enabled for the app identifier and signed into the application entitlement.
End Rem
Type TGameCenter
	Field listener:IGameCenterListener
	Field localPlayer:TGameCenterPlayer
	Field started:Int
	Field nextRequestId:Int = 1
	Field achievementLoads:TMap = New TMap
	Field leaderboardLoads:TMap = New TMap
	Field achievementDescriptionLoads:TMap = New TMap
	Field leaderboardInfoLoads:TMap = New TMap
	Field leaderboardSetLoads:TMap = New TMap
	Field playerLoads:TMap = New TMap
	Field savedGameLoads:TMap = New TMap
	Field savedGames:TMap = New TMap

	Rem
	bbdoc: Returns the process-wide Game Center service.
	End Rem
	Function Shared:TGameCenter()
		Return _gameCenter
	End Function

	Rem
	bbdoc: Starts Game Center authentication and installs the supplied listener.
	about: The authentication callback can occur more than once when the account state changes.
	End Rem
	Method Start(listener:IGameCenterListener)
		Self.listener = listener
		If Not started Then
			started = True
			bmx_gamekit_start(Self)
		End If
	End Method

	Rem
	bbdoc: Stops callbacks and hides the access point.
	End Rem
	Method Stop()
		If started Then
			bmx_gamekit_stop()
			started = False
		End If
		localPlayer = Null
		listener = Null
		achievementLoads.Clear()
		leaderboardLoads.Clear()
		achievementDescriptionLoads.Clear()
		leaderboardInfoLoads.Clear()
		leaderboardSetLoads.Clear()
		playerLoads.Clear()
		savedGameLoads.Clear()
		savedGames.Clear()
	End Method

	Rem
	bbdoc: Returns #True when Game Center is available on this OS version.
	End Rem
	Method IsAvailable:Int()
		Return bmx_gamekit_is_available()
	End Method

	Rem
	bbdoc: Returns #True when the local player is authenticated.
	End Rem
	Method IsAuthenticated:Int()
		Return bmx_gamekit_is_authenticated()
	End Method

	Rem
	bbdoc: Fetches a signed identity payload for authenticating the local player with an application server.
	about: The payload is short-lived and must be forwarded promptly to a trusted server. It does not authenticate the player until that server has validated Apple's certificate and signature, checked the timestamp, and prevented replay.
	returns: A request identifier supplied to #IGameCenterIdentityListener.
	End Rem
	Method FetchIdentityVerification:Int()
		Local requestId:Int = NextRequest()
		bmx_gamekit_fetch_identity_verification(requestId)
		Return requestId
	End Method

	Rem
	bbdoc: Shows or hides Apple's Game Center access point.
	End Rem
	Method SetAccessPointActive(active:Int, location:EGameCenterAccessPointLocation = EGameCenterAccessPointLocation.TopLeading)
		bmx_gamekit_set_access_point_active(active, location)
	End Method

	Rem
	bbdoc: Shows Apple's Game Center access point at the requested screen location.
	End Rem
	Method ShowAccessPoint(location:EGameCenterAccessPointLocation = EGameCenterAccessPointLocation.TopLeading)
		SetAccessPointActive(True, location)
	End Method

	Rem
	bbdoc: Hides Apple's Game Center access point.
	about: Games that only show the access point on menus should call this again when resuming gameplay so a reconnect banner cannot leave the widget visible.
	End Rem
	Method HideAccessPoint()
		SetAccessPointActive(False)
	End Method

	Rem
	bbdoc: Returns #True when the game has requested that the access point be active.
	End Rem
	Method IsAccessPointActive:Int()
		Return bmx_gamekit_is_access_point_active()
	End Method

	Rem
	bbdoc: Returns #True when the access point is currently visible on screen.
	about: Visibility can temporarily differ from #IsAccessPointActive while Game Center displays a banner or dashboard.
	End Rem
	Method IsAccessPointVisible:Int()
		Return bmx_gamekit_is_access_point_visible()
	End Method

	Rem
	bbdoc: Returns #True while the access point is presenting Game Center UI.
	End Rem
	Method IsPresentingGameCenter:Int()
		Return bmx_gamekit_is_presenting()
	End Method

	Rem
	bbdoc: Opens Game Center at a particular section through the access point.
	End Rem
	Method ShowGameCenter(view:EGameCenterView = EGameCenterView.Default)
		bmx_gamekit_show(view)
	End Method

	Rem
	bbdoc: Reports progress from 0 through 100 for an achievement.
	returns: A request identifier supplied to the listener callback.
	End Rem
	Method ReportAchievement:Int(identifier:String, percentComplete:Double, showCompletionBanner:Int = True)
		Local requestId:Int = NextRequest()
		bmx_gamekit_report_achievement(requestId, identifier, percentComplete, showCompletionBanner)
		Return requestId
	End Method

	Rem
	bbdoc: Loads the local player's reported achievements.
	returns: A request identifier supplied to the listener callback.
	End Rem
	Method LoadAchievements:Int()
		Local requestId:Int = NextRequest()
		bmx_gamekit_load_achievements(requestId)
		Return requestId
	End Method

	Rem
	bbdoc: Loads the localized descriptions of every achievement configured for the game.
	returns: A request identifier supplied to #IGameCenterMetadataListener.
	End Rem
	Method LoadAchievementDescriptions:Int()
		Local requestId:Int = NextRequest()
		bmx_gamekit_load_achievement_descriptions(requestId)
		Return requestId
	End Method

	Rem
	bbdoc: Resets every achievement for the local player.
	returns: A request identifier supplied to the listener callback.
	End Rem
	Method ResetAchievements:Int()
		Local requestId:Int = NextRequest()
		bmx_gamekit_reset_achievements(requestId)
		Return requestId
	End Method

	Rem
	bbdoc: Submits a score to a leaderboard.
	returns: A request identifier supplied to the listener callback.
	End Rem
	Method SubmitScore:Int(leaderboardIdentifier:String, score:Long, context:ULong = 0)
		Local requestId:Int = NextRequest()
		bmx_gamekit_submit_score(requestId, leaderboardIdentifier, score, context)
		Return requestId
	End Method

	Rem
	bbdoc: Loads metadata for every classic and recurring leaderboard in the game, or for the supplied leaderboard set.
	about: Pass an empty set identifier to load every leaderboard.
	returns: A request identifier supplied to #IGameCenterMetadataListener.
	End Rem
	Method LoadLeaderboards:Int(setIdentifier:String = "")
		Local requestId:Int = NextRequest()
		bmx_gamekit_load_leaderboards(requestId, setIdentifier)
		Return requestId
	End Method

	Rem
	bbdoc: Loads every leaderboard set configured for the game.
	returns: A request identifier supplied to #IGameCenterMetadataListener.
	End Rem
	Method LoadLeaderboardSets:Int()
		Local requestId:Int = NextRequest()
		bmx_gamekit_load_leaderboard_sets(requestId)
		Return requestId
	End Method

	Rem
	bbdoc: Loads PNG artwork for an achievement, leaderboard, or leaderboard set.
	returns: A request identifier supplied to #IGameCenterMetadataListener.
	End Rem
	Method LoadResourceImage:Int(kind:EGameCenterResourceKind, identifier:String)
		Local requestId:Int = NextRequest()
		bmx_gamekit_load_resource_image(requestId, kind, identifier)
		Return requestId
	End Method

	Rem
	bbdoc: Loads the current Game Center friends authorization state without displaying a permission prompt.
	about: Requires NSGKFriendListUsageDescription in the application Info.plist and iOS 14.5 or macOS 11.3.
	returns: A request identifier supplied to #IGameCenterPlayerListener.
	End Rem
	Method LoadFriendsAuthorizationStatus:Int()
		Local requestId:Int = NextRequest()
		bmx_gamekit_load_friends_authorization(requestId)
		Return requestId
	End Method

	Rem
	bbdoc: Loads friends who have also allowed this game to access their friends list.
	about: If authorization is not determined, this call displays Apple's permission prompt. Call it from a deliberate user action rather than during gameplay. Requires NSGKFriendListUsageDescription in the application Info.plist and iOS 14.5 or macOS 11.3.
	returns: A request identifier supplied to #IGameCenterPlayerListener.
	End Rem
	Method LoadFriends:Int()
		Local requestId:Int = NextRequest()
		bmx_gamekit_load_friends(requestId)
		Return requestId
	End Method

	Rem
	bbdoc: Loads a Game Center player photo as PNG bytes.
	about: The player must have been supplied by Game Center during this session. The local player's photo is always available for lookup; a friend may also be resolved after friend-list authorization.
	returns: A request identifier supplied to #IGameCenterPlayerListener.
	End Rem
	Method LoadPlayerPhoto:Int(player:TGameCenterPlayer, size:EGameCenterPhotoSize = EGameCenterPhotoSize.Normal)
		Local requestId:Int = NextRequest()
		Local identifier:String
		If player Then identifier = player.gamePlayerId
		bmx_gamekit_load_player_photo(requestId, identifier, size)
		Return requestId
	End Method

	Rem
	bbdoc: Fetches metadata for every saved game available to the local player.
	returns: A request identifier supplied to #IGameCenterSavedGameListener.
	End Rem
	Method FetchSavedGames:Int()
		Local requestId:Int = NextRequest()
		bmx_gamekit_fetch_saved_games(requestId)
		Return requestId
	End Method

	Rem
	bbdoc: Saves arbitrary game data to the local player's iCloud account.
	about: Saving with an existing name replaces the current version from this device. Keep the data compact and encode its format and schema version within the byte array.
	returns: A request identifier supplied to #IGameCenterSavedGameListener.
	End Rem
	Method SaveGame:Int(name:String, data:Byte[])
		Local requestId:Int = NextRequest()
		bmx_gamekit_save_game(requestId, name, data)
		Return requestId
	End Method

	Rem
	bbdoc: Loads the bytes stored in a saved-game version returned during the current session.
	returns: A request identifier supplied to #IGameCenterSavedGameListener.
	End Rem
	Method LoadSavedGame:Int(savedGame:TGameCenterSavedGame)
		Local requestId:Int = NextRequest()
		Local handle:Int
		If savedGame Then handle = savedGame._handle
		bmx_gamekit_load_saved_game(requestId, handle)
		Return requestId
	End Method

	Rem
	bbdoc: Deletes every saved-game version with the supplied name.
	returns: A request identifier supplied to #IGameCenterSavedGameListener.
	End Rem
	Method DeleteSavedGames:Int(name:String)
		Local requestId:Int = NextRequest()
		bmx_gamekit_delete_saved_games(requestId, name)
		Return requestId
	End Method

	Rem
	bbdoc: Replaces all versions in a conflict reported by #IGameCenterSavedGameListener with the supplied data.
	about: A conflict identifier is valid only for the current authenticated Game Center session. The application should load and compare the conflicting versions before choosing or merging their data.
	returns: A request identifier supplied to #IGameCenterSavedGameListener.
	End Rem
	Method ResolveSavedGameConflict:Int(conflictId:Int, data:Byte[])
		Local requestId:Int = NextRequest()
		bmx_gamekit_resolve_saved_game_conflict(requestId, conflictId, data)
		Return requestId
	End Method

	Rem
	bbdoc: Loads a ranked range from a leaderboard.
	about: startRank is one based and count is limited to 100 by GameKit.
	returns: A request identifier supplied to the listener callback.
	End Rem
	Method LoadLeaderboard:Int(leaderboardIdentifier:String, playerScope:EGameCenterPlayerScope = EGameCenterPlayerScope.Global, timeScope:EGameCenterTimeScope = EGameCenterTimeScope.AllTime, startRank:Int = 1, count:Int = 10)
		Local requestId:Int = NextRequest()
		bmx_gamekit_load_leaderboard(requestId, leaderboardIdentifier, playerScope, timeScope, startRank, count)
		Return requestId
	End Method

	Private

	Method NextRequest:Int()
		Local requestId:Int = nextRequestId
		nextRequestId :+ 1
		If nextRequestId <= 0 Then nextRequestId = 1
		Return requestId
	End Method

	Function _OnAuthenticationChanged(service:TGameCenter, authenticated:Int, gamePlayerId:String, teamPlayerId:String, alias:String, displayName:String, underage:Int, multiplayerRestricted:Int, personalizedCommunicationRestricted:Int, errorDomain:String, errorCode:Int, errorMessage:String) { nomangle }
		Local accountChanged:Int = Not authenticated Or Not service.localPlayer Or service.localPlayer.gamePlayerId <> gamePlayerId
		If accountChanged Then
			service.savedGameLoads.Clear()
			service.savedGames.Clear()
		End If
		Local player:TGameCenterPlayer
		If authenticated Then
			player = TGameCenterPlayer._Create(gamePlayerId, teamPlayerId, alias, displayName, underage, multiplayerRestricted, personalizedCommunicationRestricted)
		End If
		service.localPlayer = player
		If service.listener Then service.listener.OnGameCenterAuthenticationChanged(authenticated, player, TGameCenterError._Create(errorDomain, errorCode, errorMessage))
	End Function

	Function _OnIdentityVerificationFetched(service:TGameCenter, requestId:Int, gamePlayerId:String, teamPlayerId:String, bundleIdentifier:String, publicKeyUrl:String, signature:Byte[], salt:Byte[], timestamp:ULong, errorDomain:String, errorCode:Int, errorMessage:String) { nomangle }
		Local verification:TGameCenterIdentityVerification
		If Not errorDomain Then
			verification = TGameCenterIdentityVerification._Create(gamePlayerId, teamPlayerId, bundleIdentifier, publicKeyUrl, signature, salt, timestamp)
		End If
		Local identityListener:IGameCenterIdentityListener = IGameCenterIdentityListener(service.listener)
		If identityListener Then identityListener.OnGameCenterIdentityVerificationFetched(requestId, verification, TGameCenterError._Create(errorDomain, errorCode, errorMessage))
	End Function

	Function _OnAchievementReported(service:TGameCenter, requestId:Int, identifier:String, errorDomain:String, errorCode:Int, errorMessage:String) { nomangle }
		If service.listener Then service.listener.OnGameCenterAchievementReported(requestId, identifier, TGameCenterError._Create(errorDomain, errorCode, errorMessage))
	End Function

	Function _OnAchievementLoadBegin(service:TGameCenter, requestId:Int, count:Int) { nomangle }
		Local load:TAchievementLoad = New TAchievementLoad
		load.values = New TGameCenterAchievement[count]
		service.achievementLoads.Insert(String.FromInt(requestId), load)
	End Function

	Function _OnAchievementLoaded(service:TGameCenter, requestId:Int, identifier:String, percentComplete:Double, completed:Int, lastReportedTime:Double) { nomangle }
		Local load:TAchievementLoad = TAchievementLoad(service.achievementLoads.ValueForKey(String.FromInt(requestId)))
		If load And load.index < load.values.length Then
			load.values[load.index] = TGameCenterAchievement._Create(identifier, percentComplete, completed, lastReportedTime)
			load.index :+ 1
		End If
	End Function

	Function _OnAchievementLoadComplete(service:TGameCenter, requestId:Int, errorDomain:String, errorCode:Int, errorMessage:String) { nomangle }
		Local key:String = String.FromInt(requestId)
		Local load:TAchievementLoad = TAchievementLoad(service.achievementLoads.ValueForKey(key))
		service.achievementLoads.Remove(key)
		Local result:TGameCenterAchievementResult
		If load Then
			result = New TGameCenterAchievementResult
			result.achievements = load.values
		End If
		If service.listener Then service.listener.OnGameCenterAchievementsLoaded(requestId, result, TGameCenterError._Create(errorDomain, errorCode, errorMessage))
	End Function

	Function _OnAchievementDescriptionLoadBegin(service:TGameCenter, requestId:Int, count:Int) { nomangle }
		Local load:TAchievementDescriptionLoad = New TAchievementDescriptionLoad
		load.values = New TGameCenterAchievementDescription[count]
		service.achievementDescriptionLoads.Insert(String.FromInt(requestId), load)
	End Function

	Function _OnAchievementDescriptionLoaded(service:TGameCenter, requestId:Int, identifier:String, groupIdentifier:String, title:String, achievedDescription:String, unachievedDescription:String, maximumPoints:Int, hidden:Int, replayable:Int, rarityPercent:Double, releaseState:EGameCenterReleaseState) { nomangle }
		Local load:TAchievementDescriptionLoad = TAchievementDescriptionLoad(service.achievementDescriptionLoads.ValueForKey(String.FromInt(requestId)))
		If load And load.index < load.values.length Then
			load.values[load.index] = TGameCenterAchievementDescription._Create(identifier, groupIdentifier, title, achievedDescription, unachievedDescription, maximumPoints, hidden, replayable, rarityPercent, releaseState)
			load.index :+ 1
		End If
	End Function

	Function _OnAchievementDescriptionLoadComplete(service:TGameCenter, requestId:Int, errorDomain:String, errorCode:Int, errorMessage:String) { nomangle }
		Local key:String = String.FromInt(requestId)
		Local load:TAchievementDescriptionLoad = TAchievementDescriptionLoad(service.achievementDescriptionLoads.ValueForKey(key))
		service.achievementDescriptionLoads.Remove(key)
		Local result:TGameCenterAchievementDescriptionResult
		If load Then
			result = New TGameCenterAchievementDescriptionResult
			result.descriptions = load.values
		End If
		Local metadataListener:IGameCenterMetadataListener = IGameCenterMetadataListener(service.listener)
		If metadataListener Then metadataListener.OnGameCenterAchievementDescriptionsLoaded(requestId, result, TGameCenterError._Create(errorDomain, errorCode, errorMessage))
	End Function

	Function _OnAchievementsReset(service:TGameCenter, requestId:Int, errorDomain:String, errorCode:Int, errorMessage:String) { nomangle }
		If service.listener Then service.listener.OnGameCenterAchievementsReset(requestId, TGameCenterError._Create(errorDomain, errorCode, errorMessage))
	End Function

	Function _OnScoreSubmitted(service:TGameCenter, requestId:Int, leaderboardIdentifier:String, score:Long, errorDomain:String, errorCode:Int, errorMessage:String) { nomangle }
		If service.listener Then service.listener.OnGameCenterScoreSubmitted(requestId, leaderboardIdentifier, score, TGameCenterError._Create(errorDomain, errorCode, errorMessage))
	End Function

	Function _OnLeaderboardLoadBegin(service:TGameCenter, requestId:Int, identifier:String, title:String, count:Int, totalPlayerCount:Long) { nomangle }
		Local load:TLeaderboardLoad = New TLeaderboardLoad
		load.result = New TGameCenterLeaderboardResult
		load.result.identifier = identifier
		load.result.title = title
		load.result.totalPlayerCount = totalPlayerCount
		load.values = New TGameCenterLeaderboardEntry[count]
		service.leaderboardLoads.Insert(String.FromInt(requestId), load)
	End Function

	Function _OnLeaderboardEntry(service:TGameCenter, requestId:Int, localPlayer:Int, gamePlayerId:String, teamPlayerId:String, alias:String, displayName:String, rank:Long, score:Long, formattedScore:String, context:ULong, date:Double) { nomangle }
		Local load:TLeaderboardLoad = TLeaderboardLoad(service.leaderboardLoads.ValueForKey(String.FromInt(requestId)))
		If Not load Then Return
		Local player:TGameCenterPlayer = TGameCenterPlayer._Create(gamePlayerId, teamPlayerId, alias, displayName)
		Local entry:TGameCenterLeaderboardEntry = TGameCenterLeaderboardEntry._Create(player, rank, score, formattedScore, context, date)
		If localPlayer Then
			load.result.localPlayerEntry = entry
		Else If load.index < load.values.length Then
			load.values[load.index] = entry
			load.index :+ 1
		End If
	End Function

	Function _OnLeaderboardLoadComplete(service:TGameCenter, requestId:Int, errorDomain:String, errorCode:Int, errorMessage:String) { nomangle }
		Local key:String = String.FromInt(requestId)
		Local load:TLeaderboardLoad = TLeaderboardLoad(service.leaderboardLoads.ValueForKey(key))
		service.leaderboardLoads.Remove(key)
		Local result:TGameCenterLeaderboardResult
		If load Then
			load.result.entries = load.values
			result = load.result
		End If
		If service.listener Then service.listener.OnGameCenterLeaderboardLoaded(requestId, result, TGameCenterError._Create(errorDomain, errorCode, errorMessage))
	End Function

	Function _OnLeaderboardInfoLoadBegin(service:TGameCenter, requestId:Int, setIdentifier:String, count:Int) { nomangle }
		Local load:TLeaderboardInfoLoad = New TLeaderboardInfoLoad
		load.result = New TGameCenterLeaderboardInfoResult
		load.result.setIdentifier = setIdentifier
		load.values = New TGameCenterLeaderboardInfo[count]
		service.leaderboardInfoLoads.Insert(String.FromInt(requestId), load)
	End Function

	Function _OnLeaderboardInfoLoaded(service:TGameCenter, requestId:Int, identifier:String, groupIdentifier:String, title:String, leaderboardType:EGameCenterLeaderboardType, startTime:Double, nextStartTime:Double, duration:Double, description:String, hidden:Int, releaseState:EGameCenterReleaseState) { nomangle }
		Local load:TLeaderboardInfoLoad = TLeaderboardInfoLoad(service.leaderboardInfoLoads.ValueForKey(String.FromInt(requestId)))
		If load And load.index < load.values.length Then
			load.values[load.index] = TGameCenterLeaderboardInfo._Create(identifier, groupIdentifier, title, leaderboardType, startTime, nextStartTime, duration, description, hidden, releaseState)
			load.index :+ 1
		End If
	End Function

	Function _OnLeaderboardInfoLoadComplete(service:TGameCenter, requestId:Int, errorDomain:String, errorCode:Int, errorMessage:String) { nomangle }
		Local key:String = String.FromInt(requestId)
		Local load:TLeaderboardInfoLoad = TLeaderboardInfoLoad(service.leaderboardInfoLoads.ValueForKey(key))
		service.leaderboardInfoLoads.Remove(key)
		Local result:TGameCenterLeaderboardInfoResult
		If load Then
			load.result.leaderboards = load.values
			result = load.result
		End If
		Local metadataListener:IGameCenterMetadataListener = IGameCenterMetadataListener(service.listener)
		If metadataListener Then metadataListener.OnGameCenterLeaderboardsLoaded(requestId, result, TGameCenterError._Create(errorDomain, errorCode, errorMessage))
	End Function

	Function _OnLeaderboardSetLoadBegin(service:TGameCenter, requestId:Int, count:Int) { nomangle }
		Local load:TLeaderboardSetLoad = New TLeaderboardSetLoad
		load.values = New TGameCenterLeaderboardSet[count]
		service.leaderboardSetLoads.Insert(String.FromInt(requestId), load)
	End Function

	Function _OnLeaderboardSetLoaded(service:TGameCenter, requestId:Int, identifier:String, groupIdentifier:String, title:String) { nomangle }
		Local load:TLeaderboardSetLoad = TLeaderboardSetLoad(service.leaderboardSetLoads.ValueForKey(String.FromInt(requestId)))
		If load And load.index < load.values.length Then
			load.values[load.index] = TGameCenterLeaderboardSet._Create(identifier, groupIdentifier, title)
			load.index :+ 1
		End If
	End Function

	Function _OnLeaderboardSetLoadComplete(service:TGameCenter, requestId:Int, errorDomain:String, errorCode:Int, errorMessage:String) { nomangle }
		Local key:String = String.FromInt(requestId)
		Local load:TLeaderboardSetLoad = TLeaderboardSetLoad(service.leaderboardSetLoads.ValueForKey(key))
		service.leaderboardSetLoads.Remove(key)
		Local result:TGameCenterLeaderboardSetResult
		If load Then
			result = New TGameCenterLeaderboardSetResult
			result.sets = load.values
		End If
		Local metadataListener:IGameCenterMetadataListener = IGameCenterMetadataListener(service.listener)
		If metadataListener Then metadataListener.OnGameCenterLeaderboardSetsLoaded(requestId, result, TGameCenterError._Create(errorDomain, errorCode, errorMessage))
	End Function

	Function _OnResourceImageLoaded(service:TGameCenter, requestId:Int, kind:EGameCenterResourceKind, identifier:String, pngData:Byte[], errorDomain:String, errorCode:Int, errorMessage:String) { nomangle }
		Local metadataListener:IGameCenterMetadataListener = IGameCenterMetadataListener(service.listener)
		If metadataListener Then metadataListener.OnGameCenterResourceImageLoaded(requestId, kind, identifier, pngData, TGameCenterError._Create(errorDomain, errorCode, errorMessage))
	End Function

	Function _OnFriendsAuthorizationLoaded(service:TGameCenter, requestId:Int, status:EGameCenterFriendsAuthorization, errorDomain:String, errorCode:Int, errorMessage:String) { nomangle }
		Local playerListener:IGameCenterPlayerListener = IGameCenterPlayerListener(service.listener)
		If playerListener Then playerListener.OnGameCenterFriendsAuthorizationLoaded(requestId, status, TGameCenterError._Create(errorDomain, errorCode, errorMessage))
	End Function

	Function _OnFriendsLoadBegin(service:TGameCenter, requestId:Int, count:Int) { nomangle }
		Local load:TPlayerLoad = New TPlayerLoad
		load.values = New TGameCenterPlayer[count]
		service.playerLoads.Insert(String.FromInt(requestId), load)
	End Function

	Function _OnFriendLoaded(service:TGameCenter, requestId:Int, gamePlayerId:String, teamPlayerId:String, alias:String, displayName:String) { nomangle }
		Local load:TPlayerLoad = TPlayerLoad(service.playerLoads.ValueForKey(String.FromInt(requestId)))
		If load And load.index < load.values.length Then
			load.values[load.index] = TGameCenterPlayer._Create(gamePlayerId, teamPlayerId, alias, displayName)
			load.index :+ 1
		End If
	End Function

	Function _OnFriendsLoadComplete(service:TGameCenter, requestId:Int, errorDomain:String, errorCode:Int, errorMessage:String) { nomangle }
		Local key:String = String.FromInt(requestId)
		Local load:TPlayerLoad = TPlayerLoad(service.playerLoads.ValueForKey(key))
		service.playerLoads.Remove(key)
		Local result:TGameCenterPlayerResult
		If load Then
			result = New TGameCenterPlayerResult
			result.players = load.values
		End If
		Local playerListener:IGameCenterPlayerListener = IGameCenterPlayerListener(service.listener)
		If playerListener Then playerListener.OnGameCenterFriendsLoaded(requestId, result, TGameCenterError._Create(errorDomain, errorCode, errorMessage))
	End Function

	Function _OnPlayerPhotoLoaded(service:TGameCenter, requestId:Int, gamePlayerId:String, size:EGameCenterPhotoSize, pngData:Byte[], errorDomain:String, errorCode:Int, errorMessage:String) { nomangle }
		Local playerListener:IGameCenterPlayerListener = IGameCenterPlayerListener(service.listener)
		If playerListener Then playerListener.OnGameCenterPlayerPhotoLoaded(requestId, gamePlayerId, size, pngData, TGameCenterError._Create(errorDomain, errorCode, errorMessage))
	End Function

	Function _SavedGameLoadKey:String(operation:Int, identifier:Int)
		Return operation + ":" + identifier
	End Function

	Function _OnSavedGameListBegin(service:TGameCenter, operation:Int, identifier:Int, count:Int) { nomangle }
		Local load:TSavedGameLoad = New TSavedGameLoad
		load.values = New TGameCenterSavedGame[count]
		service.savedGameLoads.Insert(_SavedGameLoadKey(operation, identifier), load)
	End Function

	Function _OnSavedGameListItem(service:TGameCenter, operation:Int, identifier:Int, handle:Int, name:String, deviceName:String, modificationTime:Double) { nomangle }
		Local savedGame:TGameCenterSavedGame = TGameCenterSavedGame._Create(handle, name, deviceName, modificationTime)
		service.savedGames.Insert(String.FromInt(handle), savedGame)
		Local load:TSavedGameLoad = TSavedGameLoad(service.savedGameLoads.ValueForKey(_SavedGameLoadKey(operation, identifier)))
		If load And load.index < load.values.length Then
			load.values[load.index] = savedGame
			load.index :+ 1
		End If
	End Function

	Function _OnSavedGameListComplete(service:TGameCenter, operation:Int, identifier:Int, conflictId:Int, errorDomain:String, errorCode:Int, errorMessage:String) { nomangle }
		Local key:String = _SavedGameLoadKey(operation, identifier)
		Local load:TSavedGameLoad = TSavedGameLoad(service.savedGameLoads.ValueForKey(key))
		service.savedGameLoads.Remove(key)
		Local result:TGameCenterSavedGameResult
		If load Then
			result = New TGameCenterSavedGameResult
			result.savedGames = load.values
		End If
		Local savedGameListener:IGameCenterSavedGameListener = IGameCenterSavedGameListener(service.listener)
		If Not savedGameListener Then Return
		Select operation
			Case 0
				savedGameListener.OnGameCenterSavedGamesFetched(identifier, result, TGameCenterError._Create(errorDomain, errorCode, errorMessage))
			Case 1
				savedGameListener.OnGameCenterSavedGameConflictResolved(identifier, conflictId, result, TGameCenterError._Create(errorDomain, errorCode, errorMessage))
			Case 2
				savedGameListener.OnGameCenterSavedGameConflict(conflictId, result)
		End Select
	End Function

	Function _OnSavedGameSaved(service:TGameCenter, requestId:Int, handle:Int, name:String, deviceName:String, modificationTime:Double, errorDomain:String, errorCode:Int, errorMessage:String) { nomangle }
		Local savedGame:TGameCenterSavedGame
		If handle Then
			savedGame = TGameCenterSavedGame._Create(handle, name, deviceName, modificationTime)
			service.savedGames.Insert(String.FromInt(handle), savedGame)
		End If
		Local savedGameListener:IGameCenterSavedGameListener = IGameCenterSavedGameListener(service.listener)
		If savedGameListener Then savedGameListener.OnGameCenterSavedGameSaved(requestId, savedGame, TGameCenterError._Create(errorDomain, errorCode, errorMessage))
	End Function

	Function _OnSavedGameDataLoaded(service:TGameCenter, requestId:Int, handle:Int, data:Byte[], errorDomain:String, errorCode:Int, errorMessage:String) { nomangle }
		Local savedGame:TGameCenterSavedGame = TGameCenterSavedGame(service.savedGames.ValueForKey(String.FromInt(handle)))
		Local savedGameListener:IGameCenterSavedGameListener = IGameCenterSavedGameListener(service.listener)
		If savedGameListener Then savedGameListener.OnGameCenterSavedGameDataLoaded(requestId, savedGame, data, TGameCenterError._Create(errorDomain, errorCode, errorMessage))
	End Function

	Function _OnSavedGamesDeleted(service:TGameCenter, requestId:Int, name:String, errorDomain:String, errorCode:Int, errorMessage:String) { nomangle }
		Local savedGameListener:IGameCenterSavedGameListener = IGameCenterSavedGameListener(service.listener)
		If savedGameListener Then savedGameListener.OnGameCenterSavedGamesDeleted(requestId, name, TGameCenterError._Create(errorDomain, errorCode, errorMessage))
	End Function

	Function _OnSavedGameModified(service:TGameCenter, handle:Int, name:String, deviceName:String, modificationTime:Double) { nomangle }
		Local savedGame:TGameCenterSavedGame = TGameCenterSavedGame._Create(handle, name, deviceName, modificationTime)
		service.savedGames.Insert(String.FromInt(handle), savedGame)
		Local savedGameListener:IGameCenterSavedGameListener = IGameCenterSavedGameListener(service.listener)
		If savedGameListener Then savedGameListener.OnGameCenterSavedGameModified(savedGame)
	End Function

	Function _OnViewDismissed(service:TGameCenter, view:EGameCenterView) { nomangle }
		If service.listener Then service.listener.OnGameCenterViewDismissed(view)
	End Function
End Type

Private
Global _gameCenter:TGameCenter = New TGameCenter
Public

Extern
	Function bmx_gamekit_start(service:TGameCenter)
	Function bmx_gamekit_stop()
	Function bmx_gamekit_is_available:Int()
	Function bmx_gamekit_is_authenticated:Int()
	Function bmx_gamekit_fetch_identity_verification(requestId:Int)
	Function bmx_gamekit_set_access_point_active(active:Int, location:EGameCenterAccessPointLocation)
	Function bmx_gamekit_is_access_point_active:Int()
	Function bmx_gamekit_is_access_point_visible:Int()
	Function bmx_gamekit_is_presenting:Int()
	Function bmx_gamekit_show(view:EGameCenterView)
	Function bmx_gamekit_report_achievement(requestId:Int, identifier:String, percentComplete:Double, showCompletionBanner:Int)
	Function bmx_gamekit_load_achievements(requestId:Int)
	Function bmx_gamekit_load_achievement_descriptions(requestId:Int)
	Function bmx_gamekit_reset_achievements(requestId:Int)
	Function bmx_gamekit_submit_score(requestId:Int, leaderboardIdentifier:String, score:Long, context:ULong)
	Function bmx_gamekit_load_leaderboard(requestId:Int, leaderboardIdentifier:String, playerScope:EGameCenterPlayerScope, timeScope:EGameCenterTimeScope, startRank:Int, count:Int)
	Function bmx_gamekit_load_leaderboards(requestId:Int, setIdentifier:String)
	Function bmx_gamekit_load_leaderboard_sets(requestId:Int)
	Function bmx_gamekit_load_resource_image(requestId:Int, kind:EGameCenterResourceKind, identifier:String)
	Function bmx_gamekit_load_friends_authorization(requestId:Int)
	Function bmx_gamekit_load_friends(requestId:Int)
	Function bmx_gamekit_load_player_photo(requestId:Int, gamePlayerId:String, size:EGameCenterPhotoSize)
	Function bmx_gamekit_fetch_saved_games(requestId:Int)
	Function bmx_gamekit_save_game(requestId:Int, name:String, data:Byte[])
	Function bmx_gamekit_load_saved_game(requestId:Int, handle:Int)
	Function bmx_gamekit_delete_saved_games(requestId:Int, name:String)
	Function bmx_gamekit_resolve_saved_game_conflict(requestId:Int, conflictId:Int, data:Byte[])
End Extern
