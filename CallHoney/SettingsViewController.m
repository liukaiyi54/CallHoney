//
//  SettingsViewController.m
//  CallHoney
//
//  Created by Michael on 21/05/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import "SettingsViewController.h"

#import <ChameleonFramework/Chameleon.h>

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置？不存在的";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor flatWhiteColor]}];
    [self.navigationController setHidesNavigationBarHairline:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor flatMintColor];
    self.navigationController.navigationBar.tintColor = [UIColor flatWhiteColor];
}


@end
