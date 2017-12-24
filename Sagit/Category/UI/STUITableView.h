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
@property (nonatomic,copy) AddCell addCell;
@property (nonatomic,strong) NSMutableArray<id> *source;
-(UITableView*)source:(NSMutableArray<id> *)dataSource;
-(BOOL)autoHeight;
-(UITableView*)autoHeight:(BOOL)yesNo;

#pragma mark 扩展属性
-(UITableView*)scrollEnabled:(BOOL)yesNo;
@end
