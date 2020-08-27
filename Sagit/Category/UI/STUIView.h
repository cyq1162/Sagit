//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "STView.h"

@class STController;
@class STView;

@interface UIView(ST)
//!获取当前UI的STController，如果当前UI的控制器没有继承自STController，则返回nil
-(STController*)stController;
//!获取当前UI的STView，如果当前UI的根视图没有继承自STView，则返回nil
-(STView*)stView;
//!获取当前应用的状态栏
-(UIView*)statusBar;
//!获取当前UI的根控制器UIViewController
//-(UIViewController*)baseController;
//!获取当前UI的根视图，如果当前的UI没有根视图或根视图为UIWindow，则返回自身。
-(UIView*)baseView;
//!
-(UIWindow*)keyWindow;
//!检测当前UI是否STView
-(BOOL)isSTView;
//!检测当前UI的根视图是否继承自STView
//-(BOOL)isOnSTView;
//!为每个UI都扩展有一个name
- (NSString*)name;
//!为UI设置name
- (UIView*)name:(NSString *)name;

#pragma mark keyvalue
//!一个强引用的字典属性，方便存档及数据传递
-(NSMutableDictionary<NSString*,id>*)keyValue;
//!扩展一个弱引用的字典属性，用于存档有可能造成双向循环的对象，避免死引用
//-(NSMapTable*)keyValueWeak;
//!从keyValue属性中获取字指定key的值
-(id)key:(NSString*)key;
//!为keyValue属性设置键与值
-(UIView*)key:(NSString*)key value:(id)value;
//当value不存在时，才允许赋值（保证该方法仅赋值一次）
-(UIView*)key:(NSString *)key valueIfNil:(id)value;
//!为keyValue属性设置键与值 其中value为弱引用
-(UIView*)key:(NSString*)key valueWeak:(id)value;

#pragma mark 扩展系统属性

-(UIColor*)toColor:(id)hexOrColor;
+(UIColor*)toColor:(id)hexOrColor;
-(UIImage*)toImage:(id)imgOrName;
+(UIImage*)toImage:(id)imgOrName;
-(UIFont *)toFont:(NSInteger)px;
+(UIFont *)toFont:(NSString*)name size:(NSInteger)px;

-(UIView*)hidden:(BOOL)yesNo;
-(UIView*)backgroundColor:(id)colorOrHex;
-(UIImage*)backgroundImage;
-(UIView*)backgroundImage:(id)imgOrName;
-(UIView*)clipsToBounds:(BOOL)value;
-(UIView*)tag:(NSInteger)tag;
-(UIView*)alpha:(CGFloat)value;
//!将圆角半径设为宽度的一半
-(UIView*)layerCornerRadiusToHalf;
-(UIView*)layerCornerRadius:(CGFloat)px;
-(UIView*)layerBorderWidth:(NSInteger)px;
-(UIView*)layerBorderWidth:(NSInteger)px color:(id)colorOrHex;
-(UIView*)layerBorderColor:(id)colorOrHex;
-(UIView*)corner:(BOOL)yesNo;
-(UIView*)contentMode:(UIViewContentMode)contentMode;
-(UIView*)userInteractionEnabled:(BOOL)yesNO;
//!克隆复制一份UIView
-(UIView*)clone;
#pragma mark 扩展系统方法
-(UITextField*)bottomLine:(id)colorOrHex;
-(UITextField*)bottomLine:(id)colorOrHex height:(NSInteger)px;
//!框架自动释放资源（不需要人工调用）
-(void)dispose;
@end


