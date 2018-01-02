//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUITableView.h"

@implementation UITableView(ST)

#pragma mark 核心扩展
-(NSMutableArray<id> *)source
{
    return [self key:@"source"];
}
-(void)setSource:(NSMutableArray<id> *)source
{
    if(self.allowDelete && ![source isKindOfClass:[NSMutableArray class]])
    {
        source=[source toNSMutableArray];
    }
    [self source:source];
}
-(UITableView *)source:(NSMutableArray<id> *)dataSource
{
    [self key:@"source" value:dataSource];
    return self;
}
-(AddTableCell)addCell
{
    return [self key:@"addCell"];
}
-(void)setAddCell:(AddTableCell)addCell
{
    [self key:@"addCell" value:addCell];
}
-(DelTableCell)delCell
{
    return [self key:@"delCell"];
}
-(void)setDelCell:(DelTableCell)delCell
{
    [self key:@"delCell" value:delCell];
}
-(AfterTableReloadData)afterReload
{
    return [self key:@"afterReload"];
}
-(void)setAfterReload:(AfterTableReloadData)afterReload
{
    [self key:@"afterReload" value:afterReload];
}
-(BOOL)autoHeight
{
    if(self.keyValue[@"autoHeight"]!=nil)
    {
        return [self.keyValue[@"autoHeight"] isEqualToString:@"1"];
    }
    return NO;
}
-(UITableView *)autoHeight:(BOOL)yesNo
{
    [self.keyValue set:@"autoHeight" value:yesNo?@"1":@"0"];
    if(yesNo){
       // [self height:0];//先置为0,避免没有数据时全屏空白
        [self scrollEnabled:NO];//自动计算高度时，滚动条默认没必要存在。
    }
    return self;
}
-(UITableViewCellStyle)cellStyle
{
    NSString* style=[self key:@"cellStyle"];
    if(style==nil)
    {
        return UITableViewCellStyleDefault;
    }
    return (UITableViewCellStyle)[style intValue];
}
-(UITableView *)cellStyle:(UITableViewCellStyle)style
{
    [self key:@"cellStyle" value:[@(style) stringValue]];
    return self;
}
-(BOOL)allowDelete
{
    return [self key:@"allowDelete"]!=nil && [[self key:@"allowDelete"] isEqualToString:@"1"];
}
-(UITableView *)allowDelete:(BOOL)yesNo
{
    [self key:@"allowDelete" value:yesNo?@"1":@"0"];
    return self;
}
-(UITableView*)afterDelCell:(NSIndexPath*)indexPath
{
   // dispatch_async(dispatch_get_main_queue(), ^{
        [self.source removeObjectAtIndex:indexPath.row];
        [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if(self.autoHeight)
        {
            [self height:(self.contentSize.height-1)*Ypx];
        }
        return self;
   // });
    
}
#pragma mark 属性扩展
-(UITableView*)scrollEnabled:(BOOL)yesNo
{
    self.scrollEnabled=yesNo;
    return self;
}
-(UITableView*)sectionCount:(NSInteger)count
{
    [self key:@"sectionCount" value:[@(count) stringValue]];
    return self;
}
-(UITableView*)rowCountInSections:(id)nums
{
    NSArray *items;
    if([nums isKindOfClass:[NSString class]])
    {
        items=[nums split:@","];
    }
    else
    {
        items=nums;
    }
    [self key:@"rowCountInSections" value:items];
    return self;
}
@end
