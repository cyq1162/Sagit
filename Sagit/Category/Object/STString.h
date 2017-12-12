//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString(ST)

-(NSString*)reverse;
-(BOOL)isInt;
-(BOOL)isFloat;
-(NSString*)append:(NSString*)string;
-(NSString*)replace:(NSString*)a with:(NSString*)b;
-(NSString *)replace:(NSString *)a with:(NSString *)b isCase:(BOOL)isCase;
-(NSArray<NSString*>*)split:(NSString*)separator;
-(NSString*)toUpper;
-(NSString*)toLower;
-(BOOL)startWith:(NSString*)value;
-(BOOL)endWith:(NSString*)value;
-(BOOL)contains:(NSString*)value;
-(BOOL)contains:(NSString*)value isCase:(BOOL)isCase;
-(BOOL)isEmpty;
+(BOOL)isNilOrEmpty:(NSString*)value;
+(NSString*)toString:(id)value;
-(NSString*)trim;


-(NSInteger)indexOf:(NSString*)searchString;
-(NSInteger)indexOf:(NSString*)searchString isCase:(BOOL)isCase;
-(NSString*)firstCharUpper;
-(NSString*)firstCharLower;
@end
