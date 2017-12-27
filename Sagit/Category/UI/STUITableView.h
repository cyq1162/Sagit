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
typedef void(^AddCell)(UITableViewCell *cell,NSIndexPath *indexPath);
//!用于为Table追加每一行的Cell
@property (nonatomic,copy) AddCell addCell;
//!获取Table的数据源
@property (nonatomic,strong) NSMutableArray<id> *source;
//!设置Table的数据源
-(UITableView*)source:(NSMutableArray<id> *)dataSource;
//!是否自动控制Table的高度
-(BOOL)autoHeight;
//!设置是否自动控制Table的高度
-(UITableView*)autoHeight:(BOOL)yesNo;

#pragma mark 扩展属性
-(UITableView*)scrollEnabled:(BOOL)yesNo;
@end
