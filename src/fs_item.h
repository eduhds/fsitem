//
//  fs_item.h
//  fsitem
//
//  Created by Eduardo Henrique on 08/04/23.
//

#ifndef fs_item_h
#define fs_item_h


#endif /* fs_item_h */

#import <Foundation/Foundation.h>

@interface FSItem : NSObject {
    NSString *itemName;
    NSString *itemCopyName;
}

- (NSString*) getItemName;

- (NSString*) getItemCopyName;

- (void) setItemName: (NSString*) name;

- (void) setItemCopyName: (NSString*) name;

- (bool) itemExists;

- (bool) itemIsDir;

- (bool) itemCopyExists;

- (bool) itemCopyIsDir;

- (bool) copyIem;

- (bool) replaceIem;

- (bool) deleteItem;

- (bool) linkItem;

@end
