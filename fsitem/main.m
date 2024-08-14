//
//  main.m
//  fsitem
//
//  Created by Eduardo Henrique on 05/06/22.
//

#import <Foundation/Foundation.h>
#import "argparse.h"
#import "fs_item.h"
#import "util.h"
#import "libs/termbox2.h"
#import "tui.h"

#define APP_NAME @"fsitem"
#define APP_VERSION @"1.0.0"
#define APP_DESCRIPTION @"fsitem"
#define OPT_COPY @"-c"
#define OPT_LINK @"-l"
#define OPT_REPLACE @"-r"
#define OPT_DELETE @"-d"

#define ARROW_UP_KEY 65517
#define ARROW_DOWN_KEY 65516

int focusIndex = 0;
int selectedIndex = -1;

void printScreen(int width, int height, NSArray *teste1, NSArray *teste2) {
    // TOP
    int topX = width / 2 - ((int)[APP_NAME length] / 2), topY = 0;
    
    tb_print(topX, topY++, TB_GREEN, 0, [[APP_NAME uppercaseString] UTF8String]);
    tb_print(0, topY++, 0, 0, [[Tui line:width] UTF8String]);
    
    // LEFT
    int leftX = 0, leftY = topY;
    int leftW = width / 2;
    int focusW = leftW - 1;

    for (int i = 0; i < [teste1 count]; i++) {
        NSString *item = [teste1 objectAtIndex:i];

        NSString *brackets = i == selectedIndex ? @"[✔] " : @"[ ] ";
        
        item = [brackets stringByAppendingFormat: @"%@", item];
        
        if (i == focusIndex) {
            tb_printf(leftX, leftY++, 0, TB_GREEN, "%s", [[Tui text:item maxWidth:focusW] UTF8String]);
        } else {
            tb_printf(leftX, leftY++, 0, 0, "%s", [[Tui text:item maxWidth:focusW] UTF8String]);
        }
    }
    
    // MIDDLE
    int middleX = leftW - 1, middleY = topY;
    
    for (int i = middleY; i < height; i++) {
        tb_print(middleX, i, 0, 0, "│");
    }
    
    // RIGHT
    int rightX = middleX + 1, rightY = topY;
    //int rightW = width - leftW;
    
    NSString *rightText = [teste2 objectAtIndex:focusIndex];
    tb_print(rightX, rightY, 0, 0, [rightText UTF8String]);
    
    // BOTTOM
    int bottomX = 0, bottomY = height - 1;
    tb_print(bottomX, bottomY, 0, TB_BLUE, [[Tui text:@" " maxWidth:width] UTF8String]);
    
    tb_present();
}

int nextFocusIndex(int currentIndex, int totalItems, BOOL toDown) {
    return toDown
        ? currentIndex < totalItems - 1 ? currentIndex + 1 : 0
        : currentIndex > 0 ? currentIndex - 1 : totalItems - 1;
}

int main(int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    Argparse *argparse = [[Argparse alloc] initWithName:APP_NAME withVersion:APP_VERSION withDescription:APP_DESCRIPTION];
    
    BOOL argsOk = [argparse parse:argc withArgv:argv];
    
    if (!argsOk) {
        exit(1);
    }
    
    NSString *arg1 = [argparse argAtIndex:0];

    NSArray *teste1 = [[NSArray alloc] initWithObjects: arg1, @"exemplo2.env", @"exemplo3.env", nil];
    NSArray *teste2 = [[NSArray alloc] initWithObjects: @"Lorem ipsum 1", @"Lorem ipsum 2", @"Lorem ipsum 3", nil];

    struct tb_event ev;
    
    tb_init();
    
    int height = tb_height();
    int width = tb_width();

    printScreen(width, height, teste1, teste2);

    while (true) {
        tb_poll_event(&ev);
        
        // Exit on ESC or Ctrl+C
        if (ev.key == 3 || ev.key == 27) {
            tb_shutdown();
            break;
        }
        
        // Resize window
        if (ev.type == TB_EVENT_RESIZE) {
            width = ev.w;
            height = ev.h;
            tb_clear();
            printScreen(width, height, teste1, teste2);
        }
        
        // Move focus
        if (ev.key == ARROW_UP_KEY || ev.key == ARROW_DOWN_KEY) {
            focusIndex = nextFocusIndex(focusIndex, (int)[teste1 count], ev.key == ARROW_DOWN_KEY);
            tb_clear();
            printScreen(width, height, teste1, teste2);
        }
        
        // Select item
        if (ev.ch == 32) {
            selectedIndex = selectedIndex == focusIndex ? -1 : focusIndex;
            tb_clear();
            printScreen(width, height, teste1, teste2);
        }
        
        tb_printf(0, height - 1, 0, TB_BLUE, "                                ");
        tb_printf(0, height - 1, 0, TB_BLUE, "%d %d %d", ev.type, ev.key, ev.ch);
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
