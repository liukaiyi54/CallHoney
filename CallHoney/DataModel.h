//
//  DataModel.h
//  CallHoney
//
//  Created by Michael on 26/04/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (nonatomic, strong) NSMutableArray *templates;

- (void)saveTemplates;

@end
