//
//  screen_manager.h
//  fsitem
//
//  Created by Eduardo Henrique da Silva on 16/08/24.
//

#ifndef screen_manager_h
#define screen_manager_h

#import <Foundation/Foundation.h>

#import "switch_config.h"

#define AREAS 3

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

- (void) printScreen;

@end

#endif /* screen_manager_h */
