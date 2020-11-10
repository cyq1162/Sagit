//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STController.h"

@interface UICollectionView(ST)
#pragma mark 核心扩展
typedef void(^OnAddCollectionCell)(UICollectionViewCell *cell,NSIndexPath *indexPath);
typedef BOOL(^OnDelCollectionCell)(UICollectionViewCell *cell,NSIndexPath *indexPath);
//!用于为Table追加每一行的Cell
@property (nonatomic,copy) OnAddCollectionCell addCell;
//!用于为Table移除行的Cell
@property (nonatomic,copy) OnDelCollectionCell delCell;
//!获取Table的数据源
@property (nonatomic,strong) NSMutableArray<id> *source;
//!设置Table的数据源
-(UITableView*)source:(NSMutableArray<id> *)dataSource;
@end
