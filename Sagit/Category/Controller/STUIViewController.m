//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUIViewController.h"
#import <objc/runtime.h>
#import "STDictionary.h"
#import "STDefineFunc.h"
#import "STDefineUI.h"
#import "STUserDefaults.h"
#import "STUIView.h"
#import "STUIViewAddUI.h"
#import "STUIViewAutoLayout.h"
#import "STCategory.h"
#import "STSagit.h"
#import "STNavController.h"

@implementation UIViewController(ST)

//设置是否隐藏
- (BOOL)prefersStatusBarHidden {
    return ![self needStatusBar];
}

#pragma mark keyvalue
static char keyValueChar='k';
-(id)key:(NSString *)key
{
    id value=[self.keyValue get:key];
    if(value==nil)
    {
        value=[self.keyValueWeak get:key];
    }
    return value;
}
-(UIViewController*)key:(NSString *)key valueWeak:(id)value
{
    [self.keyValueWeak set:key value:value];
    return self;
}
-(UIViewController*)key:(NSString *)key valueIfNil:(id)value
{
    if([self key:key]==nil)
    {
        return [self key:key value:value];
    }
    return self;
}
-(UIViewController*)key:(NSString *)key value:(id)value
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
-(UIViewController*)setKeyValue:(NSMutableDictionary<NSString*,id>*)keyValue
{
    objc_setAssociatedObject(self, &keyValueChar, keyValue,OBJC_ASSOCIATION_RETAIN);
    return self;
}
-(NSMapTable*)keyValueWeak
{
    NSMapTable *kv=[self.keyValue get:@"keyValueWeak"];
    if(kv==nil)
    {
        kv=[NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableWeakMemory];
        [self.keyValue set:@"keyValueWeak" value:kv];
    }
    return kv;
}
#pragma mark 设置为默认的根视图

-(UIView *)baseView
{
    return self.view.baseView;
}

//获取上一个（父）控制器
-(UIViewController *)preController
{
    if(self.navigationController!=nil)
    {
        NSInteger count=self.navigationController.viewControllers.count;
        if(count>1)
        {
            NSInteger i=count-2;
            UIViewController *uic = self.navigationController.viewControllers[i];
            if([self isEqual:uic])
            {
                i--;
                if(i<0)
                {
                    return self;
                }
            }
            return self.navigationController.viewControllers[i];
        }
    }
    return self;
}
-(UIViewController *)nextController
{
    return [self key:@"nextController"];
}

- (UIViewController*)asRoot {
    
    return [self asRoot:RootViewDefaultType];
}
//将当前视图设置为根视图
-(UIViewController*)asRoot:(RootViewControllerType)rootViewControllerType{
    
    UIViewController *controller=self;
    if(rootViewControllerType==RootViewNavigationType)
    {
        controller = [[STNavController alloc]initWithRootViewController:self];
        ////让默认View在导航工具条之下。
        self.navigationController.navigationBar.translucent=NO;
    }
    UIWindow *win= [self keyWindow];
    UIViewController *root=win.rootViewController;
    if(root)//ios13 释放后才能添加。
    {
        if (@available(iOS 13.0, *)) {
            [root dispose];
            root=nil;
        }
    }
    win.rootViewController=controller;
    return self;
}
-(UIWindow*)keyWindow
{
    return [UIWindow mainWindow];
    
}
#pragma mark 导航栏、状态栏、Tab栏 显示隐藏
-(BOOL)needNavBar
{
    if([self key:@"needNavBar"]!=nil)
    {
        return [[self key:@"needNavBar"] isEqualToString:@"1"];
    }
    if(self.navigationController && self.navigationController.navigationBar)
    {
        return Sagit.Define.DefaultShowNav;
        //return !self.navigationController.navigationBar.hidden;
    }
    return NO;
}
-(UIViewController*)needNavBar:(BOOL)yesNo
{
    return [self needNavBar:yesNo forThisView:YES];
}
-(UIViewController*)needNavBar:(BOOL)yesNo forThisView:(BOOL)forThisView
{
    if(forThisView)
    {
        [self key:@"needNavBar" value:yesNo?@"1":@"0"];
    }
    if(self.navigationController!=nil)
    {
        //self.navigationController.navigationBar.isHidden=!yesNo
        [self.navigationController setNavigationBarHidden:!yesNo animated:NO];
    }
//    if(!yesNo)
//    {
 //       self.navigationController.interactivePopGestureRecognizer.enabled=yesNo;
   // }
    return self;
}

