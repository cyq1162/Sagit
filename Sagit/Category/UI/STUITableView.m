//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUITableView.h"
#import "STDefineUI.h"
#import "STUIView.h"
#import "STUIViewAutoLayout.h"
#import "STArray.h"
#import "STDictionary.h"
#import "STString.h"
#import "STSagit.h"
@implementation UITableView(ST)

#pragma mark 核心扩展
-(NSMutableArray<id> *)source
{
    return [self key:@"source"];
}
-(void)setSource:(NSMutableArray<id> *)source
{
    [self source:source];
}
-(UITableView *)source:(NSMutableArray<id> *)dataSource
{
    if(![dataSource isKindOfClass:[NSMutableArray class]])
    {
        dataSource=[dataSource toNSMutableArray];
    }
    //清掉高度缓存
    [self.heightForCells removeAllObjects];
    [self key:@"source" value:dataSource];
    return self;
}
-(OnAddTableCell)addCell
{
    return [self key:@"addCell"];
}
-(void)setAddCell:(OnAddTableCell)addCell
{
    if(addCell!=nil)
    {
        //addCell=[addCell copy];
        [self key:@"addCell" value:addCell];
    }
    else
    {
        [self.keyValue remove:@"addCell"];
    }
}
-(OnDelTableCell)delCell
{
    return [self key:@"delCell"];
}
-(void)setDelCell:(OnDelTableCell)delCell
{
    if(delCell==nil)
    {
        [self.keyValue remove:@"delCell"];
    }
    else
    {
        [self key:@"delCell" value:delCell];
    }
}
-(OnAddTableCellAction)addCellAction
{
    return [self key:@"addCellAction"];
}
-(void)setAddCellAction:(OnAddTableCellAction)addCellAction
{
    if(addCellAction==nil)
    {
        [self.keyValue remove:@"addCellAction"];
    }
    else
    {
        [self key:@"addCellAction" value:addCellAction];
    }
}

-(OnAddTableSectionView)addSectionView
{
    return [self key:@"addSectionView"];
}
-(void)setAddSectionView:(OnAddTableSectionView)addSectionView
{
    if(addSectionView==nil)
    {
        [self.keyValue remove:@"addSectionView"];
    }
    else
    {
        [self key:@"addSectionView" value:addSectionView];
    }
}

-(NSMutableDictionary*)heightForCells
{
    NSMutableDictionary *heights=[self key:@"heightForCells"];
    if(!heights)
    {
        heights=[NSMutableDictionary new];
        [self key:@"heightForCells" value:heights];
    }
    return heights;
}
-(OnAfterTableReloadData)afterReload
{
    return [self key:@"afterReload"];
}
-(void)setAfterReload:(OnAfterTableReloadData)afterReload
{
    [self key:@"afterReload" value:afterReload];
}
-(BOOL)reuseCell
{
    if([self key:@"reuseCell"]!=nil)
    {
        return [[self key:@"reuseCell"] isEqualToString:@"1"];
    }
    return YES;
}
-(BOOL)reuseCell:(BOOL)yesNo
{
    [self.keyValue set:@"reuseCell" value:yesNo?@"1":@"0"];
    return self;
}
-(BOOL)autoHeight
{
    if([self key:@"autoHeight"]!=nil)
    {
        return [[self key:@"autoHeight"] isEqualToString:@"1"];
    }
    return NO;
}
-(UITableView *)autoHeight:(BOOL)yesNo
{
    [self.keyValue set:@"autoHeight" value:yesNo?@"1":@"0"];
    if(yesNo){
       // [self height:0];//先置为0,避免没有数据时全屏空白
        [self scrollEnabled:NO];//自动计算高度时，滚动条默认没必要存在但如果计算高度超屏时，则自动还原回来。。
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
-(BOOL)allowEdit
{
    return [self key:@"allowEdit"]!=nil && [[self key:@"allowEdit"] isEqualToString:@"1"];
}
-(UITableView *)allowEdit:(BOOL)yesNo
{
    [self key:@"allowEdit" value:yesNo?@"1":@"0"];
    return self;
}
-(UITableView*)afterDelCell:(NSIndexPath*)indexPath
{
   // dispatch_async(dispatch_get_main_queue(), ^{
    //重置Cell高度的缓存
    [self.heightForCells remove:[NSString stringWithFormat:@"%ld_%ld",indexPath.section,indexPath.row]];
    NSMutableArray *rows=self.heightForCells[@(indexPath.section)];
    if(rows && rows.count>indexPath.row)
    {
        [rows removeObjectAtIndex:indexPath.row];
    }
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
-(void)dealloc
{
    //移除全局缓存中的事件
    
    NSLog(@"%@ ->STUITableView relase", [self class]);
}
@end
