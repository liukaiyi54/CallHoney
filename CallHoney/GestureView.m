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

@interface GestureView() {
    KLGestureRecoginzer *recognizer;
    CGPoint center;
    float score, angle;
}

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
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
    CGContextSetRGBStrokeColor(ctx, 0.51, 0.85, 0.81, 1);
    CGContextSetLineWidth(ctx, 3.0);
    CGContextFillRect(ctx, rect);
    
    CGContextSetTextDrawingMode(ctx, kCGTextFillStroke);
    CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1, -1));
    
    for (NSValue *pointValue in [recognizer touchPoints]) {
        CGPoint pointInView = [pointValue CGPointValue];
        if (pointValue == [[recognizer touchPoints] objectAtIndex:0])
            CGContextMoveToPoint(ctx, pointInView.x, pointInView.y);
        else
            CGContextAddLineToPoint(ctx, pointInView.x, pointInView.y);
    }
    CGContextStrokePath(ctx);
}

- (void)processGestureData {
    NSDictionary *gestureDic = [recognizer findBestMatchCenter:&center angle:&angle score:&score];
    NSString *gestureName = gestureDic.allKeys.firstObject;
    
    if (self.gestureViewBlock) {
        self.gestureViewBlock(self, score, gestureName);
    }
}

- (void)loadTemplates {
    [recognizer loadTemplatesFromKeyedArchiver];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [recognizer resetTouches];
    [recognizer addTouches:touches fromView:self];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [recognizer addTouches:touches fromView:self];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [recognizer addTouches:touches fromView:self];
    
    [self processGestureData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [recognizer resetTouches];
        [self setNeedsDisplay];
    });
}

@end
