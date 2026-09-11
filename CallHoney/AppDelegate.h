//
//  AppDelegate.h
//  CallHoney
//
//  Created by Michael on 23/04/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

@interface UIColor (CallHoney)
+ (UIColor *)flatMintColor;
+ (UIColor *)flatWhiteColor;
+ (UIColor *)flatGrayColor;
+ (UIColor *)flatYellowColor;
+ (UIColor *)flatSkyBlueColor;
@end

void CHShowToast(UIView *view, NSString *text, UIColor *color, NSTimeInterval duration, void (^completion)(void));
