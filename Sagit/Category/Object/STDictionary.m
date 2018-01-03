//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//
#import "STDictionary.h"
#import "STString.h"
@implementation NSMutableDictionary(ST)

-(BOOL)has:(NSString*)key{
    return self[key]!=nil;
}
-(id)get:(NSString*)key
{
    return self[key];
}
-(void)set:(NSString*)key value:(id)value
{
    if(value!=nil)
    {
        [self setObject:value forKey:key];
    }
    else
    {
        [self remove:key];
    }
}
-(void)remove:(NSString*)key
{
    NSArray *items=[key split:@","];
    for (NSString* item in items)
    {
        [self removeObjectForKey:item];
    }
    
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

-(id)firstObject
{
    if(self.count>0)
    {
        for (NSString* key in self) {
            return self[key];
        }
    }
    return nil;
}
-(id)get:(NSString*)key
{
    return self[key];
}
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
//!把格式化的JSON格式的字符串转换成字典
+ (NSDictionary *)dictionaryWithJson:(NSString *)json {
    if (json == nil) {
        return nil;
    }
    
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end

@implementation NSMapTable(ST)

-(id)get:(NSString*)key
{
    return [self objectForKey:key];
}
-(BOOL)has:(NSString*)key
{
    return [self objectForKey:key]!=nil;
}
-(void)set:(NSString*)key value:(id)value
{
    if(value!=nil)
    {
        [self setObject:value forKey:key];
    }
    else
    {
        [self remove:key];
    }
}
-(void)remove:(NSString*)key
{
    NSArray *items=[key split:@","];
    for (NSString* item in items)
    {
        [self removeObjectForKey:item];
    }
    
}
@end
