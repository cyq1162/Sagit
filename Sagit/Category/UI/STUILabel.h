//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UILabel(ST)

#pragma mark 扩展系统事件
-(UILabel*)longPressCopy:(BOOL)yesNo;
//!复制文本
-(UILabel*)copy;

#pragma mark 扩展系统属性
-(UILabel*)text:(NSString*)text;
-(UILabel*)textColor:(id)colorOrHex;
-(UILabel*)textAlignment:(NSTextAlignment)align;
-(UILabel*)font:(NSInteger)px;
-(UILabel*)numberOfLines:(NSInteger)value;
-(UILabel*)adjustsFontSizeToFitWidth:(BOOL)yesNo;
@end