-(BOOL)needTabBar
{
    if([self key:@"needTabBar"]!=nil)
    {
        return [[self key:@"needTabBar"] isEqualToString:@"1"];
    }
    if(self.tabBarController && self.tabBarController.tabBar)
    {
        if(self.tabBarController.tabBar.hidden && self.navigationController && self.preController!=nil)
        {
            return NO;
        }
        return Sagit.Define.DefaultShowTab;
        //return !self.tabBarController.tabBar.hidden;
    }
    return NO;
}
-(UIViewController*)needTabBar:(BOOL)yesNo
{
    return [self needTabBar:yesNo forThisView:YES];
}
-(UIViewController*)needTabBar:(BOOL)yesNo forThisView:(BOOL)forThisView
{
    if(forThisView)
    {
        [self key:@"needTabBar" value:yesNo?@"1":@"0"];
    }
    if(self.tabBarController && self.tabBarController.tabBar)
    {
        self.tabBarController.tabBar.hidden=!yesNo;
        //self.hidesBottomBarWhenPushed=!yesNo;
    }
    return self;
}
-(BOOL)needStatusBar
{
    if([self key:@"needStatusBar"]!=nil)
    {
        return [[self key:@"needStatusBar"] isEqualToString:@"1"];
    }
    return Sagit.Define.DefaultShowStatus;
    //return ![UIApplication sharedApplication].statusBarHidden;
}
-(UIViewController*)needStatusBar:(BOOL)yesNo
{
    return [self needStatusBar:yesNo forThisView:YES];
}
-(UIViewController*)needStatusBar:(BOOL)yesNo forThisView:(BOOL)forThisView
{
    if(forThisView)
    {
        [self key:@"needStatusBar" value:yesNo?@"1":@"0"];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:!yesNo animated:NO];//隐藏
    if (@available(ios 13.0, *)) {
        if(yesNo)
        {
            [self.view.statusBar width:STScreenWidthPx height:STStatusHeightPx];
        }
        else{
            [self.view.statusBar width:0 height:0];
        }
    }
    [self setNeedsStatusBarAppearanceUpdate];//兼容View controller-based status bar appearance 为YES
    return self;
}
-(UIViewController *)setStatusBarStyle:(UIStatusBarStyle)style
{
    [self.keyWindow key:@"statusBarStyle" value:@(style)];//全局设置。
    return [self setStatusBarStyle:style forThisView:NO];
}
-(UIViewController *)setStatusBarStyle:(UIStatusBarStyle)style forThisView:(BOOL)forThisView
{
    if(forThisView)
    {
        [self key:@"statusBarStyle" value:@(style)];
    }
    UIApplication *app=[UIApplication sharedApplication];
    if(style==UIStatusBarStyleDarkContent)
    {
        if (@available(iOS 13.0, *)) {
        
        }
        else
        {
            style=UIStatusBarStyleDefault;
        }
    }
    [app setStatusBarStyle:style animated:YES];//Start中字颜色为黑,这里改白
    [self setNeedsStatusBarAppearanceUpdate];
    return self;
}
#pragma mark 导航栏：进入、退出
- (void)stPush:(UIViewController *)viewController
{
    [self stPush:viewController title:Sagit.Define.DefaultNavLeftTitle img:Sagit.Define.DefaultNavLeftImage];
}
- (void)stPush:(UIViewController *)viewController title:(NSString *)title
{
    [self stPush:viewController title:title img:nil];
}
- (void)stPush:(UIViewController *)viewController title:(NSString *)title img:(id)imgOrName
{
    UINavigationController *navC=self.navigationController;
    if(navC==nil){return;}
    
    if(self.tabBarController!=nil)//存档最后的Tab栏状态，用于检测是否还原。
    {
        [self key:@"needTabBar" valueIfNil:!self.tabBarController.tabBar.hidden?@"1":@"0"];
        self.tabBarController.tabBar.hidden=YES;
        //self.tabBarController.tabBar.translucent=NO;
        self.hidesBottomBarWhenPushed=YES;
        //又是一个坑，fuck，如果push一次，再切换tab，再切回来，就不见了,但成对出现在还原的时候需要设置为NO，就可以了，
        //（不用这个在5s下10.3//.1系统下，状态栏会空白不会取消。
    }
    [self key:@"needNavBar" valueIfNil:!navC.navigationBar.hidden?@"1":@"0"];

    [navC setNavigationBarHidden:NO animated:NO];

    navC.navigationBar.translucent=NO;//让默认View在导航工具条之下。

    if (navC.viewControllers.count != 0)
    {
        NSMutableDictionary *dic=[viewController key:STNavConfig];
        if(dic==nil)
        {
            dic=[NSMutableDictionary new];
            [viewController key:STNavConfig value:dic];
        }
        if(title)
        {
            [dic set:STNavLeftTitle value:title];
        }
        if(imgOrName)
        {
            [dic set:STNavLeftImage value:imgOrName];
        }
        [viewController reSetNav:navC];
    }
    
    [self key:@"nextController" valueWeak:viewController];//设置指向的下一个控制器（用于滑动返回时，若有循环引用无法释放时，补上一刀）
    navC.interactivePopGestureRecognizer.delegate=(id)navC;
    [navC pushViewController:viewController animated:YES];
}

