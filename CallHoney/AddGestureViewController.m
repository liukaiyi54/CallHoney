//
//  AddGestureViewController.m
//  CallHoney
//
//  Created by Michael on 04/05/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import "AddGestureViewController.h"
#import "TemplatesViewController.h"

#import "AddGestureView.h"
#import "DataModel.h"
#import "CRToast.h"
#import <ChameleonFramework/Chameleon.h>

#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@interface AddGestureViewController () <CNContactPickerDelegate>

@property (nonatomic, strong) AddGestureView *gestureView;

@end

@implementation AddGestureViewController

- (void)viewDidLoad {
    [self.view addSubview:self.gestureView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [button addTarget:self action:@selector(didTapContactButton:) forControlEvents:UIControlEventTouchUpInside];
    self.gestureView.textField.rightView = button;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"archive" style:UIBarButtonItemStylePlain target:self action:@selector(didTapRightButton:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)didTapRightButton:(id)sender {
    TemplatesViewController *vc = [[TemplatesViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didTapContactButton:(id)sender {
    CNContactPickerViewController *vc = [[CNContactPickerViewController alloc] init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - delegate
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    CNPhoneNumber *num = contact.phoneNumbers.firstObject.value;
    NSString *numStr = [num valueForKey:@"digits"];
    self.gestureView.textField.text = numStr;
}

#pragma mark - getter
- (AddGestureView *)gestureView {
    if (!_gestureView) {
        _gestureView = [[AddGestureView alloc] initWithFrame:CGRectMake(0, 80, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame))];
        _gestureView.addButtonBlock = ^(AddGestureView *view, Template *temp) {
            NSDictionary *options = @{
                                      kCRToastTextKey : @"添加成功",
                                      kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                      kCRToastBackgroundColorKey : [UIColor flatSkyBlueColor],
                                      kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                      kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                      kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                                      kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionBottom),
                                      kCRToastNotificationTypeKey: @(CRToastTypeNavigationBar),
                                      kCRToastNotificationPresentationTypeKey: @(CRToastPresentationTypeCover)
                                      };
            [CRToastManager showNotificationWithOptions:options
                                        completionBlock:nil];
            [[DataModel sharedInstance].templates setValue:temp forKey:temp.phoneNumber];
            [[DataModel sharedInstance] saveTemplates];
        };
    }
    return _gestureView;
}

@end
