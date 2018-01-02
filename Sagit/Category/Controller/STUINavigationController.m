//
//  UINavigationBar+STUINavigationController.m
//  IT恋
//
//  Created by 陈裕强 on 2017/12/19.
//  Copyright © 2017年 . All rights reserved.
//

#import "STUINavigationController.h"


@implementation UINavigationController (ST)
//返回到当前页面
- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item
{
    if(navigationBar!=nil && [navigationBar.lastSubView isKindOfClass:[UIButton class]])
    {
        [navigationBar.lastSubView height:0];//取消自定义复盖的UIButton
    }
    NSInteger count=self.navigationController.viewControllers.count;
    if(count>0)
    {
        UIView *currentView=self.navigationController.viewControllers[count-1].view;
        self.navigationController.navigationBar.hidden=![currentView needNavBar];
        if(self.tabBarController!=nil)
        {
            self.tabBarController.tabBar.hidden=![currentView needTabBar];
        }
    }
}

@end
