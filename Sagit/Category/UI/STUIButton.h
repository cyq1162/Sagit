//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^onAction)(UIButton *button);
@interface UIButton (ST)

//定义可以额外追加方法
//- (void)addClick:(onAction)block;
//- (void)addAction:(onAction)block forControlEvents:(UIControlEvents)controlEvents;

#pragma mark 扩展系统属性
-(UIButton*)backgroundImage:(NSString*)imgName;
-(UIButton*)backgroundImage:(NSString*)imgName forState:(UIControlState)state;
-(UIButton*)image:(NSString*)imgName;
-(UIButton*)image:(NSString*)imgName forState:(UIControlState)state;
-(UIButton*)title:(NSString*)title;
-(UIButton*)title:(NSString*)title forState:(UIControlState)state;
-(UIButton*)titleColor:(id)colorOrHex;
-(UIButton*)titleColor:(id)colorOrHex forState:(UIControlState)state;
-(UIButton*)titleFont:(NSInteger)px;
//-(UIButton*)buttonType:(UIButtonType)type;
@end
