//
//  tui.h
//  fsitem
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

@end

#endif /* tui_h */

