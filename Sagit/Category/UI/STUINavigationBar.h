//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//
//  Copyright © 2017-2027年. All rights reserved.
//

#import <UIKit/UIKit.h>
//说明对于 [UINavigationBar appearcence] 出来的是协议，不是实例
//网上的Demo多数是：UINavigationBar *bar=[UINavigationBar appearcence];
//这种拿到的bar是协议不是实例，如果调用了扩展方法，就会Crash。

@interface UINavigationBarSetting:NSObject
#pragma mark 扩展系统属性
//字体颜色
-(UINavigationBarSetting*)tintColor:(id)colorOrHex;
//背景色
-(UINavigationBarSetting*)barTintColor:(id)colorOrHex;
-(UINavigationBarSetting*)backgroundImage:(id)img;
-(UINavigationBarSetting*)backgroundImage:(id)img stretch:(BOOL)stretch;
-(UINavigationBarSetting*)shadowImage:(id)img;
-(UINavigationBarSetting*)titleTextAttributes:(NSDictionary<NSAttributedStringKey,id> *)dic;
-(UINavigationBarSetting*)translucent:(BOOL)yesNo;
@end

@interface UINavigationBar (ST)
+(UINavigationBarSetting*)globalSetting;
@end
