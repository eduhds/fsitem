//
//  fs_item.m
//  dot_ssh_switch
//
//  Created by Eduardo Henrique on 09/04/23.
//

#import <Foundation/Foundation.h>
#import "fs_item.h"
#import "util.h"

@implementation FSItem

- (NSString *)getItemName {
    return itemName;
}

- (NSString *)getItemCopyName {
    return itemCopyName;
}

- (void)setItemName:(NSString *)name {
    itemName = name;
}

-(void)setItemCopyName:(NSString *)name {
    itemCopyName = name;
}

- (bool)itemExists {
    Util *util = [[Util alloc] init];
    
    NSString *dir = [[util currentPath] stringByAppendingString:@"/"];
    NSString *item = [dir stringByAppendingString:itemName];
    
    return [util pathExists:item];
}

- (bool)itemIsDir {
    Util *util = [[Util alloc] init];
    
    NSString *dir = [[util currentPath] stringByAppendingString:@"/"];
    NSString *item = [dir stringByAppendingString:itemName];
    
    return [util pathIsDirectory:item];
}

- (bool)itemCopyExists {
    Util *util = [[Util alloc] init];
    
    NSString *dir = [[util currentPath] stringByAppendingString:@"/"];
    NSString *itemCopy = [dir stringByAppendingString:itemCopyName];
    
    return [util pathExists:itemCopy];
}

- (bool)itemCopyIsDir {
    Util *util = [[Util alloc] init];
    
    NSString *dir = [[util currentPath] stringByAppendingString:@"/"];
    NSString *itemCopy = [dir stringByAppendingString:itemCopyName];
    
    return [util pathIsDirectory:itemCopy];
}

- (bool) copyIem {
    Util *util = [[Util alloc] init];
    
    NSString *dir = [[util currentPath] stringByAppendingString:@"/"];
    NSString *origin = [dir stringByAppendingString:itemName];
    NSString *destin = [dir stringByAppendingString:itemCopyName];
    
    return [util copyItem:origin toPath:destin];
}

- (bool) replaceIem {
    Util *util = [[Util alloc] init];
    
    NSString *dir = [[util currentPath] stringByAppendingString:@"/"];
    NSString *old = [dir stringByAppendingString:itemName];
    NSString *new = [dir stringByAppendingString:itemCopyName];
    
    if ([util deleteItem:old]) {
        return [util moveItem:new toPath:old];
    }
    
    return false;
}

- (bool) deleteItem {
    Util *util = [[Util alloc] init];
    
    NSString *dir = [[util currentPath] stringByAppendingString:@"/"];
    NSString *item = [dir stringByAppendingString:itemName];
    
    return [util deleteItem:item];
}

- (bool) linkItem {
    Util *util = [[Util alloc] init];
    
    NSString *dir = [[util currentPath] stringByAppendingString:@"/"];
    NSString *origin = [dir stringByAppendingString:itemName];
    NSString *destin = [dir stringByAppendingString:itemCopyName];
    
    return [util createLink:destin destination:origin];
}

@end
