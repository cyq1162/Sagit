//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (ST)

#pragma mark 系统事件
typedef  void(^onAction)(id control);
////!执行点击事件
//-(UIControl*)action;
////!绑定事件 event：指定事件名称，也可以是控制器名称，也可以指向其它UI的事件，如：Age.click (Age是其它UI的name）
//-(UIControl*)addAction:(NSString*)event;
////!绑定事件 并指定target
//-(UIControl*)addAction:(NSString *)event target:(UIViewController*)target;
////!绑定事件 用代码块的形式
//-(UIControl*)onAction:(onAction)block event:(UIControlEvents)event;
////!移除绑定点击事件
//-(UIControl*)removeAction;
-(UIControl*)onAction:(UIControlEvents)event on:(onAction)block;
#pragma mark 系统属性
-(UIControl*)enabled:(BOOL)yesNo;
-(UIControl *)selected:(BOOL)yesNo;
-(UIControl *)highlighted:(BOOL)yesNo;
@end
