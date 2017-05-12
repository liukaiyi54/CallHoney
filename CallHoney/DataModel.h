//
//  DataModel.h
//  CallHoney
//
//  Created by Michael on 26/04/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Template.h"

@interface DataModel : NSObject

@property (nonatomic, strong) NSMutableDictionary *templates;

+ (instancetype)sharedInstance;

- (void)saveTemplates;

@end
