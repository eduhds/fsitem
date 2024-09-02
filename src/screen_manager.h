//
//  screen_manager.h
//
//  Created by Eduardo Henrique on 16/08/24.
//

#ifndef screen_manager_h
#define screen_manager_h

#import <Foundation/Foundation.h>

#import "switch_config.h"

#define AREAS 2
#define AREA_1 1
#define AREA_2 2

@interface ScreenManager : NSObject {
    int width; // int _width;
    int height; // int _height;
    int focusIndex;
    int selectedIndex;
    Target *target;
    NSString *title;
    NSArray *content;
    NSString *typed;
    NSString *message;
    NSNumber *areaFocus;
    BOOL alertVisible;
    BOOL alertCancelFocus;
    BOOL success;
}

@property (nonatomic) int width; // Number of characters
@property (nonatomic) int height; // Number of lines
@property (nonatomic) int focusIndex;
@property (nonatomic) int selectedIndex;
@property (nonatomic, retain) Target *target;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSArray *content;
@property (nonatomic, retain) NSString *typed;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSNumber *areaFocus;
@property (nonatomic) BOOL alertVisible;
@property (nonatomic) BOOL alertCancelFocus;
@property (nonatomic) BOOL success;

- (void) printScreen;

- (void) printAlert: (NSString *) aMessage;

- (void) setStatus: (NSString *) aMessage success: (BOOL) status;

@end

#endif /* screen_manager_h */
