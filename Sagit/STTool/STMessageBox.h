//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^OnClick)(BOOL isOK);
typedef void (^Complete)();
typedef void (^Executive)();
@interface STMessageBox : NSObject
+ (STMessageBox*)share;

#pragma AlertView
-(void)prompt:(NSString*)text;
-(void)prompt:(NSString*)text duration:(int)duration;
-(void)prompt:(NSString*)text duration:(int)duration withDetailText:(NSString *)detailText;//需要展示的第二行小文字
-(void)alert:(NSString*)text;
-(void)alert:(NSString*)title msg:(NSString*)text;
-(void)loading;
-(void)loading:(NSString*)text;
-(void)hideLoading;
-(void)confirm:(NSString*)title msg:(NSString*)message click:(OnClick)click;
-(void)confirm:(NSString *)title msg:(NSString *)message click:(OnClick)click okText:(NSString*)okText;
-(void)confirm:(NSString *)title msg:(NSString *)message click:(OnClick)click okText:(NSString*)okText  cancelText:(NSString*)cancelText;

@end
