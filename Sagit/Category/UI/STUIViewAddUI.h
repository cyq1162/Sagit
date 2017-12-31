//
//  STUIViewAddUI.h
//  IT恋
//
//  Created by 陈裕强 on 2017/12/23.
//  Copyright © 2017年 . All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "STTable.h"
@interface UIView (STUIViewAddUI)

#pragma mark UI属性
//!当前UI下最后一次被添加的UI
-(UIView*)lastAddView;
//!当前UI的最后一个子UI
-(UIView*)lastSubView;
//!当前UI的第一个子UI
-(UIView*)firstSubView;
//!当前UI的前一个UI
- (UIView*)preView;
//!设置当前UI的前一个UI
- (UIView*)preView:(UIView*)view;
//!当前UI的下一个UI
- (UIView*)nextView;
//!设置当前UI的下一个UI
- (UIView*)nextView:(UIView*)view;
//!当前UI是否表单UI【如果是，可以通过self.formData 取值】
- (BOOL)isFormUI;
//!设置当前UI是否表单UI
- (UIView*)isFormUI:(BOOL)yesNo;

#pragma mark 添置UI
//!移除自身（前会修改前后视图的指向关系）
-(void)removeSelf;
//!移除所有的subViews
-(UIView*)removeAllsubViews;
//!所有添加View的最后总入口。
-(UIView*)addView:(UIView *)view name:(NSString*)name;
//!添加一个STView类型的子控件
-(STView*)addSTView:(NSString*)name;
//!添加一个空的UIView
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
-(UIImageView*)addImageView:(NSString*)name img:(id)imgOrName;
-(UIImageView*)addImageView:(NSString*)name img:(id)imgOrName xyFlag:(XYFlag)xyFlag;

-(UITextField*)addTextField:(NSString*)name;
-(UITextField*)addTextField:(NSString*)name placeholder:(NSString*)placeholder;
-(UITextField*)addTextField:(NSString*)name placeholder:(NSString*)placeholder font:(NSInteger)px;
-(UITextField*)addTextField:(NSString*)name placeholder:(NSString*)placeholder font:(NSInteger)px color:(id)colorOrHex;
-(UITextView*)addTextView:(NSString*)name;
-(UITextView*)addTextView:(NSString*)name placeholder:(NSString*)placeholder;
-(UITextView*)addTextView:(NSString*)name placeholder:(NSString*)placeholder font:(NSInteger)px;
-(UITextView*)addTextView:(NSString*)name placeholder:(NSString*)placeholder font:(NSInteger)px color:(id)colorOrHex;

-(UIButton*)addButton:(NSString*)name;
-(UIButton*)addButton:(NSString*)name buttonType:(UIButtonType)buttonType;
-(UIButton*)addButton:(NSString*)name img:(id)imgOrName;
-(UIButton*)addButton:(NSString*)name title:(NSString*)title;
-(UIButton*)addButton:(NSString*)name title:(NSString*)title font:(NSInteger)px;
-(UIButton*)addButton:(NSString*)name title:(NSString*)title font:(NSInteger)px color:(id)colorOrHex;
-(UIButton*)addButton:(NSString*)name title:(NSString*)title font:(NSInteger)px color:(id)colorOrHex img:(id)imgOrName;

-(UIView*)addLine:name color:(id)colorOrHex;
-(UIScrollView*)addScrollView:(NSString*)name;
-(UIScrollView *)addScrollView:(NSString*)name direction:(XYFlag)direction img:(id)imgOrName,...NS_REQUIRES_NIL_TERMINATION;

-(UITableView*)addTableView:(NSString*)name;
-(UITableView*)addTableView:(NSString*)name style:(UITableViewStyle)style;
-(UICollectionView*)addCollectionView:(NSString*)name;
-(UICollectionView*)addCollectionView:(NSString*)name layout:(UICollectionViewLayout*)layout;
@end