//-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer
//
//{
//    [Sagit delayExecute:2 onMainThread:YES block:^{
//        [self reSetBarState:NO];
//    }];
//    return YES;
//}

-(void)reSetBarState:(BOOL)animated
{
    UINavigationController *navC=self.navigationController;
    if(navC==nil){return;}
    
    if([UIApplication sharedApplication].statusBarHidden==self.needStatusBar)//状态必须在导航之前
    {
        [UIApplication sharedApplication].statusBarHidden=!self.needStatusBar;
    }
    
    if(navC.navigationBar.hidden==self.needNavBar)
    {
        [navC setNavigationBarHidden:!self.needNavBar animated:animated];//全部统一用这个处理
    }
    if(self.tabBarController!=nil && self.tabBarController.tabBar.hidden==self.needTabBar)
    {
        //self.tabBarController.tabBar
        self.tabBarController.tabBar.hidden=!self.needTabBar;
        self.hidesBottomBarWhenPushed=!self.needTabBar;//这个要成对出现。。shit~~~
    }

    //递归检测上一个控制器有没有释放
    [self disposeNextController:self.nextController current:self animated:animated];
    
//    UIViewController *nextController=self.nextController;
//    if(nextController)
//    {
//        [nextController dispose];
//        [self key:@"nextController" valueWeak:nil];
//        if(animated){nextController=nil;}
//    }
}
-(void)disposeNextController:(UIViewController*)next current:(UIViewController*)current animated:(BOOL)animated
{
    if(next)
    {
        UIViewController *next2=[next key:@"nextController"];
        if(next2)
        {
            [self disposeNextController:next2 current:nil animated:animated];
            [next2 key:@"nextController" valueWeak:nil];
        }
        [next dispose];
        next=nil;
        if(current)
        {
            [current key:@"nextController" valueWeak:nil];
            //if(animated){next=nil;}
        }
//        else
//        {
//            next=nil;
//        }
    }
}
-(void)stPopToTop
{
    UINavigationController *navC=self.navigationController;
    if(navC)
    {
        NSInteger count=navC.viewControllers.count;
        if(count>1)
        {
//            for (int i=count-1; i>=1; i--) {
//                UIViewController *vc=navC.viewControllers[i];
//                [vc dispose];//释放内存。
//                [vc key:@"nextController" valueWeak:nil];
//                vc=nil;
//            }
            UIViewController *preController=navC.viewControllers[0];
            [preController reSetBarState:NO];
        }
        [navC popToRootViewControllerAnimated:YES];
    }
    else if([self isKindOfClass:[UINavigationController class]])
    {
        [((UINavigationController*)self) popToRootViewControllerAnimated:YES];
    }
}
- (void)stPop {
    UINavigationController *navC=self.navigationController;
    if(navC)
    {
        NSInteger count=navC.viewControllers.count;
        if(count>1)
        {
            UIViewController *preController=navC.viewControllers[count-2];
            [preController reSetBarState:NO];
        }
        [navC popViewControllerAnimated:YES];
    }
    else if([self isKindOfClass:[UINavigationController class]])
    {
        //什么鬼，升级到Xcode 9.2 二次push之后，第二次竟然已经到了Navigation了？ 修正图票事件后好了？
        [((UINavigationController*)self) popViewControllerAnimated:YES];
    }
}
//系统内部调用的方法
-(UIViewController*)reSetNav:(UINavigationController*)navController
{
    NSDictionary *dic=[self key:STNavConfig];
    if(dic!=nil)
    {
        //标题
        if(!self.title)
        {
            [self title:dic[STNavTitle]];
        }
        //左导航功能按钮
        [self leftNav:dic[STNavLeftTitle] img:dic[STNavLeftImage] navController:navController];
        //右导航功能按钮
        [self rightNav:dic[STNavRightTitle] img:dic[STNavRightImage]];
    }
    return self;
}
-(UIViewController*)leftNav:(NSString*)title img:(id)imgOrName
{
    return [self leftNav:title img:imgOrName navController:nil];
}
-(UIViewController*)leftNav:(NSString*)title img:(id)imgOrName navController:(UINavigationController*)navController
{
    if(self.navigationItem==nil){return self;}
    [self addNavButton:navController];
    if(imgOrName)
    {
        //这里引用的viewController在第二次回退时，出现了野指针问题。
        UIImage *img=[UIImage toImage:imgOrName];
        if(img.size.width*Xpx<120){
            //扩大点击范围。
            img= [img drawIn:STSizeMake(120, img.size.height*Ypx) point:CGPointZero];
        }
        self.navigationItem.leftBarButtonItem=
        [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStyleDone target:self action:@selector(leftNavClick:)];
    }
    else
    {
        if ([NSString isNilOrEmpty:title])
        {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
        }
        else if(![title eq:@"STEmpty"])
        {
             self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(leftNavClick:)];
        }
    }
    return self;
}
-(void)addNavButton:(UINavigationController*)navController
{
    if(navController==nil){navController=self.navigationController;if(navController==nil){return;}}
    UIButton * btn=nil;
    if(![navController.navigationBar.lastSubView isKindOfClass:[UIButton class]])
    {
        //创一张空View 显示
        btn=[[UIButton alloc] initWithFrame:STRectMake(0, 0, 180, STNavHeightPx)];
        [btn backgroundColor:ColorClear];
        //[btn backgroundColor:ColorRed];
        [navController.navigationBar addSubview:btn];
        //事件绑定到公用的Nav中。
        [btn addTarget:navController action:@selector(leftNavClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn addLongPress:@"leftNavBarLongPress" target:navController];
    }
    else
    {
        btn=(UIButton*)navController.navigationBar.lastSubView;
        [btn height:STNavHeightPx];//重设高度,在被pop这后，为了不影响其它自定义，高度会被置为0
    }
}
-(BOOL)onLeftNavBarLongPress:(UIBarButtonItem*)view
{
    return YES;
}
-(void)leftNavBarLongPress
{
    UIViewController *vc=self;
    if([self isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nc=(UINavigationController*)vc;
        NSInteger count=nc.viewControllers.count;
        vc=nc.viewControllers[count-1];
    }
    if([vc onLeftNavBarLongPress:vc.navigationItem.leftBarButtonItem])
    {
        [vc stPopToTop];
    }
}
//开放给用户的,左侧导航栏的默认点击事件 return YES 则系统调stPop返回方法。
-(BOOL)onLeftNavBarClick:(UIBarButtonItem*)view
{
    return YES;
}
//系统的
-(void)leftNavClick:(id)view
{
    UIViewController *vc=self;
    if([self isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nc=(UINavigationController*)vc;
        NSInteger count=nc.viewControllers.count;
        vc=nc.viewControllers[count-1];
    }
    if([vc onLeftNavBarClick:vc.navigationItem.leftBarButtonItem])
   {
       [vc stPop];
   }
    
}
-(UIViewController*)rightNav:(NSString*)title img:(id)imgOrName
{
    if(self.navigationItem==nil){return self;}
    if(imgOrName)
    {
        self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithImage:[UIImage toImage:imgOrName] style:UIBarButtonItemStyleDone target:self action:@selector(rightNavClick:)];
    }
    else if(![NSString isNilOrEmpty:title])
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(rightNavClick:)];
    }
    else
    {
        self.navigationItem.rightBarButtonItem=[UIBarButtonItem new];
    }
    return self;
}
-(void)rightNavClick:(UIBarButtonItem*)view
{
    if(view!=nil)
    {
        
        view.enabled=NO;
        [self onRightNavBarClick:view];
        [Sagit delayExecute:2 onMainThread:YES block:^{
            if(view)
            {
                view.enabled=YES;
            }
        }];
        
    }
}
//用于被用户复盖方法
-(void)onRightNavBarClick:(UIBarButtonItem*)view
{
    
}
-(void)redirect:(UIView*)view{
    if(view==nil){return;}
    NSString* name=[view key:@"clickSel"];
    if(name!=nil)
    {
        if(![name hasSuffix:@"Controller"])
        {
            name=[name append:@"Controller"];
        }
        Class class=NSClassFromString(name);
        if(class!=nil)
        {
            STController *controller=[class new];
            if(self.navigationController!=nil)
            {
                NSDictionary *config=[view key:STNavConfig];
                if(config!=nil)
                {
                    [controller key:STNavConfig value: [config toNSMutableDictionary]];
                    [self stPush:controller title:nil img:nil];
                }
                else
                {
                    [self stPush:controller];
                }
                
            }
            else
            {
                [self presentViewController:controller animated:YES completion:nil];
            }
        }
    }
}
-(UIViewController *)hideNavShadow
{
    if([self isKindOfClass:[UINavigationController class]])
    {
        [((UINavigationController*)self).navigationBar setShadowImage:[UIImage new]];
    }
    else if(self.navigationController)
    {
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }
    return self;
}
#pragma mark 共用接口
//子类重写
-(void)reloadData{}
-(void)reloadData:(NSString*)para{}

