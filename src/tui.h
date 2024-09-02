//
//  tui.h
//
//  Created by Eduardo Henrique da Silva on 09/08/24.
//

#ifndef tui_h
#define tui_h

#import <Foundation/Foundation.h>

@interface Tui : NSObject {
}

+ (NSString *) line: (int) length;

+ (NSString *) text: (NSString *) value maxWidth: (int) width;

+ (NSString *) topLeft;
+ (NSString *) topRight;
+ (NSString *) bottomLeft;
+ (NSString *) bottomRight;

+ (NSString *) left;
+ (NSString *) right;
+ (NSString *) top;
+ (NSString *) bottom;

+ (NSString *) vertLine;
+ (NSString *) horizLine;

+ (NSString *) sliceText: (NSString *) value limitedTo: (int) length;

@end

#endif /* tui_h */

