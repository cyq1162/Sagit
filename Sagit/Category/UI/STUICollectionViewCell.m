//
//  STUICollectionViewCell.m
//  IT恋
//
//  Created by 陈裕强 on 2017/12/29.
//  Copyright © 2017年 Silan Xie. All rights reserved.
//

#import "STUICollectionViewCell.h"

@implementation UICollectionViewCell(ST)

+(instancetype)reuseCell:(UICollectionView *)tableView index:(NSIndexPath *)index
{
    UICollectionViewCell *cell=[tableView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:index];
    if(cell==nil)
    {
        cell=[UICollectionViewCell new];
        [cell key:@"table" value:tableView];
    }
    return cell;
}
-(UICollectionView *)table
{
    return [self key:@"table"];
}
-(NSMutableDictionary<NSString *,id> *)source
{
    return [self key:@"source"];
}
-(void)setSource:(NSMutableDictionary<NSString *,id> *)source
{
    [self source:source];
}
-(UICollectionViewCell*)source:(NSMutableDictionary<NSString *,id> *)dataSource
{
    [self key:@"source" value:dataSource];
    return self;
}
//-(BOOL)allowDelete
//{
//    if([self key:@"allowDelete"]==nil)
//    {
//        return self.table.allowDelete;
//    }
//    return [[self key:@"allowDelete"] isEqualToString:@"1"];
//}
//-(UITableView *)allowDelete:(BOOL)yesNo
//{
//    [self key:@"allowDelete" value:yesNo?@"1":@"0"];
//    return self;
//}
-(NSString *)firstValue
{
    return [self key:@"firstValue"];
}
-(UICollectionViewCell *)firstValue:(NSString *)value
{
    [self key:@"firstValue" value:value];
    return self;
}
@end
