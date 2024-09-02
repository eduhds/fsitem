//
//  switch_config.h
//
//  Created by Eduardo Henrique da Silva on 16/08/24.
//

#ifndef switch_config_h
#define switch_config_h

#import <Foundation/Foundation.h>

#define CONFIG_DIR @".switch-config"
#define CONFIG_EXT @".switch-config"

@interface Target : NSObject {
    NSString *name;
    NSArray *items;
    NSString *current;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, retain) NSString *current;

@end

@interface SwitchConfig : NSObject {
    Target *target;
    NSString *config;
    NSError *lastError;
}

@property (nonatomic, retain) Target *target;
@property (nonatomic, retain) NSString *config;
@property (nonatomic, retain) NSError *lastError;

- (instancetype) initWithTarget: (Target *) t;

+ (BOOL) hasConfig;
- (BOOL) makeConfigDir;

- (BOOL) targetExists;
- (BOOL) targetIsDirectory;
- (BOOL) targetHasConfig;
- (BOOL) makeTargetConfig;
- (BOOL) makeTargetItem: (NSString *) name;
- (NSArray *) getTargetItems;
- (NSArray *) readItemContent: (NSString *) name;
- (BOOL) replaceItem: (int) selectedIndex;

@end

#endif /* switch_config_h */
