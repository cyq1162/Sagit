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

@interface UIView(STAutoLayout)
#pragma mark 属性定义
- (NSMutableDictionary*)LayoutTracer;
- (UIView*)setLayoutTracer:(NSMutableDictionary*)tracer;
- (CGRect)OriginFrame;
- (UIView*)setOriginFrame:(CGRect)frame;

-(CGSize)superSize;
#pragma mark [相对布局方法] RelativeLayout
-(UIView*)onRight:(id)uiOrName x:(CGFloat)x;
-(UIView*)onRight:(id)uiOrName x:(CGFloat)x y:(CGFloat)y;
-(UIView*)onLeft:(id)uiOrName x:(CGFloat)x;
-(UIView*)onLeft:(id)uiOrName x:(CGFloat)x y:(CGFloat)y;
-(UIView*)onTop:(id)uiOrName y:(CGFloat)y;
-(UIView*)onTop:(id)uiOrName y:(CGFloat)y x:(CGFloat)x;
-(UIView *)onBottom:(id)uiOrName y:(CGFloat)y;
-(UIView *)onBottom:(id)uiOrName y:(CGFloat)y x:(CGFloat)x;
-(UIView*)relate:(XYLocation)location v:(CGFloat)value;
-(UIView*)relate:(XYLocation)location v:(CGFloat)value v2:(CGFloat)value2;
-(UIView*)relate:(XYLocation)location v:(CGFloat)value v2:(CGFloat)value2 v3:(CGFloat)value3;
-(UIView*)relate:(XYLocation)location v:(CGFloat)value v2:(CGFloat)value2 v3:(CGFloat)value3 v4:(CGFloat)value4;
-(UIView*)toCenter;
-(UIView*)toCenter:(XYFlag)xyFlag;



-(CGFloat)stX;
-(CGFloat)stAbsX;
-(CGFloat)stY;
-(CGFloat)stAbsY;
-(CGFloat)stWidth;
-(CGFloat)stHeight;

-(UIView*)x:(CGFloat)x;
-(UIView*)x:(CGFloat)x y:(CGFloat)y;
-(UIView*)x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;
-(UIView*)y:(CGFloat)y;
-(UIView*)width:(CGFloat)width;
-(UIView*)width:(CGFloat)width height:(CGFloat)height;
-(UIView*)width:(CGFloat)width height:(CGFloat)height x:(CGFloat)x y:(CGFloat)y;
-(UIView*)height:(CGFloat)height;
-(UIView*)moveTo:(CGRect)frame;
-(UIView*)backToOrigin;
-(UIView*)refleshLayout;
-(UIView*)refleshLayout:(BOOL)withWidthHeight;
-(UIView*)stSizeToFit;
@end
