//
//  STTabController.m
//  IT恋
//
//  Created by 陈裕强 on 2017/12/24.
//  Copyright © 2017年. All rights reserved.
//

#import "STTabController.h"
#import "STUIView.h"

@implementation STTabController

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
-(void)initData
{
    
}
-(void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers
{
    if(viewControllers==nil){return;}
    for (NSInteger i=0; i<viewControllers.count; i++)
    {
        [self addChildViewController:viewControllers[i]];
    }
}
-(void)addChildViewController:(UIViewController *)childController
{
    if(childController==nil){return;}
    if(childController.navigationController!=nil)
    {
        [childController.navigationController.viewControllers[0].view needTabBar:YES setTabBar:YES];
    }
    else
    {
        [childController.view needTabBar:YES setTabBar:YES];
    }
    [super addChildViewController:childController];
}
@end
