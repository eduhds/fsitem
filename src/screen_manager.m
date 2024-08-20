//
//  screen_manager.m
//  fsitem
//
//  Created by Eduardo Henrique da Silva on 16/08/24.
//

#import <Foundation/Foundation.h>

#import "libs/termbox2.h"
#import "screen_manager.h"
#import "tui.h"

@implementation ScreenManager

@synthesize width; // @synthesize width = _width;
@synthesize height; // @synthesize height = _height;
@synthesize focusIndex;
@synthesize selectedIndex;
@synthesize target;
@synthesize title;
@synthesize content;
@synthesize typed;
@synthesize message;
@synthesize areaFocus;

- (id) init {
    self = [super init];
    self.focusIndex = 0;
    self.selectedIndex = -1;
    self.title = [[NSString alloc] init];
    self.content = [[NSArray alloc] init];
    self.typed = [[NSString alloc] init];
    self.message = [[NSString alloc] init];
    self.areaFocus = [NSNumber numberWithInt:0];
    return self;
}

- (void) printScreen {
    tb_clear();
    
    // BOX
    int boxX = 0, boxY = 0, boxH = height - 1, boxW = width - 1;
    
    tb_print(boxX, 0, 0, 0, [[Tui topLeft] UTF8String]);
    tb_print(boxX, boxH, 0, 0, [[Tui bottomLeft] UTF8String]);
    
    for (boxX = boxX + 1; boxX < boxW; boxX++) {
        tb_print(boxX, 0, 0, 0, [[Tui top] UTF8String]);
        tb_print(boxX, boxH, 0, 0, [[Tui bottom] UTF8String]);
    }
    
    tb_print(boxX, 0, 0, 0, [[Tui topRight] UTF8String]);
    tb_print(boxX, boxH, 0, 0, [[Tui bottomRight] UTF8String]);

    for (boxY = boxY + 1; boxY < boxH; boxY++) {
        tb_print(0, boxY, 0, 0, [[Tui left] UTF8String]);
        tb_print(boxW, boxY, 0, 0, [[Tui right] UTF8String]);
    }

    // TOP
    int topX = width / 2 - (((int)[title length] + 2) / 2), topY = 0;

    tb_printf(topX, topY++, TB_GREEN, 0, " %s ", [[title uppercaseString] UTF8String]);
    
    // LEFT
    int leftX = 1, leftY = topY;
    int leftW = (width / 2) - 1;
    int focusW = leftW;

    tb_printf(leftX, leftY++, 0, 0, "%s", [[@"> " stringByAppendingString: [target name]] UTF8String]);
    tb_print(leftX, leftY++, 0, 0, [[Tui line:leftW] UTF8String]);

    NSArray *targetItems = [target items];
    
    if ([targetItems count] > 0) {
        for (int i = 0; i < [targetItems count]; i++) {
            NSString *item = [targetItems objectAtIndex:i];
            item = [[item componentsSeparatedByString: @"|"] objectAtIndex: 0];

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
        tb_set_cursor((int)[typed length] + 1, height - 3);
    } else {
        tb_hide_cursor();
    }
    
    // MIDDLE
    int middleX = leftW, middleY = topY;
    
    for (int i = middleY; i < boxY; i++) {
        tb_print(middleX, i, 0, 0, [[Tui left] UTF8String]);
    }
    
    // RIGHT
    int rightX = middleX + 1, rightY = topY;
    //int rightW = width - leftW;
    
    if ([content count] > 0) {
        for (int i = 0; i < [content count]; i++) {
            NSString *item = [content objectAtIndex: i];
            tb_print(rightX, rightY++, 0, 0, [[Tui text: item maxWidth: (boxW - rightX)] UTF8String]);
            if (rightY >= boxY) break;
        }
    }
    
    // BOTTOM
    int bottomX = 1, bottomY = boxY - 1;
    tb_print(bottomX, bottomY, 0, TB_BLUE, [[Tui text:@" " maxWidth: (boxX - 1)] UTF8String]);
    
    if ([message length] > 0) {
        tb_print(bottomX, bottomY, 0, TB_BLUE, [message UTF8String]);
        [self setMessage: @""];
    }
    
    tb_present();
}

@end