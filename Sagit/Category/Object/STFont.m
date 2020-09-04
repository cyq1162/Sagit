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
    NSString*name=nil;//IOS默认字体
    if(px>100)
    {
        NSString*value=[@(px) stringValue];
        px=[[value substringWithRange:NSMakeRange(0, 2)] integerValue];
        NSInteger type=[[value substringFromIndex:2] integerValue];//type
        if(type==0)
        {
            return [UIFont boldSystemFontOfSize:px*Xpt];
        }
        else if(type==1)
        {
            name=@"SFUIText-Light";
        }
    }
    return [UIFont toFont:name size:px];
}
+(UIFont *)toFont:(NSString*)name size:(NSInteger)px
{
    //NSInteger ii=px*Xpt;
    if (name)
    {
        return [UIFont fontWithName:name size:px*Xpt];
    }
    return [UIFont systemFontOfSize:px*Xpt];
}

@end
