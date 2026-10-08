#include "brl.mod/blitz.mod/blitz.h"

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import <TargetConditionals.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

extern void apple_gamekit_TGameCenter__OnAuthenticationChanged(BBObject *, int, BBString *, BBString *, BBString *, BBString *, int, int, int, BBString *, int, BBString *);
extern void apple_gamekit_TGameCenter__OnAchievementReported(BBObject *, int, BBString *, BBString *, int, BBString *);
extern void apple_gamekit_TGameCenter__OnAchievementLoadBegin(BBObject *, int, int);
extern void apple_gamekit_TGameCenter__OnAchievementLoaded(BBObject *, int, BBString *, double, int, double);
extern void apple_gamekit_TGameCenter__OnAchievementLoadComplete(BBObject *, int, BBString *, int, BBString *);
extern void apple_gamekit_TGameCenter__OnAchievementsReset(BBObject *, int, BBString *, int, BBString *);
extern void apple_gamekit_TGameCenter__OnScoreSubmitted(BBObject *, int, BBString *, BBLONG, BBString *, int, BBString *);
extern void apple_gamekit_TGameCenter__OnLeaderboardLoadBegin(BBObject *, int, BBString *, BBString *, int, BBLONG);
extern void apple_gamekit_TGameCenter__OnLeaderboardEntry(BBObject *, int, int, BBString *, BBString *, BBString *, BBString *, BBLONG, BBLONG, BBString *, BBULONG, double);
extern void apple_gamekit_TGameCenter__OnLeaderboardLoadComplete(BBObject *, int, BBString *, int, BBString *);
extern void apple_gamekit_TGameCenter__OnViewDismissed(BBObject *, int);

static BBObject *bmxGameKitService = NULL;

static NSString *NSStringFromBBString(BBString *value) {
    unsigned char *utf8 = bbStringToUTF8String(value);
    NSString *result = [NSString stringWithUTF8String:(const char *)utf8];
    bbMemFree(utf8);
    return result ?: @"";
}

static BBString *BBStringFromNSString(NSString *value) {
    return bbStringFromUTF8String((const unsigned char *)[(value ?: @"") UTF8String]);
}

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
    apple_gamekit_TGameCenter__OnAuthenticationChanged(
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
    apple_gamekit_TGameCenter__OnLeaderboardEntry(
        bmxGameKitService, requestId, localPlayer,
        BBStringFromNSString(player.gamePlayerID), BBStringFromNSString(player.teamPlayerID),
        BBStringFromNSString(player.alias), BBStringFromNSString(player.displayName),
        (BBLONG)entry.rank, (BBLONG)entry.score, BBStringFromNSString(entry.formattedScore),
        (BBULONG)entry.context, entry.date.timeIntervalSince1970);
}

void bmx_gamekit_start(BBObject *service) {
    DispatchMain(^{
        if (bmxGameKitService != service) {
            if (bmxGameKitService) BBRELEASE(bmxGameKitService);
            bmxGameKitService = service;
            BBRETAIN(bmxGameKitService);
        }
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
        if (@available(iOS 14.0, macOS 11.0, *)) {
            GKAccessPoint.shared.active = NO;
        }
        if (bmxGameKitService) {
            BBRELEASE(bmxGameKitService);
            bmxGameKitService = NULL;
        }
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
                    if (bmxGameKitService) apple_gamekit_TGameCenter__OnViewDismissed(bmxGameKitService, view);
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
                    apple_gamekit_TGameCenter__OnAchievementReported(bmxGameKitService, requestId, BBStringFromNSString(identifier), domain, code, message);
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
                apple_gamekit_TGameCenter__OnAchievementLoadBegin(bmxGameKitService, requestId, (int)values.count);
                for (GKAchievement *achievement in values) {
                    apple_gamekit_TGameCenter__OnAchievementLoaded(
                        bmxGameKitService, requestId, BBStringFromNSString(achievement.identifier),
                        achievement.percentComplete, achievement.isCompleted,
                        achievement.lastReportedDate.timeIntervalSince1970);
                }
                CompleteSimple(^(BBString *domain, int code, BBString *message) {
                    apple_gamekit_TGameCenter__OnAchievementLoadComplete(bmxGameKitService, requestId, domain, code, message);
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
                    apple_gamekit_TGameCenter__OnAchievementsReset(bmxGameKitService, requestId, domain, code, message);
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
                        apple_gamekit_TGameCenter__OnScoreSubmitted(bmxGameKitService, requestId, BBStringFromNSString(leaderboardIdentifier), score, domain, code, message);
                    }, error);
                });
            }];
        } else {
            NSError *error = ModuleError(-1, @"Leaderboards require iOS 14 or macOS 11.");
            CompleteSimple(^(BBString *domain, int code, BBString *message) {
                apple_gamekit_TGameCenter__OnScoreSubmitted(bmxGameKitService, requestId, BBStringFromNSString(leaderboardIdentifier), score, domain, code, message);
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
                            apple_gamekit_TGameCenter__OnLeaderboardLoadComplete(bmxGameKitService, requestId, domain, code, message);
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
                        apple_gamekit_TGameCenter__OnLeaderboardLoadBegin(
                            bmxGameKitService, requestId, BBStringFromNSString(leaderboardIdentifier),
                            BBStringFromNSString(leaderboard.title), (int)values.count, (BBLONG)totalPlayerCount);
                        if (localEntry) SendLeaderboardEntry(requestId, localEntry, 1);
                        for (GKLeaderboardEntry *entry in values) SendLeaderboardEntry(requestId, entry, 0);
                        CompleteSimple(^(BBString *domain, int code, BBString *message) {
                            apple_gamekit_TGameCenter__OnLeaderboardLoadComplete(bmxGameKitService, requestId, domain, code, message);
                        }, entryError);
                    });
                }];
            }];
        } else {
            NSError *error = ModuleError(-1, @"Leaderboards require iOS 14 or macOS 11.");
            CompleteSimple(^(BBString *domain, int code, BBString *message) {
                apple_gamekit_TGameCenter__OnLeaderboardLoadComplete(bmxGameKitService, requestId, domain, code, message);
            }, error);
        }
    });
}
