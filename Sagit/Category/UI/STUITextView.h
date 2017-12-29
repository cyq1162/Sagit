//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UITextView(ST)
#pragma mark 自定义追加属系统
//文字框最多能输入的长度
-(NSInteger)maxLength;
- (UITextView*)maxLength:(NSInteger)length;
//- (UITextView*)setMaxLength:(NSInteger)length;

//文字框最大的高度
- (CGFloat)maxHeight;
- (UITextView*)maxHeight:(CGFloat)px;

#pragma mark 扩展系统属性
-(UITextView*)keyboardType:(UIKeyboardType)value;
-(UITextView*)secureTextEntry:(BOOL)value;
-(UITextView*)text:(NSString*)text;
-(UITextView*)font:(NSInteger)px;
-(UITextView*)textColor:(id)colorOrHex;
-(UITextView*)textAlignment:(NSTextAlignment)value;
//!自定义扩展
-(UITextView*)placeholder;
-(UITextView*)placeholder:(NSString*)text;
@end


