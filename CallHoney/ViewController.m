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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController {
    DataModel *_dataModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _dataModel = [[DataModel alloc] init];
    GestureView *gestureView = [[GestureView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    gestureView.dataModel = _dataModel;
    [self.view addSubview:gestureView];
    
    [gestureView addSubview:self.button];
}

- (IBAction)didTapButton:(id)sender {
    AddGestureViewController *vc = [[AddGestureViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
