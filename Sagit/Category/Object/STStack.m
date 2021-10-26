//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  Copyright © 2017-2027年. All rights reserved.
//
#import "STStack.h"
@interface STStack()
@property (nonatomic,strong) NSMutableArray<id> *array;

@end
@implementation STStack
-(instancetype)init
{
    _array=[NSMutableArray new];
    return self;
}
-(NSUInteger)count
{
    return self.array.count;
}
-(void)push:(id)anObject
{
    [self.array addObject:anObject];
}
-(id)pop
{
    id obj=[self.array lastObject];
    [self.array removeObject:obj];
    return obj;
}
-(id)peek
{
    id obj=[self.array lastObject];
    return obj;
}
@end
