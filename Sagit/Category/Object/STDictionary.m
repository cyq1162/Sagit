//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  Copyright © 2017-2027年. All rights reserved.
//
#import "STDictionary.h"
#import "STString.h"
#import "STCategory.h"
@implementation NSDictionary(ST)

-(NSMutableDictionary *)toNSMutableDictionary
{
    NSMutableDictionary*dic=[NSMutableDictionary new];
    for (NSString*key in self) {
        [dic set:key value:self[key]];
    }
    return dic;
}
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

-(BOOL)has:(NSString*)key{
    return self[key]!=nil;
}
-(NSString*)toJson{
    return [NSJSONSerialization dicToJson:self];
}
//!把格式化的JSON格式的字符串转换成字典
+(id)initWithJsonOrEntity:(id)jsonOrEntity
{
    return [NSMutableDictionary initWithJsonOrEntity:jsonOrEntity];
}

#pragma mark ToEntity
+(void)dictionaryToEntity:(NSDictionary*)dic to:(id)entity
{
    if(entity==nil || dic==nil || dic.count==0){return;}
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([entity class], &propsCount);//获得属性列表
    //Class superClass=class_getSuperclass([entity class]);
    //判断属性是否需要忽略
    SEL sel = NSSelectorFromString(@"isIgnore:");
    BOOL hasMethod=[entity respondsToSelector:sel];
 
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];//获得属性的名称
        id v=[dic getWithIgnoreCase:propName];
        if(v==nil || [v isKindOfClass:[NSNull class]])
        {
            continue;
        }
        if (hasMethod && [entity performSelector:sel withObject:propName]) {
            continue;
        }
        NSString *atts= [NSString stringWithUTF8String:property_getAttributes(prop)];
        if([atts startWith:@"R"]){continue;}
        
        if([atts contains:@"\"NS"] || [atts contains:@"<NS"])
        {
            //NSArray
            if(([atts contains:@"Array\""] || [atts contains:@"Array<"])
               && [v isKindOfClass:[NSArray class]])//@"T@\"NSMutableArray<PersonalPhoto>\",&,N,V_photos"    0x0000600002e9a200
            {
                NSString *className= [[[atts split:@","][0] split:@"<"][1] trimEnd:@">\""];
                Class class=NSClassFromString(className);
                if(class!=nil)//view
                {
                    NSMutableArray<id> *arr=[NSMutableArray new];
                    NSArray *arrValue=(NSArray*)v;
                    for (int i=0; i<arrValue.count; i++) {
                        id obj=[[class alloc] init];
                        [self dictionaryToEntity:arrValue[i] to:obj];
                        [arr addObject:obj];
                    }
                    [entity setValue:arr forKey:propName];
                    continue;
                }
                }
        }
        else if([atts contains:@"@"] && [v isKindOfClass:[NSDictionary class]])//自定义实体
        {
            NSString *className=[[[atts split:@","][0] substringFromIndex:3] trimEnd:@"\""];
            className=[className split:@"<"][0];//@"T@\"PersonalUser<PersonalUser>\",&,N,V_user"    0x0000600000df0e80
            Class class=NSClassFromString(className);
            if(class!=nil)//view
            {
                id obj=[[class alloc] init];
                [self dictionaryToEntity:v to:obj];
                [entity setValue:obj forKey:propName];
            }
            continue;;
        }

        [entity setValue:v forKey:propName];

    }
    free(props);
}
@end

@implementation NSJSONSerialization(ST)

+(NSString *)dicToJson:(NSDictionary*)dic
{
    if(dic==nil || dic.count==0)
    {
        return @"{}";
    }
    NSString *json = nil;
    NSError *error;
    NSData *jsonData = [self dataWithJSONObject:self options:0 error:&error];
    if (jsonData)
    {
        json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return json;
}
@end
