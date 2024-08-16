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

@interface Target : NSObject {
    NSString *name;
    NSArray *items;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *items;

@end

@implementation Target

@synthesize name;
@synthesize items;

@end

@interface ScreenManager : NSObject {
    int width; // int _width;
    int height; // int _height;
    int focusIndex;
    int selectedIndex;
    Target *target;
    NSString *content;
    NSString *typed;
    NSNumber *areaFocus;
}

@property (nonatomic) int width; // Number of characters
@property (nonatomic) int height; // Number of lines
@property (nonatomic) int focusIndex;
@property (nonatomic) int selectedIndex;
@property (nonatomic, retain) Target *target;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *typed;
@property (nonatomic, retain) NSNumber *areaFocus;

- (void) printScreen;

@end

@implementation ScreenManager

@synthesize width; // @synthesize width = _width;
@synthesize height; // @synthesize height = _height;
@synthesize focusIndex;
@synthesize selectedIndex;
@synthesize target;
@synthesize content;
@synthesize typed;
@synthesize areaFocus;

- (id) init {
    self = [super init];
    self.focusIndex = 0;
    self.selectedIndex = -1;
    self.content = [[NSString alloc] init];
    self.typed = [[NSString alloc] init];
    self.areaFocus = [NSNumber numberWithInt:0];
    return self;
}

- (id) initWithWidth: (int) w andHeight: (int) h {
    self = [super init];
    self.width = w;
    self.height = h;
    self.focusIndex = 0;
    self.selectedIndex = -1;
    self.content = [[NSString alloc] init];
    self.typed = [[NSString alloc] init];
    self.areaFocus = [NSNumber numberWithInt:0];
    return self;
}

- (void) printScreen {
    tb_clear();

    // TOP
    int topX = width / 2 - ((int)[APP_NAME length] / 2), topY = 0;
    
    tb_print(topX, topY++, TB_GREEN, 0, [[APP_NAME uppercaseString] UTF8String]);
    tb_print(0, topY++, 0, 0, [[Tui line:width] UTF8String]);
    
    // LEFT
    int leftX = 0, leftY = topY;
    int leftW = (width / 2) - 1;
    int focusW = leftW;

    tb_printf(leftX, leftY++, 0, 0, "%s", [[@"⮚ " stringByAppendingString: [target name]] UTF8String]);
    tb_print(leftX, leftY++, 0, 0, [[Tui line:leftW] UTF8String]);

    NSArray *targetItems = [target items];
    
    if ([targetItems count] > 0) {
        for (int i = 0; i < [targetItems count]; i++) {
            NSString *item = [targetItems objectAtIndex:i];

            NSString *brackets = i == selectedIndex ? @"[✔] " : @"[ ] ";
            
            item = [brackets stringByAppendingFormat: @"%@", item];
            
            int focusY = leftY++;
            if ([areaFocus intValue] == 0 && i == focusIndex) {
                tb_printf(leftX, focusY, 0, TB_GREEN, "%s", [[Tui text:item maxWidth:focusW] UTF8String]);
                tb_print(focusW -2, focusY, 0, TB_GREEN, "▶");
            } else {
                tb_printf(leftX, focusY, 0, 0, "%s", [[Tui text:item maxWidth:focusW] UTF8String]);
            }
        }
    } else {
        tb_print(leftX, leftY++, 0, 0, [[Tui text:@"Nenhum item encontrado" maxWidth:focusW] UTF8String]);
    }

    tb_print(leftX, height - 4, 0, 0, [[Tui line:leftW] UTF8String]);
    tb_print(leftX, height - 3, 0, 0, [typed UTF8String]);
    tb_print(leftX, height - 2, 0, 0, [[Tui text:@"" maxWidth:leftW] UTF8String]);

    if ([areaFocus intValue] == 1) {
        tb_set_cursor([typed length], height - 3);
    } else {
        tb_hide_cursor();
    }
    
    // MIDDLE
    int middleX = leftW, middleY = topY;
    
    for (int i = middleY; i < height; i++) {
        tb_print(middleX, i, 0, 0, "│");
    }
    
    // RIGHT
    int rightX = middleX + 1, rightY = topY;
    //int rightW = width - leftW;
    
    tb_print(rightX, rightY, 0, 0, [content UTF8String]);
    
    // BOTTOM
    int bottomX = 0, bottomY = height - 1;
    tb_print(bottomX, bottomY, 0, TB_BLUE, [[Tui text:@" " maxWidth:width] UTF8String]);
    
    tb_present();
}

@end

int main(int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    Argparse *argparse = [[Argparse alloc] initWithName:APP_NAME withVersion:APP_VERSION withDescription:APP_DESCRIPTION];
    
    BOOL argsOk = [argparse parse:argc withArgv:argv];
    
    if (!argsOk) {
        exit(1);
    }

    Util *util = [[Util alloc] init];
    
    Target *target = [[Target alloc] init];
    [target setName:[argparse argAtIndex:0]];

    if ([util pathExists:[target name]]) {
        if ([util pathIsDirectory:[target name]]) {
            printf("Directory is not supported.\n");
            exit(1);
        }
    } else {
        printf("Target file not found.\n");
        exit(1);
    }

    NSArray *exampleItems = [[NSArray alloc] initWithObjects: @"Lorem ipsum 1", @"Lorem ipsum 2", @"Lorem ipsum 3", nil];

    [target setItems:exampleItems];
    
    struct tb_event ev;
    
    tb_init();

    ScreenManager *sm = [[ScreenManager alloc] init];
    [sm setWidth:tb_width()];
    [sm setHeight:tb_height()];
    [sm setTarget:target];
    
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
        }

        [sm printScreen];

        tb_printf(0, [sm height] - 1, 0, TB_BLUE, "                                ");
        tb_printf(0, [sm height] - 1, 0, TB_BLUE, "%d %d %d", ev.type, ev.key, ev.ch);
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
