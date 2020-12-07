//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//
//  Copyright © 2017-2027年. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface STModelBase:NSObject
//@用于方便子类扩展属性用。
@property(nonatomic,strong) NSMutableDictionary* stKeyValue;
-(id)init;
-(id)initWithObject:(id<NSObject>)msg;
-(id)initWithDictionary:(NSDictionary*)dic;
-(NSDictionary*)toDictionary;

//!指定的属性名称是否忽略。
-(BOOL)isIgnore:(NSString*)name;
//!是否忽略大小写。
-(BOOL)isIgnoreCase;
//转JSON。
-(NSString*)toJson;
//!NSArray<NSDictionary> 转 NSArray<Model>
+(NSArray<id>* )toArrayEntityFrom:(NSArray*)array;
@end

