//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUIViewController.h"
#import <objc/runtime.h>

@implementation UIViewController(ST)

#pragma mark keyvalue
static char keyValueChar='k';
-(id)key:(NSString *)key
{
    return self.keyValue[key];
}
-(UIView*)key:(NSString *)key value:(id)value
{
    [self.keyValue set:key value:value];
    return self;
}
-(NSMutableDictionary<NSString*,id>*)keyValue
{
    
    NSMutableDictionary<NSString*,id> *kv= (NSMutableDictionary<NSString*,id>*)objc_getAssociatedObject(self, &keyValueChar);
    if(kv==nil)
    {
        kv=[NSMutableDictionary<NSString*,id> new];
        [self setKeyValue:kv];
    }
    return kv;
}
-(UIView*)setKeyValue:(NSMutableDictionary<NSString*,id>*)keyValue
{
    objc_setAssociatedObject(self, &keyValueChar, keyValue,OBJC_ASSOCIATION_RETAIN);
    return self;
}

#pragma mark 设置为默认的根视图
//获取上一个（父）控制器
-(UIViewController *)preController
{
    if(self.navigationController!=nil)
    {
        NSInteger count=self.navigationController.viewControllers.count;
        if(count>1)
        {
            return self.navigationController.viewControllers[count-2];
        }
    }
    return self;
}

- (UIViewController*)asRoot {
    
    return [self asRoot:RootViewDefaultType];
}
//将当前视图设置为根视图
-(UIViewController*)asRoot:(RootViewControllerType)rootViewControllerType{
    
    UIViewController *controller=self;
    if(rootViewControllerType==RootViewNavigationType)
    {
        controller = [[UINavigationController alloc]initWithRootViewController:self];
    }
    [UIApplication sharedApplication].delegate.window.rootViewController=controller;
    return self;
}

#pragma mark 导航栏功能

- (void)stPush:(UIViewController *)viewController title:(NSString *)title img:(id)imgOrName
{
    if(self.navigationController==nil){return;}
    [self block:@"存档最后的Tab栏状态，用于检测是否还原。" on:^(UIViewController *controller)
    {
        if(controller.tabBarController!=nil)//存档最后的Tab栏状态，用于检测是否还原。
        {
            [controller.view needTabBar:!self.tabBarController.tabBar.hidden];
            controller.tabBarController.tabBar.hidden=YES;
        }
    }];
    [self block:@"存档最后的Nav栏状态，用于检测是否还原。" on:^(UIViewController *controller)
     {
         [controller.view needNavBar:!controller.navigationController.navigationBar.hidden];//存档最后的导航栏状态，用于检测是否还原。
         controller.navigationController.navigationBar.hidden=NO;//显示返回导航工具条。
         controller.navigationController.navigationBar.translucent=NO;//让默认View在导航工具条之下。
     }];

    if (self.navigationController.viewControllers.count != 0)
    {
        NSDictionary *dic=[viewController key:STNavConfig];
        if(dic!=nil)
        {
            if(!title){title=dic[STNavLeftTitle];}
            if(!imgOrName){imgOrName=dic[STNavLeftImage];}
            //处理标题：
            if(!viewController.title)
            {
                [viewController title:dic[STNavTitle]];
            }
            [viewController rightNav:dic[STNavRightTitle] img:dic[STNavRightImage]];
        }
        //右导航功能按钮
        if (title!=nil)
        {
            if([title isEqualToString:@""])
            {
                viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem new];
            }
            else
            {
            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:viewController action:@selector(stPop)];
            }
        }
        else if(imgOrName)
        {
            viewController.navigationItem.leftBarButtonItem =
            [[UIBarButtonItem alloc] initWithImage:[UIView toImage:imgOrName] style:UIBarButtonItemStyleDone target:viewController action:@selector(stPop)];
        }
        else
        {
            UIButton * btn=nil;
            if(![self.navigationController.navigationBar.lastSubView isKindOfClass:[UIButton class]])
            {
                //创一张空View 显示
                btn=[[UIButton alloc] initWithFrame:STRectMake(0, 0, 200, STNavHeightPx)];
                [btn backgroundColor:ColorClear];
                [self.navigationController.navigationBar addSubview:btn];
            }
            else
            {
                btn=(UIButton*)self.navigationController.navigationBar.lastSubView;
                [btn height:STNavHeightPx];//重设高度,在被pop这后，为了不影响其它自定义，高度会被置为0
            }
            
            //移除事件，避免target指向一个旧的viewController
            [btn removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
            [btn addTarget:viewController action:@selector(stPop) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }

    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self.navigationController;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)stPop {
    if(self.navigationController!=nil)
    {
        NSInteger count=self.navigationController.viewControllers.count;
        UIView *preView=self.navigationController.viewControllers[count-2].view;
        self.navigationController.navigationBar.hidden=![preView needNavBar];
        if(self.tabBarController!=nil)
        {
            self.tabBarController.tabBar.hidden=![preView needTabBar];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(UIViewController*)rightNav:(NSString*)title img:(id)imgOrName
{
    if(self.navigationItem==nil){return self;}
    if(title)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(onRightNavBarClick:)];
    }
    else if(imgOrName)
    {
        self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithImage:[UIView toImage:imgOrName] style:UIBarButtonItemStyleDone target:self action:@selector(onRightNavBarClick:)];
    }
    else
    {
        self.navigationItem.leftBarButtonItem=[UIBarButtonItem new];
    }
    return self;
}
-(void)onRightNavBarClick:(UIView*)view
{
    
}
#pragma mark 共用接口
//子类重写
-(void)reloadData{}
-(void)reloadData:(NSString*)para{}

#pragma mark 代码说明块
-(void)block:(NSString*)description on:(ControllerDescription)descBlock
{
    if(descBlock!=nil)
    {
        STWeakSelf;
        descBlock(this);
    }
}

#pragma mark for TabBar 属性扩展
-(UIViewController*)title:(NSString*)title
{
    self.title=title;
    return self;
}
-(UIViewController*)tabTitle:(NSString*)title
{
    self.tabBarItem.title=title;
    return self;
}
-(UIViewController*)tabImage:(NSString*)imgName
{
    self.tabBarItem.image=STImageOriginal(imgName);
    return self;
}
-(UIViewController*)tabSelectedImage:(NSString*)imgName
{
    self.tabBarItem.selectedImage=STImageOriginal(imgName);
    return self;
}
-(UIViewController*)tabBadgeValue:(NSString*)value
{
    self.tabBarItem.badgeValue=value;
    return self;
}
-(UIViewController*)tabBadgeColor:(id)colorOrHex
{
    self.tabBarItem.badgeColor=[self.view toColor:colorOrHex];
    return self;
}
-(UINavigationController*)toUINavigationController
{
    if(self.navigationController!=nil){return self.navigationController;}
    return [[UINavigationController alloc]initWithRootViewController:self];
}
@end
