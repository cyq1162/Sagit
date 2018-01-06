//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUITableViewCell.h"
#import "STUITableView.h"
#import "STUIView.h"
@implementation UITableViewCell(ST)

+(instancetype)reuseCell:(UITableView *)tableView index:(NSIndexPath *)index
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:tableView.cellStyle reuseIdentifier:@"TableViewCell"];
       // [cell.keyValueWeak set:@"table" value:tableView];
//        STWeakObj(tableView);//
        [cell key:@"table" valueWeak:tableView];
        [cell key:@"stView" valueWeak:tableView.stView];
        [cell key:@"baseView" valueWeak:tableView.baseView];//因为Cell在Add时，并没有父，所以需要提前设置，这样STLastView等宏才能找到上一个UI
    }
    return cell;
}
-(UITableView *)table
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
-(UITableViewCell*)source:(NSMutableDictionary<NSString *,id> *)dataSource
{
    [self key:@"source" value:dataSource];
    return self;
}
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
-(void)dealloc
{
    NSLog(@"%@ ->STUITableViewCell relase", [self class]);
}
@end
