//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView(ST)

#pragma mark 核心扩展
typedef void(^AddTableCell)(UITableViewCell *cell,NSIndexPath *indexPath);
typedef BOOL(^DelTableCell)(UITableViewCell *cell,NSIndexPath *indexPath);
typedef void(^AfterTableReloadData)(UITableView *tableView);
//!用于为Table追加每一行的Cell
@property (nonatomic,copy) AddTableCell addCell;
//!用于为Table移除行的Cell
@property (nonatomic,copy) DelTableCell delCell;
//!用于为Table reloadData 加载完数据后触发
@property (nonatomic,copy) AfterTableReloadData afterReload;
//!获取Table的数据源
@property (nonatomic,strong) NSMutableArray<id> *source;
//!设置Table的数据源
-(UITableView*)source:(NSMutableArray<id> *)dataSource;
//!存档所有Cell的高度（由系统控制）
@property (readonly,nonatomic,retain) NSMutableDictionary *heightForCells;


//!是否自动控制Table的高度
-(BOOL)autoHeight;
//!设置是否自动控制Table的高度
-(UITableView*)autoHeight:(BOOL)yesNo;
//!获取默认的UITableViewCellStyle
-(UITableViewCellStyle)cellStyle;
//!设置默认的UITableViewCellStyle
-(UITableView*)cellStyle:(UITableViewCellStyle)style;
//!获取是否允许删除属性
-(BOOL)allowDelete;
//!设置是否允许删除
-(UITableView*)allowDelete:(BOOL)yesNo;
//!移除数据源和数据行
-(UITableView*)afterDelCell:(NSIndexPath*)indexPath;
#pragma mark 扩展属性
-(UITableView*)scrollEnabled:(BOOL)yesNo;
-(UITableView*)sectionCount:(NSInteger)count;
//!每个Section的num数：参数可以传递：@[@"1",@"2",@"2",@"1"] 或者：@"1,2,2,1"
-(UITableView*)rowCountInSections:(id)nums;
@end
