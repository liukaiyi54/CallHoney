//
//  GestureView.m
//  CallHoney
//
//  Created by Michael on 24/04/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import "GestureView.h"
#import "KLGestureRecoginzer+ArchiveTemplates.h"
#import "DataModel.h"

#import <ChameleonFramework/Chameleon.h>

@interface GestureView() {
    KLGestureRecoginzer *recognizer;
    CGPoint center;
    float score, angle;
}

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL fingerMoved;

@end

@implementation GestureView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    recognizer = [[KLGestureRecoginzer alloc] init];
    [recognizer loadTemplatesFromKeyedArchiver];
    self.opaque = NO;
}

- (void)drawRect:(CGRect)rect {
    [self.image drawInRect:self.bounds];
}

#pragma mark - private
- (void)drawNewLine {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.image drawInRect:self.bounds];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetRGBStrokeColor(ctx, 0.51, 0.85, 0.81, 1);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 4.0);
    CGContextBeginPath(ctx);
    
    for (NSValue *pointValue in [recognizer touchPoints]) {
        CGPoint pointInView = [pointValue CGPointValue];
        if (pointValue == [[recognizer touchPoints] objectAtIndex:0])
            CGContextMoveToPoint(ctx, pointInView.x, pointInView.y);
        else
            CGContextAddLineToPoint(ctx, pointInView.x, pointInView.y);
    }
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setNeedsDisplay];
}

- (void)processGestureData {
    NSDictionary *gestureDic = [recognizer findBestMatchCenter:&center angle:&angle score:&score];
    NSString *gestureName = gestureDic.allKeys.firstObject;
    
    if (self.gestureViewBlock) {
        self.gestureViewBlock(self, score, gestureName);
    }
}

#pragma mark - public
- (void)loadTemplates {
    [recognizer loadTemplatesFromKeyedArchiver];
}

- (void)resetView {
    [recognizer resetTouches];
    self.image = nil;
    [self setNeedsDisplay];
}

#pragma mark - override
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [recognizer resetTouches];
    [recognizer addTouches:touches fromView:self];
    self.image = nil;
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [recognizer addTouches:touches fromView:self];
    [self drawNewLine];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [recognizer addTouches:touches fromView:self];
    [self drawNewLine];
    [self processGestureData];
}

@end
