//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "STCategory.h"
#import "STDefineUI.h"
typedef void (^OnConfirmClick)(NSInteger btnIndex,UIAlertController* alertController);
typedef BOOL (^OnInputClick)(NSInteger btnIndex,UIAlertController* alertController);
typedef void (^OnMenuClick)(NSInteger btnIndex,UIAlertController* alertController);
typedef BOOL (^OnBeforeDialogHide)(UIView* winView,UIView* clickView);
typedef void (^OnBeforeShow)(UIAlertController* alertController);
typedef void (^OnDialogShow)(UIView* winView);
//!提供基础的消息弹窗
@interface STMsgBox : NSObject
+ (STMsgBox*)share;
//!dialog 状态。
@property (nonatomic,assign) BOOL isDialoging;
//!dialog 控制器（内部使用）
@property (nonatomic,strong) STController *dialogController;
//!alert 控制器（内部使用）
@property (nonatomic,retain) STQueue<UIAlertController*> *alertQueue;
//!dialog 控制器（内部使用）
@property (nonatomic,retain) STStack<STController*> *dialogStack;
#pragma AlertView
//!提示消息
-(void)prompt:(id)msg;
-(void)prompt:(id)msg second:(NSInteger)second;
//!弹出需要点击确定的消息框
-(void)alert:(id)msg;
-(void)alert:(id)msg title:(NSString*)title;
-(void)alert:(id)msg title:(NSString *)title okText:(NSString*)okText;
-(void)loading;
-(void)loading:(id)text;
-(void)hideLoading;
//!弹出需要确认，并可执行事件的消息框。
-(void)confirm:(id)msg title:(NSString*)title click:(OnConfirmClick)click;
-(void)confirm:(id)msg title:(NSString *)title click:(OnConfirmClick)click okText:(NSString*)okText;
-(void)confirm:(id)msg title:(NSString *)title click:(OnConfirmClick)click okText:(NSString*)okText  cancelText:(NSString*)cancelText;
//!弹出一个可以(自定义)输入内容的对话框
-(void)input:(id)title before:(OnBeforeShow)beforeShow click:(OnInputClick)click okText:(NSString*)okText  cancelText:(NSString*)cancelText;
//!弹出底部菜单
-(void)menu:(id)msg title:(NSString*)title click:(OnMenuClick)click names:(id)names,...NS_REQUIRES_NIL_TERMINATION;
//!弹出底部菜单
-(void)menu:(OnMenuClick)click names:(id)names,...NS_REQUIRES_NIL_TERMINATION;
//!弹出自定义界面的对话框
- (void)dialog:(OnDialogShow)dialog;
- (void)dialog:(OnDialogShow)dialog beforeHide:(OnBeforeDialogHide) beforeHide;
//!手动触发关闭所有对话框（包含嵌套）
- (void)dialogClose;
//!手动触发关闭指定对话框（嵌套时可能有多个）
- (void)dialogClose:(UIView*)winView;
@end
