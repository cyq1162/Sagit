//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIViewController(ST)
- (UIViewController*)setRoot:(UIViewController *)rootViewController;
//自定义导航的工具条为自己的图标或文字
- (void)stPush:(UIViewController *)viewController;
- (void)stPush:(UIViewController *)viewController title:(NSString *)title;
- (void)stPush:(UIViewController *)viewController title:(NSString *)title imgName:(NSString *)imgName;
- (void)stPop;
@end
