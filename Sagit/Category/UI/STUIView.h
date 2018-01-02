//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "STController.h"
#import "STView.h"


@interface UIView(ST)
//!获取当前UI的STController，如果当前UI的控制器没有继承自STController，则返回nil
-(STController*)STController;
//!获取当前UI的STView，如果当前UI的根视图没有继承自STView，则返回nil
-(STView*)stView;
//!获取当前UI的根视图，如果当前的UI没有根视图或根视图为UIWindow，则返回自身。
-(UIView*)baseView;
//!检测当前UI是否STView
-(BOOL)isSTView;
//!检测当前UI的根视图是否继承自STView
//-(BOOL)isOnSTView;
//!为每个UI都扩展有一个name
- (NSString*)name;
//!为UI设置name
- (UIView*)name:(NSString *)name;
//!根据UI类型不同而返回不同的属性值
-(NSString*)stValue;
//!为UI赋属性值
-(UIView*)stValue:(NSString*)value;
//!默认为下拉选择等做简化（扩展属性）
-(NSString*)selectText;
-(UIView*)selectText:(NSString*)text;
//!默认为下拉选择等做简化（扩展属性）
-(NSString*)selectValue;
-(UIView*)selectValue:(NSString*)value;

#pragma mark keyvalue
//!扩展一个字典属性，方便存档及数据传递
-(NSMutableDictionary<NSString*,id>*)keyValue;
//!从keyValue属性中获取字指定key的值
-(id)key:(NSString*)key;
//!为keyValue属性设置键与值
-(UIView*)key:(NSString*)key value:(id)value;
//避免外部赋值，破坏系统内部预设的值。
//-(UIView*)keyValue:(NSMutableDictionary<NSString*,id>*)keyValue;
//-(UIView*)setKeyValue:(NSMutableDictionary<NSString*,id>*)keyValue;

#pragma mark 共用接口
//!重新加载数据（一般由子类重写，由于方法统一，在不同控制器中都可以直接调用，而不用搞代理事件）
-(void)reloadData;
//!重新加载数据（一般由子类重写，只是多了个参数，方便根据参数重新加载不同的数据）
-(void)reloadData:(NSString*)para;

#pragma mark 扩展系统属性

-(UIColor*)toColor:(id)hexOrColor;
+(UIColor*)toColor:(id)hexOrColor;
-(UIImage*)toImage:(id)imgOrName;
+(UIImage*)toImage:(id)imgOrName;

-(UIView*)frame:(CGRect) frame;
-(UIView*)hidden:(BOOL)yesNo;
-(UIView*)backgroundColor:(id)colorOrHex;
-(UIView*)clipsToBounds:(BOOL)value;
-(UIView*)tag:(NSInteger)tag;
-(UIView*)alpha:(CGFloat)value;
//!将圆角半径设为宽度的一半
-(UIView*)layerCornerRadiusToHalf;
-(UIView*)layerCornerRadius:(CGFloat)px;
-(UIView*)corner:(BOOL)yesNo;
-(UIView*)contentMode:(UIViewContentMode)contentMode;
#pragma mark 扩展导航栏事件
//!返回当前视图是否需要导航栏
-(BOOL)needNavBar;
//!设置当前视图是否需要导航栏（默认并不设置显示或隐藏）
-(UIView*)needNavBar:(BOOL)yesNo;
//!设置当前视图是否需要导航栏 setNavBar:同时是否设置隐藏或显示
-(UIView*)needNavBar:(BOOL)yesNo setNavBar:(BOOL)setNavBar;


//!返回当前视图是否需要Tab栏
-(BOOL)needTabBar;
//!设置当前视图是否需要Tab栏
-(UIView*)needTabBar:(BOOL)yesNo;
//!设置当前视图是否需要Tab栏 setTabBar:同时是否设置隐藏或显示
-(UIView*)needTabBar:(BOOL)yesNo setTabBar:(BOOL)setTabBar;

@end


