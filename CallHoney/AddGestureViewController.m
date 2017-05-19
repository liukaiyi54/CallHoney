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

@interface AddGestureViewController () <CNContactPickerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) AddGestureView *gestureView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, copy) NSArray *points;
@property (nonatomic, strong) Template *template;

@end

@implementation AddGestureViewController

- (void)viewDidLoad {
    self.template = [[Template alloc] init];
    
    [self setupForDismissKeyboard];
    
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(19, 99, CGRectGetWidth(self.view.frame)-38, CGRectGetWidth(self.view.frame)-38)];
    dummyView.layer.cornerRadius = 8.0f;
    dummyView.backgroundColor = [UIColor colorWithRed:0.51 green:0.85 blue:0.81 alpha:1];
    [self.view addSubview:dummyView];
    
    [self.view addSubview:self.gestureView];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.addButton];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor flatWhiteColor]}];
    [self.navigationController setHidesNavigationBarHairline:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor flatMintColor];
    self.navigationController.navigationBar.tintColor = [UIColor flatWhiteColor];
}

#pragma mark - event handler
- (void)didTapContactButton:(id)sender {
    CNContactPickerViewController *vc = [[CNContactPickerViewController alloc] init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didTapAddButton:(id)sender {
    if (!self.template.points) {
        [self showToastWithText:@"添加个手势先" color:[UIColor flatYellowColor]];
        return;
    }
    
    if (self.textField.text.length == 0) {
        [self showToastWithText:@"添加个手机先" color:[UIColor flatYellowColor]];
        return;
    }
    
    if (self.textField.text.length > 0 && self.template.points) {
        self.template.phoneNumber = self.textField.text;
        [[DataModel sharedInstance].templates setValue:self.template forKey:self.template.phoneNumber];
        [[DataModel sharedInstance] saveTemplates];
        [self showToastWithText:@"添加成功" color: [UIColor flatSkyBlueColor]];

        self.textField.text = @"";
        [self.gestureView resetView];
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
                              kCRToastNotificationPresentationTypeKey: @(CRToastPresentationTypeCover)
                              };
    [CRToastManager showNotificationWithOptions:options completionBlock:nil];
}

#pragma mark - delegate
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    CNPhoneNumber *num = contact.phoneNumbers.firstObject.value;
    NSString *numStr = [num valueForKey:@"digits"];
    self.textField.text = numStr;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 216);
    if (offset <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
    return YES;
}

#pragma mark - getter
- (AddGestureView *)gestureView {
    if (!_gestureView) {
        _gestureView = [[AddGestureView alloc] initWithFrame:CGRectMake(23, 103, CGRectGetWidth(self.view.frame)-44, CGRectGetWidth(self.view.frame)-44)];

        __weak typeof(self) weakSelf = self;
        _gestureView.addCompletion = ^(AddGestureView *view, NSArray *points, UIImage *image) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", weakSelf.textField.text]];
            [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
            
            weakSelf.template.points = points;
            weakSelf.template.imageName = [NSString stringWithFormat:@"%@.png", weakSelf.textField.text];
        };
    }
    return _gestureView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(self.gestureView.frame) + 20, 200, 44)];
        _textField.keyboardType = UIKeyboardTypePhonePad;
        _textField.placeholder = @"输入联系人号码";
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.rightViewMode = UITextFieldViewModeAlways;
        _textField.delegate = self;
        _textField.layer.borderColor = [UIColor colorWithRed:0.51 green:0.85 blue:0.81 alpha:1].CGColor;
        _textField.layer.borderWidth = 1.0f;
        _textField.layer.cornerRadius = 4.0f;
        
        UIButton*button = [[UIButton alloc] init];
        [button setFrame:CGRectMake(0, 0, 22, 22)];
        [button setImage:[UIImage imageNamed:@"phone-book"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didTapContactButton:) forControlEvents:UIControlEventTouchUpInside];
        _textField.rightView = button;
    }
    return _textField;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.textField.frame) + 32, CGRectGetMaxY(self.gestureView.frame) + 20, 60, 44)];
        [_addButton setTitle:@"添加" forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor colorWithRed:0.51 green:0.85 blue:0.81 alpha:1] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(didTapAddButton:) forControlEvents:UIControlEventTouchUpInside];
        _addButton.layer.borderColor = [UIColor colorWithRed:0.51 green:0.85 blue:0.81 alpha:1].CGColor;
        _addButton.layer.cornerRadius = 4.0f;
        _addButton.layer.borderWidth = 1.0f;
    }
    return _addButton;
}

#pragma mark - private
- (void)setupForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    
    __weak typeof(self) weakSelf = self;
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [weakSelf.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [weakSelf.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
    [self.navigationItem.titleView endEditing:YES];
}

@end
