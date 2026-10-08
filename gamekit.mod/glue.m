#include "brl.mod/blitz.mod/blitz.h"

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import <TargetConditionals.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

extern void apple_gamekit_gamekit_apple_TGameCenter__OnAuthenticationChanged(BBObject *, int, BBString *, BBString *, BBString *, BBString *, int, int, int, BBString *, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnAchievementReported(BBObject *, int, BBString *, BBString *, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnAchievementLoadBegin(BBObject *, int, int);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnAchievementLoaded(BBObject *, int, BBString *, double, int, double);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnAchievementLoadComplete(BBObject *, int, BBString *, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnAchievementDescriptionLoadBegin(BBObject *, int, int);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnAchievementDescriptionLoaded(BBObject *, int, BBString *, BBString *, BBString *, BBString *, BBString *, int, int, int, double, int);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnAchievementDescriptionLoadComplete(BBObject *, int, BBString *, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnAchievementsReset(BBObject *, int, BBString *, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnScoreSubmitted(BBObject *, int, BBString *, BBLONG, BBString *, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnLeaderboardLoadBegin(BBObject *, int, BBString *, BBString *, int, BBLONG);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnLeaderboardEntry(BBObject *, int, int, BBString *, BBString *, BBString *, BBString *, BBLONG, BBLONG, BBString *, BBULONG, double);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnLeaderboardLoadComplete(BBObject *, int, BBString *, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnLeaderboardInfoLoadBegin(BBObject *, int, BBString *, int);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnLeaderboardInfoLoaded(BBObject *, int, BBString *, BBString *, BBString *, int, double, double, double, BBString *, int, int);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnLeaderboardInfoLoadComplete(BBObject *, int, BBString *, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnLeaderboardSetLoadBegin(BBObject *, int, int);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnLeaderboardSetLoaded(BBObject *, int, BBString *, BBString *, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnLeaderboardSetLoadComplete(BBObject *, int, BBString *, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnResourceImageLoaded(BBObject *, int, int, BBString *, BBArray *, BBString *, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnFriendsAuthorizationLoaded(BBObject *, int, int, BBString *, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnFriendsLoadBegin(BBObject *, int, int);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnFriendLoaded(BBObject *, int, BBString *, BBString *, BBString *, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnFriendsLoadComplete(BBObject *, int, BBString *, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnPlayerPhotoLoaded(BBObject *, int, BBString *, int, BBArray *, BBString *, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnSavedGameListBegin(BBObject *, int, int, int);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnSavedGameListItem(BBObject *, int, int, int, BBString *, BBString *, double);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnSavedGameListComplete(BBObject *, int, int, int, BBString *, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnSavedGameSaved(BBObject *, int, int, BBString *, BBString *, double, BBString *, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnSavedGameDataLoaded(BBObject *, int, int, BBArray *, BBString *, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnSavedGamesDeleted(BBObject *, int, BBString *, BBString *, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnSavedGameModified(BBObject *, int, BBString *, BBString *, double);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnViewDismissed(BBObject *, int);

static BBObject *bmxGameKitService = NULL;
static NSMutableDictionary<NSString *, GKPlayer *> *bmxGameKitPlayers = nil;
static NSMutableDictionary<NSNumber *, GKSavedGame *> *bmxGameKitSavedGames = nil;
static NSMutableDictionary<NSNumber *, NSArray<GKSavedGame *> *> *bmxGameKitSavedGameConflicts = nil;
static NSString *bmxGameKitAuthenticatedPlayerID = nil;
static int bmxGameKitNextSavedGameHandle = 1;
static int bmxGameKitNextConflictHandle = 1;

static NSMutableDictionary<NSString *, GKPlayer *> *PlayerCache(void) {
    if (!bmxGameKitPlayers) bmxGameKitPlayers = [[NSMutableDictionary alloc] init];
    return bmxGameKitPlayers;
}

static void ResetPlayerCache(void) {
    [bmxGameKitPlayers removeAllObjects];
    GKLocalPlayer *player = GKLocalPlayer.localPlayer;
    if (!player.isAuthenticated) return;
    if (player.gamePlayerID.length) PlayerCache()[player.gamePlayerID] = player;
    if (player.teamPlayerID.length) PlayerCache()[player.teamPlayerID] = player;
}

static NSMutableDictionary<NSNumber *, GKSavedGame *> *SavedGameCache(void) {
    if (!bmxGameKitSavedGames) bmxGameKitSavedGames = [[NSMutableDictionary alloc] init];
    return bmxGameKitSavedGames;
}

static NSMutableDictionary<NSNumber *, NSArray<GKSavedGame *> *> *SavedGameConflictCache(void) {
    if (!bmxGameKitSavedGameConflicts) bmxGameKitSavedGameConflicts = [[NSMutableDictionary alloc] init];
    return bmxGameKitSavedGameConflicts;
}

static void ResetSavedGameCaches(void) {
    [bmxGameKitSavedGames removeAllObjects];
    [bmxGameKitSavedGameConflicts removeAllObjects];
}

static int NextPositiveHandle(int *value) {
    int result = *value;
    *value += 1;
    if (*value <= 0) *value = 1;
    return result;
}

static int StoreSavedGame(GKSavedGame *savedGame) {
    if (!savedGame) return 0;
    int handle = NextPositiveHandle(&bmxGameKitNextSavedGameHandle);
    SavedGameCache()[@(handle)] = savedGame;
    return handle;
}

static NSString *NSStringFromBBString(BBString *value) {
    unsigned char *utf8 = bbStringToUTF8String(value);
    NSString *result = [NSString stringWithUTF8String:(const char *)utf8];
    bbMemFree(utf8);
    return result ?: @"";
}

static BBString *BBStringFromNSString(NSString *value) {
    return bbStringFromUTF8String((const unsigned char *)[(value ?: @"") UTF8String]);
}

static BBArray *BBByteArrayFromNSData(NSData *data) {
    if (!data.length) return &bbEmptyArray;
    return bbArrayFromData("b", (int)data.length, (void *)data.bytes);
}

static NSData *NSDataFromBBByteArray(BBArray *data) {
    if (!data || data == &bbEmptyArray || data->scales[0] <= 0) return [NSData data];
    return [NSData dataWithBytes:BBARRAYDATA(data, 1) length:(NSUInteger)data->scales[0]];
}

#if TARGET_OS_IPHONE
typedef UIImage BMXGameKitImage;

static NSData *PNGDataFromImage(BMXGameKitImage *image) {
    return image ? UIImagePNGRepresentation(image) : nil;
}
#else
typedef NSImage BMXGameKitImage;

static NSData *PNGDataFromImage(BMXGameKitImage *image) {
    if (!image) return nil;
    CGImageRef cgImage = [image CGImageForProposedRect:NULL context:nil hints:nil];
    if (!cgImage) return nil;
    NSBitmapImageRep *representation = [[NSBitmapImageRep alloc] initWithCGImage:cgImage];
    return [representation representationUsingType:NSBitmapImageFileTypePNG properties:@{}];
}
#endif

static void DispatchMain(dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

static void ErrorValues(NSError *error, BBString **domain, int *code, BBString **message) {
    if (error) {
        *domain = BBStringFromNSString(error.domain);
        *code = (int)error.code;
        *message = BBStringFromNSString(error.localizedDescription);
    } else {
        *domain = &bbEmptyString;
        *code = 0;
        *message = &bbEmptyString;
    }
}

static NSError *ModuleError(NSInteger code, NSString *message) {
    return [NSError errorWithDomain:@"Apple.GameKit" code:code userInfo:@{NSLocalizedDescriptionKey: message}];
}

static BOOL ModernGameKitAvailable(void) {
    if (@available(iOS 14.0, macOS 11.0, *)) return YES;
    return NO;
}

static void NotifyAuthentication(NSError *error) {
    if (!bmxGameKitService) return;
    GKLocalPlayer *player = GKLocalPlayer.localPlayer;
    BOOL authenticated = player.isAuthenticated;
    NSString *playerID = authenticated ? player.gamePlayerID : nil;
    BOOL accountChanged = ![bmxGameKitAuthenticatedPlayerID isEqualToString:playerID];
    bmxGameKitAuthenticatedPlayerID = [playerID copy];
    ResetPlayerCache();
    if (accountChanged) ResetSavedGameCaches();
    BBString *domain;
    BBString *message;
    int code;
    ErrorValues(error, &domain, &code, &message);
    BBString *gamePlayerID = authenticated ? BBStringFromNSString(player.gamePlayerID) : &bbEmptyString;
    BBString *teamPlayerID = authenticated ? BBStringFromNSString(player.teamPlayerID) : &bbEmptyString;
    BBString *alias = authenticated ? BBStringFromNSString(player.alias) : &bbEmptyString;
    BBString *displayName = authenticated ? BBStringFromNSString(player.displayName) : &bbEmptyString;
    BOOL personalizedRestricted = NO;
    if (@available(iOS 14.0, macOS 11.0, *)) {
        personalizedRestricted = player.isPersonalizedCommunicationRestricted;
    }
    apple_gamekit_gamekit_apple_TGameCenter__OnAuthenticationChanged(
        bmxGameKitService, authenticated, gamePlayerID, teamPlayerID, alias, displayName,
        player.isUnderage, player.isMultiplayerGamingRestricted, personalizedRestricted,
        domain, code, message);
}

#if TARGET_OS_IPHONE
static UIWindow *ActiveWindow(void) {
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class]) continue;
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        if (windowScene.activationState != UISceneActivationStateForegroundActive &&
            windowScene.activationState != UISceneActivationStateForegroundInactive) continue;
        for (UIWindow *window in windowScene.windows) {
            if (window.isKeyWindow) return window;
        }
        if (windowScene.windows.count) return windowScene.windows.firstObject;
    }
    return nil;
}

static UIViewController *TopViewController(void) {
    UIViewController *controller = ActiveWindow().rootViewController;
    while (controller.presentedViewController) controller = controller.presentedViewController;
    return controller;
}

static void PresentAuthenticationController(UIViewController *controller) {
    UIViewController *presenter = TopViewController();
    if (presenter && controller && presenter.presentedViewController != controller) {
        [presenter presentViewController:controller animated:YES completion:nil];
    }
}
#else
static void PresentAuthenticationController(NSViewController *controller) {
    GKDialogController *dialog = GKDialogController.sharedDialogController;
    dialog.parentWindow = NSApp.keyWindow ?: NSApp.mainWindow;
    if (controller) [dialog presentViewController:(NSViewController<GKViewController> *)controller];
}
#endif

static void CompleteSimple(void (^callback)(BBString *, int, BBString *), NSError *error) {
    BBString *domain;
    BBString *message;
    int code;
    ErrorValues(error, &domain, &code, &message);
    callback(domain, code, message);
}

static void SendLeaderboardEntry(int requestId, GKLeaderboardEntry *entry, int localPlayer) API_AVAILABLE(ios(14.0), macos(11.0)) {
    GKPlayer *player = entry.player;
    if (player.gamePlayerID.length) PlayerCache()[player.gamePlayerID] = player;
    if (player.teamPlayerID.length) PlayerCache()[player.teamPlayerID] = player;
    apple_gamekit_gamekit_apple_TGameCenter__OnLeaderboardEntry(
        bmxGameKitService, requestId, localPlayer,
        BBStringFromNSString(player.gamePlayerID), BBStringFromNSString(player.teamPlayerID),
        BBStringFromNSString(player.alias), BBStringFromNSString(player.displayName),
        (BBLONG)entry.rank, (BBLONG)entry.score, BBStringFromNSString(entry.formattedScore),
        (BBULONG)entry.context, entry.date.timeIntervalSince1970);
}

static void SendLeaderboardInfo(int requestId, GKLeaderboard *leaderboard) API_AVAILABLE(ios(14.0), macos(11.0)) {
    NSString *description = @"";
    BOOL hidden = NO;
    NSUInteger releaseState = 0;
    if (@available(iOS 26.0, macOS 26.0, *)) {
        description = leaderboard.leaderboardDescription;
        hidden = leaderboard.isHidden;
        releaseState = (NSUInteger)leaderboard.releaseState;
    }
    apple_gamekit_gamekit_apple_TGameCenter__OnLeaderboardInfoLoaded(
        bmxGameKitService, requestId, BBStringFromNSString(leaderboard.baseLeaderboardID),
        BBStringFromNSString(leaderboard.groupIdentifier), BBStringFromNSString(leaderboard.title),
        (int)leaderboard.type, leaderboard.startDate.timeIntervalSince1970,
        leaderboard.nextStartDate.timeIntervalSince1970, leaderboard.duration,
        BBStringFromNSString(description), hidden, (int)releaseState);
}

static void CompleteResourceImage(int requestId, int kind, NSString *identifier, BMXGameKitImage *image, NSError *error) {
    if (!error && !image) error = ModuleError(-4, @"Game Center did not return artwork for this resource.");
    CompleteSimple(^(BBString *domain, int code, BBString *message) {
        apple_gamekit_gamekit_apple_TGameCenter__OnResourceImageLoaded(
            bmxGameKitService, requestId, kind, BBStringFromNSString(identifier),
            BBByteArrayFromNSData(PNGDataFromImage(image)), domain, code, message);
    }, error);
}

static void SendSavedGameList(int operation, int identifier, int conflictId, NSArray<GKSavedGame *> *savedGames, NSError *error) {
    DispatchMain(^{
        if (!bmxGameKitService) return;
        NSArray<GKSavedGame *> *values = savedGames ?: @[];
        apple_gamekit_gamekit_apple_TGameCenter__OnSavedGameListBegin(
            bmxGameKitService, operation, identifier, (int)values.count);
        for (GKSavedGame *savedGame in values) {
            int handle = StoreSavedGame(savedGame);
            apple_gamekit_gamekit_apple_TGameCenter__OnSavedGameListItem(
                bmxGameKitService, operation, identifier, handle,
                BBStringFromNSString(savedGame.name), BBStringFromNSString(savedGame.deviceName),
                savedGame.modificationDate.timeIntervalSince1970);
        }
        CompleteSimple(^(BBString *domain, int code, BBString *message) {
            apple_gamekit_gamekit_apple_TGameCenter__OnSavedGameListComplete(
                bmxGameKitService, operation, identifier, conflictId, domain, code, message);
        }, error);
    });
}

@interface BMXGameKitLocalPlayerListener : NSObject <GKLocalPlayerListener>
@end

@implementation BMXGameKitLocalPlayerListener

- (void)player:(GKPlayer *)player didModifySavedGame:(GKSavedGame *)savedGame {
    DispatchMain(^{
        if (!bmxGameKitService || !savedGame) return;
        int handle = StoreSavedGame(savedGame);
        apple_gamekit_gamekit_apple_TGameCenter__OnSavedGameModified(
            bmxGameKitService, handle, BBStringFromNSString(savedGame.name),
            BBStringFromNSString(savedGame.deviceName), savedGame.modificationDate.timeIntervalSince1970);
    });
}

- (void)player:(GKPlayer *)player hasConflictingSavedGames:(NSArray<GKSavedGame *> *)savedGames {
    DispatchMain(^{
        if (!bmxGameKitService) return;
        int conflictId = NextPositiveHandle(&bmxGameKitNextConflictHandle);
        SavedGameConflictCache()[@(conflictId)] = [savedGames copy];
        SendSavedGameList(2, conflictId, conflictId, savedGames, nil);
    });
}

@end

static BMXGameKitLocalPlayerListener *bmxGameKitLocalPlayerListener = nil;

void bmx_gamekit_start(BBObject *service) {
    DispatchMain(^{
        if (bmxGameKitService != service) {
            if (bmxGameKitService) BBRELEASE(bmxGameKitService);
            bmxGameKitService = service;
            BBRETAIN(bmxGameKitService);
        }
        if (!bmxGameKitLocalPlayerListener) bmxGameKitLocalPlayerListener = [[BMXGameKitLocalPlayerListener alloc] init];
        [GKLocalPlayer.localPlayer registerListener:bmxGameKitLocalPlayerListener];
        GKLocalPlayer.localPlayer.authenticateHandler = ^(id controller, NSError *error) {
            DispatchMain(^{
                if (controller) PresentAuthenticationController(controller);
                NotifyAuthentication(error);
            });
        };
    });
}

void bmx_gamekit_stop(void) {
    DispatchMain(^{
        GKLocalPlayer.localPlayer.authenticateHandler = nil;
        if (bmxGameKitLocalPlayerListener) [GKLocalPlayer.localPlayer unregisterListener:bmxGameKitLocalPlayerListener];
        [bmxGameKitPlayers removeAllObjects];
        ResetSavedGameCaches();
        bmxGameKitAuthenticatedPlayerID = nil;
        if (@available(iOS 14.0, macOS 11.0, *)) {
            GKAccessPoint.shared.active = NO;
        }
        if (bmxGameKitService) {
            BBRELEASE(bmxGameKitService);
            bmxGameKitService = NULL;
        }
    });
}

static void CompletePlayerPhoto(int requestId, NSString *identifier, int size, BMXGameKitImage *image, NSError *error) {
    if (!error && !image) error = ModuleError(-4, @"Game Center did not return a photo for this player.");
    CompleteSimple(^(BBString *domain, int code, BBString *message) {
        apple_gamekit_gamekit_apple_TGameCenter__OnPlayerPhotoLoaded(
            bmxGameKitService, requestId, BBStringFromNSString(identifier), size,
            BBByteArrayFromNSData(PNGDataFromImage(image)), domain, code, message);
    }, error);
}

static void LoadPhotoForPlayer(int requestId, NSString *identifier, int size, GKPlayer *player) {
    if (!player) {
        CompletePlayerPhoto(requestId, identifier, size, nil, ModuleError(-3, @"The requested player is not available in this Game Center session."));
        return;
    }
    [player loadPhotoForSize:(GKPhotoSize)size withCompletionHandler:^(BMXGameKitImage *photo, NSError *error) {
        DispatchMain(^{ if (bmxGameKitService) CompletePlayerPhoto(requestId, identifier, size, photo, error); });
    }];
}

void bmx_gamekit_load_friends_authorization(int requestId) {
    DispatchMain(^{
        if (@available(iOS 14.5, macOS 11.3, *)) {
            [GKLocalPlayer.localPlayer loadFriendsAuthorizationStatus:^(GKFriendsAuthorizationStatus status, NSError *error) {
                DispatchMain(^{
                    if (!bmxGameKitService) return;
                    if (status == GKFriendsAuthorizationStatusRestricted || status == GKFriendsAuthorizationStatusDenied) {
                        ResetPlayerCache();
                    }
                    CompleteSimple(^(BBString *domain, int code, BBString *message) {
                        apple_gamekit_gamekit_apple_TGameCenter__OnFriendsAuthorizationLoaded(
                            bmxGameKitService, requestId, (int)status, domain, code, message);
                    }, error);
                });
            }];
        } else {
            NSError *error = ModuleError(-1, @"Friends access requires iOS 14.5 or macOS 11.3.");
            CompleteSimple(^(BBString *domain, int code, BBString *message) {
                apple_gamekit_gamekit_apple_TGameCenter__OnFriendsAuthorizationLoaded(
                    bmxGameKitService, requestId, 0, domain, code, message);
            }, error);
        }
    });
}

void bmx_gamekit_load_friends(int requestId) {
    DispatchMain(^{
        if (@available(iOS 14.5, macOS 11.3, *)) {
            [GKLocalPlayer.localPlayer loadFriends:^(NSArray<GKPlayer *> *friends, NSError *error) {
                DispatchMain(^{
                    if (!bmxGameKitService) return;
                    NSArray<GKPlayer *> *values = friends ?: @[];
                    apple_gamekit_gamekit_apple_TGameCenter__OnFriendsLoadBegin(bmxGameKitService, requestId, (int)values.count);
                    for (GKPlayer *player in values) {
                        if (player.gamePlayerID.length) PlayerCache()[player.gamePlayerID] = player;
                        if (player.teamPlayerID.length) PlayerCache()[player.teamPlayerID] = player;
                        apple_gamekit_gamekit_apple_TGameCenter__OnFriendLoaded(
                            bmxGameKitService, requestId, BBStringFromNSString(player.gamePlayerID),
                            BBStringFromNSString(player.teamPlayerID), BBStringFromNSString(player.alias),
                            BBStringFromNSString(player.displayName));
                    }
                    CompleteSimple(^(BBString *domain, int code, BBString *message) {
                        apple_gamekit_gamekit_apple_TGameCenter__OnFriendsLoadComplete(bmxGameKitService, requestId, domain, code, message);
                    }, error);
                });
            }];
        } else {
            apple_gamekit_gamekit_apple_TGameCenter__OnFriendsLoadBegin(bmxGameKitService, requestId, 0);
            NSError *error = ModuleError(-1, @"Friends access requires iOS 14.5 or macOS 11.3.");
            CompleteSimple(^(BBString *domain, int code, BBString *message) {
                apple_gamekit_gamekit_apple_TGameCenter__OnFriendsLoadComplete(bmxGameKitService, requestId, domain, code, message);
            }, error);
        }
    });
}

void bmx_gamekit_load_player_photo(int requestId, BBString *identifierValue, int size) {
    NSString *identifier = NSStringFromBBString(identifierValue);
    DispatchMain(^{
        if (!identifier.length) {
            CompletePlayerPhoto(requestId, identifier, size, nil, ModuleError(-2, @"A Game Center player is required."));
            return;
        }
        GKPlayer *player = bmxGameKitPlayers[identifier];
        if (player) {
            LoadPhotoForPlayer(requestId, identifier, size, player);
            return;
        }
        CompletePlayerPhoto(requestId, identifier, size, nil,
            ModuleError(-3, @"The requested player is not available in this Game Center session."));
    });
}

void bmx_gamekit_fetch_saved_games(int requestId) {
    DispatchMain(^{
        [GKLocalPlayer.localPlayer fetchSavedGamesWithCompletionHandler:^(NSArray<GKSavedGame *> *savedGames, NSError *error) {
            SendSavedGameList(0, requestId, 0, savedGames, error);
        }];
    });
}

void bmx_gamekit_save_game(int requestId, BBString *nameValue, BBArray *dataValue) {
    NSString *name = NSStringFromBBString(nameValue);
    NSData *data = NSDataFromBBByteArray(dataValue);
    DispatchMain(^{
        if (!name.length) {
            NSError *error = ModuleError(-2, @"A saved-game name is required.");
            CompleteSimple(^(BBString *domain, int code, BBString *message) {
                apple_gamekit_gamekit_apple_TGameCenter__OnSavedGameSaved(
                    bmxGameKitService, requestId, 0, &bbEmptyString, &bbEmptyString, 0.0, domain, code, message);
            }, error);
            return;
        }
        [GKLocalPlayer.localPlayer saveGameData:data withName:name completionHandler:^(GKSavedGame *savedGame, NSError *error) {
            DispatchMain(^{
                if (!bmxGameKitService) return;
                int handle = StoreSavedGame(savedGame);
                CompleteSimple(^(BBString *domain, int code, BBString *message) {
                    apple_gamekit_gamekit_apple_TGameCenter__OnSavedGameSaved(
                        bmxGameKitService, requestId, handle, BBStringFromNSString(savedGame.name),
                        BBStringFromNSString(savedGame.deviceName), savedGame.modificationDate.timeIntervalSince1970,
                        domain, code, message);
                }, error);
            });
        }];
    });
}

void bmx_gamekit_load_saved_game(int requestId, int handle) {
    DispatchMain(^{
        GKSavedGame *savedGame = bmxGameKitSavedGames[@(handle)];
        if (!savedGame) {
            NSError *error = ModuleError(-3, @"The requested saved game is not available in this Game Center session.");
            CompleteSimple(^(BBString *domain, int code, BBString *message) {
                apple_gamekit_gamekit_apple_TGameCenter__OnSavedGameDataLoaded(
                    bmxGameKitService, requestId, handle, &bbEmptyArray, domain, code, message);
            }, error);
            return;
        }
        [savedGame loadDataWithCompletionHandler:^(NSData *data, NSError *error) {
            DispatchMain(^{
                if (!bmxGameKitService) return;
                CompleteSimple(^(BBString *domain, int code, BBString *message) {
                    apple_gamekit_gamekit_apple_TGameCenter__OnSavedGameDataLoaded(
                        bmxGameKitService, requestId, handle, BBByteArrayFromNSData(data), domain, code, message);
                }, error);
            });
        }];
    });
}

void bmx_gamekit_delete_saved_games(int requestId, BBString *nameValue) {
    NSString *name = NSStringFromBBString(nameValue);
    DispatchMain(^{
        if (!name.length) {
            NSError *error = ModuleError(-2, @"A saved-game name is required.");
            CompleteSimple(^(BBString *domain, int code, BBString *message) {
                apple_gamekit_gamekit_apple_TGameCenter__OnSavedGamesDeleted(
                    bmxGameKitService, requestId, BBStringFromNSString(name), domain, code, message);
            }, error);
            return;
        }
        [GKLocalPlayer.localPlayer deleteSavedGamesWithName:name completionHandler:^(NSError *error) {
            DispatchMain(^{
                if (!bmxGameKitService) return;
                if (!error) {
                    NSArray<NSNumber *> *handles = [bmxGameKitSavedGames keysOfEntriesPassingTest:^BOOL(NSNumber *key, GKSavedGame *savedGame, BOOL *stop) {
                        return [savedGame.name isEqualToString:name];
                    }].allObjects;
                    [bmxGameKitSavedGames removeObjectsForKeys:handles];
                }
                CompleteSimple(^(BBString *domain, int code, BBString *message) {
                    apple_gamekit_gamekit_apple_TGameCenter__OnSavedGamesDeleted(
                        bmxGameKitService, requestId, BBStringFromNSString(name), domain, code, message);
                }, error);
            });
        }];
    });
}

void bmx_gamekit_resolve_saved_game_conflict(int requestId, int conflictId, BBArray *dataValue) {
    NSData *data = NSDataFromBBByteArray(dataValue);
    DispatchMain(^{
        NSArray<GKSavedGame *> *conflicts = bmxGameKitSavedGameConflicts[@(conflictId)];
        if (!conflicts.count) {
            SendSavedGameList(1, requestId, conflictId, nil,
                ModuleError(-3, @"The saved-game conflict is no longer available in this Game Center session."));
            return;
        }
        [GKLocalPlayer.localPlayer resolveConflictingSavedGames:conflicts withData:data completionHandler:^(NSArray<GKSavedGame *> *savedGames, NSError *error) {
            DispatchMain(^{
                if (!error) [bmxGameKitSavedGameConflicts removeObjectForKey:@(conflictId)];
                SendSavedGameList(1, requestId, conflictId, savedGames, error);
            });
        }];
    });
}

int bmx_gamekit_is_available(void) {
    return ModernGameKitAvailable();
}

int bmx_gamekit_is_authenticated(void) {
    return GKLocalPlayer.localPlayer.isAuthenticated;
}

void bmx_gamekit_set_access_point_active(int active, int location) {
    DispatchMain(^{
        if (@available(iOS 14.0, macOS 11.0, *)) {
            GKAccessPoint *accessPoint = GKAccessPoint.shared;
            accessPoint.location = (GKAccessPointLocation)location;
#if TARGET_OS_IPHONE
            accessPoint.parentWindow = ActiveWindow();
#else
            accessPoint.parentWindow = NSApp.keyWindow ?: NSApp.mainWindow;
#endif
            accessPoint.active = active != 0;
        }
    });
}

int bmx_gamekit_is_access_point_active(void) {
    if (@available(iOS 14.0, macOS 11.0, *)) return GKAccessPoint.shared.isActive;
    return 0;
}

int bmx_gamekit_is_access_point_visible(void) {
    if (@available(iOS 14.0, macOS 11.0, *)) return GKAccessPoint.shared.isVisible;
    return 0;
}

int bmx_gamekit_is_presenting(void) {
    if (@available(iOS 14.0, macOS 11.0, *)) return GKAccessPoint.shared.isPresentingGameCenter;
    return 0;
}

void bmx_gamekit_show(int view) {
    DispatchMain(^{
        if (!bmxGameKitService) return;
        if (@available(iOS 14.0, macOS 11.0, *)) {
            GKAccessPoint *accessPoint = GKAccessPoint.shared;
#if TARGET_OS_IPHONE
            accessPoint.parentWindow = ActiveWindow();
#else
            accessPoint.parentWindow = NSApp.keyWindow ?: NSApp.mainWindow;
#endif
            void (^finished)(void) = ^{
                DispatchMain(^{
                    if (bmxGameKitService) apple_gamekit_gamekit_apple_TGameCenter__OnViewDismissed(bmxGameKitService, view);
                });
            };
            if (view == GKGameCenterViewControllerStateDefault) {
                [accessPoint triggerAccessPointWithHandler:finished];
            } else {
                [accessPoint triggerAccessPointWithState:(GKGameCenterViewControllerState)view handler:finished];
            }
        }
    });
}

void bmx_gamekit_report_achievement(int requestId, BBString *identifierValue, double percentComplete, int showCompletionBanner) {
    NSString *identifier = NSStringFromBBString(identifierValue);
    DispatchMain(^{
        GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
        achievement.percentComplete = MAX(0.0, MIN(100.0, percentComplete));
        achievement.showsCompletionBanner = showCompletionBanner != 0;
        [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {
            DispatchMain(^{
                if (!bmxGameKitService) return;
                CompleteSimple(^(BBString *domain, int code, BBString *message) {
                    apple_gamekit_gamekit_apple_TGameCenter__OnAchievementReported(bmxGameKitService, requestId, BBStringFromNSString(identifier), domain, code, message);
                }, error);
            });
        }];
    });
}

void bmx_gamekit_load_achievements(int requestId) {
    DispatchMain(^{
        [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray<GKAchievement *> *achievements, NSError *error) {
            DispatchMain(^{
                if (!bmxGameKitService) return;
                NSArray<GKAchievement *> *values = achievements ?: @[];
                apple_gamekit_gamekit_apple_TGameCenter__OnAchievementLoadBegin(bmxGameKitService, requestId, (int)values.count);
                for (GKAchievement *achievement in values) {
                    apple_gamekit_gamekit_apple_TGameCenter__OnAchievementLoaded(
                        bmxGameKitService, requestId, BBStringFromNSString(achievement.identifier),
                        achievement.percentComplete, achievement.isCompleted,
                        achievement.lastReportedDate.timeIntervalSince1970);
                }
                CompleteSimple(^(BBString *domain, int code, BBString *message) {
                    apple_gamekit_gamekit_apple_TGameCenter__OnAchievementLoadComplete(bmxGameKitService, requestId, domain, code, message);
                }, error);
            });
        }];
    });
}

void bmx_gamekit_load_achievement_descriptions(int requestId) {
    DispatchMain(^{
        [GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler:^(NSArray<GKAchievementDescription *> *descriptions, NSError *error) {
            DispatchMain(^{
                if (!bmxGameKitService) return;
                NSArray<GKAchievementDescription *> *values = descriptions ?: @[];
                apple_gamekit_gamekit_apple_TGameCenter__OnAchievementDescriptionLoadBegin(bmxGameKitService, requestId, (int)values.count);
                for (GKAchievementDescription *description in values) {
                    double rarityPercent = -1.0;
                    NSUInteger releaseState = 0;
                    if (@available(iOS 17.0, macOS 14.0, *)) {
                        if (description.rarityPercent) rarityPercent = description.rarityPercent.doubleValue;
                    }
                    if (@available(iOS 18.4, macOS 15.4, *)) {
                        releaseState = (NSUInteger)description.releaseState;
                    }
                    apple_gamekit_gamekit_apple_TGameCenter__OnAchievementDescriptionLoaded(
                        bmxGameKitService, requestId, BBStringFromNSString(description.identifier),
                        BBStringFromNSString(description.groupIdentifier), BBStringFromNSString(description.title),
                        BBStringFromNSString(description.achievedDescription), BBStringFromNSString(description.unachievedDescription),
                        (int)description.maximumPoints, description.isHidden, description.isReplayable,
                        rarityPercent, (int)releaseState);
                }
                CompleteSimple(^(BBString *domain, int code, BBString *message) {
                    apple_gamekit_gamekit_apple_TGameCenter__OnAchievementDescriptionLoadComplete(bmxGameKitService, requestId, domain, code, message);
                }, error);
            });
        }];
    });
}

void bmx_gamekit_reset_achievements(int requestId) {
    DispatchMain(^{
        [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error) {
            DispatchMain(^{
                if (!bmxGameKitService) return;
                CompleteSimple(^(BBString *domain, int code, BBString *message) {
                    apple_gamekit_gamekit_apple_TGameCenter__OnAchievementsReset(bmxGameKitService, requestId, domain, code, message);
                }, error);
            });
        }];
    });
}

void bmx_gamekit_submit_score(int requestId, BBString *leaderboardIdentifierValue, BBLONG score, BBULONG context) {
    NSString *leaderboardIdentifier = NSStringFromBBString(leaderboardIdentifierValue);
    DispatchMain(^{
        if (@available(iOS 14.0, macOS 11.0, *)) {
            [GKLeaderboard submitScore:(NSInteger)score context:(NSUInteger)context player:GKLocalPlayer.localPlayer leaderboardIDs:@[leaderboardIdentifier] completionHandler:^(NSError *error) {
                DispatchMain(^{
                    if (!bmxGameKitService) return;
                    CompleteSimple(^(BBString *domain, int code, BBString *message) {
                        apple_gamekit_gamekit_apple_TGameCenter__OnScoreSubmitted(bmxGameKitService, requestId, BBStringFromNSString(leaderboardIdentifier), score, domain, code, message);
                    }, error);
                });
            }];
        } else {
            NSError *error = ModuleError(-1, @"Leaderboards require iOS 14 or macOS 11.");
            CompleteSimple(^(BBString *domain, int code, BBString *message) {
                apple_gamekit_gamekit_apple_TGameCenter__OnScoreSubmitted(bmxGameKitService, requestId, BBStringFromNSString(leaderboardIdentifier), score, domain, code, message);
            }, error);
        }
    });
}

void bmx_gamekit_load_leaderboard(int requestId, BBString *leaderboardIdentifierValue, int playerScope, int timeScope, int startRank, int count) {
    NSString *leaderboardIdentifier = NSStringFromBBString(leaderboardIdentifierValue);
    DispatchMain(^{
        if (@available(iOS 14.0, macOS 11.0, *)) {
            [GKLeaderboard loadLeaderboardsWithIDs:@[leaderboardIdentifier] completionHandler:^(NSArray<GKLeaderboard *> *leaderboards, NSError *loadError) {
                GKLeaderboard *leaderboard = leaderboards.firstObject;
                if (!leaderboard || loadError) {
                    NSError *error = loadError ?: ModuleError(-2, @"The requested leaderboard was not found.");
                    DispatchMain(^{
                        if (!bmxGameKitService) return;
                        CompleteSimple(^(BBString *domain, int code, BBString *message) {
                            apple_gamekit_gamekit_apple_TGameCenter__OnLeaderboardLoadComplete(bmxGameKitService, requestId, domain, code, message);
                        }, error);
                    });
                    return;
                }
                NSInteger safeStart = MAX(1, startRank);
                NSInteger safeCount = MAX(1, MIN(100, count));
                [leaderboard loadEntriesForPlayerScope:(GKLeaderboardPlayerScope)playerScope
                                             timeScope:(GKLeaderboardTimeScope)timeScope
                                                 range:NSMakeRange(safeStart, safeCount)
                                     completionHandler:^(GKLeaderboardEntry *localEntry, NSArray<GKLeaderboardEntry *> *entries, NSInteger totalPlayerCount, NSError *entryError) {
                    DispatchMain(^{
                        if (!bmxGameKitService) return;
                        NSArray<GKLeaderboardEntry *> *values = entries ?: @[];
                        apple_gamekit_gamekit_apple_TGameCenter__OnLeaderboardLoadBegin(
                            bmxGameKitService, requestId, BBStringFromNSString(leaderboardIdentifier),
                            BBStringFromNSString(leaderboard.title), (int)values.count, (BBLONG)totalPlayerCount);
                        if (localEntry) SendLeaderboardEntry(requestId, localEntry, 1);
                        for (GKLeaderboardEntry *entry in values) SendLeaderboardEntry(requestId, entry, 0);
                        CompleteSimple(^(BBString *domain, int code, BBString *message) {
                            apple_gamekit_gamekit_apple_TGameCenter__OnLeaderboardLoadComplete(bmxGameKitService, requestId, domain, code, message);
                        }, entryError);
                    });
                }];
            }];
        } else {
            NSError *error = ModuleError(-1, @"Leaderboards require iOS 14 or macOS 11.");
            CompleteSimple(^(BBString *domain, int code, BBString *message) {
                apple_gamekit_gamekit_apple_TGameCenter__OnLeaderboardLoadComplete(bmxGameKitService, requestId, domain, code, message);
            }, error);
        }
    });
}

static void SendLeaderboardInfos(int requestId, NSString *setIdentifier, NSArray<GKLeaderboard *> *leaderboards, NSError *error) API_AVAILABLE(ios(14.0), macos(11.0)) {
    DispatchMain(^{
        if (!bmxGameKitService) return;
        NSArray<GKLeaderboard *> *values = leaderboards ?: @[];
        apple_gamekit_gamekit_apple_TGameCenter__OnLeaderboardInfoLoadBegin(
            bmxGameKitService, requestId, BBStringFromNSString(setIdentifier), (int)values.count);
        for (GKLeaderboard *leaderboard in values) SendLeaderboardInfo(requestId, leaderboard);
        CompleteSimple(^(BBString *domain, int code, BBString *message) {
            apple_gamekit_gamekit_apple_TGameCenter__OnLeaderboardInfoLoadComplete(bmxGameKitService, requestId, domain, code, message);
        }, error);
    });
}

static void CompleteLeaderboardInfoError(int requestId, NSString *setIdentifier, NSError *error) {
    DispatchMain(^{
        if (!bmxGameKitService) return;
        apple_gamekit_gamekit_apple_TGameCenter__OnLeaderboardInfoLoadBegin(
            bmxGameKitService, requestId, BBStringFromNSString(setIdentifier), 0);
        CompleteSimple(^(BBString *domain, int code, BBString *message) {
            apple_gamekit_gamekit_apple_TGameCenter__OnLeaderboardInfoLoadComplete(bmxGameKitService, requestId, domain, code, message);
        }, error);
    });
}

void bmx_gamekit_load_leaderboards(int requestId, BBString *setIdentifierValue) {
    NSString *setIdentifier = NSStringFromBBString(setIdentifierValue);
    DispatchMain(^{
        if (@available(iOS 14.0, macOS 11.0, *)) {
            if (!setIdentifier.length) {
                [GKLeaderboard loadLeaderboardsWithIDs:nil completionHandler:^(NSArray<GKLeaderboard *> *leaderboards, NSError *error) {
                    SendLeaderboardInfos(requestId, @"", leaderboards, error);
                }];
                return;
            }
            [GKLeaderboardSet loadLeaderboardSetsWithCompletionHandler:^(NSArray<GKLeaderboardSet *> *sets, NSError *loadError) {
                GKLeaderboardSet *requestedSet = nil;
                for (GKLeaderboardSet *set in sets) {
                    if ([set.identifier isEqualToString:setIdentifier]) {
                        requestedSet = set;
                        break;
                    }
                }
                if (!requestedSet || loadError) {
                    SendLeaderboardInfos(requestId, setIdentifier, nil,
                        loadError ?: ModuleError(-3, @"The requested leaderboard set was not found."));
                    return;
                }
                [requestedSet loadLeaderboardsWithHandler:^(NSArray<GKLeaderboard *> *leaderboards, NSError *error) {
                    SendLeaderboardInfos(requestId, setIdentifier, leaderboards, error);
                }];
            }];
        } else {
            CompleteLeaderboardInfoError(requestId, setIdentifier, ModuleError(-1, @"Leaderboards require iOS 14 or macOS 11."));
        }
    });
}

void bmx_gamekit_load_leaderboard_sets(int requestId) {
    DispatchMain(^{
        [GKLeaderboardSet loadLeaderboardSetsWithCompletionHandler:^(NSArray<GKLeaderboardSet *> *sets, NSError *error) {
            DispatchMain(^{
                if (!bmxGameKitService) return;
                NSArray<GKLeaderboardSet *> *values = sets ?: @[];
                apple_gamekit_gamekit_apple_TGameCenter__OnLeaderboardSetLoadBegin(bmxGameKitService, requestId, (int)values.count);
                for (GKLeaderboardSet *set in values) {
                    apple_gamekit_gamekit_apple_TGameCenter__OnLeaderboardSetLoaded(
                        bmxGameKitService, requestId, BBStringFromNSString(set.identifier),
                        BBStringFromNSString(set.groupIdentifier), BBStringFromNSString(set.title));
                }
                CompleteSimple(^(BBString *domain, int code, BBString *message) {
                    apple_gamekit_gamekit_apple_TGameCenter__OnLeaderboardSetLoadComplete(bmxGameKitService, requestId, domain, code, message);
                }, error);
            });
        }];
    });
}

void bmx_gamekit_load_resource_image(int requestId, int kind, BBString *identifierValue) {
    NSString *identifier = NSStringFromBBString(identifierValue);
    DispatchMain(^{
        switch (kind) {
            case 0:
                [GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler:^(NSArray<GKAchievementDescription *> *descriptions, NSError *loadError) {
                    GKAchievementDescription *requestedDescription = nil;
                    for (GKAchievementDescription *description in descriptions) {
                        if ([description.identifier isEqualToString:identifier]) {
                            requestedDescription = description;
                            break;
                        }
                    }
                    if (!requestedDescription || loadError) {
                        DispatchMain(^{
                            if (bmxGameKitService) CompleteResourceImage(requestId, kind, identifier, nil,
                                loadError ?: ModuleError(-3, @"The requested achievement was not found."));
                        });
                        return;
                    }
                    [requestedDescription loadImageWithCompletionHandler:^(BMXGameKitImage *image, NSError *error) {
                        DispatchMain(^{ if (bmxGameKitService) CompleteResourceImage(requestId, kind, identifier, image, error); });
                    }];
                }];
                break;
            case 1:
                if (@available(iOS 14.0, macOS 11.0, *)) {
                    [GKLeaderboard loadLeaderboardsWithIDs:@[identifier] completionHandler:^(NSArray<GKLeaderboard *> *leaderboards, NSError *loadError) {
                        GKLeaderboard *leaderboard = leaderboards.firstObject;
                        if (!leaderboard || loadError) {
                            DispatchMain(^{
                                if (bmxGameKitService) CompleteResourceImage(requestId, kind, identifier, nil,
                                    loadError ?: ModuleError(-3, @"The requested leaderboard was not found."));
                            });
                            return;
                        }
                        [leaderboard loadImageWithCompletionHandler:^(BMXGameKitImage *image, NSError *error) {
                            DispatchMain(^{ if (bmxGameKitService) CompleteResourceImage(requestId, kind, identifier, image, error); });
                        }];
                    }];
                } else {
                    CompleteResourceImage(requestId, kind, identifier, nil, ModuleError(-1, @"Leaderboards require iOS 14 or macOS 11."));
                }
                break;
            case 2:
                [GKLeaderboardSet loadLeaderboardSetsWithCompletionHandler:^(NSArray<GKLeaderboardSet *> *sets, NSError *loadError) {
                    GKLeaderboardSet *requestedSet = nil;
                    for (GKLeaderboardSet *set in sets) {
                        if ([set.identifier isEqualToString:identifier]) {
                            requestedSet = set;
                            break;
                        }
                    }
                    if (!requestedSet || loadError) {
                        DispatchMain(^{
                            if (bmxGameKitService) CompleteResourceImage(requestId, kind, identifier, nil,
                                loadError ?: ModuleError(-3, @"The requested leaderboard set was not found."));
                        });
                        return;
                    }
                    [requestedSet loadImageWithCompletionHandler:^(BMXGameKitImage *image, NSError *error) {
                        DispatchMain(^{ if (bmxGameKitService) CompleteResourceImage(requestId, kind, identifier, image, error); });
                    }];
                }];
                break;
            default:
                CompleteResourceImage(requestId, kind, identifier, nil, ModuleError(-5, @"Unknown Game Center resource kind."));
                break;
        }
    });
}
