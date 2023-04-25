//
//  util.m
//  dot_ssh_switch
//
//  Created by Eduardo Henrique on 09/04/23.
//

#import <Foundation/Foundation.h>
#import "util.h"

@implementation Util

- (id) init {
    self = [super init];
    fileManager = [[NSFileManager alloc] init];
    return self;
}

- (NSString *)getHomePath {
    NSString *home = @(getenv("HOME"));
    return home;
}

- (bool)pathExists:(NSString *)path {
    return [fileManager fileExistsAtPath:path];
}

- (bool)pathIsDirectory:(NSString *)path {
    BOOL isDirectory = NO;
    return [fileManager fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory;
}

- (NSString *) currentPath {
    return [fileManager currentDirectoryPath];
}

- (bool) deleteItem:(NSString *)path {
    return [fileManager removeItemAtPath: path error: NULL];
}

- (bool) createLink:(NSString *)originPath destination:(NSString *)destinationPath {
    return [fileManager createSymbolicLinkAtPath: originPath withDestinationPath: destinationPath error: NULL];
}

- (bool)createDirectory:(NSString *)path {
    NSURL *dir = [NSURL fileURLWithPath: path];
    bool created = [fileManager createDirectoryAtURL:dir withIntermediateDirectories:YES attributes:nil error:nil];
    return created;
}

- (NSArray *)getDirectoryContent:(NSString *)path {
    NSArray *directoryContent = [fileManager contentsOfDirectoryAtPath: path error:nil];
    return directoryContent;
}

-(bool)moveItem:(NSString *)fromPath toPath:(NSString *)newPath {
    NSURL *fromUrl = [NSURL fileURLWithPath:fromPath];
    NSURL *toUrl = [NSURL fileURLWithPath:newPath];
    
    bool moved = [fileManager moveItemAtURL:fromUrl toURL:toUrl error:NULL];
    return moved;
}

-(bool)copyItem:(NSString *)fromPath toPath:(NSString *)copyPath {
    bool copied = [fileManager copyItemAtPath:fromPath toPath:copyPath error:NULL];
    return copied;
}

-(NSString *)getDateString {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [dateFormatter stringFromDate:[NSDate date]];
    return [[date stringByReplacingOccurrencesOfString:@" " withString:@"_"] stringByReplacingOccurrencesOfString:@":" withString:@"-"];
}

@end
