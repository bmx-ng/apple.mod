SuperStrict

Framework Max2D.SDL3RenderMax2D
Import Apple.GameKit
Import BRL.PolledInput
Import BRL.StandardIO

Const SCREEN_WIDTH:Int = 800
Const SCREEN_HEIGHT:Int = 450

Global gameCenter:TGameCenter
Global statusText:String = "Starting Game Center..."
Global detailText:String = ""
Global inputText:String = "No button tapped yet"
Global savedGames:TGameCenterSavedGame[] = New TGameCenterSavedGame[0]
Global newestSave:TGameCenterSavedGame
Global score:Long
Global pendingConflictId:Int
Global pendingConflictSave:TGameCenterSavedGame

Function EncodeScore:Byte[](value:Long)
	Local data:Byte[] = New Byte[8]
	For Local index:Int = 0 Until data.length
		data[index] = Byte(value Shr (index * 8))
	Next
	Return data
End Function

Function DecodeScore:Long(data:Byte[])
	If Not data Or data.length < 8 Then Return 0
	Local value:Long
	For Local index:Int = 0 Until 8
		value :| (Long(data[index]) & $ff) Shl (index * 8)
	Next
	Return value
End Function

Function SelectNewestSave()
	newestSave = Null
	For Local savedGame:TGameCenterSavedGame = EachIn savedGames
		If Not newestSave Or savedGame.modificationTime > newestSave.modificationTime Then newestSave = savedGame
	Next
End Function

Function ShowError(context:String, error:TGameCenterError)
	statusText = context
	detailText = error.domain + " (" + error.code + "): " + error.message
	Print statusText + ": " + detailText
End Function

Type TListener Implements IGameCenterListener, IGameCenterSavedGameListener
	Method OnGameCenterAuthenticationChanged(authenticated:Int, player:TGameCenterPlayer, error:TGameCenterError)
		If error Then
			ShowError("Authentication failed", error)
		Else If authenticated Then
			statusText = "Authenticated as " + player.displayName
			gameCenter.FetchSavedGames()
		Else
			statusText = "Game Center is not authenticated"
		End If
	End Method

	Method OnGameCenterSavedGamesFetched(requestId:Int, result:TGameCenterSavedGameResult, error:TGameCenterError)
		If error Then
			ShowError("Fetch failed", error)
		Else
			savedGames = New TGameCenterSavedGame[0]
			If result Then savedGames = result.savedGames
			SelectNewestSave()
			statusText = "Found " + savedGames.length + " saved games"
			If newestSave Then detailText = newestSave.name + " from " + newestSave.deviceName
			Print statusText
		End If
	End Method

	Method OnGameCenterSavedGameSaved(requestId:Int, savedGame:TGameCenterSavedGame, error:TGameCenterError)
		If error Then
			ShowError("Save failed", error)
		Else
			statusText = "Saved score " + score
			Print statusText
			gameCenter.FetchSavedGames()
		End If
	End Method

	Method OnGameCenterSavedGameDataLoaded(requestId:Int, savedGame:TGameCenterSavedGame, data:Byte[], error:TGameCenterError)
		If error Then
			ShowError("Load failed", error)
			Return
		End If
		score = DecodeScore(data)
		statusText = "Loaded score " + score
		Print statusText + " from " + savedGame.name + " (" + data.length + " bytes)"
		If pendingConflictId And savedGame = pendingConflictSave Then
			Local conflictId:Int = pendingConflictId
			pendingConflictId = 0
			pendingConflictSave = Null
			statusText = "Resolving conflict with newest version"
			gameCenter.ResolveSavedGameConflict(conflictId, data)
		End If
	End Method

	Method OnGameCenterSavedGamesDeleted(requestId:Int, name:String, error:TGameCenterError)
		If error Then
			ShowError("Delete failed", error)
		Else
			statusText = "Deleted " + name
			Print statusText
			gameCenter.FetchSavedGames()
		End If
	End Method

	Method OnGameCenterSavedGameConflict(conflictId:Int, result:TGameCenterSavedGameResult)
		If Not result Or Not result.savedGames.length Then Return
		pendingConflictId = conflictId
		pendingConflictSave = result.savedGames[0]
		For Local savedGame:TGameCenterSavedGame = EachIn result.savedGames
			If savedGame.modificationTime > pendingConflictSave.modificationTime Then pendingConflictSave = savedGame
		Next
		statusText = "Conflict found; loading newest version"
		Print statusText
		gameCenter.LoadSavedGame(pendingConflictSave)
	End Method

	Method OnGameCenterSavedGameConflictResolved(requestId:Int, conflictId:Int, result:TGameCenterSavedGameResult, error:TGameCenterError)
		If error Then
			ShowError("Conflict resolution failed", error)
		Else
			statusText = "Saved-game conflict resolved"
			Print statusText
			gameCenter.FetchSavedGames()
		End If
	End Method

	Method OnGameCenterSavedGameModified(savedGame:TGameCenterSavedGame)
		statusText = "Cloud save changed on another device"
		Print statusText
		gameCenter.FetchSavedGames()
	End Method

	Method OnGameCenterAchievementReported(requestId:Int, identifier:String, error:TGameCenterError) End Method
	Method OnGameCenterAchievementsLoaded(requestId:Int, result:TGameCenterAchievementResult, error:TGameCenterError) End Method
	Method OnGameCenterAchievementsReset(requestId:Int, error:TGameCenterError) End Method
	Method OnGameCenterScoreSubmitted(requestId:Int, leaderboardIdentifier:String, submittedScore:Long, error:TGameCenterError) End Method
	Method OnGameCenterLeaderboardLoaded(requestId:Int, leaderboard:TGameCenterLeaderboardResult, error:TGameCenterError) End Method
	Method OnGameCenterViewDismissed(view:EGameCenterView) End Method
