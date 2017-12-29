//
//  STUICollectionView.m
//  IT恋
//
//  Created by 陈裕强 on 2017/12/29.
//  Copyright © 2017年 Silan Xie. All rights reserved.
//

#import "STUICollectionView.h"

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
-(UITableView *)source:(NSMutableArray<id> *)dataSource
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
