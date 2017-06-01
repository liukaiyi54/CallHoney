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
#import "UINavigationBar+Awesome.h"

#import <ChameleonFramework/Chameleon.h>

@interface ViewController ()

@property (nonatomic, strong) GestureView *gestureView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Draw & Call";
    [self.view addSubview:self.gestureView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:@"ImageName" object:nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor flatWhiteColor]}];
    [self.navigationController setHidesNavigationBarHairline:YES];
    self.navigationController.navigationBar.tintColor = [UIColor flatWhiteColor];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Chalkduster" size:24], NSForegroundColorAttributeName: [UIColor flatWhiteColor]}];
    
    NSString *imageName = [[NSUserDefaults standardUserDefaults] objectForKey:@"ImageName"];
    if (imageName) {
        self.imageView.image = [UIImage imageNamed:imageName];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.gestureView respondsToSelector:@selector(loadTemplates)]) {
        [self.gestureView loadTemplates];
    }
}

- (void)showToastWithText:(NSString *)text color:(UIColor *)color completionBlock:(void (^)(void))completionBlock{
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
    [CRToastManager showNotificationWithOptions:options completionBlock:completionBlock];
}

- (void)didReceiveNotification:(NSNotification *)notification {
    self.imageView.image = [UIImage imageNamed:notification.object];
}

- (GestureView *)gestureView {
    if (!_gestureView) {
        _gestureView = [[GestureView alloc] init];
        _gestureView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        __weak typeof(self) weakSelf = self;
        _gestureView.gestureViewBlock = ^(GestureView *view, float score, NSString *phoneNum) {
            if ([DataModel sharedInstance].templates.count == 0) {
                NSString *string = NSLocalizedString(@"No gesture to match", nil);
                [weakSelf showToastWithText:string color:[UIColor flatYellowColor] completionBlock:^{
                    [view resetView];
                }];
                return;
            }
            if (score > 0.5) {
                NSString *string = NSLocalizedString(@"Match failed", nil);
                [weakSelf showToastWithText:string color:[UIColor flatYellowColor] completionBlock:^{
                    [view resetView];
                }];
                return;
            } else {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNum]];
                NSString *version = [UIDevice currentDevice].systemVersion;
                if (version.doubleValue >= 10.0) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                        [view resetView];
                    }];
                } else {
                    [[UIApplication sharedApplication] openURL:url];
                    [view resetView];
                }

            }
        };
    }
    return _gestureView;
}

@end
