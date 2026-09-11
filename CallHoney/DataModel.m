//
//  DataModel.m
//  CallHoney
//
//  Created by Michael on 26/04/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

static id _instance;

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        [self loadTemplates];
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"IllegalAccessException" reason:@"Use `+ (instancetype)sharedManager` instead" userInfo:nil];
}

+ (instancetype)sharedInstance {
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] initPrivate];
        }
    }
    return _instance;
}

- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths.firstObject;
    return documentsDirectory;
}

- (NSString *)dataFilePath {
    return [[self documentsDirectory] stringByAppendingPathComponent:@"Templates.plist"];
}

- (void)saveTemplates {
    NSError *error = nil;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.templates
                                         requiringSecureCoding:YES
                                                         error:&error];
    if (!data || ![data writeToFile:[self dataFilePath] options:NSDataWritingAtomic error:&error]) {
        NSLog(@"Unable to save templates: %@", error);
    }
}

- (void)loadTemplates {
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSSet *classes = [NSSet setWithObjects:[NSDictionary class], [NSMutableDictionary class],
                          [NSString class], [Template class], [NSArray class], [NSMutableArray class],
                          [NSValue class], nil];
        NSError *error = nil;
        NSDictionary *templates = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes
                                                                        fromData:data
                                                                           error:&error];
        if (!templates) {
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:&error];
            unarchiver.requiresSecureCoding = YES;
            templates = [unarchiver decodeObjectOfClasses:classes forKey:@"Templates"];
            [unarchiver finishDecoding];
        }
        self.templates = [templates isKindOfClass:[NSDictionary class]] ? [templates mutableCopy] : [NSMutableDictionary dictionary];
        if (error) {
            NSLog(@"Unable to load templates: %@", error);
        }
    } else {
        self.templates = [[NSMutableDictionary alloc] init];
    }
}

@end
