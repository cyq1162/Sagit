//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUserDefaults.h"


@implementation NSUserDefaults(ST)

-(NSString *)get:(NSString *)key
{
    //NSUserDefaults *data=[NSUserDefaults standardUserDefaults];
    return [self valueForKey:key];
}

-(void)set:(NSString *)key value:(NSString *)value
{
    //NSUserDefaults *data=[NSUserDefaults standardUserDefaults];
    return [self setValue:value forKey:key];
}
-(BOOL)has:(NSString *)key
{
    return [self get:key]!=nil;
    
}
-(void)remove:(NSString *)key
{
    //NSUserDefaults *data=[NSUserDefaults standardUserDefaults];
    return [self removeObjectForKey:key];
}
@end
