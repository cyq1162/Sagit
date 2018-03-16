//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString(ST)
//+ (instancetype)format:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

-(NSString*)reverse;
-(BOOL)isInt;
-(BOOL)isFloat;
-(NSString*)append:(NSString*)string;
//!检测是否已经是以后面的结尾，如果是，则不追加
-(NSString *)appendIfNotEndWith:(NSString *)string;
-(NSString*)replace:(NSString*)a with:(NSString*)b;
-(NSString *)replace:(NSString *)a with:(NSString *)b ignoreCase:(BOOL)ignoreCase;
-(NSArray<NSString*>*)split:(NSString*)separator;
-(NSString*)toUpper;
-(NSString*)toLower;
-(BOOL)startWith:(NSString*)value;
-(BOOL)endWith:(NSString*)value;
-(BOOL)contains:(NSString*)value;
-(BOOL)contains:(NSString*)value ignoreCase:(BOOL)ignoreCase;
-(BOOL)isEmpty;
-(BOOL)eq:(id)value;
+(BOOL)isNilOrEmpty:(NSString*)value;
+(NSString*)toString:(id)value;
+(NSString *)newGuid;
-(NSString*)trim;

-(NSInteger)indexOf:(NSString*)searchString;
-(NSInteger)indexOf:(NSString*)searchString ignoreCase:(BOOL)ignoreCase;
-(NSString*)firstCharUpper;
-(NSString*)firstCharLower;

-(CGSize)sizeWithFont:font maxSize:(CGSize)maxSize;
@end
