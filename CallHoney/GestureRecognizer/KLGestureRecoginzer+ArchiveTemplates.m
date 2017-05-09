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
    DataModel *dataModel = [[DataModel alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dataModel.templates enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Template *template = (Template *)obj;
        [dict setValue:template.points forKey:template.phoneNumber];
    }];
    self.templates = [dict copy];
}

@end
