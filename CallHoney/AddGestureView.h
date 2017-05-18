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
typedef void (^AddGestureViewCompletion)(AddGestureView *view, NSArray *points, UIImage *image);

@interface AddGestureView : UIView

@property (nonatomic, copy) AddGestureViewCompletion addCompletion;

- (void)resetView;

@end
