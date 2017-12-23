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
//可以附加的点击事件
typedef void(^onClick)(UIView *view);
@interface UIView(ST)

-(STController*)STController;
-(STView*)stView;
-(UIView*)baseView;
-(BOOL)isSTView;
-(BOOL)isOnSTView;

- (NSString*)name;
- (UIView*)name:(NSString *)name;
-(NSString*)stValue;
-(UIView*)stValue:(NSString*)value;


//为每个UI增加一个可以存档临时值的字典
-(NSMutableDictionary<NSString*,id>*)keyValue;
-(id)key:(NSString*)key;
-(UIView*)key:(NSString*)key value:(id)value;
-(UIView*)keyValue:(NSMutableDictionary<NSString*,id>*)keyValue;
-(UIView*)setKeyValue:(NSMutableDictionary<NSString*,id>*)keyValue;

#pragma mark 共用接口
//子类重写
-(void)reloadData;
-(void)reloadData:(NSString*)para;
#pragma mark 扩展系统事件
-(UIView*)click:(NSString*)event;
-(UIView*)click:(NSString *)event target:(UIViewController*)target;
- (UIView*)addClick:(onClick)block;
-(UIColor*)toColor:(id)hexOrColor;
+(UIColor*)toColor:(id)hexOrColor;
#pragma mark 扩展系统属性
-(UIView*)frame:(CGRect) frame;
-(UIView*)hidden:(BOOL)yesNo;
-(UIView*)backgroundColor:(id)colorOrHex;
-(UIView*)clipsToBounds:(BOOL)value;
-(UIView*)tag:(NSInteger)tag;
-(UIView*)alpha:(NSInteger)value;
//将圆角半私设为1半。
-(UIView*)layerCornerRadiusToHalf;
-(UIView*)needNavigationBar:(BOOL)yesNo;
-(UIView*)needNavigationBar:(BOOL)yesNo setNavBar:(BOOL)setNavBar;
-(BOOL)needNavigationBar;
@end


