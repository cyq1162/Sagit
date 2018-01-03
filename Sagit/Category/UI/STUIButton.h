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

#pragma mark 扩展系统属性
-(UIButton*)backgroundImage:(id)img;
-(UIButton*)backgroundImage:(id)img forState:(UIControlState)state;
-(UIButton*)image:(id)img;
-(UIButton*)image:(id)img forState:(UIControlState)state;
-(UIButton*)title:(NSString*)title;
-(UIButton*)title:(NSString*)title forState:(UIControlState)state;
-(UIButton*)titleColor:(id)colorOrHex;
-(UIButton*)titleColor:(id)colorOrHex forState:(UIControlState)state;
-(UIButton*)titleFont:(NSInteger)px;
-(UIButton*)adjustsImageWhenHighlighted:(BOOL)yesNo;
//!当button在动态设置文字或图片之后，宽度自适应
-(UIButton*)stWidthToFit;
//!显示Ns的倒计时状态
-(UIButton*)showTime:(NSInteger)second;
@end
