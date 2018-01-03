//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUICollectionViewCell.h"
#import "STUIView.h"
@implementation UICollectionViewCell(ST)

+(instancetype)reuseCell:(UICollectionView *)tableView index:(NSIndexPath *)index
{
    UICollectionViewCell *cell=[tableView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:index];
    if(cell==nil)
    {
        cell=[UICollectionViewCell new];
        [cell key:@"table" value:tableView];
        [cell key:@"stView" value:tableView.stView];
        [cell key:@"baseView" value:tableView.baseView];
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
