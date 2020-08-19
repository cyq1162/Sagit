//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUIViewController.h"
#import <objc/runtime.h>
#import "STDictionary.h"
#import "STDefine.h"
#import "STDefineUI.h"
#import "STUIView.h"
#import "STUIViewAddUI.h"
#import "STUIViewAutoLayout.h"
#import "Sagit.h"

@implementation UIViewController(ST)
//ios 13.2 弹新窗兼容（13.2 可以用）
//- (UIModalPresentationStyle)modalPresentationStyle{
//    return UIModalPresentationFullScreen;
//}
//-(UIView *)view
//{
//    UIView *view=[self key:@"view"];
//    if(!view)
//    {
//        view=[[STView alloc]initWithController:self];
//        [self key:@"view" value:view];
//    }
//    return view;
//}

//此方法在第一次view时被触发，把view修改成 STView
//-(void)loadView
//{
//     // 引发UIAlertView弹窗全屏(把导航栏也占了,背景也全灰了)，所以不用了
//   // self.view=[[STView alloc]initWithController:self];
//}

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
            return self.navigationController.viewControllers[count-2];
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
        controller = [[UINavigationController alloc]initWithRootViewController:self];
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
     if (@available(iOS 13.0, *)) {
         // 获取keywindow
         NSArray *array = [UIApplication sharedApplication].windows;
         UIWindow *window = [array objectAtIndex:0];
      
          //  判断取到的window是不是keywidow
         if (!window.hidden || window.isKeyWindow) {
             return window;
         }
      
         //  如果上面的方式取到的window 不是keywidow时  通过遍历windows取keywindow
         for (UIWindow *window in array) {
             if (!window.hidden || window.isKeyWindow) {
                 return window;
             }
         }
    }
    UIApplication *app=[UIApplication sharedApplication];
    UIWindow *win=app.keyWindow;
    if(win!=nil)
    {
        return win;
    }
    return app.delegate.window;}
#pragma mark 导航栏、状态栏、Tab栏 显示隐藏
-(BOOL)needNavBar
{
    if([self key:@"needNavBar"]!=nil)
    {
        return [[self key:@"needNavBar"] isEqualToString:@"1"];
    }
    if(self.navigationController && self.navigationController.navigationBar)
    {
        return STDefaultShowNav;
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
        [self.navigationController setNavigationBarHidden:!yesNo animated:NO];
    }
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
        return STDefaultShowTab;
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
    return STDefaultShowStatus;
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

    return self;
}
#pragma mark 导航栏：进入、退出
- (void)stPush:(UIViewController *)viewController
{
    [self stPush:viewController title:STDefaultForNavLeftTitle img:STDefaultForNavLeftImage];
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

    //检测上一个控制器有没有释放
    UIViewController *nextController=self.nextController;
    if(nextController)
    {
        [nextController dispose];
        [self key:@"nextController" valueWeak:nil];
        if(animated){nextController=nil;}
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
        NSLog(@"发生了...");
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
    if(imgOrName)
    {
        //这里引用的viewController在第二次回退时，出现了野指针问题。
        self.navigationItem.leftBarButtonItem=
        [[UIBarButtonItem alloc] initWithImage:[UIView toImage:imgOrName] style:UIBarButtonItemStyleDone target:self action:@selector(leftNavClick:)];
    }
    else
    {
        if ([NSString isNilOrEmpty:title])
        {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
        }
        else if([title eq:@"STEmpty"])
        {
            if(navController==nil){navController=self.navigationController;if(navController==nil){return self;}}
            UIButton * btn=nil;
            if(![navController.navigationBar.lastSubView isKindOfClass:[UIButton class]])
            {
                //创一张空View 显示
                btn=[[UIButton alloc] initWithFrame:STRectMake(0, 0, 200, STNavHeightPx)];
                [btn backgroundColor:ColorClear];
                [navController.navigationBar addSubview:btn];
            }
            else
            {
                btn=(UIButton*)navController.navigationBar.lastSubView;
                [btn height:STNavHeightPx];//重设高度,在被pop这后，为了不影响其它自定义，高度会被置为0
            }
            
            //移除事件，避免target指向一个旧的viewController
            [btn removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
            [btn addTarget:self action:@selector(leftNavClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        else
        {
             self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(leftNavClick:)];
        }
    }
    return self;
}
//开放给用户的,左侧导航栏的默认点击事件 return YES 则系统调stPop返回方法。
-(BOOL)onLeftNavBarClick:(id)view
{
    return YES;
}
//系统的
-(void)leftNavClick:(id)view
{
   if([self onLeftNavBarClick:view])
   {
       [self stPop];
   }
    
}
-(UIViewController*)rightNav:(NSString*)title img:(id)imgOrName
{
    if(self.navigationItem==nil){return self;}
    if(imgOrName)
    {
        self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithImage:[UIView toImage:imgOrName] style:UIBarButtonItemStyleDone target:self action:@selector(rightNavClick:)];
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
-(UIViewController*)block:(NSString*)description on:(ControllerDescription)descBlock
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
        self.tabBarItem.image=[UIView toImage:imgOrName];
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
        self.tabBarItem.selectedImage=[UIView toImage:imgOrName];
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
    self.tabBarItem.badgeColor=[self.view toColor:colorOrHex];
    return self;
}
-(UINavigationController*)toUINavigationController
{
    if(self.navigationController!=nil){return self.navigationController;}
    return [[UINavigationController alloc]initWithRootViewController:self];
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
