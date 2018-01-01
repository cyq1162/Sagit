//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^OnConfirmClick)(BOOL isOK,UIAlertView* view);
//!提供基础的消息弹窗
@interface STMessageBox : NSObject
+ (STMessageBox*)share;

#pragma AlertView
//!提示消息
-(void)prompt:(NSString*)msg;
-(void)prompt:(NSString*)msg second:(int)second;
//!弹出需要点击确定的消息框
-(void)alert:(NSString*)msg;
-(void)alert:(NSString*)msg title:(NSString*)title;
-(void)loading;
-(void)loading:(NSString*)text;
-(void)hideLoading;
//!弹出需要确认，并可执行事件的消息框。
-(void)confirm:(NSString*)msg title:(NSString*)title click:(OnConfirmClick)click;
-(void)confirm:(NSString *)msg title:(NSString *)title click:(OnConfirmClick)click okText:(NSString*)okText;
-(void)confirm:(NSString *)msg title:(NSString *)title click:(OnConfirmClick)click okText:(NSString*)okText  cancelText:(NSString*)cancelText;

@end
