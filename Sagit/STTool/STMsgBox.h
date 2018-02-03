//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef BOOL (^OnConfirmClick)(NSInteger btnIndex,UIAlertView* view);
typedef void (^OnBeforeShow)(UIAlertView* view);
//!提供基础的消息弹窗
@interface STMsgBox : NSObject
+ (STMsgBox*)share;

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
-(void)custom:(id)title before:(OnBeforeShow)beforeShow click:(OnConfirmClick)click okText:(NSString*)okText  cancelText:(NSString*)cancelText;
@end
