//
//  main.m
//
//  Created by Eduardo Henrique on 05/06/22.
//

#import <Foundation/Foundation.h>

#import "libs/termbox2.h"
#import "argparse.h"
#import "screen_manager.h"
#import "switch_config.h"

#define APP_NAME @"Switch-Config"
#define APP_VERSION @"1.0.0"
#define APP_DESCRIPTION @"Switch-Config"

int main(int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    Argparse *argparse = [[Argparse alloc] initWithName: APP_NAME withVersion: APP_VERSION withDescription: APP_DESCRIPTION];
    
    BOOL argsOk = [argparse parse: argc withArgv: argv];
    
    if (!argsOk) {
        exit(1);
    }
    
    Target *target = [[Target alloc] init];
    [target setName: [argparse argAtIndex: 0]];
    
    SwitchConfig *switchConfig = [[SwitchConfig alloc] initWithTarget: target];

    if ([switchConfig targetExists]) {
        if ([switchConfig targetIsDirectory]) {
            printf("Directory is not supported.\n");
            exit(1);
        }
    } else {
        printf("Target file not found.\n");
        exit(1);
    }

    BOOL hasConfig = NO;
    BOOL hasItems = NO;
    
    if ([switchConfig targetHasConfig]) {
        NSArray *items = [switchConfig getTargetItems];
        [target setItems: items];
        hasConfig = YES;
        hasItems = [items count] > 0;
    }

    struct tb_event ev;
    
    tb_init();

    ScreenManager *sm = [[ScreenManager alloc] init];
    [sm setTitle: APP_NAME];
    [sm setWidth: tb_width()];
    [sm setHeight: tb_height()];
    [sm setTarget: target];
    
    if (hasItems) {
        [sm setContent: [switchConfig readItemContent: [[target items] objectAtIndex: 0]]];
    }
    
    [sm printScreen];

    NSString *alertMessage = @"";

    while (true) {
        tb_poll_event(&ev);
        
        // Exit on ESC or Ctrl+C
        if (ev.key == TB_KEY_ESC || ev.key == TB_KEY_CTRL_C) {
            tb_shutdown();
            break;
        }
        
        // Resize window
        if (ev.type == TB_EVENT_RESIZE) {
            [sm setWidth: ev.w];
            [sm setHeight: ev.h];
        }
        
        // Alert visible
        if ([sm alertVisible]) {
            if (ev.key == TB_KEY_TAB || ev.key == TB_KEY_ARROW_LEFT || ev.key == TB_KEY_ARROW_RIGHT) {
                [sm setAlertCancelFocus: ![sm alertCancelFocus]];
            }
            
            if (ev.key == TB_KEY_ENTER) {
                if ([sm alertCancelFocus] == NO) {
                    if ([sm areaFocus] == [NSNumber numberWithInt: AREA_1]) { // Switch target item
                        if ([switchConfig replaceItem: [sm selectedIndex]]) {
                            [target setItems: [switchConfig getTargetItems]];
                            [sm setTarget: target];
                            [sm setFocusIndex: 0];
                            [sm setSelectedIndex: -1];
                        } else {
                            [sm setMessage: @"Item não foi trocado"];
                        }
                    } else { // Create target item
                        if (!hasConfig) {
                            hasConfig = [SwitchConfig makeConfigDir] && [switchConfig makeTargetConfig];
                        }

                        if (hasConfig && [switchConfig makeTargetItem: [sm typed]]) {
                            [sm setMessage: [NSString stringWithFormat: @"\"%@\" criado com sucesso", [sm typed]]];
                            [sm setTyped: @""];
                            [sm setAreaFocus: [NSNumber numberWithInt: AREA_1]];
                            [sm setFocusIndex: 0];
                            [target setItems: [switchConfig getTargetItems]];
                            [sm setTarget: target];
                            [sm setContent: [switchConfig readItemContent: [[target items] objectAtIndex: 0]]];
                            hasItems = YES;
                        } else {
                            [sm setMessage: @"Item não foi criado"];
                        }
                    }
                }
                
                [sm setAlertVisible: NO];
                [sm setAlertCancelFocus: YES];
                alertMessage = @"";
            }
        } else {
            // Tab pressed
            if (ev.key == TB_KEY_TAB) {
                int area = [[sm areaFocus] intValue];
                area = area < AREAS ? area + 1 : AREA_1;
                [sm setAreaFocus: [NSNumber numberWithInt: area]];
                [sm setSelectedIndex: -1];
            }
            
            if ([[sm areaFocus] intValue] == AREA_1) {
                // Move focus
                if (ev.key == TB_KEY_ARROW_UP || ev.key == TB_KEY_ARROW_DOWN) {
                    int currentIndex = [sm focusIndex];
                    int totalItems = (int)[[target items] count];
                    BOOL toDown = ev.key == TB_KEY_ARROW_DOWN;
                    int value = toDown
                            ? currentIndex < totalItems - 1 ? currentIndex + 1 : 0
                            : currentIndex > 0 ? currentIndex - 1 : totalItems - 1;
                    [sm setFocusIndex: value];
                    [sm setContent: [switchConfig readItemContent: [[target items] objectAtIndex: value]]];
                }

                BOOL isCurrentFocused = [[[target items] objectAtIndex: [sm focusIndex]] isEqualTo: [switchConfig current]];

                // Select item
                if (ev.ch == TB_KEY_SPACE) {
                    if (isCurrentFocused) {
                        [sm setMessage: @"Target already selected"];
                    } else {
                        [sm setSelectedIndex: [sm selectedIndex] == [sm focusIndex] ? -1 : [sm focusIndex]];
                    }
                }

                // Enter
                if (ev.key == TB_KEY_ENTER) {
                    if (isCurrentFocused) {
                        [sm setMessage: @"Target already selected"];
                    } else if ([sm selectedIndex] != -1) {
                        [sm setAlertVisible: YES];
                        alertMessage = @"Switch current config?";
                    } else {
                        [sm setMessage: @"Select a item first"];
                    }
                }
            }

            if ([[sm areaFocus] intValue] == AREA_2) {
                // Type
                if (ev.key == 0 && ev.ch != 0) {
                    [sm setTyped: [[sm typed] stringByAppendingString: [NSString stringWithFormat: @"%c", ev.ch]]];
                }

                // Delete
                if (ev.key == TB_KEY_BACKSPACE || ev.key == TB_KEY_BACKSPACE2) {
                    if ([[sm typed] length] > 0) {
                        [sm setTyped: [[sm typed] substringToIndex: [[sm typed] length] - 1]];
                    }
                }
                
                // Enter
                if (ev.key == TB_KEY_ENTER) {
                    // TODO: validar typed
                    if ([[sm typed] length] > 0) {
                        [sm setAlertVisible: YES];
                        alertMessage = [NSString stringWithFormat: @"Criar \"%@\"?", [sm typed]];
                    } else {
                        [sm setMessage: @"Type something first"];
                    }
                }
            }
        }
        
        [sm printScreen];
        
        if ([sm alertVisible]) {
            [sm printAlert: alertMessage];
        }
    }

    [pool drain];

    return 0;
}
