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
//-(void)showWaitViewInView:(UIView*)view//添加在要展示的view
//                animation:(BOOL)animated//显示时是否添加动画
//                 withText:(NSString*)text//要展示的文本
//          withDetailsText:(NSString *)detailsText//需要展示的第二行小文字，如果不需要则填nil
//             withDuration:(CGFloat)duration//弹出动画时间
//           hideWhenFinish:(BOOL)hideWhenFinish;//展示后是否自动移除
//-(void)showWaitViewWithIcon:(UIView*)view//添加在要展示的view
//                   withText:(NSString*)text//要展示的文本
//                       icon:(NSString*)icon;//展示图片
//- (void)showWhileExecuting:(UIView*)view//添加在要展示的view
//                  withText:(NSString*)text//要展示的文本
//       whileExecutingBlock:(dispatch_block_t)block complete:(Complete)complete;//展示期间需要执行的内容
//-(void)showWithCustomView:(UIView*)view gifName:(NSString*)gifName;//显示自定义的View,gif动画
//-(void)showCustomViewText:(NSString*)text;//在自定义View上显示文本。必需和showWithCustomView一起用。
//-(void)hiddenView;
//- (void)showLoadingViewOnView:(UIView *)view text:(NSString *)text;//菊花加载

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
