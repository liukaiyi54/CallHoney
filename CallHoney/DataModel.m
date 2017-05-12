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
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.templates forKey:@"Templates"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)loadTemplates {
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.templates = [unarchiver decodeObjectForKey:@"Templates"];
        [unarchiver finishDecoding];
    } else {
        self.templates = [[NSMutableDictionary alloc] init];
    }
}

@end
