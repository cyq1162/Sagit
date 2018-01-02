//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "STEnum.h"

@interface UIViewController(ST)
//!前一个页面控制器
-(UIViewController*)preController;
//!设置自身为根控制器
-(UIViewController*)asRoot;
/**设置自身为根控制器
 @param rootType 设置的根类型
 */
-(UIViewController*)asRoot:(RootViewControllerType) rootType;

#pragma mark keyvalue
//!扩展一个字典属性，方便存档及数据传递
-(NSMutableDictionary<NSString*,id>*)keyValue;
//!从keyValue属性中获取字指定key的值
-(id)key:(NSString*)key;
//!为keyValue属性设置键与值
-(UIViewController*)key:(NSString*)key value:(id)value;

#pragma mark 代码说明块
typedef void(^ControllerDescription)(UIViewController *controller);
//!提供一个代码块，方便代码规范 description处可以写代码块的说明文字
-(void)block:(NSString*)description on:(ControllerDescription)descBlock;
#pragma mark 导航栏功能
//!压入视图并显示下一个页面（通过此方法跳转视图，系统会自动控制导航栏和Tab栏的显示与隐藏，以及滑动返回事件）
- (void)stPush:(UIViewController *)viewController title:(NSString *)title img:(id)imgOrName;
//!退弹出视图并返回上一个页面(对应stPush方法)
- (void)stPop;
//!设置右侧导航栏的按钮为文字或图片
-(UIViewController*)rightNav:(NSString*)title img:(id)imgOrName;
//!右侧导航栏的默认点击事件
-(void)onRightNavBarClick:(UIView*)view;
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

@end
