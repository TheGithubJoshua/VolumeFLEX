#define LD_DEBUG NO
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <objc/runtime.h>
#import <notify.h>
#import "FLEXManager.h"
#import <rootless.h>
#import <dlfcn.h>

static BOOL tweakEnabled = YES;
static NSUserDefaults *preferences = nil;
static BOOL tune = NO;
NSString *dylibPath = ROOT_PATH_NS(@"/Library/MobileSubstrate/DynamicLibraries/libFLEX.dylib");

@interface SBApplication
- (NSString *)bundleIdentifier;
@end

@interface SpringBoard
- (SBApplication *)_accessibilityFrontMostApplication;
@end

@interface SBLockScreenManager : NSObject
+ (instancetype)sharedInstance;
- (BOOL)isUILocked;
@end

// Function to handle preferences changed
static void preferencesChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
}

%hook SpringBoard

- (BOOL)_handlePhysicalButtonEvent:(UIPressesEvent *)event {
        BOOL upPressed = NO;
        BOOL downPressed = NO;

        for (UIPress *press in event.allPresses.allObjects) {
            if (press.type == 102 && press.force == 1) {
                upPressed = YES;
            }
            if (press.type == 103 && press.force == 1) {
                downPressed = YES;
            }
        }
        
        if (upPressed && downPressed) {
           // Is the tweak enabled?
    NSString *currentID = NSBundle.mainBundle.bundleIdentifier;
    if ([currentID isEqualToString:@"com.apple.springboard"]) {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)preferencesChanged, CFSTR("com.joshua.VFPB.preferences.changed"), NULL, CFNotificationSuspensionBehaviorCoalesce);

        preferences = [[NSUserDefaults alloc] initWithSuiteName:@"com.joshua.VFPB.plist"];

        [preferences registerDefaults:@{
            @"Enabled": @(tweakEnabled)
        }];

        tweakEnabled = [[preferences objectForKey:@"Enabled"] boolValue];

    } else {
        int regToken;
        NSString *notifForBundle = [NSString stringWithFormat:@"com.joshua.volumeflex/%@", currentID];
        notify_register_dispatch(notifForBundle.UTF8String, &regToken, dispatch_get_main_queue(), ^(int token) {
            dlopen(dylibPath.UTF8String, RTLD_NOW);
	    NSLog(@"libraryHandle = %s", dlerror());
            [[objc_getClass("FLEXManager") sharedManager] showExplorer];
        });
    }

        // Do you want a tune?
        if ([currentID isEqualToString:@"com.apple.springboard"]) {
            CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)preferencesChanged, CFSTR("com.joshua.VFPB.preferences.changed.tune"), NULL, CFNotificationSuspensionBehaviorCoalesce);

            preferences = [[NSUserDefaults alloc] initWithSuiteName:@"com.joshua.VFPB.plist"];

            [preferences registerDefaults:@{
                @"tune": @(tune)
            }];

            tune = [[preferences objectForKey:@"tune"] boolValue];

    } else {
        int regToken;
        NSString *notifForBundle = [NSString stringWithFormat:@"com.joshua.volumeflex/%@", currentID];
        notify_register_dispatch(notifForBundle.UTF8String, &regToken, dispatch_get_main_queue(), ^(int token) {
            dlopen(dylibPath.UTF8String, RTLD_NOW);
            [[objc_getClass("FLEXManager") sharedManager] showExplorer];
        });
    }
        }

    if (tweakEnabled) {

        SBApplication *frontmostApp = [(SpringBoard *)UIApplication.sharedApplication _accessibilityFrontMostApplication];
        SBLockScreenManager *lockscreenManager = [objc_getClass("SBLockScreenManager") sharedInstance];

        // Only proceed if the user is holding down both buttons
        if (upPressed && downPressed && !lockscreenManager.isUILocked) {
            if (tune) {
                // Vibrate and play tune :D
                AudioServicesPlaySystemSound(1328);
            }
            [(SpringBoard *)UIApplication.sharedApplication _accessibilityFrontMostApplication];
            SBLockScreenManager *lockscreenManager = [objc_getClass("SBLockScreenManager") sharedInstance];
            // if frontmostApp is true and the phone is not locked
            if (frontmostApp && !lockscreenManager.isUILocked) {
                notify_post([[NSString stringWithFormat:@"com.joshua.volumeflex/%@", frontmostApp.bundleIdentifier] UTF8String]);
            } else {
                dlopen(dylibPath.UTF8String, RTLD_NOW);
                [[objc_getClass("FLEXManager") sharedManager] showExplorer];
            }
        }
    }
    return %orig;
}

%end

%ctor {
    // Is the tweak enabled?
    NSString *currentID = NSBundle.mainBundle.bundleIdentifier;
    if ([currentID isEqualToString:@"com.apple.springboard"]) {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)preferencesChanged, CFSTR("com.joshua.VFPB.preferences.changed"), NULL, CFNotificationSuspensionBehaviorCoalesce);
        
        preferences = [[NSUserDefaults alloc] initWithSuiteName:@"com.joshua.VFPB.plist"];

        [preferences registerDefaults:@{
            @"Enabled": @(tweakEnabled)
        }];

        tweakEnabled = [[preferences objectForKey:@"Enabled"] boolValue];
        
    } else {
        int regToken;
        NSString *notifForBundle = [NSString stringWithFormat:@"com.joshua.volumeflex/%@", currentID];
        notify_register_dispatch(notifForBundle.UTF8String, &regToken, dispatch_get_main_queue(), ^(int token) {
            dlopen(dylibPath.UTF8String, RTLD_NOW);
            [[objc_getClass("FLEXManager") sharedManager] showExplorer];
        });
    }
        
        // Do you want a tune?
        if ([currentID isEqualToString:@"com.apple.springboard"]) {
            CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)preferencesChanged, CFSTR("com.joshua.VFPB.preferences.changed.tune"), NULL, CFNotificationSuspensionBehaviorCoalesce);
            
            preferences = [[NSUserDefaults alloc] initWithSuiteName:@"com.joshua.VFPB.plist"];

            [preferences registerDefaults:@{
                @"tune": @(tune)
            }];

            tune = [[preferences objectForKey:@"tune"] boolValue];

%init
            
    } else {
        int regToken;
        NSString *notifForBundle = [NSString stringWithFormat:@"com.joshua.volumeflex/%@", currentID];
        notify_register_dispatch(notifForBundle.UTF8String, &regToken, dispatch_get_main_queue(), ^(int token) {
            dlopen(dylibPath.UTF8String, RTLD_NOW);
            [[objc_getClass("FLEXManager") sharedManager] showExplorer];
        });
    }
}

