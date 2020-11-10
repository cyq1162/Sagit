//
//  STFont.m
//  STITLink
//
//  Created by 陈裕强 on 2020/9/3.
//  Copyright © 2020 随天科技. All rights reserved.
//

#import "STFont.h"

@implementation UIFont(ST)

+(UIFont *)toFont:(NSInteger)px
{
   return [UIFont systemFontOfSize:px*Xpt];
}
+(UIFont *)toFont:(NSInteger)px name:(NSString*)name
{
    return [UIFont fontWithName:name size:px*Xpt];
}
+(UIFont *)toFont:(NSInteger)px bold:(BOOL)bold
{
    return bold?[UIFont boldSystemFontOfSize:px*Xpt]:[UIFont systemFontOfSize:px*Xpt];
}

@end
