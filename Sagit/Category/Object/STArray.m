//
//  STArray.m
//  IT恋
//
//  Created by 陈裕强 on 2017/12/28.
//  Copyright © 2017年 Silan Xie. All rights reserved.
//

#import "STArray.h"

@implementation NSArray(ST)

-(NSMutableArray*)toNSMutableArray
{
    NSMutableArray *array=[NSMutableArray new];
    for (NSInteger i=0; i<self.count; i++) {
        [array addObject:self[i]];
    }
    return array;
}
@end
