//
//  profile_manager.m
//  fsitem
//
//  Created by Eduardo Henrique on 06/06/22.
//

#import <Foundation/Foundation.h>
#import "profile_manager.h"

@implementation ProfileManager
- (id) init {
    self = [super init];
    fileManager = [[NSFileManager alloc] init];
    return self;
}

- (NSString *) currentPath {
    return [fileManager currentDirectoryPath];
}

- (void) deleteItem:(NSString *)path {
    [fileManager removeItemAtPath: path error: NULL];
}

- (bool) createLink:(NSString *)originPath destination:(NSString *)destinationPath {
    return [fileManager createSymbolicLinkAtPath: originPath withDestinationPath: destinationPath error: NULL];
}

- (void) listProfiles:(NSString *)path {
    NSArray *list = [fileManager contentsOfDirectoryAtPath:path error:nil];
    
    if ([list count] > 0) {
        printf("*** ALL SSH PROFILES ***\n");
        
        for (int i = 0; i < [list count]; i++) {
            NSString *profile = [list objectAtIndex: i];
            if (![profile isEqualTo: @".DS_Store"]) {
                printf("%d) %s\n", i + 1, [profile UTF8String]);
            }
        }
    } else {
        printf("*** NO SSH PROFILES ***\n");
    }
}

- (bool) isProfile:(NSString *)path argValue:(NSString *)value {
    NSArray *list = [fileManager contentsOfDirectoryAtPath: path error:nil];
    
    bool isProfile = NO;
    
    if ([list count] > 0) {
        for (int i = 0; i < [list count]; i++) {
            if ([value isEqualTo: [list objectAtIndex: i]]) {
                isProfile = YES;
            }
        }
    }
    
    return isProfile;
}

- (bool) createProfile:(NSString *)path {
    NSURL *dir = [NSURL fileURLWithPath: path];
    
    bool created = [fileManager createDirectoryAtURL:dir withIntermediateDirectories:YES attributes:nil error:nil];
    
    return created;
}
@end
