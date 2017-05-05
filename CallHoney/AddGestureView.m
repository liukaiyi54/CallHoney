//
//  AddGestureView.m
//  CallHoney
//
//  Created by Michael on 04/05/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import "AddGestureView.h"

#import "KLGestureRecoginzer+ArchiveTemplates.h"
#import "DataModel.h"

@interface AddGestureView() {
    KLGestureRecoginzer *recognizer;
    CGPoint center;
    float score, angle;
}

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
    
    [self addSubview:self.textField];
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
    NSString *phoneNum = self.textField.text;
    if (!phoneNum) return;
    [self.dataModel.templates setValue:gestureDic.allValues.firstObject forKey:phoneNum];
    [self.dataModel saveTemplates];
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
    [self setNeedsDisplay];
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, 200, 40)];
        _textField.keyboardType = UIKeyboardTypePhonePad;
        _textField.backgroundColor = [UIColor redColor];
        _textField.rightView = [UIButton buttonWithType:UIButtonTypeContactAdd];
        _textField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _textField;
}

@end
