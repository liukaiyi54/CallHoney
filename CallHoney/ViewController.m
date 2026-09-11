//
//  ViewController.m
//  CallHoney
//
//  Created by Michael on 23/04/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

#import "DataModel.h"
#import "GestureView.h"
#import "UINavigationBar+Awesome.h"

@interface ViewController ()

@property (nonatomic, strong) GestureView *gestureView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *destination = segue.destinationViewController;
    if ([destination isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)destination;
        navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
        navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        navigationController.modalInPresentation = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Draw & Call";
    [self.view addSubview:self.gestureView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:@"ImageName" object:nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor flatWhiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor flatWhiteColor];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Chalkduster" size:24], NSForegroundColorAttributeName: [UIColor flatWhiteColor]}];
    
    NSString *imageName = [[NSUserDefaults standardUserDefaults] objectForKey:@"ImageName"];
    if (imageName) {
        self.imageView.image = [UIImage imageNamed:imageName] ?: [UIImage imageWithContentsOfFile:
            [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject
             stringByAppendingPathComponent:imageName]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.gestureView respondsToSelector:@selector(loadTemplates)]) {
        [self.gestureView loadTemplates];
    }
}

- (void)showToastWithText:(NSString *)text color:(UIColor *)color completionBlock:(void (^)(void))completionBlock{
    CHShowToast(self.navigationController.view, text, color, 0.6, completionBlock);
}

- (void)didReceiveNotification:(NSNotification *)notification {
    NSString *imageName = notification.object;
    self.imageView.image = [UIImage imageNamed:imageName] ?: [UIImage imageWithContentsOfFile:
        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject
         stringByAppendingPathComponent:imageName]];
}

- (GestureView *)gestureView {
    if (!_gestureView) {
        _gestureView = [[GestureView alloc] init];
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        if (CGRectGetWidth(self.view.bounds) >= 414) {
            frame = CGRectMake(20, 64+80, CGRectGetWidth(self.view.frame)-40, CGRectGetHeight(self.view.frame)-200);
        }
        _gestureView.frame = frame;
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
                NSString *phone = [phoneNum stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone]];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                        [view resetView];
                    }];
                } else {
                    [view resetView];
                }

            }
        };
    }
    return _gestureView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ImageName" object:nil];
}

@end