End Type

Function DrawButton(label:String, x:Int, y:Int)
	SetColor 55, 155, 235
	DrawRect x, y, 150, 48
	SetColor 255, 255, 255
	DrawText label, x + 18, y + 15
End Function

Graphics SCREEN_WIDTH, SCREEN_HEIGHT
SetVirtualResolution SCREEN_WIDTH, SCREEN_HEIGHT, VIRTUAL_LETTERBOX
SetClsColor 12, 18, 30

gameCenter = TGameCenter.Shared()
Local listener:TListener = New TListener
gameCenter.Start(listener)

While Not AppTerminate()
	Cls
	SetColor 255, 255, 255
	DrawText "Game Center Saved Games", 55, 45
	DrawText statusText, 55, 90
	DrawText detailText, 55, 120
	DrawText "Current score: " + score, 55, 155
	DrawText inputText, 55, 180

	DrawButton "Fetch", 55, 220
	DrawButton "Save +1", 225, 220
	DrawButton "Load newest", 395, 220
	DrawButton "Delete", 565, 220

	If MouseHit(1) Then
		Local mouseX:Float, mouseY:Float
		Local insideViewport:Int = GetVirtualMouse(mouseX, mouseY, True)
		inputText = "Tap at " + Int(mouseX) + ", " + Int(mouseY)
		If Not insideViewport Then
			inputText :+ " - outside viewport"
		Else If mouseY >= 220 And mouseY < 268 And mouseX >= 55 And mouseX < 205 Then
			inputText :+ " - Fetch"
			gameCenter.FetchSavedGames()
		Else If mouseY >= 220 And mouseY < 268 And mouseX >= 225 And mouseX < 375 Then
			inputText :+ " - Save +1"
			score :+ 1
			gameCenter.SaveGame("example-save", EncodeScore(score))
		Else If mouseY >= 220 And mouseY < 268 And mouseX >= 395 And mouseX < 545 And newestSave Then
			inputText :+ " - Load newest"
			gameCenter.LoadSavedGame(newestSave)
		Else If mouseY >= 220 And mouseY < 268 And mouseX >= 565 And mouseX < 715 Then
			inputText :+ " - Delete"
			gameCenter.DeleteSavedGames("example-save")
		End If
		Print inputText
	End If
	Flip
Wend

gameCenter.Stop()
EndGraphics
