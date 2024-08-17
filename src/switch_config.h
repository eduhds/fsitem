//
//  switch_config.h
//  fsitem
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
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *items;

@end

@interface SwitchConfig : NSObject

+ (BOOL) hasConfig;
+ (BOOL) makeConfigDir;

+ (BOOL) targetExists: (Target *) t;
+ (BOOL) targetIsDirectory: (Target *) t;
+ (BOOL) targetHasConfig: (Target *) t;
+ (BOOL) makeTargetConfig: (Target *) t;
+ (BOOL) makeTargetItem: (Target *) t withName: (NSString *) name;

@end

#endif /* switch_config_h */
