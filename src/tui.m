//
//  tui.m
//  fsitem
//
//  Created by Eduardo Henrique da Silva on 09/08/24.
//

#import "tui.h"

@implementation Tui

+ (NSString *) line: (int) length {
    NSString *line = @"";
    for (int i = 0; i < length; i++) {
        line = [line stringByAppendingString:@"─"];
    }
    return line;
}

+ (NSString *) text: (NSString *) value maxWidth: (int) width {
    NSString *text = value;
    if ([value length] > width) {
        text = [value substringToIndex:width];
    } else {
        for (NSUInteger i = [text length]; i < width; i++) {
            text = [text stringByAppendingString:@" "];
        }
    }
    return text;
}

@end
