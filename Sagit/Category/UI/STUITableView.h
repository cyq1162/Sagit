//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  Copyright © 2017-2027年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STUITableViewCellAction.h"
@interface UITableView(ST)

#pragma mark 核心扩展
typedef void(^OnAddTableCell)(UITableViewCell *cell,NSIndexPath *indexPath);
typedef BOOL(^OnDelTableCell)(UITableViewCell *cell,NSIndexPath *indexPath);
typedef void(^OnAddTableCellAction)(STUITableViewCellAction *cellAction, NSIndexPath *indexPath);
typedef bool(^OnAddTableCellMove)(UITableView *tableView,NSIndexPath *sourceIndexPath,NSIndexPath *destinationIndexPath);
typedef void(^OnAddTableSectionHeaderView)(UIView *sectionHeaderView,NSInteger section);
typedef void(^OnAddTableSectionFooterView)(UIView *sectionFooterView,NSInteger section);
typedef void(^OnAfterTableReloadData)(UITableView *tableView);
//!用于为Table追加每一行的Cell
@property (nonatomic,copy) OnAddTableCell addCell;
//!用于为Table追加每一行的Cell的滑动菜单
@property (nonatomic,copy) OnAddTableCellAction addCellAction;
//!用于为Table追加每一行的拖动
@property (nonatomic,copy) OnAddTableCellMove addCellMove;
//!用于为Table追加每一组Section的标题View
@property (nonatomic,copy) OnAddTableSectionHeaderView addSectionHeaderView;
@property (nonatomic,copy) OnAddTableSectionFooterView addSectionFooterView;
//!用于为Table移除行的Cell
@property (nonatomic,copy) OnDelTableCell delCell;
//!用于为Table reloadData 加载完数据后触发
@property (nonatomic,copy) OnAfterTableReloadData afterReload;
//!获取Table的数据源
@property (nonatomic,strong) NSMutableArray<id> *source;
//!设置Table的数据源
-(UITableView*)source:(NSMutableArray<id> *)dataSource;
//!存档所有Cell的高度（由系统控制）[存档格式为：section key,[row Array]]
@property (readonly,nonatomic,retain) NSMutableDictionary *heightForCells;

//!是否重用Cell（默认Yes)
-(BOOL)reuseCell;
-(BOOL)reuseCell:(BOOL)yesNo;
//!是否自动控制Table的高度
-(BOOL)autoHeight;
//!设置是否自动控制Table的高度
-(UITableView*)autoHeight:(BOOL)yesNo;
//!获取默认的UITableViewCellStyle
-(UITableViewCellStyle)cellStyle;
//!设置默认的UITableViewCellStyle
-(UITableView*)cellStyle:(UITableViewCellStyle)style;
//!获取是否允许编辑【删除】属性
-(BOOL)allowEdit;
//!设置是否允许编辑【删除】
-(UITableView*)allowEdit:(BOOL)yesNo;
//!移除数据源和数据行（并重新计算且刷新高度）
-(UITableView*)afterDelCell:(NSIndexPath*)indexPath;
#pragma mark 扩展属性
-(UITableView*)scrollEnabled:(BOOL)yesNo;
//!分组数（默认1）
-(UITableView*)sectionCount:(NSInteger)count;
//!每个Section的num数：参数可以传递：@[@"1",@"2",@"2",@"1"] 或者：@"1,2,2,1"
-(UITableView*)rowCountInSections:(id)nums;
@end
