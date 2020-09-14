//
//  STNavController.m
//
//  Created by 陈裕强 on 2020/9/12.
//

#import "STNavController.h"

@implementation STNavController

#pragma mark ios 13.6 不能用扩展属性 处理的。

//!屏幕旋转
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}
//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.topViewController preferredStatusBarStyle];
}
#pragma mark NavigationBar 的协议，这里触发
- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item
{
    NSInteger count=self.viewControllers.count;
    if(count>0)
    {
        //找到关键，忽略全屏点击事件
        UIViewController *current=self.viewControllers[count-1];
        [current reSetBarState:YES];
    }
}

@end
