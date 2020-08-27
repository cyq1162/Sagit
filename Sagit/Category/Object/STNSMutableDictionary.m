//
//  STNSMutableDictionary.m
//
//  Created by 陈裕强 on 2020/8/18.
//

#import "STNSMutableDictionary.h"

@implementation NSMutableDictionary(ST)

+(instancetype)share
{
    static NSMutableDictionary *_share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _share = [NSMutableDictionary new];
    });
    return _share;
}

-(BOOL)has:(NSString*)key{
    return self[key]!=nil;
}
-(id)get:(NSString*)key
{
    return self[key];
}
-(id)getWithIgnoreCase:(NSString *)key
{
    id v=self[key];
    if(v!=nil)
    {
        return v;
    }
    NSString *lowerKey=[key toLower];
    for (NSString* k in self) {
        if([lowerKey isEqual:[k toLower]])
        {
            return self[k];
        }
    }
    return nil;
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
    return [NSJSONSerialization dicToJson:self];
}

#pragma mark CreateFormEntity
+(id)initWithJsonOrEntity:(id)jsonOrEntity
{
    if([jsonOrEntity isKindOfClass:[NSString class]])
    {
        return [NSMutableDictionary creteFromJson:jsonOrEntity];
    }
    return [NSMutableDictionary creteFromEntity:jsonOrEntity];
}

//!把格式化的JSON格式的字符串转换成字典
+ (NSMutableDictionary *)creteFromJson:(NSString *)json {
    if (json == nil) {
        return nil;
    }
    
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
+ (NSMutableDictionary*)creteFromEntity:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);//获得属性列表
    
    //判断属性是否需要忽略
    SEL sel = NSSelectorFromString(@"isIgnore:");
    BOOL hasMethod=[obj respondsToSelector:sel];
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];//获得属性的名称
        
           if (hasMethod && [obj performSelector:sel withObject:propName]) {
               continue;
           }
        id value = [obj valueForKey:propName];//kvc读值
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [NSMutableDictionary getEntityValue:value];//自定义处理数组，字典，其他类
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}
+ (id)getEntityValue:(id)obj
{
    if([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSMutableArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[NSMutableDictionary getEntityValue:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    else if([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSMutableDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getEntityValue:[objdic objectForKey:key]] forKey:key];//对字典类型进行解析，递归调用
        }
        return dic;
    }
    else
    {
        NSString* className= NSStringFromClass([obj class]);
        if([className startWith:@"NS"] || [className startWith:@"__NS"])
        {
            return obj;
        }
        if([className isEqual:@"BOOL"] || [className isEqual:@"float"] || [className isEqual:@"int"] || [className isEqual:@"long"]
           || [className isEqual:@"double"] || [className isEqual:@"short"] || [className isEqual:@"Block"] )
        {
            return obj;
        }
    }
    return [NSMutableDictionary creteFromEntity:obj];//对其他class解析，递归调用
}
@end


