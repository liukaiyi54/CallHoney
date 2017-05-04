//
//  AddGestureViewController.m
//  CallHoney
//
//  Created by Michael on 04/05/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import "AddGestureViewController.h"
#import "GestureView.h"
#import "DataModel.h"

@interface AddGestureViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) DataModel *dataModel;

@end

@implementation AddGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataModel = [[DataModel alloc] init];
    
    GestureView *gestureView = [[GestureView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    gestureView.dataModel = self.dataModel;
    gestureView.isAddingProcess = YES;
    [self.view addSubview:gestureView];
}

@end
