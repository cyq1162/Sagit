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
+(UIFont *)toFont:(NSInteger)px;
+(UIFont *)toFont:(NSInteger)px name:(NSString*)name;
+(UIFont *)toFont:(NSInteger)px bold:(BOOL)bold;
@end


