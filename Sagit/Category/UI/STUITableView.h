//
//  STUITableView.h
//  IT恋
//
//  Created by 陈裕强 on 2017/12/23.
//  Copyright © 2017年 . All rights reserved.
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
