//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "STEnum.h"

@interface UIViewController(ST)
//!当前控制器的视图的根视图
-(UIView*)baseView;
//!前一个页面控制器
-(UIViewController*)preController;
//!后一个页面控制器（系统用于检测是否释放使用）
-(UIViewController *)nextController;
//!设置自身为根控制器
-(UIViewController*)asRoot;
/**设置自身为根控制器
 @param rootType 设置的根类型
 */
-(UIViewController*)asRoot:(RootViewControllerType) rootType;
//!获取当前主Window
-(UIWindow*)keyWindow;
#pragma mark 扩展导航栏事件
//!返回当前视图是否需要导航栏
-(BOOL)needNavBar;
//!设置当前视图是否需要导航栏
-(UIViewController*)needNavBar:(BOOL)yesNo;
//!设置当前视图是否需要导航栏 forThisView:标记当前UIView是否设置隐藏或显示
-(UIViewController*)needNavBar:(BOOL)yesNo forThisView:(BOOL)forThisView;

//!返回当前视图是否需要Tab栏
-(BOOL)needTabBar;
//!设置当前视图是否需要Tab栏
-(UIViewController*)needTabBar:(BOOL)yesNo;
//!设置当前视图是否需要Tab栏  forThisView:标记当前UIView是否设置隐藏或显示 默认：YES
-(UIViewController*)needTabBar:(BOOL)yesNo forThisView:(BOOL)forThisView;

//!返回当前视图是否需要Status栏
-(BOOL)needStatusBar;
//!设置当前视图是否需要Status栏
-(UIViewController*)needStatusBar:(BOOL)yesNo;
//!设置当前视图是否需要Status栏  forThisView:标记当前UIView是否设置隐藏或显示
-(UIViewController*)needStatusBar:(BOOL)yesNo forThisView:(BOOL)forThisView;
//!设置视图Status栏显示的样式：默认全局
-(UIViewController*)setStatusBarStyle:(UIStatusBarStyle)style;
//!设置当前视图Status栏显示的样式：默认全局 @forThisView 是否只在当前View失效  默认：NO
-(UIViewController*)setStatusBarStyle:(UIStatusBarStyle)style forThisView:(BOOL)forThisView;
//【系统内部方法】：用于还原导航栏和状态栏和Tab栏
-(void)reSetBarState:(BOOL)animated;

#pragma mark keyvalue
//!扩展一个字典属性，方便存档及数据传递
-(NSMutableDictionary<NSString*,id>*)keyValue;
//!从keyValue属性中获取字指定key的值
-(id)key:(NSString*)key;
//!为keyValue属性设置键与值
-(UIViewController*)key:(NSString*)key value:(id)value;
//当value不存在时，才允许赋值（保证该方法仅赋值一次）
-(UIViewController*)key:(NSString *)key valueIfNil:(id)value;
//!为keyValue属性设置键与值 其中value为弱引用
-(UIViewController*)key:(NSString*)key valueWeak:(id)value;
#pragma mark 代码说明块
typedef void(^OnControllerDescription)(UIViewController *controller);
//!提供一个代码块，方便代码规范 description处可以写代码块的说明文字
-(UIViewController*)block:(OnControllerDescription)descBlock;
-(UIViewController*)block:(NSString*)description on:(OnControllerDescription)descBlock;
#pragma mark 导航栏功能
//!压入视图并显示下一个页面（通过此方法跳转视图，系统会自动控制导航栏和Tab栏的显示与隐藏，以及滑动返回事件）
- (void)stPush:(UIViewController *)viewController;
//!压入视图并显示下一个页面（通过此方法跳转视图，系统会自动控制导航栏和Tab栏的显示与隐藏，以及滑动返回事件）
- (void)stPush:(UIViewController *)viewController title:(NSString *)title;
//!压入视图并显示下一个页面（通过此方法跳转视图，系统会自动控制导航栏和Tab栏的显示与隐藏，以及滑动返回事件）
- (void)stPush:(UIViewController *)viewController title:(NSString *)title img:(id)imgOrName;
//!退弹出视图并返回上一个页面(对应stPush方法)
- (void)stPop;
//!退弹出视图并返回首页(对应stPush方法)
-(void)stPopToTop;
//!左侧导航栏的默认长按事件 return YES 则系统调stPopToTop返回方法。
-(BOOL)onLeftNavBarLongPress:(UIBarButtonItem*)view;
//!设置左侧导航栏的按钮为文字或图片
-(UIViewController*)leftNav:(NSString*)title img:(id)imgOrName;
//!左侧导航栏的默认点击事件 return YES 则系统调stPop返回方法。
-(BOOL)onLeftNavBarClick:(UIBarButtonItem*)view;
//!设置右侧导航栏的按钮为文字或图片
-(UIViewController*)rightNav:(NSString*)title img:(id)imgOrName;
//!右侧导航栏的默认点击事件
-(void)onRightNavBarClick:(UIBarButtonItem*)view;
//系统内部调用的方法
-(UIViewController*)reSetNav:(UINavigationController*)navController;
//!隐藏导航条下面的阴线
-(UIViewController*)hideNavShadow;
//!跳转到其它页面(内部方法)
-(void)redirect:(UITapGestureRecognizer*)recognizer;
#pragma mark 共用接口
//!重新加载数据（一般由子类重写，由于方法统一，在不同控制器中都可以直接调用，而不用搞代理事件）
-(void)reloadData;
//!重新加载数据（一般由子类重写，只是多了个参数，方便根据参数重新加载不同的数据）
-(void)reloadData:(NSString*)para;


#pragma mark for TabBar 属性扩展
-(UIViewController*)title:(NSString*)title;
-(UIViewController*)tabTitle:(NSString*)title;
-(UIViewController*)tabImage:(id)imgOrName;
-(UIViewController*)tabSelectedImage:(id)imgOrName;
-(UIViewController*)tabBadgeValue:(NSString*)value;
-(UIViewController*)tabBadgeColor:(id)colorOrHex;
-(UINavigationController*)toUINavigationController;
//!【系统内部方法】：框架自动释放资源（不需要人工调用）
-(void)dispose;
@end
