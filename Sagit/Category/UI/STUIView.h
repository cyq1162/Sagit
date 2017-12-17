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
-(STView*)STView;
-(BOOL)isSTView;
-(BOOL)isOnSTView;

- (NSString*)name;
- (UIView*)name:(NSString *)name;
- (UIView*)setName:(NSString *)name;

-(NSString*)stValue;
-(UIView*)stValue:(NSString*)value;
- (BOOL)isFormUI;
- (UIView*)isFormUI:(BOOL)yesNo;
- (UIView*)setIsFormUI:(BOOL)yesNo;
- (UIView*)preView;
- (UIView*)preView:(UIView*)view;
- (UIView*)setPreView:(UIView*)view;
- (UIView*)nextView;
- (UIView*)nextView:(UIView*)view;
- (UIView*)setNextView:(UIView*)view;


-(void)addView:(UIView *)view name:(NSString*)name;
-(UIView*)addUIView:(NSString*)name;
-(UIButton*)addSwitch:(NSString*)name;
-(UIButton *)addStepper:(NSString *)name;
-(UIButton *)addSlider:(NSString *)name;
-(UIButton *)addProgress:(NSString *)name;

-(UILabel*)addLabel:(NSString*)name;
-(UILabel*)addLabel:(NSString*)name text:(NSString*)text;
-(UILabel*)addLabel:(NSString*)name text:(NSString*)text font:(NSInteger)px;
-(UIImageView*)addImageView:(NSString*)name;
-(UIImageView*)addImageView:(NSString*)name imgName:(NSString*)imgName;
-(UIImageView*)addImageView:(NSString*)name imgName:(NSString*)imgName xyFlag:(XYFlag)xyFlag;

-(UITextField*)addTextField:(NSString*)name;
-(UITextField*)addTextField:(NSString*)name placeholder:(NSString*)placeholder;
-(UITextView*)addTextView:(NSString*)name;

-(UIButton*)addButton:(NSString*)name;
-(UIButton*)addButton:(NSString*)name imgName:(NSString*)imgName;
-(UIButton*)addButton:(NSString*)name imgName:(NSString*)imgName buttonType:(UIButtonType)buttonType;
-(UIButton*)addButton:(NSString*)name title:(NSString*)title;
-(UIButton*)addButton:(NSString*)name title:(NSString*)title font:(NSInteger)px;
-(UIButton*)addButton:(NSString*)name title:(NSString*)title font:(NSInteger)px buttonType:(UIButtonType)buttonType;
-(UIButton*)addButton:(NSString*)name title:(NSString*)title font:(NSInteger)px imgName:(NSString*)imgName buttonType:(UIButtonType)buttonType;
-(UIView*)addLine:name color:(id)colorOrHex;
-(UIScrollView*)addScrollView:(NSString*)name;
-(UIScrollView *)addScrollView:(NSString*)name direction:(XYFlag)direction imgName:(NSString*)imgName,...NS_REQUIRES_NIL_TERMINATION;

-(UIView*)lastSubView;
-(UIView*)firstSubView;
-(UIView*)stretch;
-(UIView*)stretch:(CGFloat)x;
-(UIView*)stretch:(CGFloat)x y:(CGFloat)y;


#pragma mark 扩展系统事件
-(UIView*)click:(NSString*)event;
- (UIView*)addClick:(onClick)block;
-(UIColor*)toColor:(id)hexOrColor;
#pragma mark 扩展系统属性
-(UIView*)frame:(CGRect) frame;
-(UIView*)backgroundColor:(id)colorOrHex;
-(UIView*)clipsToBounds:(BOOL)value;
@end


