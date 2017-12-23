//
//  STTable.h
//  IT恋
//
//  Created by 陈裕强 on 2017/12/23.
//  Copyright © 2017年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTableCell.h"
@interface STTable : UITableView
typedef void(^AddCell)(STTableCell *cell);
@property (nonatomic,retain) NSMutableArray<id> *tableSource;
@property (nonatomic,copy) AddCell addCell;
@end
