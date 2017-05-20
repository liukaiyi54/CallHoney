//
//  GestureView.h
//  CallHoney
//
//  Created by Michael on 24/04/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@class GestureView;
typedef void(^GestureViewBlock)(GestureView *view, float score, NSString *phoneNum);

@interface GestureView : UIView

@property (nonatomic, copy) GestureViewBlock gestureViewBlock;

- (void)loadTemplates;

@end
