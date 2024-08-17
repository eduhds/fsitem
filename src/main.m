//
//  main.m
//  fsitem
//
//  Created by Eduardo Henrique on 05/06/22.
//

#import <Foundation/Foundation.h>

#import "libs/termbox2.h"
#import "argparse.h"
#import "fs_item.h"
#import "util.h"
#import "screen_manager.h"
#import "switch_config.h"

#define APP_NAME @"fsitem"
#define APP_VERSION @"1.0.0"
#define APP_DESCRIPTION @"fsitem"

int main(int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    Argparse *argparse = [[Argparse alloc] initWithName: APP_NAME withVersion: APP_VERSION withDescription: APP_DESCRIPTION];
    
    BOOL argsOk = [argparse parse: argc withArgv: argv];
    
    if (!argsOk) {
        exit(1);
    }
    
    Target *target = [[Target alloc] init];
    [target setName: [argparse argAtIndex: 0]];

    if ([SwitchConfig targetExists: target]) {
        if ([SwitchConfig targetIsDirectory: target]) {
            printf("Directory is not supported.\n");
            exit(1);
        }
    } else {
        printf("Target file not found.\n");
        exit(1);
    }

    NSArray *exampleItems = [[NSArray alloc] initWithObjects: @"Lorem ipsum 1", @"Lorem ipsum 2", @"Lorem ipsum 3", nil];
    BOOL hasConfig = NO;
    
    if ([SwitchConfig targetHasConfig: target]) {
        // TODO: Listar items
        [target setItems: exampleItems];
        hasConfig = YES;
    }

    struct tb_event ev;
    
    tb_init();

    ScreenManager *sm = [[ScreenManager alloc] init];
    [sm setTitle: APP_NAME];
    [sm setWidth: tb_width()];
    [sm setHeight: tb_height()];
    [sm setTarget: target];
    
    [sm printScreen];

    while (true) {
        tb_poll_event(&ev);
        
        // Exit on ESC or Ctrl+C
        if (ev.key == TB_KEY_ESC || ev.key == TB_KEY_CTRL_C) {
            tb_shutdown();
            break;
        }
        
        // Resize window
        if (ev.type == TB_EVENT_RESIZE) {
            [sm setWidth:ev.w];
            [sm setHeight:ev.h];
        }

        // Tab pressed
        if (ev.key == TB_KEY_TAB) {
            [sm setAreaFocus: [[sm areaFocus] intValue] == 0 ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0]];
        }
        
        if ([[sm areaFocus] intValue] == 0) {
            // Move focus
            if (ev.key == TB_KEY_ARROW_UP || ev.key == TB_KEY_ARROW_DOWN) {
                int currentIndex = [sm focusIndex];
                int totalItems = (int)[[target items] count];
                BOOL toDown = ev.key == TB_KEY_ARROW_DOWN;
                int value = toDown
                        ? currentIndex < totalItems - 1 ? currentIndex + 1 : 0
                        : currentIndex > 0 ? currentIndex - 1 : totalItems - 1;
                [sm setFocusIndex: value];
            }

            // Select item
            if (ev.ch == TB_KEY_SPACE) {
                [sm setSelectedIndex: [sm selectedIndex] == [sm focusIndex] ? -1 : [sm focusIndex]];
            }
        }
        
        if ([[sm areaFocus] intValue] == 1) {
            // Type
            if (ev.key == 0 && ev.ch != 0) {
                [sm setTyped: [[sm typed] stringByAppendingString:[NSString stringWithFormat:@"%c", ev.ch]]];
            }

            // Delete
            if (ev.key == TB_KEY_BACKSPACE || ev.key == TB_KEY_BACKSPACE2) {
                if ([[sm typed] length] > 0) {
                    [sm setTyped: [[sm typed] substringToIndex:[[sm typed] length] - 1]];
                }
            }
            
            // Enter
            if (ev.key == TB_KEY_ENTER) {
                if ([[sm typed] length] > 0) {
                    // TODO: permitir nomes válidos
                    
                    if (!hasConfig) {
                        hasConfig = [SwitchConfig makeConfigDir] && [SwitchConfig makeTargetConfig: target];
                    }
                    
                    if (hasConfig && [SwitchConfig makeTargetItem: target withName: [sm typed]]) {
                        tb_print([sm width] - 3, 0, TB_GREEN, 0, "OK");
                        [sm setTyped: @""];
                    } else {
                        tb_print([sm width] - 3, 0, TB_RED, 0, "FAIL");
                    }
                }
            }
        }

        [sm printScreen];

        // TODO: remover
        tb_printf([sm width] - 10, [sm height] - 1, 0, TB_BLUE, "                                ");
        tb_printf([sm width] - 10, [sm height] - 1, 0, TB_BLUE, "%d %d %d", ev.type, ev.key, ev.ch);
        tb_present();
    }
    
    /*NSString *arg1, *arg2, *arg3;
    FSItem *fsItem = [[FSItem alloc] init];
    Util *util = [[Util alloc] init];
    
    switch (argc) {
        case 1:
        case 2:
            printf("---\nOpções:\n-c para copiar um item\n-l para linkar um item\n-r para substituir um item\n-d para deletar um item\n---\n");
            break;
        case 3:
        case 4:
            arg1 = [NSString stringWithUTF8String: argv[1]];
            arg2 = [NSString stringWithUTF8String: argv[2]];
            
            [fsItem setItemName:arg2];
            
            if ([fsItem itemExists]) {
                if ([arg1 isEqualTo:OPT_COPY] || [arg1 isEqualTo:OPT_LINK]) {
                    if (argc == 4) {
                        arg3 = [NSString stringWithUTF8String: argv[3]];
                        [fsItem setItemCopyName:arg3];
                    } else {
                        NSString *sufix = [@"." stringByAppendingString:[util getDateString]];
                        
                        if (![fsItem itemIsDir]) {
                            NSArray *fileName = [arg2 componentsSeparatedByString:@"."];
                            NSInteger fileNameSize = [fileName count];
                            
                            if (fileNameSize > 1) {
                                NSString *lastIem = (NSString *)[fileName objectAtIndex:fileNameSize -1];
                                NSString *extension = [@"." stringByAppendingString:lastIem];
                                sufix = [sufix stringByAppendingString:extension];
                                arg2 = [arg2 stringByReplacingOccurrencesOfString:extension withString:@""];
                                
                            }
                        }
                        
                        [fsItem setItemCopyName:[arg2 stringByAppendingString:sufix]];
                    }
                    
                    if ([fsItem itemCopyExists]) {
                        if ([arg1 isEqualTo:OPT_COPY]) printf("---\nUma cópia com este nome já existe: %s.\n---\n", [[fsItem getItemCopyName] UTF8String]);
                        else printf("---\nUm link com este nome já existe: %s.\n---\n", [[fsItem getItemCopyName] UTF8String]);
                    } else {
                        if ([arg1 isEqualTo:OPT_COPY]) {
                            if ([fsItem copyIem]) printf("---\nItem copiado!\n---\n");
                            else printf("---\nO item não foi copiado.\n---\n");
                        } else {
                            if ([fsItem linkItem]) printf("---\nLink criado!\n---\n");
                            else printf("---\nO link não foi criado!\n---\n");
                        }
                    }
                } else if ([arg1 isEqualTo:OPT_REPLACE]) {
                    if (argc == 4) {
                        arg3 = [NSString stringWithUTF8String: argv[3]];
                        [fsItem setItemCopyName:arg3];
                        
                        if ([fsItem itemCopyExists]) {
                            if ([fsItem replaceIem]) printf("---\nItem substituído!\n---\n");
                            else printf("---\nO item não foi substituído.\n---\n");
                        } else {
                            printf("---\nO item substituto não foi encontrado: %s.\n---\n", [[fsItem getItemCopyName] UTF8String]);
                        }
                    } else {
                        printf("---\nUso correto:\n-l item itemSubstituto\n---\n");
                    }
                } else if ([arg1 isEqualTo:OPT_DELETE]) {
                    if ([fsItem deleteItem]) printf("---\nItem excluído!\n---\n");
                    else printf("---\nO item não foi excluído.\n---\n");
                } else {
                    printf("---\nOpção inválida.\n---\n");
                }
            } else {
                printf("---\nItem inexistente: %s.\n---\n", [[fsItem getItemName] UTF8String]);
            }
            
            break;
        default:
            printf("---\nOpção inválida.\n---\n");
            break;
    }*/

    [pool drain];

    return 0;
}
