//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUIViewController.h"

@implementation UIViewController(ST)
- (UIViewController*)setRoot:(UIViewController *)rootViewController {
    
    [UIApplication sharedApplication].delegate.window.rootViewController=rootViewController;
    return self;
    //return;
    //    AppDelegate *delegate= (AppDelegate*)[UIApplication sharedApplication].delegate;
    //    delegate.window.rootViewController=rootController;
    
    
    //    typedef void (^Animation)(void);
    //    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    //
    //    rootViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //    Animation animation = ^{
    //        BOOL oldState = [UIView areAnimationsEnabled];
    //        [UIView setAnimationsEnabled:NO];
    //        [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
    //        [UIView setAnimationsEnabled:oldState];
    //    };
    //
    //    [UIView transitionWithView:window
    //                      duration:0.5f
    //                       options:UIViewAnimationOptionTransitionCrossDissolve
    //                    animations:animation
    //                    completion:nil];
}
//项目需要重写时，此方法留给具体项目重写。
- (void)stPush:(UIViewController *)viewController
{
    [self stPush:viewController title:nil imgName:nil];
}
- (void)stPush:(UIViewController *)viewController title:(NSString *)title
{
    [self stPush:viewController title:title imgName:nil];
}
- (void)stPush:(UIViewController *)viewController title:(NSString *)title imgName:(NSString *)imgName
{
    // || ([NSString isNilOrEmpty:imgName] && [NSString isNilOrEmpty:title])
    if(self.navigationController==nil){return;}
    self.navigationController.navigationBar.hidden=NO;//显示返回导航工具条。
    self.navigationController.navigationBar.translucent=NO;//让默认View在导般之前。
    
    
    
    if (self.navigationController.viewControllers.count != 0)
    {
        if (title)
        {
            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:viewController action:@selector(stPop)];
        }
        else if(imgName)
        {
            viewController.navigationItem.leftBarButtonItem =
            [[UIBarButtonItem alloc] initWithImage:STImage(imgName) style:UIBarButtonItemStyleDone target:viewController action:@selector(stPop)];
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
    //打开右滑返回交互。
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self.navigationController;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)stPop {
    if(self.navigationController!=nil)
    {
        if([self.navigationController.navigationBar.lastSubView isKindOfClass:[UIButton class]])
        {
            [self.navigationController.navigationBar.lastSubView height:0];//取消自定义复盖的UIButton
        }
        //如果上级就是根视图，就隐藏，否则仍显示
        if(self.navigationController.viewControllers.count==2)
        {
            self.navigationController.navigationBar.hidden=YES;//显示返回导航工具条。
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
