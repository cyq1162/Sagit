//
//  STUITableViewCell.m
//  IT恋
//
//  Created by 陈裕强 on 2017/12/23.
//  Copyright © 2017年 . All rights reserved.
//

#import "STUITableViewCell.h"

@implementation UITableViewCell(ST)

+(instancetype)reuseCell:(UITableView *)tableView index:(NSIndexPath *)index
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCell"];
    }
    return cell;
}
-(NSMutableDictionary<NSString *,id> *)source
{
    return [self key:@"source"];
}
-(void)setSource:(NSMutableDictionary<NSString *,id> *)source
{
    [self source:source];
}
-(UITableViewCell*)source:(NSMutableDictionary<NSString *,id> *)dataSource
{
    [self key:@"source" value:dataSource];
    return self;
}
//
//-(NSMutableDictionary<NSString *,id> *)cellSource
//{
//    if(_cellSource==nil){_cellSource=[NSMutableDictionary new];}
//    return _cellSource;
//}
@end
