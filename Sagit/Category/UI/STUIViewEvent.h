//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//
//  Copyright © 2017-2027年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STEnum.h"
@interface UIView (STUIViewEvent)
typedef  void(^OnAfterEvent)(NSString *eventType, id para);
//可以附加的点击事件 (存档在keyvalue中时，无法传参（内存地址失效），只能针对性存runtime的属性)
typedef  void(^OnViewClick)(id view);
//!双击事件
typedef  void(^OnViewDbClick)(id view);
typedef  BOOL(^OnViewDrag)(id view,UIPanGestureRecognizer *recognizer);
//!滑动事件：return true 滑动View；return false 不滑动View
typedef  void(^OnViewSlide)(id view,UISwipeGestureRecognizer *recognizer);
//!屏幕侧滑【只有左右事件】
typedef  void(^OnScreenEdgeSlide)(id view,UIScreenEdgePanGestureRecognizer *recognizer);
typedef  void(^OnLongPress)(id view);
//!定时器事件。
typedef  void(^OnTimer)(id view,NSTimer *timer, NSInteger count);
typedef  void(^OnViewDescription)(id view);

#pragma mark 扩展系统事件 - 点击
//!点击事件的间隔（单位秒s)
-(NSInteger)clickInterval;
//!设置点击事件的间隔（单位秒s)
-(UIView*)clickInterval:(NSInteger)sencond;
//!执行点击事件
-(UIView*)click;
//!绑定事件 event：指定事件名称，也可以是控制器名称，也可以指向其它UI的事件，如：Age.click (Age是其它UI的name）
-(UIView*)addClick:(NSString*)event;
//!绑定事件 event：指定事件名称，也可以是控制器名称，也可以指向其它UI的事件，如：Age.click (Age是其它UI的name） enlarge: 扩大点击范围（上下左右）大小。
-(UIView*)addClick:(NSString*)event enlarge:(CGFloat)value;
-(UIView*)addClick:(NSString*)event enlarge:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom;
//!绑定事件 并指定target
-(UIView*)addClick:(NSString *)event target:(UIViewController*)target;
-(UIView*)addClick:(NSString *)event target:(UIViewController*)target enlarge:(CGFloat)value;
-(UIView*)addClick:(NSString *)event target:(UIViewController*)target enlarge:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom;
//!绑定事件 用代码块的形式
-(UIView*)onClick:(OnViewClick)block;
//!绑定事件 用代码块的形式 enlarge: 扩大点击范围（上下左右）大小。
-(UIView*)onClick:(OnViewClick)block enlarge:(CGFloat)value;
-(UIView*)onClick:(OnViewClick)block enlarge:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom;
//!移除绑定点击事件
-(UIView*)removeClick;
#pragma mark 扩展系统事件 - 双击
//!执行双击事件
-(UIView*)dbClick;
//!绑定事件 event：指定事件名称，也可以是控制器名称，也可以指向其它UI的事件，如：Age.click (Age是其它UI的name）
-(UIView*)addDbClick:(NSString*)event;
//!绑定事件 并指定target
-(UIView*)addDbClick:(NSString *)event target:(UIViewController*)target;
//!绑定事件 用代码块的形式
-(UIView*)onDbClick:(OnViewClick)block;
//!移除绑定双击事件
-(UIView*)removeDbClick;
#pragma mark 扩展系统事件 - 长按
//!执行长按事件
-(UIView*)longPress;
//!绑定事件 event：指定事件名称，也可以是控制器名称，也可以指向其它UI的事件，如：Age.click (Age是其它UI的name）
-(UIView*)addLongPress:(NSString*)event;
//!绑定事件 并指定target
-(UIView*)addLongPress:(NSString *)event target:(UIViewController*)target;
//!绑定事件 用代码块的形式
-(UIView*)onLongPress:(OnLongPress)block;
//!移除绑定长按事件
-(UIView*)removeLongPress;

#pragma mark 扩展系统事件 - 拖动
//!执行拖动事件
-(UIView*)drag;
//!绑定事件 event：指定事件名称，也可以是控制器名称，也可以指向其它UI的事件，如：Age.drag (Age是其它UI的name）
-(UIView*)addDrag:(NSString*)event;
//!绑定事件 并指定target
-(UIView*)addDrag:(NSString *)event target:(UIViewController*)target;
//!绑定事件 用代码块的形式
-(UIView*)onDrag:(OnViewDrag)block;
//!绑定事件 用代码块的形式
-(UIView*)onDrag:(OnViewDrag)block direction:(DragDirection)direction;
//!移除绑定拖动事件
-(UIView*)removeDrag;

#pragma mark 扩展系统事件 - 滑动

//!绑定事件 event：指定事件名称，也可以是控制器名称，也可以指向其它UI的事件，如：Age.drag (Age是其它UI的name）
-(UIView*)addSlide:(NSString*)event;
//!绑定事件 并指定target
-(UIView*)addSlide:(NSString *)event target:(UIViewController*)target;
//!绑定事件 用代码块的形式
-(UIView*)onSlide:(OnViewSlide)block;
//!移除绑定事件
-(UIView*)removeSlide;

#pragma mark 扩展系统事件 - 屏幕侧滑（左边缘滑动）
//!绑定事件 event：指定事件名称，也可以是控制器名称，也可以指向其它UI的事件，如：Age.drag (Age是其它UI的name）
-(UIView*)addScreenLeftEdgeSlide:(NSString*)event;
//!绑定事件 并指定target
-(UIView*)addScreenLeftEdgeSlide:(NSString *)event target:(UIViewController*)target;
//!绑定事件 用代码块的形式
-(UIView*)onScreenLeftEdgeSlide:(OnScreenEdgeSlide)block;
//!移除绑定事件
-(UIView*)removeScreenLeftEdgeSlide;

#pragma mark 扩展系统事件 - 屏幕侧滑（右边缘滑动）
//!绑定事件 event：指定事件名称，也可以是控制器名称，也可以指向其它UI的事件，如：Age.drag (Age是其它UI的name）
-(UIView*)addScreenRightEdgeSlide:(NSString*)event;
//!绑定事件 并指定target
-(UIView*)addScreenRightEdgeSlide:(NSString *)event target:(UIViewController*)target;
//!绑定事件 用代码块的形式
-(UIView*)onScreenRightEdgeSlide:(OnScreenEdgeSlide)block;
//!移除绑定事件
-(UIView*)removeScreenRightEdgeSlide;

#pragma mark 定时器事件
//!绑定事件 用代码块的形式
-(UIView*)onTimer:(OnTimer)block;
-(UIView*)onTimer:(OnTimer)block interval:(double)sencond;
//!移除绑定事件
-(UIView*)removeTimer;

#pragma mark 扩展的回调事件
-(OnAfterEvent)onAfter;
//!绑定事件 用代码块的形式
-(UIView*)onAfter:(OnAfterEvent)block;

#pragma mark 增加描述
//!提供一个代码块，方便代码规范 description处可以写代码块的说明文字
-(UIView*)block:(NSString*)description on:(OnViewDescription)descBlock;
//!块写法，用于包含添加子视图
-(UIView*)block:(OnViewDescription)descBlock;
@end
