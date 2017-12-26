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
typedef  void(^onClick)(UIView *view);
typedef  void(^onLongPress)(UIView *view);
typedef  void(^onDescription)(UIView *view);
#pragma mark 扩展系统事件
//触发事件
-(UIView*)click;
//绑定事件
-(UIView*)click:(NSString*)event;
-(UIView*)click:(NSString *)event target:(UIViewController*)target;
- (UIView*)addClick:(onClick)block;
//触发事件
-(UIView*)longPress;
//绑定事件
-(UIView*)longPress:(NSString*)event;
-(UIView*)longPress:(NSString *)event target:(UIViewController*)target;
-(UIView*)addLongPress:(onLongPress)block;

#pragma mark 增加描述
-(void)block:(NSString*)description on:(onDescription)descBlock;
@end
