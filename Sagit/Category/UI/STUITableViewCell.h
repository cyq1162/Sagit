//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell(ST)
//!获取Cell的数据源
@property (nonatomic,strong) NSMutableDictionary<NSString*,id> *source;
//!设置Cell的数据源
-(UITableViewCell *)source:(NSMutableDictionary<NSString*,id> *)dataSource;
//!创建或复用Cell
+ (instancetype)reuseCell:(UITableView *)tableView index:(NSIndexPath *)index;
@end
