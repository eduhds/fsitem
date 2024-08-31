//
//  screen_manager.m
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
@synthesize alertVisible;
@synthesize alertCancelFocus;
@synthesize success;

- (id) init {
    self = [super init];
    self.focusIndex = 0;
    self.selectedIndex = -1;
    self.title = [[NSString alloc] init];
    self.content = [[NSArray alloc] init];
    self.typed = [[NSString alloc] init];
    self.message = [[NSString alloc] init];
    self.areaFocus = [NSNumber numberWithInt: AREA_1];
    self.alertVisible = NO;
    self.alertCancelFocus = YES;
    self.success = YES;
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
    tb_printf(topX, topY++, 0, 0, "%s", [[target name] UTF8String]);
    
    // LEFT
    int leftX = 1, leftY = topY;
    int leftW = (width / 2) - 1;
    int focusW = leftW;

    tb_print(leftX, leftY++, 0, 0, [[Tui line: leftW] UTF8String]);

    NSArray *targetItems = [target items];
    
    if ([targetItems count] > 0) {
        for (int i = 0; i < [targetItems count]; i++) {
            NSString *item = [targetItems objectAtIndex: i];
            item = [[item componentsSeparatedByString: @"|"] objectAtIndex: 0];

            BOOL isCurrentItem = [item hasPrefix: @"!"];
            if (isCurrentItem) {
                item = [item substringFromIndex: 1];
            }

            NSString *brackets = [@"" stringByAppendingFormat: @"[%@] ", isCurrentItem ? selectedIndex == -1 ? @"✔" : @"*" : i == selectedIndex ? @"✔" : @" "];
            
            item = [brackets stringByAppendingFormat: @"%@", item];

            if (isCurrentItem) {
                item = [item stringByAppendingString: @" (current)"];
            }
            
            int focusY = leftY++;
            if ([areaFocus intValue] == AREA_1 && i == focusIndex) {
                tb_printf(leftX, focusY, 0, TB_GREEN, "%s", [[Tui text: item maxWidth: focusW] UTF8String]);
                tb_print(focusW -2, focusY, 0, TB_GREEN, "▶");
            } else {
                tb_printf(leftX, focusY, 0, 0, "%s", [[Tui text: item maxWidth: focusW] UTF8String]);
            }
        }
    } else {
        tb_print(leftX, leftY++, 0, 0, [[Tui text:@"Nenhum item encontrado" maxWidth:focusW] UTF8String]);
    }

    tb_print(leftX, height - 6, 0, 0, [[Tui line: leftW - 1] UTF8String]);
    tb_printf(leftX, height - 5, 0, 0, "> %s", [typed UTF8String]);
    tb_print(leftX, height - 4, 0, 0, [[Tui line: leftW - 1] UTF8String]);
    
    //tb_print(leftX, height - 2, 0, 0, [[Tui text:@"" maxWidth:leftW] UTF8String]);

    if ([areaFocus intValue] == AREA_2) {
        tb_set_cursor((int)[typed length] + 3, height - 5);
    } else {
        tb_hide_cursor();
    }
    
    // MIDDLE
    int middleX = leftW, middleY = topY;
    
    tb_print(middleX, middleY, 0, 0, [[Tui topRight] UTF8String]);

    for (middleY = middleY + 1; middleY < height - 4; middleY++) {
        tb_print(middleX, middleY, 0, 0, [[Tui left] UTF8String]);
    }
    
    tb_print(middleX, middleY++, 0, 0, [[Tui bottomRight] UTF8String]);
    
    // RIGHT
    int rightX = middleX + 1, rightY = topY + 2;
    //int rightW = width - leftW;
    
    if ([content count] > 0) {
        for (int i = 0; i < [content count]; i++) {
            NSString *item = [content objectAtIndex: i];
            tb_print(rightX, rightY++, 0, 0, [[Tui text: item maxWidth: (boxW - rightX)] UTF8String]);
            if (rightY >= boxY) break;
        }
    }
    
    // BOTTOM
    int bottomX = 1, bottomY = boxY - 2;
    NSString *tips = @"<ESC> to exit <TAB> to move <SPACE> to select <ENTER> to confirm";
    
    tb_print(bottomX, bottomY, 0, TB_WHITE, [[Tui text:@" " maxWidth: (boxX - 1)] UTF8String]);
    tb_print((width / 2) - ((int)[tips length] / 2), bottomY++, 0, TB_WHITE, [tips UTF8String]);
    tb_print(bottomX, bottomY, 0, success ? TB_BLUE : TB_RED, [[Tui text:@" " maxWidth: (boxX - 1)] UTF8String]);

    if ([message length] > 0) {
        tb_print(bottomX, bottomY, TB_WHITE, success ? TB_BLUE : TB_RED, [message UTF8String]);
        [self setMessage: @""];
        [self setSuccess: YES];
    }
    
    tb_present();
}

