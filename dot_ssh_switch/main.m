//
//  main.m
//  dot_ssh_switch
//
//  Created by Eduardo Henrique on 05/06/22.
//

#import <Foundation/Foundation.h>
#import "profile_manager.h"

#define OPT_LIST @"list"
#define SSH_PROFILE_FOLDER @"/ssh_profiles"
#define SSH_FOLDER @".ssh"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc == 1) {
            printf("*** NO ARGUMENTS ***\n");
            printf("Use `list` argument to see all profiles or the profile name to change to it.\n");
        } else {
            ProfileManager *pManager = [[ProfileManager alloc] init];

            NSString *currentPath = [pManager currentPath];
            NSString *profilesPath = [currentPath stringByAppendingString: SSH_PROFILE_FOLDER];
            
            NSString *arg1 = [NSString stringWithUTF8String: argv[1]];
         
            if ([arg1 isEqualTo: OPT_LIST]) {
                // List SSH Profiles
                [pManager listProfiles: profilesPath];
            } else {
                NSString *profileFolder = [profilesPath stringByAppendingString: [@"/" stringByAppendingString: arg1]];
                
                if (![pManager isProfile: profilesPath argValue: arg1]) {
                    // Profile not exists
                    char create;
                    
                    printf("*** PROFILE NOT FOUND ***\n");
                    printf("Create new profile? (y/N)");
                    scanf("%c", &create);
                    
                    // Create new profile
                    if (create == 'y' || create == 'Y') {
                        [pManager deleteItem: SSH_FOLDER];
                        
                        NSString *profileName = [@"/" stringByAppendingString: arg1];
                        
                        bool createSuccess = [pManager createProfile: [profilesPath stringByAppendingString: profileName]];
                        [pManager deleteItem: SSH_FOLDER];
                        
                        bool changedSuccess = [pManager createLink: SSH_FOLDER destination: profileFolder];
                        
                        if (createSuccess && changedSuccess) {
                            printf("*** NEW PROFILE CREATED ***\n");
                        } else {
                            printf("*** CREATE FAILED ***\n");
                        }
                    }
                } else {
                    // Profile exists, change to it
                    [pManager deleteItem: SSH_FOLDER];
                    
                    bool created = [pManager createLink: SSH_FOLDER destination: profileFolder];
                    
                    if (created) {
                        printf("*** PROFILE CHANGED ***\n");
                    } else {
                        printf("*** CHANGE FAILED ***\n");
                    }
                }
            }
        }
    }
    return 0;
}
