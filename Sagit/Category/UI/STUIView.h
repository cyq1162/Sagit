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

-(STController*)STController;
-(STView*)STView;
-(BOOL)isSTView;
-(BOOL)isOnSTView;
- (NSString*)Name;
- (UIView*)setName:(NSString *)name;
-(NSString*)stringValue;
-(UIView*)stringValue:(NSString*)value;
- (BOOL)IsFormUI;
- (UIView*)setIsFormUI:(BOOL)yesNo;
- (UIView*)PreView;
- (UIView*)setPreView:(UIView*)view;
- (UIView*)NextView;
- (UIView*)setNextView:(UIView*)view;
- (CGRect)OriginFrame;
- (UIView*)setOriginFrame:(CGRect)frame;
- (NSMutableDictionary*)LayoutTracer;
- (UIView*)setLayoutTracer:(NSMutableDictionary*)tracer;
-(CGSize)superSize;

-(void)addView:(UIView *)view name:(NSString*)name;
-(UIView*)addUIView:(NSString*)name;
-(UIButton*)addSwitch:(NSString*)name;
-(UIButton *)addStepper:(NSString *)name;
-(UIButton *)addSlider:(NSString *)name;
-(UIButton *)addProgress:(NSString *)name;

-(UILabel*)addLabel:(NSString*)text;
-(UILabel*)addLabel:(NSString*)text name:(NSString*)name;

-(UIImageView*)addImageView:(NSString*)imgName;
-(UIImageView*)addImageView:(NSString*)imgName xyFlag:(XYFlag)xyFlag;

-(UITextField*)addTextField:(NSString*)name;
-(UITextField*)addTextField:(NSString*)name placeholder:(NSString*)placeholder;
-(UITextView*)addTextView:(NSString*)name;

-(UIButton*)addButton:(NSString*)name;
-(UIButton*)addButton:(NSString*)name imgName:(NSString*)imgName;
-(UIButton*)addButton:(NSString*)name imgName:(NSString*)imgName click:(NSString*)event;
-(UIButton*)addButton:(NSString*)name imgName:(NSString*)imgName click:(NSString*)event buttonType:(UIButtonType)buttonType;
-(UIButton*)addButton:(NSString*)name title:(NSString*)title;
-(UIButton*)addButton:(NSString*)name title:(NSString*)title click:(NSString*)event;
-(UIButton*)addButton:(NSString*)name title:(NSString*)title click:(NSString*)event buttonType:(UIButtonType)buttonType;
-(UIView*)addLine:(UIColor*)color;
-(UIView*)addRectangle;
-(UIScrollView*)addScrollView;
-(UIScrollView *)addScrollView:(NSString*)imgName,...NS_REQUIRES_NIL_TERMINATION;

-(UIView*)lastSubView;
-(UIView*)firstSubView;
-(UIView*)stretch;
-(UIView*)stretch:(CGFloat)x;
-(UIView*)stretch:(CGFloat)x y:(CGFloat)y;

#pragma mark [相对布局方法] RelativeLayout
-(UIView*)onRight:(UIView*)ui x:(CGFloat)x;
-(UIView*)onRight:(UIView*)ui x:(CGFloat)x y:(CGFloat)y;
-(UIView*)onLeft:(UIView*)ui x:(CGFloat)x;
-(UIView*)onLeft:(UIView*)ui x:(CGFloat)x y:(CGFloat)y;
-(UIView*)onTop:(UIView*)ui y:(CGFloat)y;
-(UIView*)onTop:(UIView*)ui y:(CGFloat)y x:(CGFloat)x;
-(UIView *)onBottom:(UIView*)ui y:(CGFloat)y;
-(UIView *)onBottom:(UIView*)ui y:(CGFloat)y x:(CGFloat)x;
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
#pragma mark 扩展系统属性
-(UIView*)frame:(CGRect) frame;
-(UIView*)backgroundColor:(UIColor*)backgroundColor;
-(UIView*)clipsToBounds:(BOOL)value;
@end


