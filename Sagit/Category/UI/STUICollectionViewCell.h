//
//  STUICollectionViewCell.h
//  IT恋
//
//  Created by 陈裕强 on 2017/12/29.
//  Copyright © 2017年 Silan Xie. All rights reserved.
//

#import "STController.h"

@interface UICollectionViewCell(ST)
//!获取Cell的数据源
@property (nonatomic,strong) NSMutableDictionary<NSString*,id> *source;
//!设置Cell的数据源
-(UICollectionViewCell *)source:(NSMutableDictionary<NSString*,id> *)dataSource;
//!创建或复用Cell
+ (instancetype)reuseCell:(UICollectionView *)tableView index:(NSIndexPath *)index;
//!获取当前所在的table
-(UICollectionView*)table;

//!获取是否允许删除属性
//-(BOOL)allowDelete;
//!设置是否允许删除
//-(UITableView*)allowDelete:(BOOL)yesNo;
//!数据源中的第一个字段，系统自动设置
-(NSString*)firstValue;
-(UICollectionViewCell*)firstValue:(NSString*)value;
@end
