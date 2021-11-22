//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "STController.h"
#import "STView.h"

@interface UIView(STAutoLayout)
#pragma mark 属性定义
//!记录每个UI的移动轨迹，系统自动控制，不需要用户处理
- (NSMutableDictionary*)LayoutTracer;
- (UIView*)setLayoutTracer:(NSMutableDictionary*)tracer;
//!当前UI第一次设置的frame，方便以后归位。
- (CGRect)OriginFrame;
- (UIView*)setOriginFrame:(CGRect)frame;
//!获取修正后父窗体的宽高。
-(CGSize)superSizeWithFix;
//-(CGSize)superSize;
#pragma mark [相对布局方法] RelativeLayout
//当前UI将布局于指定UI的右侧
-(UIView*)onRight:(id)uiOrName;
-(UIView*)onRight:(id)uiOrName x:(CGFloat)x;
-(UIView*)onRight:(id)uiOrName x:(CGFloat)x y:(CGFloat)y;
//当前UI将布局于指定UI的左侧
-(UIView*)onLeft:(id)uiOrName;
-(UIView*)onLeft:(id)uiOrName x:(CGFloat)x;
-(UIView*)onLeft:(id)uiOrName x:(CGFloat)x y:(CGFloat)y;
//当前UI将布局于指定UI的上方
-(UIView*)onTop:(id)uiOrName;
-(UIView*)onTop:(id)uiOrName y:(CGFloat)y;
-(UIView*)onTop:(id)uiOrName y:(CGFloat)y x:(CGFloat)x;
//当前UI将布局于指定UI的下方
-(UIView *)onBottom:(id)uiOrName;
-(UIView *)onBottom:(id)uiOrName y:(CGFloat)y;
-(UIView *)onBottom:(id)uiOrName y:(CGFloat)y x:(CGFloat)x;
//!相对当前UI的父视图布局 XYLocation 决定相对的位置
-(UIView*)relate:(XYLocation)location v:(CGFloat)value;
-(UIView*)relate:(XYLocation)location v:(CGFloat)value v2:(CGFloat)value2;
-(UIView*)relate:(XYLocation)location v:(CGFloat)value v2:(CGFloat)value2 v3:(CGFloat)value3;
-(UIView*)relate:(XYLocation)location v:(CGFloat)value v2:(CGFloat)value2 v3:(CGFloat)value3 v4:(CGFloat)value4;
//!将当前的UI居中 （不传参默认上下左右都居中）
-(UIView*)toCenter;
//!将当前的UI居中 XYFlag 指定左右或上下
-(UIView*)toCenter:(XYFlag)xyFlag;
//!获取当前UI的X值（px)
-(CGFloat)stX;
//!获取当前UI的相对屏幕X值（px)
-(CGFloat)stScreenX;
//!获取当前UI的Y值（px)
-(CGFloat)stY;
//!获取当前UI的相对屏幕Y值（px)
-(CGFloat)stScreenY;
//!获取当前UI的width值（px)
-(CGFloat)stWidth;
//!获取当前UI的height值（px)
-(CGFloat)stHeight;
-(UIView*)frame:(CGRect) frame;
//!用px值设置当前UI的坐标体系或宽高
-(UIView*)x:(CGFloat)x;
-(UIView*)x:(CGFloat)x y:(CGFloat)y;
-(UIView*)x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;
//!用px值设置当前UI的坐标体系或宽高
-(UIView*)y:(CGFloat)y;
//!用px值设置当前UI的坐标体系或宽高
-(UIView*)width:(CGFloat)width;
-(UIView*)width:(CGFloat)width height:(CGFloat)height;
//!用px值设置当前UI的坐标体系或宽高
-(UIView*)width:(CGFloat)width height:(CGFloat)height x:(CGFloat)x y:(CGFloat)y;
//!用px值设置当前UI的坐标体系或宽高
-(UIView*)height:(CGFloat)height;
//!将当前的UI移动到指定的坐标（及视情况改变宽高）
-(UIView*)moveTo:(CGRect)frame;
//!还原第一次设置的坐标系及宽高
-(UIView*)backToOrigin;
//!刷新当前UI及子UI的布局以及宽高
-(UIView*)refleshLayout;
//!刷新当前UI及子UI的布局以及[宽高(可控制)] withWidthHeight : 是否改变宽与高，默认是YES
-(UIView*)refleshLayout:(BOOL)withWidthHeight;
//!刷新[当前UI(可控制)]及子UI的布局 withWidthHeight:是否改变宽与高，默认是YES ignoreSelf:忽略自身，默认是NO
-(UIView*)refleshLayout:(BOOL)withWidthHeight ignoreSelf:(BOOL)ignoreSelf;
//!刷新布局【屏幕旋转后】
-(void)refleshLayoutAfterRotate;

//!遍历检测其子UI，如果子UI部分超过，则扩展宽与高，但不会缩小。
-(UIView*)stSizeToFit;
//!遍历检测其子UI，如果子UI部分超过，则扩展宽与高，但不会缩小。px参数：扩展后再追加的长度或高度，默认0
-(UIView*)stSizeToFit:(NSInteger)widthPx y:(NSInteger)heightPx;
//!图片拉伸（一般适用于背景拉伸或聊天图片的拉伸）
-(UIView*)stretch;
//!图片拉伸（一般适用于背景拉伸或聊天图片的拉伸） x：是px值
-(UIView*)stretch:(CGFloat)x;
//!图片拉伸（一般适用于背景拉伸或聊天图片的拉伸） x、y: 都是px值
-(UIView*)stretch:(CGFloat)x y:(CGFloat)y;

//!缩小UIView的两边宽高、并保持中心点不变。
-(UIView*)cut:(NSInteger)widthPx height:(NSInteger)heightPx;
//#pragma mark 【px<=>pt】动态转换系数
//+(NSInteger)stStandardWidthPt:(id)viewOrController;
//+(NSInteger)stStandardHeightPt:(id)viewOrController;
//+(CGFloat)xToPt;
//+(CGFloat)yToPt;
//+(CGFloat)xToPx;
//+(CGFloat)yToPx;
@end
