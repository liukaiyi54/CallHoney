//
//  AddGestureView.m
//  CallHoney
//
//  Created by Michael on 04/05/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import "AddGestureView.h"
#import "KLGestureRecoginzer+ArchiveTemplates.h"

@interface AddGestureView() {
    KLGestureRecoginzer *recognizer;
    CGPoint center;
    float score, angle;
}
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL endDrawing;
@property (nonatomic, copy) NSDictionary *gestureDict;
@property (nonatomic, copy) NSString *phoneNum;

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
    [self addSubview:self.addButton];
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
    self.phoneNum = self.textField.text;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.phoneNum]];
    [UIImagePNGRepresentation(self.image) writeToFile:filePath atomically:YES];
}

- (void)didTapAddButton:(id)sender {
    if (self.addButtonBlock) {
        Template *template = [[Template alloc] init];
        template.phoneNumber = self.phoneNum;
        template.points = self.gestureDict.allValues.firstObject;
        template.imageName = [NSString stringWithFormat:@"%@.png", self.phoneNum];
        if (template.phoneNumber && template.points && template.imageName) {
            self.addButtonBlock(self, template);
        }
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

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2 - 100, 100, 200, 34)];
        _textField.keyboardType = UIKeyboardTypePhonePad;
        _textField.placeholder = @"输入联系人号码";
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _textField;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2 - 30, CGRectGetHeight(self.frame) - 60, 60, 40)];
        [_addButton setTitle:@"添加" forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(didTapAddButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}
@end
