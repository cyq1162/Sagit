//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
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
