//
//  AddGestureView.h
//  CallHoney
//
//  Created by Michael on 04/05/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "Template.h"

@class AddGestureView;
typedef void(^AddButtonBlock)(AddGestureView *view, Template *temp);

@interface AddGestureView : UIView

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, copy) AddButtonBlock addButtonBlock;

- (void)resetView;

@end
