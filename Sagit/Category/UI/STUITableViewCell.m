//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUITableViewCell.h"
#import "STUITableView.h"
#import "STUIView.h"
@implementation UITableViewCell(ST)

+(instancetype)reuseCell:(UITableView *)tableView index:(NSIndexPath *)index
{
    NSString *key=@"TableViewCell";
    if(!tableView.reuseCell)
    {
        key=[[key append:@(index.section)] append:@(index.row)];
    }
    UITableViewCell*  cell=[tableView dequeueReusableCellWithIdentifier:key];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:tableView.cellStyle reuseIdentifier:key];
        [cell key:@"table" valueWeak:tableView];
        [cell key:@"stView" valueWeak:tableView.stView];
        [cell key:@"baseView" valueWeak:tableView.baseView];//因为Cell在Add时，并没有父，所以需要提前设置，这样STLastView等宏才能找到上一个UI
        [cell accessoryType:UITableViewCellAccessoryDisclosureIndicator];//右边有小箭头
        [cell selectionStyle:UITableViewCellSelectionStyleNone];//选中无状态
    }
    [cell indexPath:index];
    if(!tableView.reuseCell)
    {
        return cell;
    }
    
    if(cell.contentView.subviews.count>0)
    {
        [cell.contentView removeAllSubViews];
        for (NSInteger i=0; i<cell.subviews.count; i++)//恢复分隔线的Y坐标
        {
            UIView*view=cell.subviews[i];
            if(view.stY>88){[view y:88];}
            if(view.stHeight>88){[view height:88];}
        }
    }
    //默认设置
    [cell width:1 height:88];//IOS的默认高度
    return cell;
}
-(UITableView *)table
{
    return [self key:@"table"];
}
-(id)source
{
    return [self key:@"source"];
}
-(void)setSource:(id)source
{
    [self source:source];
}
-(UITableViewCell*)source:(id)dataSource
{
    [self key:@"source" value:dataSource];
    return self;
}
-(NSIndexPath *)indexPath
{
    return [self key:@"indexPath"];
}
-(UITableViewCell *)indexPath:(NSIndexPath *)indexPath
{
    [self key:@"indexPath" value:indexPath];
    return self;
}
//-(BOOL)isReused
//{
//    return [self key:@"isReused"]!=nil;
//}
-(BOOL)allowDelete
{
    if([self key:@"allowDelete"]==nil)
    {
        return self.table.allowDelete;
    }
    return [[self key:@"allowDelete"] isEqualToString:@"1"];
}
-(UITableView *)allowDelete:(BOOL)yesNo
{
    [self key:@"allowDelete" value:yesNo?@"1":@"0"];
    return self;
}
-(NSString *)firstValue
{
    return [self key:@"firstValue"];
}
-(UITableViewCell *)firstValue:(NSString *)value
{
    [self key:@"firstValue" value:value];
    return self;
}
-(UITableViewCell*)resetHeightCache
{
    NSIndexPath *index=self.indexPath;
    NSMutableArray *array=[self.table.heightForCells get:@(index.section)];
    if(array && array.count>=index.row)
    {
        array[index.row]=@(self.frame.size.height);
    }
    return self;
}
#pragma mark 扩展属性
-(UITableViewCell *)accessoryType:(UITableViewCellAccessoryType)type
{
    self.accessoryType=type;
    return self;
}
-(UITableViewCell *)selectionStyle:(UITableViewCellSelectionStyle)style
{
    self.selectionStyle=style;
    return self;
}
//-(void)dealloc
//{
//    NSLog(@"%@ ->STUITableViewCell relase", [self class]);
//}
@end
