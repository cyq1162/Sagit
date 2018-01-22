//
//  UINavigationBar+STUINavigationController.m
//  IT恋
//
//  Created by 陈裕强 on 2017/12/19.
//  Copyright © 2017年 . All rights reserved.
//
#import "STUINavigationController.h"
#import "STUIView.h"
#import "STUIViewAddUI.h"
#import "STUIViewAutoLayout.h"
#import "STUIViewController.h"

//发现直接复盖原生的方法，Bug太多，只好用继承试试

@implementation UINavigationController(ST)

#pragma mark NavigationBar 的协议，这里触发
// fuck shouldPopItem 方法存在时，只会触发导航栏后退，界面视图却不后退。
//- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item  // same as push methods
//{
//
//    NSLog([@(navigationBar.items.count) stringValue]);
//    NSLog([@(self.viewControllers.count) stringValue]);
////    if([super.navigationBar.delegate navigationBar:navigationBar shouldPopItem:item])
////    {
////        NSLog(@"ok...");
////    }
////    else
////    {
////        NSLog(@"no..");
////
////    }
//    return YES;
////    NSLog(@"before...");
//////    //重设上一个Controller的导航（不然在二次Push后再Pop会Crash)
//////    NSInteger count=self.viewControllers.count;
//////    if(count>0)//发现这里返回的viewControllers，已经是移掉了当前的Controller后剩下的。
//////    {
//////        UIViewController *preController=self.viewControllers[count-1];//获取上一个控制器
//////        if([preController needNavBar])
//////        {
//////            [preController reSetNav:self];
//////        }
//////    }
//////
////    return YES;
//}
//-(void)resetBar
//{
//
//}
//返回到当前页面
- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item
{
    NSInteger count=self.viewControllers.count;
    if(count>0)
    {
        //找到关键，忽略全屏点击事件
        UIViewController *current=self.viewControllers[count-1];
        //current.view.userInteractionEnabled=NO;
        [current.view key:@"stopEvent" value:@"1"];
        self.navigationBar.hidden=![current needNavBar];
        if(self.tabBarController!=nil)
        {
            self.tabBarController.tabBar.hidden=![current needTabBar];
        }
        //检测上一个控制器有没有释放
        UIViewController *nextController=current.nextController;
        if(nextController)
        {
            [nextController dispose];
            nextController=nil;
        }
        [current.view key:@"stopEvent" value:nil];
        //current.view.userInteractionEnabled=YES;
    }
   
}
//-(void)dealloc
//{
//    NSLog(@"UINavigationController relase -> %@", [self class]);
//}
@end


