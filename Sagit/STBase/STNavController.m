//
//  STNavController.m
//
//  Created by 陈裕强 on 2020/9/12.
//

#import "STNavController.h"
#import "STUIViewController.h"
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
//- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item {
//    //只有一个控制器的时候禁止手势，防止卡死现象
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.interactivePopGestureRecognizer.enabled = NO;
//    }
//    if (self.childViewControllers.count > 1) {
//        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//            self.interactivePopGestureRecognizer.enabled = YES;
//        }
//    }
//    return YES;
//}
- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item
{
    NSInteger count=self.viewControllers.count;
    if(count>0)
    {
        //找到关键，忽略全屏点击事件
        UIViewController *current=self.viewControllers[count-1];
        [current reSetBarState:YES];
    }
//        //只有一个控制器的时候禁止手势，防止卡死现象
//        if (self.childViewControllers.count == 1) {
//            if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//                self.interactivePopGestureRecognizer.enabled = NO;
//            }
//        }
}

@end
