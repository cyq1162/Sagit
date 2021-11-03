//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(ST)
@property (nonatomic,retain)NSDictionary* caseDic;
//!把格式化的JSON格式的字符串转换成字典
+(id)initWithJsonOrEntity:(id)jsonOrEntity;

-(NSMutableDictionary*)toNSMutableDictionary;
-(id)get:(NSString*)key;
//!取值并忽略大小写。
-(id)getWithIgnoreCase:(NSString*)key;
-(id)firstObject;
-(BOOL)has:(NSString*)key;
-(NSString*)toJson;
//!转成实体类（Model）
+(void)dictionaryToEntity:(NSDictionary*)dic to:(id<NSObject>)entity;

@end


@interface NSJSONSerialization(ST)
+(NSString*)dicToJson:(NSDictionary*)dic;
+(NSString*)arrayToJson:(NSArray*)array;
@end


