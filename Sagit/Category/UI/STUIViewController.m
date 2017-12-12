//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUIViewController.h"

@implementation UIViewController(ST)
- (void)setRoot:(UIViewController *)rootViewController {
    
    [UIApplication sharedApplication].delegate.window.rootViewController=rootViewController;
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
@end
