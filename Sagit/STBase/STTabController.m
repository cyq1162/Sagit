//
//  STTabController.m
//
//  Created by 陈裕强 on 2017/12/24.
//  Copyright © 2017年. All rights reserved.
//

#import "STTabController.h"
#import "STUIView.h"
#import "STUIViewController.h"
@implementation STTabController

#pragma mark ios 13.6 不能用扩展属性 处理的。
//! Presentation 弹新窗口兼容
- (UIModalPresentationStyle)modalPresentationStyle{
    return UIModalPresentationFullScreen;
}
//!屏幕旋转
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.selectedViewController supportedInterfaceOrientations];
}
//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.selectedViewController preferredStatusBarStyle];
}

-(instancetype)init
{
    self=[super init];
    //初始化全局设置，必须要在UI初始之前。
    [self onInit];
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
}

//在UI加载之前处理的
-(void)onInit{}
//加载UI时处理的
-(void)initUI{}
//加载UI后处理的
-(void)initData{}
-(void)beforeViewAppear{}
-(void)beforeViewDisappear{}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self beforeViewDisappear];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self beforeViewAppear];
}
-(void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated
{
    if(self.viewControllers.count>0)////清空旧的
    {
        for (NSInteger i=self.viewControllers.count-1; i>=0; i--) {
            [self.viewControllers[i] removeFromParentViewController];
        }
    }
    if(viewControllers==nil || viewControllers.count==0)
    {
        return;
    }
    [super setViewControllers:viewControllers animated:animated];
    for (NSInteger i=0; i<viewControllers.count; i++)
    {
        [self setBar:viewControllers[i]];
    }
}
-(void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers
{
    [self setViewControllers:viewControllers animated:NO];
}
-(void)addChildViewController:(UIViewController *)childController
{
    if(childController==nil){return;}
    [self setBar:childController];
    [super addChildViewController:childController];
}
-(void)setBar:(UIViewController*)controller
{
    if(controller==nil){return;}
    if(controller.navigationController!=nil)
    {
        [controller.navigationController.viewControllers[0] needTabBar:YES];
    }
    else
    {
        [controller needTabBar:YES];
    }
}
-(void)dealloc
{
    NSLog(@"STTabController relase -> %@", [self class]);
}
@end
