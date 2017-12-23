//
//  STUIViewAddUI.h
//  IT恋
//
//  Created by 陈裕强 on 2017/12/23.
//  Copyright © 2017年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTable.h"
@interface UIView (STUIViewAddUI)

#pragma mark UI属性
//最后一个被添加的控件，有可能是某个控件的子控件
-(UIView*)lastAddView;
-(UIView*)lastSubView;
-(UIView*)firstSubView;
- (UIView*)preView;
- (UIView*)preView:(UIView*)view;
- (UIView*)nextView;
- (UIView*)nextView:(UIView*)view;
- (BOOL)isFormUI;
- (UIView*)isFormUI:(BOOL)yesNo;

#pragma mark 添置UI
-(UIView*)removeView:(UIView*)view;
-(UIView*)removeAllViews;
-(UIView*)addView:(UIView *)view name:(NSString*)name;
-(UIView*)addUIView:(NSString*)name;
-(UISwitch*)addSwitch:(NSString*)name;
-(UIStepper *)addStepper:(NSString *)name;
-(UISlider *)addSlider:(NSString *)name;
-(UIProgressView *)addProgress:(NSString *)name;

-(UILabel*)addLabel:(NSString*)name;
-(UILabel*)addLabel:(NSString*)name text:(NSString*)text;
-(UILabel*)addLabel:(NSString*)name text:(NSString*)text font:(NSInteger)px;
-(UILabel*)addLabel:(NSString*)name text:(NSString*)text font:(NSInteger)px color:(id)colorOrHex;
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

-(UITableView*)addTableView:(NSString*)name;
-(UITableView*)addTableView:(NSString*)name style:(UITableViewStyle)style;
-(STTable*)addTable:(NSString*)name;
-(STTable*)addTable:(NSString*)name style:(UITableViewStyle)style;
@end
