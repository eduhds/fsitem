//
//  profile_manager.h
//  fsitem
//
//  Created by Eduardo Henrique on 06/06/22.
//

#ifndef profile_manager_h
#define profile_manager_h


#endif /* profile_manager_h */

#import <Foundation/Foundation.h>

@interface ProfileManager : NSObject {
    NSFileManager *fileManager;
}
- (NSString *) currentPath;
- (void) deleteItem: (NSString *) path;
- (bool) createLink: (NSString *) originPath destination: (NSString *) destinationPath;
- (void) listProfiles: (NSString *) path;
- (bool) isProfile: (NSString *) path argValue: (NSString *) value;
- (bool) createProfile: (NSString *) path;
@end
