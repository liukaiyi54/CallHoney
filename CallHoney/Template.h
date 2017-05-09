//
//  Template.h
//  CallHoney
//
//  Created by Michael on 08/05/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Template : NSObject<NSCoding>

@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSArray *points;
@property (nonatomic, copy) NSString *imageName;

@end
