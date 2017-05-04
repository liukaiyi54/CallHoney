//
//  KLGestureRecoginzer.h
//  CallHoney
//
//  Created by Michael on 24/04/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KLGestureRecoginzer : NSObject

@property (nonatomic, strong) NSDictionary *templates;
@property (nonatomic, readonly) NSArray *touchPoints;
@property (nonatomic, readonly) NSArray *resampledPoints;

- (void)addTouchAtPoint:(CGPoint)point;
- (void)addTouches:(NSSet*)set fromView:(UIView *)view;
- (void)resetTouches;

- (NSDictionary *)findBestMatch;
- (NSDictionary *)findBestMatchCenter:(CGPoint*)outCenter angle:(float*)outRadians score:(float*)outScore;

@end
