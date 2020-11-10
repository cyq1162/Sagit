//
//  STFont.h
//  STITLink
//
//  Created by 陈裕强 on 2020/9/3.
//  Copyright © 2020 随天科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIFont(ST)
//小数位.0代表加粗。
+(UIFont *)toFont:(CGFloat)px;
+(UIFont *)toFont:(NSInteger)px name:(NSString*)name;
+(UIFont *)toFont:(NSInteger)px bold:(BOOL)bold;
@end


