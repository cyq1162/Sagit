//
//  STUITableView.m
//  IT恋
//
//  Created by 陈裕强 on 2017/12/23.
//  Copyright © 2017年. All rights reserved.
//

#import "STUITableView.h"

@implementation UITableView(ST)
-(UITableView*)scrollEnabled:(BOOL)yesNo
{
    self.scrollEnabled=yesNo;
    //[self isScrollEnabled:yesNo];
    return self;
}
@end
