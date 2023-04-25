//
//  util.h
//  dot_ssh_switch
//
//  Created by Eduardo Henrique on 09/04/23.
//

#ifndef util_h
#define util_h


#endif /* util_h */

#import <Foundation/Foundation.h>

@interface Util : NSObject {
    NSFileManager *fileManager;
}

- (NSString*) getHomePath;

- (bool) pathExists: (NSString*) path;

- (bool) pathIsDirectory: (NSString*) path;

- (NSString *) currentPath;

- (bool) deleteItem: (NSString *) path;

- (bool) createLink: (NSString *) originPath destination: (NSString *) destinationPath;

- (bool) createDirectory: (NSString*) path;

- (NSArray*) getDirectoryContent: (NSString*) path;

- (bool) moveItem: (NSString*)fromPath toPath: (NSString*) newPath;

- (bool) copyItem: (NSString*)fromPath toPath: (NSString*) copyPath;

- (NSString*) getDateString;

@end
