//
//  STTableCell.h
//  IT恋
//
//  Created by 陈裕强 on 2017/12/23.
//  Copyright © 2017年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STTableCell : UITableViewCell
@property (nonatomic,retain) NSMutableDictionary<NSString*,id> *cellSource;
//创建或复用Cell
+ (instancetype)reuseCell:(UITableView *)tableView index:(NSIndexPath *)index;
@end
