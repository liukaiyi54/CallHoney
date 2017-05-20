//
//  ViewController.m
//  CallHoney
//
//  Created by Michael on 23/04/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import "ViewController.h"
#import "AddGestureViewController.h"

#import "DataModel.h"
#import "GestureView.h"
#import "CRToast.h"

#import <ChameleonFramework/Chameleon.h>

@interface ViewController ()

@property (nonatomic, strong) GestureView *gestureView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"画手势打电话";
    [self.view addSubview:self.gestureView];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor flatWhiteColor]}];
    [self.navigationController setHidesNavigationBarHairline:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor flatMintColor];
    self.navigationController.navigationBar.tintColor = [UIColor flatWhiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.gestureView respondsToSelector:@selector(loadTemplates)]) {
        [self.gestureView loadTemplates];
    }
}

- (void)showToastWithText:(NSString *)text color:(UIColor *)color {
    NSDictionary *options = @{
                              kCRToastTextKey : text,
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey : color,
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionBottom),
                              kCRToastNotificationTypeKey: @(CRToastTypeNavigationBar),
                              kCRToastFontKey: [UIFont systemFontOfSize:16],
                              kCRToastNotificationPresentationTypeKey: @(CRToastPresentationTypeCover),
                              kCRToastTimeIntervalKey: @(0.6)
                              };
    [CRToastManager showNotificationWithOptions:options completionBlock:nil];
}

- (GestureView *)gestureView {
    if (!_gestureView) {
        _gestureView = [[GestureView alloc] init];
        _gestureView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        __weak typeof(self) weakSelf = self;
        _gestureView.gestureViewBlock = ^(GestureView *view, float score, NSString *phoneNum) {
            if (score > 0.5) {
                [weakSelf showToastWithText:@"没有匹配成功哦" color:[UIColor flatYellowColor]];
                return; //得分太低，匹配失败
            }
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNum]];
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        };
    }
    return _gestureView;
}

@end