#pragma mark 代码说明块
-(UIViewController *)block:(OnControllerDescription)descBlock
{
    return [self block:nil on:descBlock];
}
-(UIViewController*)block:(NSString*)description on:(OnControllerDescription)descBlock
{
    if(descBlock!=nil)
    {
        //STWeakSelf;
        descBlock(self);
        descBlock=nil;
    }
    return self;
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
-(UIViewController*)tabImage:(id)imgOrName
{
    if([imgOrName isKindOfClass:[NSString class]])
    {
        self.tabBarItem.image=STImageOriginal(imgOrName);
    }
    else
    {
        self.tabBarItem.image=[UIImage toImage:imgOrName];
    }
    return self;
}
-(UIViewController*)tabSelectedImage:(id)imgOrName
{
    if([imgOrName isKindOfClass:[NSString class]])
    {
        self.tabBarItem.selectedImage=STImageOriginal(imgOrName);
    }
    else
    {
        self.tabBarItem.selectedImage=[UIImage toImage:imgOrName];
    }
    return self;
}
-(UIViewController*)tabBadgeValue:(NSString*)value
{
    self.tabBarItem.badgeValue=value;
    return self;
}
-(UIViewController*)tabBadgeColor:(id)colorOrHex
{
    self.tabBarItem.badgeColor=[UIColor toColor:colorOrHex];
    return self;
}
-(UINavigationController*)toUINavigationController
{
    if(self.navigationController!=nil){return self.navigationController;}
    return [[STNavController alloc]initWithRootViewController:self];
}
//!框架自动释放资源（不需要人工调用）
-(void)dispose
{
    @try
    {
        [self.view dispose];//清除自身资源
        //清理键值对。
        NSMutableDictionary *dic=self.keyValue;
        if(dic!=nil)
        {
            NSMapTable *kv=[self.keyValue get:@"keyValueWeak"];
            if(kv!=nil)
            {
                [kv removeAllObjects];
                kv=nil;
            }
            [dic removeAllObjects];
            dic=nil; //不设置为Null，因为在回退到前一个时，还要检测有没有nextControlelr。
        }
    }
    @catch(NSException *err){}
}
//fuck 这个dealloc不能存在，会影响UIAlertView，当alertViewStyle=UIAlertViewStylePlainTextInput;时，内存错误。
//-(void)dealloc
//{
//    //self.view=nil;//处理内存释放后的异常。
//    NSLog(@"UIViewController relase -> %@", [self class]);
//}redire
@end
