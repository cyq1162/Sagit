//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STArray.h"

@implementation NSArray(ST)

-(NSMutableArray*)toNSMutableArray
{
    NSMutableArray *array=[NSMutableArray new];
    for (NSInteger i=0; i<self.count; i++) {
        id obj=self[i];
        if([obj isKindOfClass:[NSArray class]])
        {
            obj=[(NSMutableArray*)obj toNSMutableArray];
        }
        else if([obj isKindOfClass:[NSDictionary class]])
        {
            obj=[(NSDictionary*)obj toNSMutableDictionary];
        }
        [array addObject:obj];
    }
    return array;
}
@end
