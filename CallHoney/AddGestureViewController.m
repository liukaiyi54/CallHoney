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

#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@interface AddGestureViewController () <CNContactPickerDelegate>

@property (nonatomic, strong) DataModel *dataModel;
@property (nonatomic, strong) AddGestureView *gestureView;

@end

@implementation AddGestureViewController

- (void)viewDidLoad {
    self.dataModel = [[DataModel alloc] init];
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
        _gestureView = [[AddGestureView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        _gestureView.dataModel = self.dataModel;
        __weak typeof(self) weakSelf = self;
        _gestureView.addButtonBlock = ^(AddGestureView *view, Template *temp) {
            [weakSelf.dataModel.templates addObject:temp];
            [weakSelf.dataModel saveTemplates];
        };
    }
    return _gestureView;
}

@end
