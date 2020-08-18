//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

@interface STModelBase:NSObject
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

