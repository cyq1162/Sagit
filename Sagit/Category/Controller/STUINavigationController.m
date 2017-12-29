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
//    //如果上级就是根视图，就隐藏，否则仍显示
//    if(self.viewControllers!=nil && self.viewControllers.count==1 && self.navigationBar!=nil)
//    {
//        if(![self.viewControllers[0].view needNavBar])
//        {
//            self.navigationBar.hidden=YES;
//        }
//        //显示返回导航工具条，如果是滑动的话，View会自动归位，但自定义事件返回，不归位（所以在自定义事件中也设置一下次）
//    }
    
}
//- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
//{
//    NSLog(@"should...");
//    long count=self.viewControllers.count;
//    return YES;
//}
@end
