//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//
//  Copyright © 2017-2027年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STUITableViewCellAction.h"

@interface UITableViewCell(ST)
//!获取当前所在的table,(weak，不能造成双strong引用)
@property (readonly,nonatomic,weak) UITableView *table;
//!获取Cell的数据源
@property (nonatomic,strong) id source;

//!Cell是否重用的Cell，如果是，就不要再添加子控制，避免重复添加。
//@property (readonly,nonatomic,assign) BOOL isReused;
//!设置Cell的数据源
-(UITableViewCell *)source:(id)dataSource;
//!创建或复用Cell
+ (instancetype)reuseCell:(UITableView *)tableView index:(NSIndexPath *)index;
//!获取Cell所在的行数
-(NSIndexPath*)indexPath;
-(UITableViewCell*)indexPath:(NSIndexPath*)indexPath;
//!获取是否允许编辑【删除】属性
-(BOOL)allowEdit;
//!设置是否允许编辑【删除】
-(UITableViewCell*)allowEdit:(BOOL)yesNo;
//!数据源中的第一个字段，系统自动设置
-(NSString*)firstValue;
-(UITableViewCell*)firstValue:(NSString*)value;
//!当Cell的高度在绑定后，需要动态根据子内容高度变化，再次刷新高度时使用。
-(UITableViewCell*)resetHeightCache;
//!刷新表格高度
-(void)refleshTableHeight;
#pragma mark 扩展属性
-(UITableViewCell*)accessoryType:(UITableViewCellAccessoryType)type;
-(UITableViewCell*)selectionStyle:(UITableViewCellSelectionStyle)style;
#pragma mark 扩展
//!获取Cell的滑动菜单项。
@property (nonatomic,strong) STUITableViewCellAction *action;
@end
