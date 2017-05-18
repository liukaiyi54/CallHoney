//
//  AddGestureView.m
//  CallHoney
//
//  Created by Michael on 04/05/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import "AddGestureView.h"
#import <ChameleonFramework/Chameleon.h>
#import "KLGestureRecoginzer+ArchiveTemplates.h"

@interface AddGestureView() {
    KLGestureRecoginzer *recognizer;
    CGPoint center;
    float score, angle;
}
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL endDrawing;
@property (nonatomic, copy) NSDictionary *gestureDict;

@end

@implementation AddGestureView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
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
    if (self.endDrawing) {
        CGImageRef imgRef = CGBitmapContextCreateImage(ctx);
        self.image = [UIImage imageWithCGImage:imgRef];
        CGImageRelease(imgRef);
        [self processGestureData];
        self.endDrawing = NO;
    }
}

- (void)processGestureData {
    self.gestureDict = [recognizer findBestMatchCenter:&center angle:&angle score:&score];
    
    if (self.addCompletion) {
        self.addCompletion(self, self.gestureDict.allValues.firstObject, self.image);
    }
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
    
    self.endDrawing = YES;
    [self setNeedsDisplay];
}

- (void)resetView {
    [recognizer resetTouches];
    [self setNeedsDisplay];
}

@end
