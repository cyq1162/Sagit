//
//  STNSMutableDictionary.h
//
//  Created by 陈裕强 on 2020/8/18.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary(ST)
+(instancetype)share;
//!把格式化的JSON格式的字符串转换成字典
+(id)initWithJsonOrEntity:(id)jsonOrEntity;
-(id)get:(NSString*)key;
//!取值并忽略大小写。
-(id)getWithIgnoreCase:(NSString*)key;
-(BOOL)has:(NSString*)key;
-(void)set:(NSString*)key value:(id)value;
//-(void)set:(NSString*)key valueWeak:(id)value;
-(void)remove:(NSString*)key;
-(NSString*)toJson;
//!转成实体类（Model）
+(void)dictionaryToEntity:(NSDictionary*)dic to:(id<NSObject>)entity;
@end


