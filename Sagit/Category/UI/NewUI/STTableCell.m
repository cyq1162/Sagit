//
//  STTableCell.m
//  IT恋
//
//  Created by 陈裕强 on 2017/12/23.
//  Copyright © 2017年 . All rights reserved.
//

#import "STTableCell.h"

@implementation STTableCell

+(instancetype)reuseCell:(UITableView *)tableView index:(NSIndexPath *)index
{
    STTableCell *cell=[tableView dequeueReusableCellWithIdentifier:@"STTableCell" forIndexPath:index];
    if(cell==nil)
    {
        cell=[[STTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STTableCell"];
    }
    return cell;
}
-(NSMutableDictionary<NSString *,id> *)cellSource
{
    if(_cellSource==nil){_cellSource=[NSMutableDictionary new];}
    return _cellSource;
}

@end
