//
//  argparse.h
//
//  Created by Eduardo Henrique on 14/08/24.
//

#ifndef argparse_h
#define argparse_h

#import <Foundation/Foundation.h>

@interface Argparse : NSObject {
    NSString *appName;
    NSString *appVersion;
    NSString *appDescription;
    NSArray *arguments;
}

- (instancetype) initWithName: (NSString *) name withVersion: (NSString *) version withDescription: (NSString *) description;

- (BOOL) parse: (int) argc withArgv: (const char *[]) argv;

- (NSString *) argAtIndex: (int) index;

@end

@implementation Argparse

- (instancetype) initWithName: (NSString *) name withVersion: (NSString *) version withDescription: (NSString *) description {
    self = [super init];
    if (self) {
        appName = name;
        appVersion = version;
        appDescription = description;
        arguments = [[NSArray alloc] init];
    }
    return self;
}

- (BOOL) parse: (int) argc withArgv: (const char *[]) argv {
    /* TODO: if (argc < 2) {
        printf("No arguments.\n");
        return NO;
    } */
    
    for (int i = 1; i < argc; i++) {
        NSString *arg = [NSString stringWithUTF8String: argv[i]];
        arguments = [arguments arrayByAddingObject: arg];
    }

    return YES;
}

- (NSString *) argAtIndex: (int) index {
    return (int)[arguments count] > index ? [arguments objectAtIndex: index] : nil;
}

@end

#endif /* argparse_h */
