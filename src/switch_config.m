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

- (id) init {
    self = [super init];
    return self;
}

+ (BOOL) hasConfig {
    return [[NSFileManager defaultManager] fileExistsAtPath: CONFIG_DIR];
}

+ (BOOL) makeConfigDir {
    return [[NSFileManager defaultManager] createDirectoryAtPath: CONFIG_DIR withIntermediateDirectories: YES attributes: nil error: nil];
}

+ (BOOL) targetExists: (Target *) t {
    return [[NSFileManager defaultManager] fileExistsAtPath: [t name]];
}

+ (BOOL) targetIsDirectory: (Target *) t {
    BOOL isDirectory = NO;
    return [[NSFileManager defaultManager] fileExistsAtPath: [t name] isDirectory: &isDirectory] && isDirectory;
}

+ (BOOL) targetHasConfig: (Target *) t {
    NSString *path = [NSString stringWithFormat: @"%@/%@%@", CONFIG_DIR, [t name], CONFIG_EXT];
    return [[NSFileManager defaultManager] fileExistsAtPath: path];
}

+ (BOOL) makeTargetConfig: (Target *) t {
    NSString *path = [NSString stringWithFormat: @"%@/%@%@", CONFIG_DIR, [t name], CONFIG_EXT];
    return [[NSFileManager defaultManager] createFileAtPath: path contents: nil attributes: nil];
}

+ (BOOL) makeTargetItem: (Target *) t withName: (NSString *) name {
    NSString *path = [NSString stringWithFormat: @"%@/%@.%@", CONFIG_DIR, name, [t name]];
    return [[NSFileManager defaultManager] createFileAtPath: path contents: nil attributes: nil];
}

@end
