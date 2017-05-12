//
//  KLGestureRecoginzer+ArchiveTemplates.m
//  CallHoney
//
//  Created by Michael on 04/05/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import "KLGestureRecoginzer+ArchiveTemplates.h"
#import "DataModel.h"
#import "Template.h"

@implementation KLGestureRecoginzer (ArchiveTemplates)

- (void)loadTemplatesFromKeyedArchiver {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [[DataModel sharedInstance].templates enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        Template *template = (Template *)obj;
        [dict setValue:template.points forKey:key];
    }];
    self.templates = [dict copy];
}

@end
