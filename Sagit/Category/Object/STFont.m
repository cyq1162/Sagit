//
//  STFont.m
//  STITLink
//
//  Created by 陈裕强 on 2020/9/3.
//  Copyright © 2020 随天科技. All rights reserved.
//

#import "STFont.h"

@implementation UIFont(ST)

+(UIFont *)toFont:(CGFloat)px
{
    NSNumber *pxNum=@(px);
    NSString*value=[@(px) stringValue];
    if([value containsString:@".0"])
    {
        //有小数点。
        return [UIFont boldSystemFontOfSize:pxNum.integerValue*Xpt];
    }
    else if(px>300)
    {
        px=[[value substringWithRange:NSMakeRange(0, 2)] integerValue];
        NSInteger type=[[value substringFromIndex:2] integerValue];//type
        if(type==0)
        {
            return [UIFont boldSystemFontOfSize:px*Xpt];
        }
    }
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
