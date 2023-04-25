//
//  main.m
//  fsitem
//
//  Created by Eduardo Henrique on 05/06/22.
//

#import <Foundation/Foundation.h>
#import "fs_item.h"
#import "util.h"

#define OPT_COPY @"-c"
#define OPT_LINK @"-l"
#define OPT_REPLACE @"-r"
#define OPT_DELETE @"-d"

int main(int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    NSString *arg1, *arg2, *arg3;
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
    }

    [pool drain];

    return 0;
}
