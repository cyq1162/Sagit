//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUserDefaults.h"


@implementation NSUserDefaults(ST)

+(NSString *)get:(NSString *)key
{
    NSUserDefaults *data=[NSUserDefaults standardUserDefaults];
    return [data valueForKey:key];
}

+(void)set:(NSString *)key v:(NSString *)value
{
    NSUserDefaults *data=[NSUserDefaults standardUserDefaults];
    return [data setValue:value forKey:key];
}
+(BOOL)has:(NSString *)key
{
    return [self get:key]!=nil;
    
}
+(void)remove:(NSString *)key
{
    NSUserDefaults *data=[NSUserDefaults standardUserDefaults];
    return [data removeObjectForKey:key];
}
@end
