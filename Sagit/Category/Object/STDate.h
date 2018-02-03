//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(ST)
//!自己处理的格式化，只处理年月日时分秒毫秒
-(NSString*)toString:(NSString*)formatter;
//!自己处理的格式化，只处理年月日时分秒毫秒
-(NSString*)toString;
//!系统的格式化（包括星期等信息）
-(NSString*)formatter:(NSString*)formatter;
//!返回类型可以取更多日期属性
-(NSDateComponents *)component;
//!获取北京的当前时间。
+(NSDate *)beiJinDate;

@property(readonly) NSInteger year;
@property(readonly) NSInteger month;
@property(readonly) NSInteger day;
@property(readonly) NSInteger hour;
@property(readonly) NSInteger minute;
@property(readonly) NSInteger second;
@property(readonly) NSInteger nanosecond;

-(NSDate*)addSecond:(NSInteger)second;
-(NSDate*)addMinute:(NSInteger)minute;
-(NSDate*)addHour:(NSInteger)hour;
-(NSDate*)addDay:(NSInteger)day;
-(NSDate*)addMonth:(NSInteger)month;
-(NSDate*)addYear:(NSInteger)year;

@end
@interface NSDateComponents(ST)
-(NSString*)toString:(NSString*)formatter;
-(NSString*)toString;
@end

