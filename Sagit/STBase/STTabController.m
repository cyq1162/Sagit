//
//  STTabController.m
//  IT恋
//
//  Created by 陈裕强 on 2017/12/24.
//  Copyright © 2017年. All rights reserved.
//

#import "STTabController.h"

@implementation STTabController

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
