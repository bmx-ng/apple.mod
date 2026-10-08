SuperStrict

Framework Max2D.SDL3RenderMax2D
Import Apple.GameKit
Import BRL.PolledInput
Import BRL.StandardIO

Const SCREEN_WIDTH:Int = 800
Const SCREEN_HEIGHT:Int = 450

Global statusText:String = "Starting Game Center..."
Global detailText:String = ""
Global errorText:String = ""
Global metadataRequested:Int
Global firstChallengeId:String

Function ShowError(context:String, error:TGameCenterError)
	statusText = context
	errorText = error.domain + " (" + error.code + "): " + error.message
	Print statusText + ": " + errorText
End Function

Type TListener Implements IGameCenterListener, IGameCenterMetadataListener, IGameCenterPlayerListener, IGameCenterIdentityListener, IGameCenterChallengeListener, IGameCenterActivityListener
	Method OnGameCenterAuthenticationChanged(authenticated:Int, player:TGameCenterPlayer, error:TGameCenterError)
		If error Then
			ShowError("Authentication failed", error)
		Else If authenticated Then
			statusText = "Authenticated as " + player.displayName
			detailText = "Player ID: " + player.gamePlayerId
			If Not metadataRequested Then
				metadataRequested = True
				TGameCenter.Shared().LoadPlayerPhoto(player, EGameCenterPhotoSize.Small)
				TGameCenter.Shared().LoadAchievementDescriptions()
				TGameCenter.Shared().LoadLeaderboards()
				TGameCenter.Shared().LoadLeaderboardSets()
				If TGameCenter.Shared().AreChallengesAvailable() Then TGameCenter.Shared().LoadChallengeDefinitions()
			End If
		Else
			statusText = "Game Center is not authenticated"
		End If
	End Method

	Method OnGameCenterAchievementReported(requestId:Int, identifier:String, error:TGameCenterError)
		If error Then ShowError("Achievement report failed", error) Else statusText = "Achievement reported: " + identifier
	End Method

	Method OnGameCenterAchievementsLoaded(requestId:Int, result:TGameCenterAchievementResult, error:TGameCenterError)
		If error Then
			ShowError("Achievement load failed", error)
		Else
			Local count:Int
			If result Then count = result.achievements.length
			statusText = "Loaded " + count + " achievements"
		End If
	End Method

	Method OnGameCenterAchievementsReset(requestId:Int, error:TGameCenterError)
		If error Then ShowError("Achievement reset failed", error) Else statusText = "Achievements reset"
	End Method

	Method OnGameCenterScoreSubmitted(requestId:Int, leaderboardIdentifier:String, score:Long, error:TGameCenterError)
		If error Then ShowError("Score submission failed", error) Else statusText = "Score submitted: " + score
	End Method

	Method OnGameCenterLeaderboardLoaded(requestId:Int, leaderboard:TGameCenterLeaderboardResult, error:TGameCenterError)
		If error Then
			ShowError("Leaderboard load failed", error)
		Else If leaderboard Then
			statusText = "Loaded " + leaderboard.entries.length + " leaderboard entries"
		End If
	End Method

	Method OnGameCenterViewDismissed(view:EGameCenterView)
		statusText = "Game Center closed"
	End Method

	Method OnGameCenterAchievementDescriptionsLoaded(requestId:Int, result:TGameCenterAchievementDescriptionResult, error:TGameCenterError)
		If error Then
			ShowError("Achievement metadata failed", error)
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
			ShowError("Leaderboard metadata failed", error)
		Else
			Local count:Int
			If result Then count = result.leaderboards.length
			statusText = "Loaded " + count + " leaderboards"
		End If
	End Method

	Method OnGameCenterLeaderboardSetsLoaded(requestId:Int, result:TGameCenterLeaderboardSetResult, error:TGameCenterError)
		If error Then
			ShowError("Leaderboard sets failed", error)
		Else
			Local count:Int
			If result Then count = result.sets.length
			statusText = "Loaded " + count + " leaderboard sets"
		End If
	End Method

	Method OnGameCenterResourceImageLoaded(requestId:Int, kind:EGameCenterResourceKind, identifier:String, pngData:Byte[], error:TGameCenterError)
		If error Then
			ShowError("Artwork load failed", error)
		Else
			statusText = "Loaded " + pngData.length + " bytes of PNG artwork"
		End If
	End Method

	Method OnGameCenterFriendsAuthorizationLoaded(requestId:Int, authorization:EGameCenterFriendsAuthorization, error:TGameCenterError)
		If error Then ShowError("Friends authorization failed", error) Else Print "Friends authorization: " + authorization.Ordinal()
	End Method

	Method OnGameCenterFriendsLoaded(requestId:Int, result:TGameCenterPlayerResult, error:TGameCenterError)
		If error Then
			ShowError("Friends load failed", error)
		Else
			Local count:Int
			If result Then count = result.players.length
			statusText = "Loaded " + count + " friends"
		End If
	End Method

	Method OnGameCenterPlayerPhotoLoaded(requestId:Int, gamePlayerId:String, size:EGameCenterPhotoSize, pngData:Byte[], error:TGameCenterError)
		If error Then
			ShowError("Player photo failed", error)
		Else
			Print "Loaded " + pngData.length + " bytes of player photo PNG"
		End If
	End Method

	Method OnGameCenterIdentityVerificationFetched(requestId:Int, verification:TGameCenterIdentityVerification, error:TGameCenterError)
		If error Then
			ShowError("Identity verification failed", error)
		Else
			statusText = "Fetched server identity payload"
			detailText = verification.signature.length + " signature bytes; timestamp " + verification.timestamp
			Print "Identity public key: " + verification.publicKeyUrl
			Print "Identity bundle: " + verification.bundleIdentifier
		End If
	End Method

	Method OnGameCenterChallengeDefinitionsLoaded(requestId:Int, result:TGameCenterChallengeDefinitionResult, error:TGameCenterError)
		If error Then
			ShowError("Challenge metadata failed", error)
		Else
			Local count:Int
			If result Then count = result.definitions.length
			statusText = "Loaded " + count + " challenge definitions"
			If count Then
				Local definition:TGameCenterChallengeDefinition = result.definitions[0]
				firstChallengeId = definition.identifier
				detailText = definition.title + " (" + definition.leaderboardIdentifier + ")"
				TGameCenter.Shared().LoadChallengeActiveStatus(definition.identifier)
				TGameCenter.Shared().LoadResourceImage(EGameCenterResourceKind.Challenge, definition.identifier)
			End If
		End If
	End Method

	Method OnGameCenterChallengeActiveStatusLoaded(requestId:Int, identifier:String, hasActiveChallenges:Int, error:TGameCenterError)
		If error Then
			ShowError("Challenge status failed", error)
		Else
			Print "Challenge " + identifier + " has active challenges: " + hasActiveChallenges
		End If
	End Method

	Method OnGameCenterChallengeViewDismissed(requestId:Int, identifier:String, error:TGameCenterError)
		If error Then
			ShowError("Challenge interface failed", error)
		Else If identifier Then
			statusText = "Challenge creation closed: " + identifier
		Else
			statusText = "Challenge browser closed"
		End If
	End Method

	Method OnGameCenterPendingActivityChecked(requestId:Int, hasPendingActivity:Int, error:TGameCenterError)
		If error Then
			ShowError("Pending activity check failed", error)
		Else
			Print "Pending Game Center activity: " + hasPendingActivity
		End If
	End Method

	Method OnGameCenterWantsToPlayActivity:Int(player:TGameCenterPlayer, activity:TGameCenterActivity)
		statusText = "Game Center activity selected"
		detailText = activity.definitionIdentifier
		Print "Route to activity: " + activity.definitionIdentifier
		' A real game should switch to the level or mode represented by the definition.
		Return True
	End Method
