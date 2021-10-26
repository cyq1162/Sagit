//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STFont.h"
#import "STDefineUI.h"
#import "STSagit.h"
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
