//
//  KLGestureRecoginzer+ArchiveTemplates.m
//  CallHoney
//
//  Created by Michael on 04/05/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import "KLGestureRecoginzer+ArchiveTemplates.h"
#import "DataModel.h"

@implementation KLGestureRecoginzer (ArchiveTemplates)

- (void)loadTemplatesFromKeyedArchiver {
    DataModel *dataModel = [[DataModel alloc] init];
    self.templates = [dataModel.templates copy];
}

@end
