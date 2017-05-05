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

@property (nonatomic, strong) GestureView *gestureView;

@end

@implementation ViewController {
    DataModel *_dataModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.gestureView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _dataModel = [[DataModel alloc] init];
    self.gestureView.dataModel = _dataModel;
    if ([self.gestureView respondsToSelector:@selector(loadTemplates)]) {
        [self.gestureView loadTemplates];
    }
}

- (IBAction)didTapButton:(id)sender {
    AddGestureViewController *vc = [[AddGestureViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (GestureView *)gestureView {
    if (!_gestureView) {
        _gestureView = [[GestureView alloc] init];
        _gestureView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    }
    return _gestureView;
}

@end
