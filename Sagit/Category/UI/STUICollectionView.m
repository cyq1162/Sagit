//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUICollectionView.h"
#import "STUIView.h"
@implementation UICollectionView(ST)

#pragma mark 核心扩展
-(NSMutableArray<id> *)source
{
    return [self key:@"source"];
}
-(void)setSource:(NSMutableArray<id> *)source
{
//    if(self.allowDelete && ![source isKindOfClass:[NSMutableArray class]])
//    {
//        source=[source toNSMutableArray];
//    }
    [self source:source];
}
-(UICollectionView *)source:(NSMutableArray<id> *)dataSource
{
    [self key:@"source" value:dataSource];
    return self;
}
-(AddCollectionCell)addCell
{
    return [self key:@"addCell"];
}
-(void)setAddCell:(AddCollectionCell)addCell
{
    [self key:@"addCell" value:addCell];
}
-(DelCollectionCell)delCell
{
    return [self key:@"delCell"];
}
-(void)setDelCell:(DelCollectionCell)delCell
{
    [self key:@"delCell" value:delCell];
}
@end
