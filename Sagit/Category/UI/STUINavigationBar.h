//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <UIKit/UIKit.h>

//说明对于 [UINavigationBar appearcence] 出来的是协议，不是实例
//网上的Demo多数是：UINavigationBar *bar=[UINavigationBar appearcence];
//这种拿到的bar是协议不是实例，如果调用了扩展方法，就会Crash。

@interface UINavigationBar (ST)

#pragma mark 扩展系统属性
//字体颜色
-(UINavigationBar*)tintColor:(id)colorOrHex;
//背景色
-(UINavigationBar*)barTintColor:(id)colorOrHex;
-(UINavigationBar*)backgroundImage:(NSString*)imgName;
-(UINavigationBar*)shadowImage:(NSString*)imgName;
-(UINavigationBar*)titleTextAttributes:(NSDictionary<NSAttributedStringKey,id> *)dic;
@end