End Type

Graphics SCREEN_WIDTH, SCREEN_HEIGHT
SetVirtualResolution SCREEN_WIDTH, SCREEN_HEIGHT, VIRTUAL_LETTERBOX
SetClsColor 12, 18, 30

Local gameCenter:TGameCenter = TGameCenter.Shared()
Local listener:TListener = New TListener
gameCenter.Start(listener)
gameCenter.ShowAccessPoint(EGameCenterAccessPointLocation.TopLeading)
If gameCenter.AreChallengesAvailable() Then gameCenter.CheckPendingGameActivity()

While Not AppTerminate()
	Cls
	SetColor 255, 255, 255
	DrawText "Apple.GameKit", 60, 60
	DrawText statusText, 60, 115
	DrawText detailText, 60, 145
	DrawText errorText, 60, 175
	DrawText "Access point active: " + gameCenter.IsAccessPointActive() + "  visible: " + gameCenter.IsAccessPointVisible(), 60, 195
	SetColor 55, 155, 235
	DrawRect 60, 250, 300, 60
	DrawRect 400, 250, 300, 60
	DrawRect 60, 330, 300, 60
	DrawRect 400, 330, 300, 60
	SetColor 255, 255, 255
	DrawText "Open Game Center", 90, 270
	DrawText "Fetch identity payload", 430, 270
	DrawText "Browse challenges", 90, 350
	DrawText "Create first challenge", 430, 350

	If MouseHit(1) Then
		Local mouseX:Float, mouseY:Float
		If GetVirtualMouse(mouseX, mouseY, True) Then
			If mouseY >= 250 And mouseY < 310 Then
				If mouseX >= 60 And mouseX < 360 Then
					gameCenter.ShowGameCenter(EGameCenterView.Dashboard)
				Else If mouseX >= 400 And mouseX < 700 Then
					gameCenter.FetchIdentityVerification()
				End If
			Else If mouseY >= 330 And mouseY < 390 Then
				If mouseX >= 60 And mouseX < 360 Then
					gameCenter.ShowChallenges()
				Else If mouseX >= 400 And mouseX < 700 Then
					If firstChallengeId Then
						gameCenter.CreateChallenge(firstChallengeId)
					Else
						statusText = "No challenge definition loaded"
					End If
				End If
			End If
		End If
	End If
	Flip
Wend

gameCenter.Stop()
EndGraphics
