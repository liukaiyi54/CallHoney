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
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, copy) NSArray *points;
@property (nonatomic, strong) Template *template;

@end

@implementation AddGestureViewController

- (void)viewDidLoad {
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(19, 119, CGRectGetWidth(self.view.frame)-38, CGRectGetWidth(self.view.frame)-38)];
    dummyView.layer.cornerRadius = 4.0f;
    dummyView.layer.borderColor = [UIColor colorWithRed:0.51 green:0.85 blue:0.81 alpha:1].CGColor;
    dummyView.layer.borderWidth = 2.0f;
    [self.view addSubview:dummyView];
    
    [self.view addSubview:self.gestureView];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.addButton];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [button addTarget:self action:@selector(didTapContactButton:) forControlEvents:UIControlEventTouchUpInside];
    self.textField.rightView = button;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor flatWhiteColor]}];
    [self.navigationController setHidesNavigationBarHairline:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor flatMintColor];
    self.navigationController.navigationBar.tintColor = [UIColor flatWhiteColor];
}

- (void)didTapContactButton:(id)sender {
    CNContactPickerViewController *vc = [[CNContactPickerViewController alloc] init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didTapAddButton:(id)sender {
    if (self.template.phoneNumber.length > 0 && self.template.points && self.template.imageName.length > 0) {
        [[DataModel sharedInstance].templates setValue:self.template forKey:self.template.phoneNumber];
        [[DataModel sharedInstance] saveTemplates];
        
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
        [CRToastManager showNotificationWithOptions:options completionBlock:nil];
        
        self.textField.text = @"";
        [self.gestureView resetView];
    }
}

#pragma mark - delegate
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    CNPhoneNumber *num = contact.phoneNumbers.firstObject.value;
    NSString *numStr = [num valueForKey:@"digits"];
    self.textField.text = numStr;
}

#pragma mark - getter
- (AddGestureView *)gestureView {
    if (!_gestureView) {
        _gestureView = [[AddGestureView alloc] initWithFrame:CGRectMake(20, 120, CGRectGetWidth(self.view.frame)-40, CGRectGetWidth(self.view.frame)-40)];

        __weak typeof(self) weakSelf = self;
        _gestureView.addCompletion = ^(AddGestureView *view, NSArray *points, UIImage *image) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", weakSelf.textField.text]];
            [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
            
            weakSelf.template = [[Template alloc] init];
            weakSelf.template.phoneNumber = weakSelf.textField.text;
            weakSelf.template.points = points;
            weakSelf.template.imageName = [NSString stringWithFormat:@"%@.png", weakSelf.textField.text];
        };
    }
    return _gestureView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2 - 100, 76, 200, 34)];
        _textField.keyboardType = UIKeyboardTypePhonePad;
        _textField.placeholder = @"输入联系人号码";
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _textField;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2 - 30, CGRectGetHeight(self.view.frame) - 120, 60, 40)];
        [_addButton setTitle:@"添加" forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor flatSkyBlueColor] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(didTapAddButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

@end
