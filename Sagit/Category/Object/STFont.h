//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIFont(ST)
//小数位.0代表加粗。
+(UIFont *)toFont:(CGFloat)px;
+(UIFont *)toFont:(NSInteger)px name:(NSString*)name;
+(UIFont *)toFont:(NSInteger)px bold:(BOOL)bold;
@end


