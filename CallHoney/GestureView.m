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

CGPoint midPoint(CGPoint p1, CGPoint p2) {
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

@interface GestureView() {
    KLGestureRecoginzer *recognizer;
    CGPoint center;
    float score, angle;
    CGPoint previousPoint1, previousPoint2, currentPoint;
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

    CGPoint mid1 = midPoint(previousPoint1, previousPoint2);
    CGPoint mid2 = midPoint(currentPoint, previousPoint1);
    
    CGContextMoveToPoint(ctx, mid1.x, mid1.y);
    CGContextAddQuadCurveToPoint(ctx, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
    
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
    previousPoint1 = previousPoint2 = currentPoint = [[touches anyObject] locationInView:self];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [recognizer addTouches:touches fromView:self];
    previousPoint2 = previousPoint1;
    previousPoint1 = currentPoint;
    currentPoint = [[touches anyObject] locationInView:self];
    [self drawNewLine];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [recognizer addTouches:touches fromView:self];
    [self drawNewLine];
    [self processGestureData];
}

@end
