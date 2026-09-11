//
//  AppDelegate.m
//  CallHoney
//
//  Created by Michael on 23/04/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

@implementation UIColor (CallHoney)

+ (UIColor *)flatMintColor { return [UIColor colorWithRed:0.51 green:0.85 blue:0.81 alpha:1.0]; }
+ (UIColor *)flatWhiteColor { return UIColor.whiteColor; }
+ (UIColor *)flatGrayColor { return [UIColor colorWithWhite:0.75 alpha:1.0]; }
+ (UIColor *)flatYellowColor { return [UIColor colorWithRed:0.98 green:0.80 blue:0.30 alpha:1.0]; }
+ (UIColor *)flatSkyBlueColor { return [UIColor colorWithRed:0.35 green:0.70 blue:0.90 alpha:1.0]; }

@end

void CHShowToast(UIView *view, NSString *text, UIColor *color, NSTimeInterval duration, void (^completion)(void)) {
    UILabel *toast = [[UILabel alloc] init];
    toast.translatesAutoresizingMaskIntoConstraints = NO;
    toast.text = text;
    toast.textColor = UIColor.whiteColor;
    toast.backgroundColor = color;
    toast.textAlignment = NSTextAlignmentCenter;
    toast.font = [UIFont systemFontOfSize:16.0];
    toast.numberOfLines = 0;
    toast.layer.cornerRadius = 8.0;
    toast.clipsToBounds = YES;
    [view addSubview:toast];
    [NSLayoutConstraint activateConstraints:@[
        [toast.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:20.0],
        [toast.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-20.0],
        [toast.topAnchor constraintEqualToAnchor:view.safeAreaLayoutGuide.topAnchor constant:8.0],
        [toast.heightAnchor constraintGreaterThanOrEqualToConstant:44.0]
    ]];
    toast.alpha = 0.0;
    [UIView animateWithDuration:0.2 animations:^{ toast.alpha = 1.0; } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{ toast.alpha = 0.0; } completion:^(BOOL finished) {
                [toast removeFromSuperview];
                if (completion) completion();
            }];
        });
    }];
}