- (void) printAlert: (NSString *) aMessage {
    tb_hide_cursor();

    int centerX = width / 2, centerY = height / 2;
    int alertW = width / 2, alertH = MIN(alertW / 3, height - 2);
    int alertX = centerX - (alertW / 2);
    int alertY = centerY - (alertH / 2);
    
    int endY = (centerY + (alertH / 2));
    int endX = (centerX + (alertW / 2));
    
    NSString *alertTitle = @" Alert ";
    NSString *alertMessage = aMessage != nil ? aMessage : @"Are you sure?";
    
    for (int y = alertY; y < endY; y++) { // Linhas
        for (int x = alertX; x < endX; x++) { // Colunas
            tb_print(x, y, 0, TB_WHITE, " ");
            
            if ((y == alertY || y == (endY - 1)) && x > alertX && x < (endX - 1)) {
                tb_print(x, y, TB_BLACK, TB_WHITE, [[Tui horizLine] UTF8String]); //
            }
            
            if (x == alertX + 1 || x == (endX - 2)) {
                tb_print(x, y, TB_BLACK, TB_WHITE, [[Tui vertLine] UTF8String]);
            }
            
            if (y == alertY) {
                tb_print(centerX - ((int)[alertTitle length] / 2), y, TB_BLACK, TB_WHITE, [alertTitle UTF8String]);
            }
            
            if (y == centerY - 1) {
                tb_print(centerX - ((int)[alertMessage length] / 2), y, TB_BLACK, TB_WHITE, [alertMessage UTF8String]);
            }
            
            if (y == endY - 2) {
                tb_print(centerX - 11, y, TB_WHITE, alertCancelFocus ? TB_BLUE : TB_WHITE, [@" <Cancel> " UTF8String]);
                tb_print(centerX + 1, y, TB_WHITE, alertCancelFocus ? TB_WHITE : TB_BLUE, [@" <Confirm> " UTF8String]);
            }
            
            tb_print(x + 1, endY, 0, TB_BLACK, "  "); // Border bottom
        }
        
        if (y == alertY) {
            tb_print(alertX + 1, y, TB_BLACK, TB_WHITE, [[Tui topLeft] UTF8String]);
            tb_print(endX - 2, y, TB_BLACK, TB_WHITE, [[Tui topRight] UTF8String]);
        }
        
        if (y == (endY - 1)) {
            tb_print(alertX + 1, y, TB_BLACK, TB_WHITE, [[Tui bottomLeft] UTF8String]);
            tb_print(endX - 2, y, TB_BLACK, TB_WHITE, [[Tui bottomRight] UTF8String]);
        }
        
        tb_print(endX, y + 1, 0, TB_BLACK, "  "); // Border right
    }

    tb_present();
}

- (void) setStatus: (NSString *) aMessage success: (BOOL) status {
    [self setMessage: aMessage];
    [self setSuccess: status];
}

@end
