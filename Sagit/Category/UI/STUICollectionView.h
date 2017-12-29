//
//  STUICollectionView.h
//  IT恋
//
//  Created by 陈裕强 on 2017/12/29.
//  Copyright © 2017年 Silan Xie. All rights reserved.
//

#import "STController.h"

@interface UICollectionView(ST)
#pragma mark 核心扩展
typedef void(^AddCollectionCell)(UICollectionViewCell *cell,NSIndexPath *indexPath);
typedef BOOL(^DelCollectionCell)(UICollectionViewCell *cell,NSIndexPath *indexPath);
//!用于为Table追加每一行的Cell
@property (nonatomic,copy) AddCollectionCell addCell;
//!用于为Table移除行的Cell
@property (nonatomic,copy) DelCollectionCell delCell;
//!获取Table的数据源
@property (nonatomic,strong) NSMutableArray<id> *source;
//!设置Table的数据源
-(UITableView*)source:(NSMutableArray<id> *)dataSource;
@end
