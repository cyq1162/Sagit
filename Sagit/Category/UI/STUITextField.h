//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UITextField(ST)
#pragma mark 自定义追加属系统
-(NSInteger)maxLength;
- (UITextField*)maxLength:(NSInteger)length;
- (UITextField*)setMaxLength:(NSInteger)length;

#pragma mark 扩展系统属性
-(UITextField*)keyboardType:(UIKeyboardType)value;
-(UITextField*)secureTextEntry:(BOOL)value;
@end
