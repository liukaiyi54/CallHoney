//
//  Template.m
//  CallHoney
//
//  Created by Michael on 08/05/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import "Template.h"

static NSString *const kPhoneNumber = @"phoneNumber";
static NSString *const kPoints = @"points";
static NSString *const kImageName = @"imageName";

@implementation Template

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.phoneNumber = [aDecoder decodeObjectForKey:kPhoneNumber];
        self.points = [aDecoder decodeObjectForKey:kPoints];
        self.imageName = [aDecoder decodeObjectForKey:kImageName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_phoneNumber forKey:kPhoneNumber];
    [aCoder encodeObject:_points forKey:kPoints];
    [aCoder encodeObject:_imageName forKey:kImageName];
}

@end
