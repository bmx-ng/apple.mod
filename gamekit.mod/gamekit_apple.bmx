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

Private

Type TAchievementLoad
	Field values:TGameCenterAchievement[]
	Field index:Int
End Type

Type TLeaderboardLoad
	Field result:TGameCenterLeaderboardResult
	Field values:TGameCenterLeaderboardEntry[]
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
	bbdoc: Shows or hides Apple's Game Center access point.
	End Rem
	Method SetAccessPointActive(active:Int, location:EGameCenterAccessPointLocation = EGameCenterAccessPointLocation.TopLeading)
		bmx_gamekit_set_access_point_active(active, location)
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
		Local player:TGameCenterPlayer
		If authenticated Then
			player = TGameCenterPlayer._Create(gamePlayerId, teamPlayerId, alias, displayName, underage, multiplayerRestricted, personalizedCommunicationRestricted)
		End If
		service.localPlayer = player
		If service.listener Then service.listener.OnGameCenterAuthenticationChanged(authenticated, player, TGameCenterError._Create(errorDomain, errorCode, errorMessage))
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
	Function bmx_gamekit_set_access_point_active(active:Int, location:EGameCenterAccessPointLocation)
	Function bmx_gamekit_show(view:EGameCenterView)
	Function bmx_gamekit_report_achievement(requestId:Int, identifier:String, percentComplete:Double, showCompletionBanner:Int)
	Function bmx_gamekit_load_achievements(requestId:Int)
	Function bmx_gamekit_reset_achievements(requestId:Int)
	Function bmx_gamekit_submit_score(requestId:Int, leaderboardIdentifier:String, score:Long, context:ULong)
	Function bmx_gamekit_load_leaderboard(requestId:Int, leaderboardIdentifier:String, playerScope:EGameCenterPlayerScope, timeScope:EGameCenterTimeScope, startRank:Int, count:Int)
End Extern
