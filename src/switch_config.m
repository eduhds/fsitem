//
//  switch_config.m
//  fsitem
//
//  Created by Eduardo Henrique da Silva on 16/08/24.
//

#import <Foundation/Foundation.h>

#import "switch_config.h"

@implementation Target

@synthesize name;
@synthesize items;

@end

@implementation SwitchConfig

@synthesize target;
@synthesize config;
@synthesize current;

- (instancetype) initWithTarget: (Target *) t {
    self = [super init];
    target = t;
    config = [NSString stringWithFormat: @"%@%@", [t name], CONFIG_EXT];
    return self;
}

+ (BOOL) hasConfig {
    return [[NSFileManager defaultManager] fileExistsAtPath: CONFIG_DIR];
}

+ (BOOL) makeConfigDir {
    BOOL created = [[NSFileManager defaultManager] createDirectoryAtPath: CONFIG_DIR withIntermediateDirectories: YES attributes: nil error: nil];
    if (created) {
        NSString *path = [NSString stringWithFormat: @"%@/.gitignore", CONFIG_DIR];
        if ([[NSFileManager defaultManager] createFileAtPath: path contents: nil attributes: nil]) {
            NSString *content = @"*\n.*\n";
            [content writeToFile: path atomically: YES encoding: NSUTF8StringEncoding error: nil];
        }
    }
    return created;
}

- (BOOL) targetExists {
    return [[NSFileManager defaultManager] fileExistsAtPath: [target name]];
}

- (BOOL) targetIsDirectory {
    BOOL isDirectory = NO;
    return [[NSFileManager defaultManager] fileExistsAtPath: [target name] isDirectory: &isDirectory] && isDirectory;
}

- (BOOL) targetHasConfig {
    NSString *path = [NSString stringWithFormat: @"%@/%@", CONFIG_DIR, config];
    return [[NSFileManager defaultManager] fileExistsAtPath: path];
}

- (BOOL) makeTargetConfig {
    NSString *path = [NSString stringWithFormat: @"%@/%@", CONFIG_DIR, config];
    return [[NSFileManager defaultManager] copyItemAtPath: [target name] toPath: path error: nil];
}

- (BOOL) makeTargetItem: (NSString *) name {
    NSString *path = [NSString stringWithFormat: @"%@/%@|%@", CONFIG_DIR, name, [target name]];
    return [[NSFileManager defaultManager] copyItemAtPath: [target name] toPath: path error: nil];
}

- (NSArray *) getTargetItems {
    NSArray *items = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: CONFIG_DIR error: nil];

    NSMutableArray *filteredArray = [NSMutableArray array];

    /* for (NSString *item in items) {
        if ([item hasSuffix:[target name]]) {
            [filteredArray addObject:item];
        }
    } */

    for (NSString *item in items)
        if (![item isEqualTo: config] && ![item isEqualTo: @".gitignore"] && [item hasSuffix: [target name]]) {
            if ([item hasPrefix: @"!"]) {
                [self setCurrent: item];
            }
            [filteredArray addObject: item];
        }
    return filteredArray;
}

- (NSArray *) readItemContent: (NSString *) name {
    NSString *path = [NSString stringWithFormat: @"%@/%@", CONFIG_DIR, name];
    NSString *content = [NSString stringWithContentsOfFile: path encoding: NSUTF8StringEncoding error: nil];
    return [content componentsSeparatedByString: @"\n"];
}

- (BOOL) replaceItem: (int) selectedIndex {
    NSString *targetName = [target name];
    NSString *itemToReplace = [[self getTargetItems] objectAtIndex: selectedIndex];

    NSString *from = [NSString stringWithFormat: @"%@/%@", CONFIG_DIR, itemToReplace];
    NSString *new = [NSString stringWithFormat: @"%@/!%@", CONFIG_DIR, itemToReplace];
    NSString *to = [NSString stringWithFormat: @"%@", targetName];
    NSString *oldFrom = [NSString stringWithFormat: @"%@/%@", CONFIG_DIR, current];
    NSString *oldTo = [NSString stringWithFormat: @"%@/%@", CONFIG_DIR, [current substringFromIndex: 1]];

    if ([[NSFileManager defaultManager] removeItemAtPath: to error: nil]) {
        // Removed target file
        if ([[NSFileManager defaultManager] copyItemAtPath: from toPath: to error: nil]) {
            // Created new target file
            if ([[NSFileManager defaultManager] moveItemAtPath: from toPath: new error: nil]) {
                // Renamed new target item file
                if ([[NSFileManager defaultManager] moveItemAtPath: oldFrom toPath: oldTo error: nil]) {
                    // Renamed old target item file
                    [self setCurrent: [@"!%@" stringByAppendingString: itemToReplace]];
                    return YES;
                };
            }
        }
    }

    return NO;
}

@end
