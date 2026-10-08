SuperStrict

Framework Max2D.SDL3RenderMax2D
Import Apple.GameKit
Import BRL.PolledInput

Const SCREEN_WIDTH:Int = 800
Const SCREEN_HEIGHT:Int = 450

Global statusText:String = "Starting Game Center..."
Global detailText:String = ""
Global metadataRequested:Int

Type TListener Implements IGameCenterListener, IGameCenterMetadataListener
	Method OnGameCenterAuthenticationChanged(authenticated:Int, player:TGameCenterPlayer, error:TGameCenterError)
		If error Then
			statusText = "Authentication: " + error.message
		Else If authenticated Then
			statusText = "Authenticated as " + player.displayName
			detailText = "Player ID: " + player.gamePlayerId
			If Not metadataRequested Then
				metadataRequested = True
				TGameCenter.Shared().LoadAchievementDescriptions()
				TGameCenter.Shared().LoadLeaderboards()
				TGameCenter.Shared().LoadLeaderboardSets()
			End If
		Else
			statusText = "Game Center is not authenticated"
		End If
	End Method

	Method OnGameCenterAchievementReported(requestId:Int, identifier:String, error:TGameCenterError)
		If error Then statusText = error.message Else statusText = "Achievement reported: " + identifier
	End Method

	Method OnGameCenterAchievementsLoaded(requestId:Int, result:TGameCenterAchievementResult, error:TGameCenterError)
		If error Then
			statusText = error.message
		Else
			Local count:Int
			If result Then count = result.achievements.length
			statusText = "Loaded " + count + " achievements"
		End If
	End Method

	Method OnGameCenterAchievementsReset(requestId:Int, error:TGameCenterError)
		If error Then statusText = error.message Else statusText = "Achievements reset"
	End Method

	Method OnGameCenterScoreSubmitted(requestId:Int, leaderboardIdentifier:String, score:Long, error:TGameCenterError)
		If error Then statusText = error.message Else statusText = "Score submitted: " + score
	End Method

	Method OnGameCenterLeaderboardLoaded(requestId:Int, leaderboard:TGameCenterLeaderboardResult, error:TGameCenterError)
		If error Then
			statusText = error.message
		Else If leaderboard Then
			statusText = "Loaded " + leaderboard.entries.length + " leaderboard entries"
		End If
	End Method

	Method OnGameCenterViewDismissed(view:EGameCenterView)
		statusText = "Game Center closed"
	End Method

	Method OnGameCenterAchievementDescriptionsLoaded(requestId:Int, result:TGameCenterAchievementDescriptionResult, error:TGameCenterError)
		If error Then
			statusText = "Achievement metadata: " + error.message
		Else
			Local count:Int
			If result Then count = result.descriptions.length
			statusText = "Loaded " + count + " achievement descriptions"
			If count Then
				detailText = result.descriptions[0].title
				TGameCenter.Shared().LoadResourceImage(EGameCenterResourceKind.Achievement, result.descriptions[0].identifier)
			End If
		End If
	End Method

	Method OnGameCenterLeaderboardsLoaded(requestId:Int, result:TGameCenterLeaderboardInfoResult, error:TGameCenterError)
		If error Then
			statusText = "Leaderboard metadata: " + error.message
		Else
			Local count:Int
			If result Then count = result.leaderboards.length
			statusText = "Loaded " + count + " leaderboards"
		End If
	End Method

	Method OnGameCenterLeaderboardSetsLoaded(requestId:Int, result:TGameCenterLeaderboardSetResult, error:TGameCenterError)
		If error Then
			statusText = "Leaderboard sets: " + error.message
		Else
			Local count:Int
			If result Then count = result.sets.length
			statusText = "Loaded " + count + " leaderboard sets"
		End If
	End Method

	Method OnGameCenterResourceImageLoaded(requestId:Int, kind:EGameCenterResourceKind, identifier:String, pngData:Byte[], error:TGameCenterError)
		If error Then
			statusText = "Artwork: " + error.message
		Else
			statusText = "Loaded " + pngData.length + " bytes of PNG artwork"
		End If
	End Method
End Type

Graphics SCREEN_WIDTH, SCREEN_HEIGHT
SetClsColor 12, 18, 30

Local gameCenter:TGameCenter = TGameCenter.Shared()
Local listener:TListener = New TListener
gameCenter.Start(listener)
gameCenter.SetAccessPointActive(True, EGameCenterAccessPointLocation.TopLeading)

While Not AppTerminate()
	Cls
	SetColor 255, 255, 255
	DrawText "Apple.GameKit", 60, 60
	DrawText statusText, 60, 115
	DrawText detailText, 60, 145
	SetColor 55, 155, 235
	DrawRect 60, 210, 300, 60
	SetColor 255, 255, 255
	DrawText "Open Game Center", 90, 230

	If MouseHit(1) And MouseX() >= 60 And MouseX() < 360 And MouseY() >= 210 And MouseY() < 270 Then
		gameCenter.ShowGameCenter(EGameCenterView.Dashboard)
	End If
	Flip
Wend

gameCenter.Stop()
EndGraphics
