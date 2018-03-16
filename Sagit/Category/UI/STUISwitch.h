//
//  STUISwitch.h
//  IT恋
//
//  Created by 陈裕强 on 2018/1/1.
//  Copyright © 2018年 . All rights reserved.
//

#import "STController.h"

@interface UISwitch(ST)

#pragma mark 事件
typedef  void(^onSwitch)(UISwitch *view);
//!绑定事件 event：指定事件名称，也可以是控制器名称，也可以指向其它UI的事件，如：Age.click (Age是其它UI的name）
//-(UIView*)addSwitch:(NSString*)event;
//!绑定事件 并指定target
//-(UIView*)addSwitch:(NSString *)event target:(UIViewController*)target;
//!绑定事件 用代码块的形式
-(UIView*)onSwitch:(onSwitch)block;

#pragma mark 属性扩展
-(UISwitch*)on:(BOOL)yesNo;
-(UISwitch*)tintColor:(id)colorOrHex;
-(UISwitch*)onTintColor:(id)colorOrHex;
-(UISwitch*)enabled:(BOOL)yesNo;
-(UISwitch*)onImage:(id)imgOrName;
-(UISwitch*)offImage:(id)imgOrName;
@end
