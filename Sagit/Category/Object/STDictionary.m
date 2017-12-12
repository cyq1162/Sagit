//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//
#import "STDictionary.h"

@implementation NSMutableDictionary(ST)

-(BOOL)has:(NSString*)key{
    return self[key]!=nil;
}
-(void)set:(NSString*)key value:(id)value
{
    [self setObject:value forKey:key];
}
-(NSString*)toJson
{
    NSString *json = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if (jsonData)
    {
        json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return json;
}
@end
@implementation NSDictionary(ST)

-(BOOL)has:(NSString*)key{
    return self[key]!=nil;
}
-(NSString*)toJson{
    NSString *json = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if (jsonData)
    {
        json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return json;
}

@end
