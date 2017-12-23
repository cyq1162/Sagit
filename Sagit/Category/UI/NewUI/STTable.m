//
//  STTable.m
//  IT恋
//
//  Created by 陈裕强 on 2017/12/23.
//  Copyright © 2017年 . All rights reserved.
//

#import "STTable.h"

@implementation STTable

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self=[super initWithFrame:frame style:style];
//    [self.tableFooterView hidden:YES];
//    [self.tableHeaderView hidden:YES];
    return self;
}
-(NSMutableArray<id> *)tableSource
{
    if(_tableSource==nil){_tableSource=[NSMutableArray new];}
    return _tableSource;
}
@end
