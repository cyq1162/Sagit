//
//  STUIViewEvent.h
//  IT恋
//
//  Created by 陈裕强 on 2017/12/25.
//  Copyright © 2017年 Silan Xie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (STUIViewEvent)
//可以附加的点击事件 (存档在keyvalue中时，无法传参（内存地址失效），只能针对性存runtime的属性)
typedef  void(^onClick)(id view);
typedef  void(^onLongPress)(id view);
typedef  void(^ViewDescription)(id view);
#pragma mark 扩展系统事件
//!执行点击事件
-(UIView*)click;
//!绑定事件 event：指定事件名称，也可以是控制器名称，也可以指向其它UI的事件，如：Age.click (Age是其它UI的name）
-(UIView*)click:(NSString*)event;
//!绑定事件 并指定target
-(UIView*)click:(NSString *)event target:(UIViewController*)target;
//!绑定事件 用代码块的形式
- (UIView*)addClick:(onClick)block;

//!执行长按事件
-(UIView*)longPress;
//!绑定事件 event：指定事件名称，也可以是控制器名称，也可以指向其它UI的事件，如：Age.click (Age是其它UI的name）
-(UIView*)longPress:(NSString*)event;
//!绑定事件 并指定target
-(UIView*)longPress:(NSString *)event target:(UIViewController*)target;
//!绑定事件 用代码块的形式
-(UIView*)addLongPress:(onLongPress)block;

#pragma mark 增加描述
//!提供一个代码块，方便代码规范 description处可以写代码块的说明文字
-(void)block:(NSString*)description on:(ViewDescription)descBlock;
@end
