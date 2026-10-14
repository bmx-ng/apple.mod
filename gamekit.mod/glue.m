#include "brl.mod/blitz.mod/blitz.h"
#include <math.h>

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import <TargetConditionals.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

extern void apple_gamekit_gamekit_apple_TGameCenter__OnAuthenticationChanged(BBObject *, int, BBString *, BBString *, BBString *, BBString *, int, int, int, BBString *, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnMatchFound(BBObject *, int, int, BBString *, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnIdentityVerificationFetched(BBObject *, int, BBString *, BBString *, BBString *, BBString *, BBArray *, BBArray *, BBULONG, BBString *, int, BBString *);
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
extern void apple_gamekit_gamekit_apple_TGameCenter__OnChallengeDefinitionLoadBegin(BBObject *, int, int);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnChallengeDefinitionLoaded(BBObject *, int, int, BBString *, BBString *, BBString *, BBString *, int, int, BBString *, int);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnChallengeDurationLoaded(BBObject *, int, int, int, int, int, int, int, int, int, int);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnChallengeDefinitionLoadComplete(BBObject *, int, BBString *, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnChallengeActiveStatusLoaded(BBObject *, int, BBString *, int, BBString *, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnChallengeViewDismissed(BBObject *, int, BBString *, BBString *, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnActivityDefinitionLoadBegin(BBObject *, int, int);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnActivityDefinitionLoaded(BBObject *, int, int, BBString *, BBString *, BBString *, BBString *, BBString *, int, int, int, int, int, int, int, int);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnActivityDefinitionProperty(BBObject *, int, int, BBString *, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnActivityDefinitionAchievement(BBObject *, int, int, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnActivityDefinitionLeaderboard(BBObject *, int, int, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnActivityDefinitionLoadComplete(BBObject *, int, BBString *, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnPendingGameActivityChecked(BBObject *, int, int, BBString *, int, BBString *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnGameActivityBegin(BBObject *, BBString *, BBString *, BBString *, BBString *, int, BBString *, BBString *, BBString *, BBString *, int, double, double, double, double, double);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnGameActivityProperty(BBObject *, BBString *, BBString *);
extern int apple_gamekit_gamekit_apple_TGameCenter__OnGameActivityReady(BBObject *);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnActivityUpdatedBegin(BBObject *, int, int, int, BBString *, BBString *, BBString *, BBString *, int, double, double, double, double, double);
extern void apple_gamekit_gamekit_apple_TGameCenter__OnActivityUpdatedReady(BBObject *, BBString *, int, BBString *);
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
static NSMutableDictionary *bmxGameKitActivities = nil;
static NSMutableDictionary *bmxGameKitMatches = nil;
static NSString *bmxGameKitAuthenticatedPlayerID = nil;
static int bmxGameKitNextSavedGameHandle = 1;
static int bmxGameKitNextConflictHandle = 1;
static int bmxGameKitNextActivityHandle = 1;
static int bmxGameKitNextMatchHandle = 1;

static void ResetMatches(void);

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

static NSMutableDictionary<NSNumber *, GKGameActivity *> *ActivityCache(void) API_AVAILABLE(ios(26.0), macos(26.0)) {
    if (!bmxGameKitActivities) bmxGameKitActivities = [[NSMutableDictionary alloc] init];
    return bmxGameKitActivities;
}

static void ResetActivityCache(void) {
    [bmxGameKitActivities removeAllObjects];
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

static int StoreActivity(GKGameActivity *activity) API_AVAILABLE(ios(26.0), macos(26.0)) {
    if (!activity) return 0;
    for (NSNumber *key in ActivityCache()) {
        if (ActivityCache()[key] == activity) return key.intValue;
    }
    int handle = NextPositiveHandle(&bmxGameKitNextActivityHandle);
    ActivityCache()[@(handle)] = activity;
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
    if (accountChanged) {
        ResetSavedGameCaches();
        ResetActivityCache();
        ResetMatches();
    }
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

static int ChallengeDateComponent(NSInteger value) API_AVAILABLE(ios(26.0), macos(26.0)) {
    return value == NSDateComponentUndefined ? 0 : (int)value;
}

static void CompleteChallengeDefinitions(int requestId, NSArray<GKChallengeDefinition *> *definitions, NSError *error) API_AVAILABLE(ios(26.0), macos(26.0)) {
    DispatchMain(^{
        if (!bmxGameKitService) return;
        NSArray<GKChallengeDefinition *> *values = definitions ?: @[];
        apple_gamekit_gamekit_apple_TGameCenter__OnChallengeDefinitionLoadBegin(
            bmxGameKitService, requestId, (int)values.count);
        [values enumerateObjectsUsingBlock:^(GKChallengeDefinition *definition, NSUInteger definitionIndex, BOOL *stop) {
            NSArray<NSDateComponents *> *durations = definition.durationOptions ?: @[];
            apple_gamekit_gamekit_apple_TGameCenter__OnChallengeDefinitionLoaded(
                bmxGameKitService, requestId, (int)definitionIndex,
                BBStringFromNSString(definition.identifier), BBStringFromNSString(definition.groupIdentifier),
                BBStringFromNSString(definition.title), BBStringFromNSString(definition.details),
                (int)durations.count, definition.isRepeatable,
                BBStringFromNSString(definition.leaderboard.baseLeaderboardID), (int)definition.releaseState);
            [durations enumerateObjectsUsingBlock:^(NSDateComponents *duration, NSUInteger durationIndex, BOOL *durationStop) {
                apple_gamekit_gamekit_apple_TGameCenter__OnChallengeDurationLoaded(
                    bmxGameKitService, requestId, (int)definitionIndex, (int)durationIndex,
                    ChallengeDateComponent(duration.year), ChallengeDateComponent(duration.month),
                    ChallengeDateComponent(duration.weekOfYear), ChallengeDateComponent(duration.day),
                    ChallengeDateComponent(duration.hour), ChallengeDateComponent(duration.minute),
                    ChallengeDateComponent(duration.second));
            }];
        }];
        CompleteSimple(^(BBString *domain, int code, BBString *message) {
            apple_gamekit_gamekit_apple_TGameCenter__OnChallengeDefinitionLoadComplete(
                bmxGameKitService, requestId, domain, code, message);
        }, error);
    });
}

static void CompleteChallengeDefinitionError(int requestId, NSError *error) {
    DispatchMain(^{
        if (!bmxGameKitService) return;
        apple_gamekit_gamekit_apple_TGameCenter__OnChallengeDefinitionLoadBegin(
            bmxGameKitService, requestId, 0);
        CompleteSimple(^(BBString *domain, int code, BBString *message) {
            apple_gamekit_gamekit_apple_TGameCenter__OnChallengeDefinitionLoadComplete(
                bmxGameKitService, requestId, domain, code, message);
        }, error);
    });
}

static void CompleteChallengeActiveStatus(int requestId, NSString *identifier, BOOL hasActiveChallenges, NSError *error) {
    DispatchMain(^{
        if (!bmxGameKitService) return;
        CompleteSimple(^(BBString *domain, int code, BBString *message) {
            apple_gamekit_gamekit_apple_TGameCenter__OnChallengeActiveStatusLoaded(
                bmxGameKitService, requestId, BBStringFromNSString(identifier), hasActiveChallenges,
                domain, code, message);
        }, error);
    });
}

static void SendActivityDefinitionResults(int requestId,
                                          NSArray<GKGameActivityDefinition *> *definitions,
                                          NSArray<NSArray<GKAchievementDescription *> *> *achievementLists,
                                          NSArray<NSArray<GKLeaderboard *> *> *leaderboardLists,
                                          NSError *error) API_AVAILABLE(ios(26.0), macos(26.0)) {
    if (!bmxGameKitService) return;
    apple_gamekit_gamekit_apple_TGameCenter__OnActivityDefinitionLoadBegin(
        bmxGameKitService, requestId, (int)definitions.count);
    [definitions enumerateObjectsUsingBlock:^(GKGameActivityDefinition *definition, NSUInteger index, BOOL *stop) {
        NSArray<GKAchievementDescription *> *achievements = achievementLists[index];
        NSArray<GKLeaderboard *> *leaderboards = leaderboardLists[index];
        apple_gamekit_gamekit_apple_TGameCenter__OnActivityDefinitionLoaded(
            bmxGameKitService, requestId, (int)index,
            BBStringFromNSString(definition.identifier), BBStringFromNSString(definition.groupIdentifier),
            BBStringFromNSString(definition.title), BBStringFromNSString(definition.details),
            BBStringFromNSString(definition.fallbackURL.absoluteString), definition.supportsPartyCode,
            definition.minPlayers.intValue, definition.maxPlayers.intValue,
            definition.supportsUnlimitedPlayers, (int)definition.playStyle, (int)definition.releaseState,
            (int)achievements.count, (int)leaderboards.count);
        [definition.defaultProperties enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *propertyStop) {
            apple_gamekit_gamekit_apple_TGameCenter__OnActivityDefinitionProperty(
                bmxGameKitService, requestId, (int)index,
                BBStringFromNSString(key), BBStringFromNSString(value));
        }];
        [achievements enumerateObjectsUsingBlock:^(GKAchievementDescription *achievement, NSUInteger achievementIndex, BOOL *achievementStop) {
            apple_gamekit_gamekit_apple_TGameCenter__OnActivityDefinitionAchievement(
                bmxGameKitService, requestId, (int)index, (int)achievementIndex,
                BBStringFromNSString(achievement.identifier));
        }];
        [leaderboards enumerateObjectsUsingBlock:^(GKLeaderboard *leaderboard, NSUInteger leaderboardIndex, BOOL *leaderboardStop) {
            apple_gamekit_gamekit_apple_TGameCenter__OnActivityDefinitionLeaderboard(
                bmxGameKitService, requestId, (int)index, (int)leaderboardIndex,
                BBStringFromNSString(leaderboard.baseLeaderboardID));
        }];
    }];
    CompleteSimple(^(BBString *domain, int code, BBString *message) {
        apple_gamekit_gamekit_apple_TGameCenter__OnActivityDefinitionLoadComplete(
            bmxGameKitService, requestId, domain, code, message);
    }, error);
}

static void CompleteActivityDefinitions(int requestId, NSArray<GKGameActivityDefinition *> *definitions, NSError *error) API_AVAILABLE(ios(26.0), macos(26.0)) {
    NSArray<GKGameActivityDefinition *> *values = definitions ?: @[];
    if (error) values = @[];
    if (!values.count) {
        DispatchMain(^{
            SendActivityDefinitionResults(requestId, values, @[], @[], error);
        });
        return;
    }

    NSMutableArray *achievementLists = [NSMutableArray arrayWithCapacity:values.count];
    NSMutableArray *leaderboardLists = [NSMutableArray arrayWithCapacity:values.count];
    for (NSUInteger index = 0; index < values.count; index++) {
        [achievementLists addObject:@[]];
        [leaderboardLists addObject:@[]];
    }
    dispatch_group_t group = dispatch_group_create();
    __block NSError *associationError = nil;
    [values enumerateObjectsUsingBlock:^(GKGameActivityDefinition *definition, NSUInteger index, BOOL *stop) {
        dispatch_group_enter(group);
        [definition loadAchievementDescriptionsWithCompletionHandler:^(NSArray<GKAchievementDescription *> *achievements, NSError *loadError) {
            @synchronized (values) {
                achievementLists[index] = achievements ?: @[];
                if (!associationError && loadError) associationError = loadError;
            }
            dispatch_group_leave(group);
        }];
        dispatch_group_enter(group);
        [definition loadLeaderboardsWithCompletionHandler:^(NSArray<GKLeaderboard *> *leaderboards, NSError *loadError) {
            @synchronized (values) {
                leaderboardLists[index] = leaderboards ?: @[];
                if (!associationError && loadError) associationError = loadError;
            }
            dispatch_group_leave(group);
        }];
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        SendActivityDefinitionResults(requestId, values, achievementLists, leaderboardLists, associationError);
    });
}

static void CompleteActivityDefinitionError(int requestId, NSError *error) {
    DispatchMain(^{
        if (!bmxGameKitService) return;
        apple_gamekit_gamekit_apple_TGameCenter__OnActivityDefinitionLoadBegin(
            bmxGameKitService, requestId, 0);
        CompleteSimple(^(BBString *domain, int code, BBString *message) {
            apple_gamekit_gamekit_apple_TGameCenter__OnActivityDefinitionLoadComplete(
                bmxGameKitService, requestId, domain, code, message);
        }, error);
    });
}

static void SendActivityUpdate(int requestId, int operation, GKGameActivity *activity, NSError *error) API_AVAILABLE(ios(26.0), macos(26.0)) {
    DispatchMain(^{
        if (!bmxGameKitService) return;
        int handle = StoreActivity(activity);
        apple_gamekit_gamekit_apple_TGameCenter__OnActivityUpdatedBegin(
            bmxGameKitService, requestId, operation, handle,
            BBStringFromNSString(activity.identifier), BBStringFromNSString(activity.activityDefinition.identifier),
            BBStringFromNSString(activity.partyCode), BBStringFromNSString(activity.partyURL.absoluteString),
            (int)activity.state, activity.creationDate.timeIntervalSince1970,
            activity.startDate.timeIntervalSince1970, activity.lastResumeDate.timeIntervalSince1970,
            activity.endDate.timeIntervalSince1970, activity.duration);
        [activity.properties enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
            apple_gamekit_gamekit_apple_TGameCenter__OnGameActivityProperty(
                bmxGameKitService, BBStringFromNSString(key), BBStringFromNSString(value));
        }];
        CompleteSimple(^(BBString *domain, int code, BBString *message) {
            apple_gamekit_gamekit_apple_TGameCenter__OnActivityUpdatedReady(
                bmxGameKitService, domain, code, message);
        }, error);
    });
}

static void CompleteActivityUpdateError(int requestId, int operation, NSError *error) {
    DispatchMain(^{
        if (!bmxGameKitService) return;
        apple_gamekit_gamekit_apple_TGameCenter__OnActivityUpdatedBegin(
            bmxGameKitService, requestId, operation, 0,
            &bbEmptyString, &bbEmptyString, &bbEmptyString, &bbEmptyString,
            0, 0, 0, 0, 0, 0);
        CompleteSimple(^(BBString *domain, int code, BBString *message) {
            apple_gamekit_gamekit_apple_TGameCenter__OnActivityUpdatedReady(
                bmxGameKitService, domain, code, message);
        }, error);
    });
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

static const NSUInteger BMXGameKitMatchEventCapacity = 512;

@interface BMXGameKitMatchEvent : NSObject
@property(nonatomic) int kind;
@property(nonatomic) int playerIndex;
@property(nonatomic, strong) NSData *data;
@property(nonatomic, strong) NSError *error;
@end

@implementation BMXGameKitMatchEvent

#if !__has_feature(objc_arc)
- (void)dealloc {
    [_data release];
    [_error release];
    [super dealloc];
}
#endif

@end

@interface BMXGameKitMatch : NSObject <GKMatchDelegate>
@property(nonatomic, strong) GKMatch *match;
@property(nonatomic, strong) NSMutableArray<GKPlayer *> *players;
@property(nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *playerIndices;
@property(nonatomic, strong) NSMutableSet<NSNumber *> *connectedPlayers;
@property(nonatomic, strong) NSMutableArray<BMXGameKitMatchEvent *> *events;
@property(nonatomic) BOOL open;
@property(nonatomic) BOOL overflowed;
- (instancetype)initWithMatch:(GKMatch *)match;
- (int)playerIndex:(GKPlayer *)player;
- (void)queueKind:(int)kind player:(GKPlayer *)player data:(NSData *)data error:(NSError *)error;
@end

@implementation BMXGameKitMatch

- (instancetype)initWithMatch:(GKMatch *)match {
    self = [super init];
    if (!self) return nil;
    self.match = match;
    self.players = [NSMutableArray array];
    self.playerIndices = [NSMutableDictionary dictionary];
    self.connectedPlayers = [NSMutableSet set];
    self.events = [NSMutableArray arrayWithCapacity:MIN(BMXGameKitMatchEventCapacity, 32)];
    _open = YES;
    match.delegate = self;
    for (GKPlayer *player in match.players) {
        int playerIndex = [self playerIndex:player];
        [_connectedPlayers addObject:@(playerIndex)];
        [self queueKind:1 player:player data:nil error:nil];
    }
    return self;
}

#if !__has_feature(objc_arc)
- (void)dealloc {
    [_match release];
    [_players release];
    [_playerIndices release];
    [_connectedPlayers release];
    [_events release];
    [super dealloc];
}
#endif

- (int)playerIndex:(GKPlayer *)player {
    if (!player) return 0;
    NSString *identifier = player.gamePlayerID ?: @"";
    NSNumber *existing = self.playerIndices[identifier];
    if (existing) return existing.intValue;
    [self.players addObject:player];
    int playerIndex = (int)self.players.count;
    self.playerIndices[identifier] = @(playerIndex);
    if (player.gamePlayerID.length) PlayerCache()[player.gamePlayerID] = player;
    if (player.teamPlayerID.length) PlayerCache()[player.teamPlayerID] = player;
    return playerIndex;
}

- (void)queueKind:(int)kind player:(GKPlayer *)player data:(NSData *)data error:(NSError *)error {
    @synchronized (self) {
        if (self.events.count >= BMXGameKitMatchEventCapacity) {
            self.overflowed = YES;
            return;
        }
        BMXGameKitMatchEvent *event = [[BMXGameKitMatchEvent alloc] init];
        event.kind = kind;
        event.playerIndex = [self playerIndex:player];
        event.data = data;
        event.error = error;
        [self.events addObject:event];
#if !__has_feature(objc_arc)
        [event release];
#endif
    }
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromRemotePlayer:(GKPlayer *)player {
    DispatchMain(^{ [self queueKind:3 player:player data:data error:nil]; });
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data forRecipient:(GKPlayer *)recipient fromRemotePlayer:(GKPlayer *)player {
    DispatchMain(^{ [self queueKind:3 player:player data:data error:nil]; });
}

- (void)match:(GKMatch *)match player:(GKPlayer *)player didChangeConnectionState:(GKPlayerConnectionState)state {
    DispatchMain(^{
        int playerIndex = [self playerIndex:player];
        NSNumber *key = @(playerIndex);
        if (state == GKPlayerStateConnected) {
            if (![self.connectedPlayers containsObject:key]) {
                [self.connectedPlayers addObject:key];
                [self queueKind:1 player:player data:nil error:nil];
            }
        } else if (state == GKPlayerStateDisconnected) {
            if ([self.connectedPlayers containsObject:key]) {
                [self.connectedPlayers removeObject:key];
                [self queueKind:2 player:player data:nil error:nil];
            }
        }
    });
}

- (void)match:(GKMatch *)match didFailWithError:(NSError *)error {
    DispatchMain(^{
        self.open = NO;
        [self queueKind:4 player:nil data:nil error:error ?: ModuleError(-12, @"The Game Center match failed.")];
    });
}

@end

static NSMutableDictionary<NSNumber *, BMXGameKitMatch *> *MatchCache(void) {
    if (!bmxGameKitMatches) bmxGameKitMatches = [[NSMutableDictionary alloc] init];
    return bmxGameKitMatches;
}

static int StoreMatch(GKMatch *match) {
    if (!match) return 0;
    int handle = NextPositiveHandle(&bmxGameKitNextMatchHandle);
    BMXGameKitMatch *wrapper = [[BMXGameKitMatch alloc] initWithMatch:match];
    MatchCache()[@(handle)] = wrapper;
#if !__has_feature(objc_arc)
    [wrapper release];
#endif
    return handle;
}

static void ResetMatches(void) {
    for (BMXGameKitMatch *wrapper in MatchCache().allValues) {
        wrapper.open = NO;
        wrapper.match.delegate = nil;
        [wrapper.match disconnect];
    }
    [bmxGameKitMatches removeAllObjects];
}

@interface BMXGameKitLocalPlayerListener : NSObject <GKLocalPlayerListener>
@end

@implementation BMXGameKitLocalPlayerListener

- (void)player:(GKPlayer *)player wantsToPlayGameActivity:(GKGameActivity *)activity completionHandler:(void (^)(BOOL handled))completionHandler API_AVAILABLE(ios(26.0), macos(26.0)) {
    DispatchMain(^{
        if (!bmxGameKitService || !activity) {
            completionHandler(NO);
            return;
        }
        if (player.gamePlayerID.length) PlayerCache()[player.gamePlayerID] = player;
        if (player.teamPlayerID.length) PlayerCache()[player.teamPlayerID] = player;
        apple_gamekit_gamekit_apple_TGameCenter__OnGameActivityBegin(
            bmxGameKitService,
            BBStringFromNSString(player.gamePlayerID), BBStringFromNSString(player.teamPlayerID),
            BBStringFromNSString(player.alias), BBStringFromNSString(player.displayName),
            StoreActivity(activity),
            BBStringFromNSString(activity.identifier),
            BBStringFromNSString(activity.activityDefinition.identifier),
            BBStringFromNSString(activity.partyCode), BBStringFromNSString(activity.partyURL.absoluteString),
            (int)activity.state, activity.creationDate.timeIntervalSince1970,
            activity.startDate.timeIntervalSince1970, activity.lastResumeDate.timeIntervalSince1970,
            activity.endDate.timeIntervalSince1970, activity.duration);
        [activity.properties enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
            apple_gamekit_gamekit_apple_TGameCenter__OnGameActivityProperty(
                bmxGameKitService, BBStringFromNSString(key), BBStringFromNSString(value));
        }];
        completionHandler(apple_gamekit_gamekit_apple_TGameCenter__OnGameActivityReady(bmxGameKitService) != 0);
    });
}

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
        ResetActivityCache();
        ResetMatches();
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

static void CompleteMatchmaking(int requestId, GKMatch *match, NSError *error) {
    DispatchMain(^{
        if (!bmxGameKitService) {
            match.delegate = nil;
            [match disconnect];
            return;
        }
        NSError *completionError = error;
        int handle = completionError ? 0 : StoreMatch(match);
        if (!completionError && !handle) completionError = ModuleError(-10, @"Game Center did not return a match.");
        if (completionError && match) {
            match.delegate = nil;
            [match disconnect];
        }
        CompleteSimple(^(BBString *domain, int code, BBString *message) {
            apple_gamekit_gamekit_apple_TGameCenter__OnMatchFound(
                bmxGameKitService, requestId, handle, domain, code, message);
        }, completionError);
    });
}

void bmx_gamekit_find_match(int requestId, int minPlayers, int maxPlayers, unsigned int playerGroup, unsigned int playerAttributes) {
    DispatchMain(^{
        GKLocalPlayer *localPlayer = GKLocalPlayer.localPlayer;
        if (!localPlayer.isAuthenticated) {
            CompleteMatchmaking(requestId, nil, ModuleError(-2, @"The local Game Center player is not authenticated."));
            return;
        }
        if (localPlayer.isMultiplayerGamingRestricted) {
            CompleteMatchmaking(requestId, nil, ModuleError(-3, @"Multiplayer gaming is restricted for the local player."));
            return;
        }
        NSUInteger maximum = [GKMatchRequest maxPlayersAllowedForMatchOfType:GKMatchTypePeerToPeer];
        if (minPlayers < 2 || maxPlayers < minPlayers || (NSUInteger)maxPlayers > maximum) {
            CompleteMatchmaking(requestId, nil, ModuleError(-4, @"The requested Game Center player range is invalid."));
            return;
        }
        GKMatchRequest *request = [[GKMatchRequest alloc] init];
        request.minPlayers = (NSUInteger)minPlayers;
        request.maxPlayers = (NSUInteger)maxPlayers;
        request.playerGroup = (NSUInteger)playerGroup;
        request.playerAttributes = (uint32_t)playerAttributes;
        [GKMatchmaker.sharedMatchmaker findMatchForRequest:request withCompletionHandler:^(GKMatch *match, NSError *error) {
            CompleteMatchmaking(requestId, match, error);
        }];
    });
}

void bmx_gamekit_cancel_matchmaking(void) {
    DispatchMain(^{ [GKMatchmaker.sharedMatchmaker cancel]; });
}

int bmx_gamekit_match_expected_player_count(int handle) {
    BMXGameKitMatch *wrapper = MatchCache()[@(handle)];
    return wrapper ? (int)wrapper.match.expectedPlayerCount : 0;
}

int bmx_gamekit_match_player_count(int handle) {
    BMXGameKitMatch *wrapper = MatchCache()[@(handle)];
    return wrapper ? (int)wrapper.players.count : 0;
}

int bmx_gamekit_match_player(int handle, int playerIndex,
                             BBString **gamePlayerID, BBString **teamPlayerID,
                             BBString **alias, BBString **displayName,
                             int *underage, int *multiplayerRestricted,
                             int *personalizedCommunicationRestricted) {
    BMXGameKitMatch *wrapper = MatchCache()[@(handle)];
    GKPlayer *player = nil;
    if (wrapper && playerIndex > 0 && (NSUInteger)playerIndex <= wrapper.players.count) {
        player = wrapper.players[(NSUInteger)playerIndex - 1];
    }
    *gamePlayerID = player ? BBStringFromNSString(player.gamePlayerID) : &bbEmptyString;
    *teamPlayerID = player ? BBStringFromNSString(player.teamPlayerID) : &bbEmptyString;
    *alias = player ? BBStringFromNSString(player.alias) : &bbEmptyString;
    *displayName = player ? BBStringFromNSString(player.displayName) : &bbEmptyString;
	*underage = 0;
	*multiplayerRestricted = 0;
    *personalizedCommunicationRestricted = 0;
    return player != nil;
}

void bmx_gamekit_match_finish_matchmaking(int handle) {
    DispatchMain(^{
        BMXGameKitMatch *wrapper = MatchCache()[@(handle)];
        if (wrapper && wrapper.open) {
            [GKMatchmaker.sharedMatchmaker finishMatchmakingForMatch:wrapper.match];
        }
    });
}

int bmx_gamekit_match_poll(int handle, void *data, size_t dataCapacity,
                           int *kind, int *playerIndex, size_t *dataLength,
                           BBString **errorDomain, int *errorCode, BBString **errorMessage) {
    BMXGameKitMatch *wrapper = MatchCache()[@(handle)];
    *kind = 0;
    *playerIndex = 0;
    *dataLength = 0;
    *errorDomain = &bbEmptyString;
    *errorCode = 0;
    *errorMessage = &bbEmptyString;
    if (!wrapper) return 0;

    BMXGameKitMatchEvent *event = nil;
    @synchronized (wrapper) {
        if (wrapper.overflowed) {
            wrapper.overflowed = NO;
            *kind = 4;
            NSError *error = ModuleError(-11, @"The Game Center match event queue overflowed.");
            ErrorValues(error, errorDomain, errorCode, errorMessage);
            return 1;
        }
        if (!wrapper.events.count) return 0;
        event = wrapper.events.firstObject;
#if !__has_feature(objc_arc)
        [event retain];
#endif
        [wrapper.events removeObjectAtIndex:0];
    }

    *kind = event.kind;
    *playerIndex = event.playerIndex;
    *dataLength = event.data.length;
    if (event.data.length && data && event.data.length <= dataCapacity) {
        memcpy(data, event.data.bytes, event.data.length);
    }
    ErrorValues(event.error, errorDomain, errorCode, errorMessage);
#if !__has_feature(objc_arc)
    [event release];
#endif
    return 1;
}

int bmx_gamekit_match_send(int handle, int playerIndex, int mode, const void *data, size_t length,
                           BBString **errorDomain, int *errorCode, BBString **errorMessage) {
    BMXGameKitMatch *wrapper = MatchCache()[@(handle)];
    NSError *error = nil;
    BOOL sent = NO;
    if (!wrapper || !wrapper.open) {
        error = ModuleError(-5, @"The Game Center match is closed.");
    } else if (playerIndex <= 0 || (NSUInteger)playerIndex > wrapper.players.count) {
        error = ModuleError(-6, @"The Game Center match player is invalid.");
    } else if (length && !data) {
        error = ModuleError(-7, @"Packet data is missing.");
    } else if (mode < GKMatchSendDataReliable || mode > GKMatchSendDataUnreliable) {
        error = ModuleError(-8, @"The Game Center match send mode is invalid.");
    } else {
        NSData *packet = [NSData dataWithBytes:data length:length];
        GKPlayer *player = wrapper.players[(NSUInteger)playerIndex - 1];
        sent = [wrapper.match sendData:packet toPlayers:@[player] dataMode:(GKMatchSendDataMode)mode error:&error];
    }
    ErrorValues(error, errorDomain, errorCode, errorMessage);
    return sent;
}

int bmx_gamekit_match_is_open(int handle) {
    BMXGameKitMatch *wrapper = MatchCache()[@(handle)];
    return wrapper && wrapper.open;
}

void bmx_gamekit_match_disconnect(int handle) {
    BMXGameKitMatch *wrapper = MatchCache()[@(handle)];
    if (!wrapper) return;
    wrapper.open = NO;
    wrapper.match.delegate = nil;
    [wrapper.match disconnect];
    [MatchCache() removeObjectForKey:@(handle)];
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

int bmx_gamekit_are_challenges_available(void) {
    if (@available(iOS 26.0, macOS 26.0, *)) return 1;
    return 0;
}

int bmx_gamekit_are_activities_available(void) {
    if (@available(iOS 26.0, macOS 26.0, *)) return 1;
    return 0;
}

void bmx_gamekit_fetch_identity_verification(int requestId) {
    DispatchMain(^{
        GKLocalPlayer *player = GKLocalPlayer.localPlayer;
        if (!player.isAuthenticated) {
            NSError *error = ModuleError(-2, @"The local player is not authenticated with Game Center.");
            CompleteSimple(^(BBString *domain, int code, BBString *message) {
                apple_gamekit_gamekit_apple_TGameCenter__OnIdentityVerificationFetched(
                    bmxGameKitService, requestId, &bbEmptyString, &bbEmptyString, &bbEmptyString,
                    &bbEmptyString, &bbEmptyArray, &bbEmptyArray, 0, domain, code, message);
            }, error);
            return;
        }
        if (@available(iOS 13.5, macOS 10.15.5, *)) {
            [player fetchItemsForIdentityVerificationSignature:^(NSURL *publicKeyURL, NSData *signature, NSData *salt, uint64_t timestamp, NSError *error) {
                DispatchMain(^{
                    if (!bmxGameKitService) return;
                    NSError *callbackError = error;
                    if (!callbackError && (!publicKeyURL || !signature.length || !salt.length || !timestamp)) {
                        callbackError = ModuleError(-4, @"Game Center returned an incomplete identity verification payload.");
                    }
                    CompleteSimple(^(BBString *domain, int code, BBString *message) {
                        apple_gamekit_gamekit_apple_TGameCenter__OnIdentityVerificationFetched(
                            bmxGameKitService, requestId,
                            BBStringFromNSString(player.gamePlayerID), BBStringFromNSString(player.teamPlayerID),
                            BBStringFromNSString(NSBundle.mainBundle.bundleIdentifier),
                            BBStringFromNSString(publicKeyURL.absoluteString),
                            BBByteArrayFromNSData(signature), BBByteArrayFromNSData(salt),
                            (BBULONG)timestamp, domain, code, message);
                    }, callbackError);
                });
            }];
        } else {
            NSError *error = ModuleError(-1, @"Identity verification requires iOS 13.5 or macOS 10.15.5.");
            CompleteSimple(^(BBString *domain, int code, BBString *message) {
                apple_gamekit_gamekit_apple_TGameCenter__OnIdentityVerificationFetched(
                    bmxGameKitService, requestId, &bbEmptyString, &bbEmptyString, &bbEmptyString,
                    &bbEmptyString, &bbEmptyArray, &bbEmptyArray, 0, domain, code, message);
            }, error);
        }
    });
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

void bmx_gamekit_load_challenge_definitions(int requestId) {
    DispatchMain(^{
        if (@available(iOS 26.0, macOS 26.0, *)) {
            [GKChallengeDefinition loadChallengeDefinitionsWithCompletionHandler:^(NSArray<GKChallengeDefinition *> *definitions, NSError *error) {
                CompleteChallengeDefinitions(requestId, definitions, error);
            }];
        } else {
            CompleteChallengeDefinitionError(requestId, ModuleError(-1, @"Challenges require iOS 26 or macOS 26."));
        }
    });
}

void bmx_gamekit_load_challenge_active_status(int requestId, BBString *identifierValue) {
    NSString *identifier = NSStringFromBBString(identifierValue);
    DispatchMain(^{
        if (!identifier.length) {
            CompleteChallengeActiveStatus(requestId, identifier, NO, ModuleError(-2, @"A challenge identifier is required."));
            return;
        }
        if (@available(iOS 26.0, macOS 26.0, *)) {
            [GKChallengeDefinition loadChallengeDefinitionsWithCompletionHandler:^(NSArray<GKChallengeDefinition *> *definitions, NSError *loadError) {
                GKChallengeDefinition *requestedDefinition = nil;
                for (GKChallengeDefinition *definition in definitions) {
                    if ([definition.identifier isEqualToString:identifier]) {
                        requestedDefinition = definition;
                        break;
                    }
                }
                if (!requestedDefinition || loadError) {
                    CompleteChallengeActiveStatus(requestId, identifier, NO,
                        loadError ?: ModuleError(-3, @"The requested challenge was not found."));
                    return;
                }
                [requestedDefinition hasActiveChallengesWithCompletionHandler:^(BOOL hasActiveChallenges, NSError *error) {
                    CompleteChallengeActiveStatus(requestId, identifier, hasActiveChallenges, error);
                }];
            }];
        } else {
            CompleteChallengeActiveStatus(requestId, identifier, NO, ModuleError(-1, @"Challenges require iOS 26 or macOS 26."));
        }
    });
}

void bmx_gamekit_show_challenges(int requestId, BBString *identifierValue) {
    NSString *identifier = NSStringFromBBString(identifierValue);
    DispatchMain(^{
        if (!bmxGameKitService) return;
        if (@available(iOS 26.0, macOS 26.0, *)) {
            GKAccessPoint *accessPoint = GKAccessPoint.shared;
#if TARGET_OS_IPHONE
            accessPoint.parentWindow = ActiveWindow();
#else
            accessPoint.parentWindow = NSApp.keyWindow ?: NSApp.mainWindow;
#endif
            void (^finished)(void) = ^{
                DispatchMain(^{
                    if (bmxGameKitService) {
                        apple_gamekit_gamekit_apple_TGameCenter__OnChallengeViewDismissed(
                            bmxGameKitService, requestId, BBStringFromNSString(identifier),
                            &bbEmptyString, 0, &bbEmptyString);
                    }
                });
            };
            if (identifier.length) {
                [accessPoint triggerAccessPointWithChallengeDefinitionID:identifier handler:finished];
            } else {
                [accessPoint triggerAccessPointForChallengesWithHandler:finished];
            }
        } else {
            NSError *error = ModuleError(-1, @"Challenges require iOS 26 or macOS 26.");
            CompleteSimple(^(BBString *domain, int code, BBString *message) {
                apple_gamekit_gamekit_apple_TGameCenter__OnChallengeViewDismissed(
                    bmxGameKitService, requestId, BBStringFromNSString(identifier), domain, code, message);
            }, error);
        }
    });
}

void bmx_gamekit_check_pending_activity(int requestId) {
    DispatchMain(^{
        if (!bmxGameKitService) return;
        if (@available(iOS 26.0, macOS 26.0, *)) {
            [GKGameActivity checkPendingGameActivityExistenceWithCompletionHandler:^(BOOL hasPendingActivity) {
                DispatchMain(^{
                    if (bmxGameKitService) {
                        apple_gamekit_gamekit_apple_TGameCenter__OnPendingGameActivityChecked(
                            bmxGameKitService, requestId, hasPendingActivity,
                            &bbEmptyString, 0, &bbEmptyString);
                    }
                });
            }];
        } else {
            NSError *error = ModuleError(-1, @"Game activities require iOS 26 or macOS 26.");
            CompleteSimple(^(BBString *domain, int code, BBString *message) {
                apple_gamekit_gamekit_apple_TGameCenter__OnPendingGameActivityChecked(
                    bmxGameKitService, requestId, 0, domain, code, message);
            }, error);
        }
    });
}

void bmx_gamekit_load_activity_definitions(int requestId) {
    DispatchMain(^{
        if (@available(iOS 26.0, macOS 26.0, *)) {
            [GKGameActivityDefinition loadGameActivityDefinitionsWithCompletionHandler:^(NSArray<GKGameActivityDefinition *> *definitions, NSError *error) {
                CompleteActivityDefinitions(requestId, definitions, error);
            }];
        } else {
            CompleteActivityDefinitionError(requestId, ModuleError(-1, @"Game activities require iOS 26 or macOS 26."));
        }
    });
}

void bmx_gamekit_start_activity(int requestId, BBString *identifierValue, BBString *partyCodeValue) {
    NSString *identifier = NSStringFromBBString(identifierValue);
    NSString *partyCode = NSStringFromBBString(partyCodeValue);
    DispatchMain(^{
        if (!bmxGameKitService) return;
        if (@available(iOS 26.0, macOS 26.0, *)) {
            if (!identifier.length) {
                SendActivityUpdate(requestId, 0, nil, ModuleError(-2, @"An activity definition identifier is required."));
                return;
            }
            if (partyCode.length && ![GKGameActivity isValidPartyCode:partyCode]) {
                SendActivityUpdate(requestId, 0, nil, ModuleError(-2, @"The party code is not valid."));
                return;
            }
            [GKGameActivityDefinition loadGameActivityDefinitionsWithIDs:@[identifier]
                                                       completionHandler:^(NSArray<GKGameActivityDefinition *> *definitions, NSError *loadError) {
                DispatchMain(^{
                    GKGameActivityDefinition *definition = definitions.firstObject;
                    if (!definition || loadError) {
                        SendActivityUpdate(requestId, 0, nil,
                            loadError ?: ModuleError(-3, @"The requested activity definition was not found."));
                        return;
                    }
                    NSError *startError = nil;
                    GKGameActivity *activity = partyCode.length
                        ? [GKGameActivity startWithDefinition:definition partyCode:partyCode error:&startError]
                        : [GKGameActivity startWithDefinition:definition error:&startError];
                    SendActivityUpdate(requestId, 0, activity, startError);
                });
            }];
        } else {
            CompleteActivityUpdateError(requestId, 0, ModuleError(-1, @"Game activities require iOS 26 or macOS 26."));
        }
    });
}

void bmx_gamekit_change_activity_state(int requestId, int handle, int operation) {
    DispatchMain(^{
        if (!bmxGameKitService) return;
        if (@available(iOS 26.0, macOS 26.0, *)) {
            GKGameActivity *activity = ActivityCache()[@(handle)];
            if (!activity) {
                SendActivityUpdate(requestId, operation, nil, ModuleError(-3, @"The activity is not available in this Game Center session."));
                return;
            }
            switch (operation) {
                case 0: [activity start]; break;
                case 1: [activity pause]; break;
                case 2: [activity resume]; break;
                case 3: [activity end]; break;
                default:
                    SendActivityUpdate(requestId, operation, activity, ModuleError(-5, @"Unknown activity state operation."));
                    return;
            }
            SendActivityUpdate(requestId, operation, activity, nil);
        } else {
            CompleteActivityUpdateError(requestId, operation, ModuleError(-1, @"Game activities require iOS 26 or macOS 26."));
        }
    });
}

void bmx_gamekit_set_activity_property(int requestId, int handle, BBString *keyValue, BBString *propertyValue) {
    NSString *key = NSStringFromBBString(keyValue);
    NSString *value = NSStringFromBBString(propertyValue);
    DispatchMain(^{
        if (!bmxGameKitService) return;
        if (@available(iOS 26.0, macOS 26.0, *)) {
            GKGameActivity *activity = ActivityCache()[@(handle)];
            if (!activity || !key.length) {
                SendActivityUpdate(requestId, 4, activity, ModuleError(-2, activity ? @"An activity property key is required." : @"The activity is not available in this Game Center session."));
                return;
            }
            NSMutableDictionary<NSString *, NSString *> *properties = [activity.properties mutableCopy] ?: [NSMutableDictionary dictionary];
            properties[key] = value;
            activity.properties = properties;
            SendActivityUpdate(requestId, 4, activity, nil);
        } else {
            CompleteActivityUpdateError(requestId, 4, ModuleError(-1, @"Game activities require iOS 26 or macOS 26."));
        }
    });
}

void bmx_gamekit_set_activity_score(int requestId, int handle, BBString *identifierValue, BBLONG score, BBULONG context) {
    NSString *identifier = NSStringFromBBString(identifierValue);
    DispatchMain(^{
        if (!bmxGameKitService) return;
        if (@available(iOS 26.0, macOS 26.0, *)) {
            GKGameActivity *activity = ActivityCache()[@(handle)];
            if (!activity || !identifier.length) {
                SendActivityUpdate(requestId, 5, activity, ModuleError(-2, activity ? @"A leaderboard identifier is required." : @"The activity is not available in this Game Center session."));
                return;
            }
            [GKLeaderboard loadLeaderboardsWithIDs:@[identifier] completionHandler:^(NSArray<GKLeaderboard *> *leaderboards, NSError *loadError) {
                DispatchMain(^{
                    GKLeaderboard *leaderboard = leaderboards.firstObject;
                    if (!leaderboard || loadError) {
                        SendActivityUpdate(requestId, 5, activity,
                            loadError ?: ModuleError(-3, @"The requested leaderboard was not found."));
                        return;
                    }
                    [activity setScoreOnLeaderboard:leaderboard toScore:(NSInteger)score context:(NSUInteger)context];
                    SendActivityUpdate(requestId, 5, activity, nil);
                });
            }];
        } else {
            CompleteActivityUpdateError(requestId, 5, ModuleError(-1, @"Game activities require iOS 26 or macOS 26."));
        }
    });
}

void bmx_gamekit_set_activity_achievement_progress(int requestId, int handle, BBString *identifierValue, double percentComplete) {
    NSString *identifier = NSStringFromBBString(identifierValue);
    DispatchMain(^{
        if (!bmxGameKitService) return;
        if (@available(iOS 26.0, macOS 26.0, *)) {
            GKGameActivity *activity = ActivityCache()[@(handle)];
            if (!activity || !identifier.length) {
                SendActivityUpdate(requestId, 6, activity, ModuleError(-2, activity ? @"An achievement identifier is required." : @"The activity is not available in this Game Center session."));
                return;
            }
            GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
            double progress = fmax(0.0, fmin(100.0, percentComplete));
            [activity setProgressOnAchievement:achievement toPercentComplete:progress];
            SendActivityUpdate(requestId, 6, activity, nil);
        } else {
            CompleteActivityUpdateError(requestId, 6, ModuleError(-1, @"Game activities require iOS 26 or macOS 26."));
        }
    });
}

int bmx_gamekit_is_valid_activity_party_code(BBString *partyCodeValue) {
    NSString *partyCode = NSStringFromBBString(partyCodeValue);
    if (@available(iOS 26.0, macOS 26.0, *)) return [GKGameActivity isValidPartyCode:partyCode];
    return 0;
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
            case 3:
                if (@available(iOS 26.0, macOS 26.0, *)) {
                    [GKChallengeDefinition loadChallengeDefinitionsWithCompletionHandler:^(NSArray<GKChallengeDefinition *> *definitions, NSError *loadError) {
                        GKChallengeDefinition *requestedDefinition = nil;
                        for (GKChallengeDefinition *definition in definitions) {
                            if ([definition.identifier isEqualToString:identifier]) {
                                requestedDefinition = definition;
                                break;
                            }
                        }
                        if (!requestedDefinition || loadError) {
                            DispatchMain(^{
                                if (bmxGameKitService) CompleteResourceImage(requestId, kind, identifier, nil,
                                    loadError ?: ModuleError(-3, @"The requested challenge was not found."));
                            });
                            return;
                        }
                        [requestedDefinition loadImageWithCompletionHandler:^(BMXGameKitImage *image, NSError *error) {
                            DispatchMain(^{ if (bmxGameKitService) CompleteResourceImage(requestId, kind, identifier, image, error); });
                        }];
                    }];
                } else {
                    CompleteResourceImage(requestId, kind, identifier, nil, ModuleError(-1, @"Challenges require iOS 26 or macOS 26."));
                }
                break;
            case 4:
                if (@available(iOS 26.0, macOS 26.0, *)) {
                    [GKGameActivityDefinition loadGameActivityDefinitionsWithIDs:@[identifier]
                                                               completionHandler:^(NSArray<GKGameActivityDefinition *> *definitions, NSError *loadError) {
                        GKGameActivityDefinition *definition = definitions.firstObject;
                        if (!definition || loadError) {
                            DispatchMain(^{
                                if (bmxGameKitService) CompleteResourceImage(requestId, kind, identifier, nil,
                                    loadError ?: ModuleError(-3, @"The requested activity definition was not found."));
                            });
                            return;
                        }
                        [definition loadImageWithCompletionHandler:^(BMXGameKitImage *image, NSError *error) {
                            DispatchMain(^{ if (bmxGameKitService) CompleteResourceImage(requestId, kind, identifier, image, error); });
                        }];
                    }];
                } else {
                    CompleteResourceImage(requestId, kind, identifier, nil, ModuleError(-1, @"Game activities require iOS 26 or macOS 26."));
                }
                break;
            default:
                CompleteResourceImage(requestId, kind, identifier, nil, ModuleError(-5, @"Unknown Game Center resource kind."));
                break;
        }
    });
}
