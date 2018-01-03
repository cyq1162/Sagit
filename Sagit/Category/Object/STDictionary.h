//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary(ST)
-(id)get:(NSString*)key;
-(BOOL)has:(NSString*)key;
-(void)set:(NSString*)key value:(id)value;
-(void)remove:(NSString*)key;
-(NSString*)toJson;
@end

@interface NSDictionary(ST)
-(id)get:(NSString*)key;
-(id)firstObject;
-(BOOL)has:(NSString*)key;
-(NSString*)toJson;
//!把格式化的JSON格式的字符串转换成字典
+ (NSDictionary *)dictionaryWithJson:(NSString *)json;
@end

@interface NSMapTable(ST)
-(id)get:(NSString*)key;
-(BOOL)has:(NSString*)key;
-(void)set:(NSString*)key value:(id)value;
-(void)remove:(NSString*)key;
@end
