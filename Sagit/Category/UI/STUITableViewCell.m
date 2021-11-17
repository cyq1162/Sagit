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
#import "STCategory.h"
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
        [cell backgroundColor:tableView.backgroundColor];//dark 模式兼容。
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
    for (int i=cell.subviews.count-1; i>=0; i--) {
        UIView *view=cell.subviews[i];
        NSString *className=NSStringFromClass([view class]);
        if([className eq:@"_UITableViewCellSeparatorView"])
        {
            if(view.stY>88){[view y:88];}
            if(view.stHeight>88){[view height:88];}
        }
        else if([className eq:@"UITableViewCellContentView"])
        {
            [view removeAllSubViews];
        }
        else
        {
            [view removeSelf];
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
-(BOOL)allowEdit
{
    if([self key:@"allowEdit"]==nil)
    {
        return self.table.allowEdit;
    }
    return [[self key:@"allowEdit"] isEqualToString:@"1"];
}
-(UITableViewCell *)allowEdit:(BOOL)yesNo
{
    [self key:@"allowEdit" value:yesNo?@"1":@"0"];
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
-(void)refleshTableHeight
{
    [self fixHeight:self];
    [self refleshLayout:NO ignoreSelf:NO];//刷新相对布局的坐标
    [self fixHeight:self];//刷新后再修正高度。
    UITableView *tableView= self.table;
    [tableView beginUpdates];
    CGFloat fixHeight=0;
    NSIndexPath *index=self.indexPath;
    NSMutableArray *array=[tableView.heightForCells get:@(index.section)];
    if(array && array.count>=index.row)
    {
        fixHeight=self.frame.size.height-((NSNumber*)array[index.row]).floatValue;
        array[index.row]=@(self.frame.size.height);
    }
    
    tableView.contentSize=CGSizeMake(tableView.contentSize.width, tableView.contentSize.height+fixHeight);
    if(tableView.autoHeight)
    {
        NSInteger relateBottomPx=0;
        //检测是否有向下的约束
        STLayoutTracer *tracer= tableView.LayoutTracer[@"relate"];
        if(tracer && tracer.hasRelateBottom)
        {
            relateBottomPx=tracer.relateBottomPx;
        }
        //检测是否高度超过屏 // 65
        NSInteger passValue=tableView.frame.origin.y+tableView.contentSize.height-tableView.superview.frame.size.height+relateBottomPx*Ypt;
        
        if(passValue>0)
        {
            tableView.scrollEnabled=YES;
            CGFloat passSuperValue=fixHeight-passValue;
            if(passSuperValue>0)//还能加。
            {
                [tableView key:@"passSuperValue" value:@(passSuperValue)];
                [tableView height:tableView.stHeight+passSuperValue*Ypx];
            }
        }
        else
        {
            bool isPassSuper=NO;
            if(fixHeight<0)
            {
                isPassSuper=passValue-fixHeight>0;//是否从超过superview=>退回。
            }
            if(!isPassSuper)
            {
                [tableView height:tableView.stHeight+fixHeight*Ypx];
            }
            else
            {
                NSNumber* passSuperValue=[tableView key:@"passSuperValue"];
                [tableView height:tableView.stHeight-passSuperValue.floatValue*Ypx];
            }
        }
        if(tableView.layer.mask)
        {
            //高度改变，mask需要刷新
            NSNumber*px=   [tableView key:@"layerMaskPx"];
            NSNumber*corner= [tableView key:@"layerMaskCorner"];
            if(px)
            {
                [tableView layerCornerRadius:px.floatValue byRoundingCorners:corner.intValue];
            }
        }
    }
    [tableView endUpdates];
}
-(void)fixHeight:(UIView*)fixView
{
    //仅遍历一级
    CGFloat maxHeight=0;
    if(fixView.subviews.count>0)
    {
        
        for (NSInteger i=0; i<fixView.subviews.count; i++)
        {
            UIView *view=fixView.subviews[i];
            NSString*className=NSStringFromClass([view class]);
            if([@"_UITableViewCellSeparatorView" eq:className] && self.table.separatorStyle)
            {
                if(self.table.separatorStyle==UITableViewCellSeparatorStyleNone ||
                   UIEdgeInsetsEqualToEdgeInsets(self.table.separatorInset, UIEdgeInsetsZero) ||
                   CGColorGetAlpha(self.table.separatorColor.CGColor)==0
                   )
                {
                    continue;;
                }
                //获取当前的类名
                maxHeight+=10;//标准默认线距离间隔。
                continue;
            }
            else if([@"UITableViewCellContentView" eq:className])
            {
                [self fixHeight:view];
            }
            CGRect subFrame= view.frame;
            CGFloat subHeight=subFrame.origin.y+subFrame.size.height;
            if(subHeight>maxHeight)
            {
                maxHeight=subHeight;
            }
        }
    }
    if(maxHeight<44 && [fixView isEqual:self])
    {
        NSNumber *initHeight=[self key:@"initHeight"];
        if(initHeight && initHeight>=44)
        {
            maxHeight=initHeight.floatValue;
        }
    }
    [fixView height:maxHeight*Ypx];
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
#pragma mark 扩展
-(STUITableViewCellAction *)action
{
    return [self key:@"action"];
}
-(void)setAction:(STUITableViewCellAction *)action
{
    [self key:@"action" value:action];
}
-(void)dealloc
{
    if(self.action!=nil)
    {
        [self.action dispose];
    }
    
    NSLog(@"%@ ->STUITableViewCell relase", [self class]);
}
@end
