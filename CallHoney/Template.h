//
//  Template.h
//  CallHoney
//
//  Created by Michael on 08/05/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Template : NSObject<NSSecureCoding>

@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSArray<NSValue *> *points;
@property (nonatomic, copy) NSString *imageName;

@end
