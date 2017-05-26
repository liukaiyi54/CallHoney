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
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *downArrow;
@property (nonatomic, strong) UIImageView *rightArrow;

@end

@implementation AddGestureViewController

- (void)viewDidLoad {
    [self setupForDismissKeyboard];
    NSString *string = NSLocalizedString(@"Add gesture", nil);
    self.title = string;
    
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(19, 71, CGRectGetWidth(self.view.frame)-38, CGRectGetWidth(self.view.frame)-38)];
    dummyView.layer.cornerRadius = 8.0f;
    dummyView.layer.borderWidth = 1.0f;
    dummyView.layer.borderColor = [UIColor colorWithRed:0.51 green:0.85 blue:0.81 alpha:1].CGColor;
    [self.view addSubview:dummyView];
    
    [self.view addSubview:self.gestureView];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.downArrow];
    [self.view addSubview:self.addButton];
    [self.view addSubview:self.rightArrow];
    
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

- (IBAction)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didTapAddButton:(id)sender {
    if (!self.image) {
        NSString *string = NSLocalizedString(@"Draw a gesture pls", nil);
        [self showToastWithText:string color:[UIColor flatYellowColor] completionBlock:nil];
        return;
    }
    
    if (self.textField.text.length == 0) {
        NSString *string = NSLocalizedString(@"Add a contact number pls", nil);
        [self showToastWithText:string color:[UIColor flatYellowColor] completionBlock:nil];
        return;
    }
    
    if (self.textField.text.length > 0 && self.image) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.textField.text]];
        [UIImagePNGRepresentation(self.image) writeToFile:filePath atomically:YES];
        
        Template *template = [[Template alloc] init];
        template.phoneNumber = self.textField.text;
        template.imageName = [NSString stringWithFormat:@"%@.png", self.textField.text];
        template.points = self.points;
        
        [[DataModel sharedInstance].templates setValue:template forKey:template.phoneNumber];
        [[DataModel sharedInstance] saveTemplates];
        NSString *string = NSLocalizedString(@"Gesture added", nil);
        [self showToastWithText:string color:[UIColor flatSkyBlueColor] completionBlock:^{
            self.textField.text = @"";
            self.points = @[];
            self.image = nil;
            [self.gestureView resetView];
        }];
    }
}

- (void)showToastWithText:(NSString *)text color:(UIColor *)color completionBlock:(void (^)(void))completionBlock {
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
                              kCRToastTimeIntervalKey: @(1.0)
                              };
    [CRToastManager showNotificationWithOptions:options completionBlock:completionBlock];
}

#pragma mark - delegate
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    CNPhoneNumber *num = contact.phoneNumbers.firstObject.value;
    NSString *numStr = [num valueForKey:@"digits"];
    self.textField.text = numStr;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CGFloat extraPaddingForPlus = 0;
    if (CGRectGetHeight(self.view.frame) > 700) {
        extraPaddingForPlus = 10.0f;
    }
    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 216 + extraPaddingForPlus);
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
        _gestureView = [[AddGestureView alloc] initWithFrame:CGRectMake(22, 74, CGRectGetWidth(self.view.frame)-44, CGRectGetWidth(self.view.frame)-44)];
        __weak typeof(self) weakSelf = self;
        _gestureView.addCompletion = ^(AddGestureView *view, NSArray *points, UIImage *image) {
            weakSelf.points = points;
            weakSelf.image = image;
        };
    }
    return _gestureView;
}

- (UITextField *)textField {
    if (!_textField) {
        CGFloat extraPaddingForSE = 0;
        if (CGRectGetWidth(self.view.frame) == 320) {
            extraPaddingForSE = 20;
        }
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(self.gestureView.frame) + 60, 180 - extraPaddingForSE, 44)];
        _textField.keyboardType = UIKeyboardTypePhonePad;
        NSString *string = NSLocalizedString(@"Enter contact number", nil);
        _textField.placeholder = string;
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
        
        UILabel *label = [_textField valueForKey:@"_placeholderLabel"];
        label.adjustsFontSizeToFitWidth =YES;
    }
    return _textField;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) - 20 - 78, CGRectGetMaxY(self.gestureView.frame) + 60, 78, 44)];
        NSString *string = NSLocalizedString(@"OK", nil);
        [_addButton setTitle:string forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor colorWithRed:0.51 green:0.85 blue:0.81 alpha:1] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(didTapAddButton:) forControlEvents:UIControlEventTouchUpInside];
        _addButton.layer.borderColor = [UIColor colorWithRed:0.51 green:0.85 blue:0.81 alpha:1].CGColor;
        _addButton.layer.cornerRadius = 4.0f;
        _addButton.layer.borderWidth = 1.0f;
    }
    return _addButton;
}

- (UIImageView *)downArrow {
    if (!_downArrow) {
        _downArrow = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.textField.frame) - 20, CGRectGetMaxY(self.gestureView.frame) + 10, 38, 38)];
        _downArrow.image = [UIImage imageNamed:@"down_arrow"];
    }
    return _downArrow;
}

- (UIImageView *)rightArrow {
    if (!_rightArrow) {
        CGFloat x = (CGRectGetMinX(self.addButton.frame) - CGRectGetMaxX(self.textField.frame)) / 2 - 19 + CGRectGetMaxX(self.textField.frame);
        _rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(x, CGRectGetMidY(self.textField.frame) - 20, 38, 38)];
        _rightArrow.image = [UIImage imageNamed:@"right_arrow"];
    }
    return _rightArrow;
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
