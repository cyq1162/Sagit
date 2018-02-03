//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//
#import "STDate.h"
#import "STString.h"

@implementation NSDate(ST)
-(NSString *)toString{return [self toString:nil];}
-(NSString *)toString:(NSString*)formatter{
    if([NSString isNilOrEmpty:formatter]){formatter=@"yyyy-MM-dd HH:mm:ss";}
    NSDateComponents *com=self.component;
    return [[[[[[[formatter replace:@"yyyy" with:[self intToString:com.year len:4]]
                            replace:@"MM" with:[self intToString:com.month]]
                            replace:@"dd" with:[self intToString:com.day]]
                            replace:@"HH" with:[self intToString:com.hour]]
                            replace:@"mm" with:[self intToString:com.minute]]
                            replace:@"ss" with:[self intToString:com.second]]
                            replace:@"SSS" with:[self intToString:com.nanosecond len:3]];
}
-(NSString*)intToString:(NSInteger)value
{
    return [self intToString:value len:2];
}
-(NSString*)intToString:(NSInteger)value len:(NSInteger)len
{
    NSString *num=STNumString(value);
    if(num.length>len)
    {
        return [num substringWithRange:NSMakeRange(0, len)];
    }
    else if(num.length<len && len==2)
    {
        return [@"0" append:num];
    }
    return num;
}
-(NSString *)formatter:(NSString *)formatter
{
    if([NSString isNilOrEmpty:formatter]){formatter=@"yyyy-MM-dd HH:mm:ss";}
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:formatter];
    return [fm stringFromDate:self];
}
+(NSDate*) beiJinDate
{
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC+0800"];//北京时区的时间。
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:self];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:self];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    return [[NSDate alloc] initWithTimeInterval:interval sinceDate:self];
}
-(NSInteger)nanosecond
{
    return [self component:NSCalendarUnitNanosecond].nanosecond;
}
-(NSInteger)second
{
    return [self component:NSCalendarUnitSecond].second;
}
-(NSInteger)minute
{
    return [self component:NSCalendarUnitMinute].minute;
}
-(NSInteger)hour
{
    return [self component:NSCalendarUnitHour].hour;
}
-(NSInteger)day
{
    return [self component:NSCalendarUnitDay].day;
}
-(NSInteger)month
{
    return [self component:NSCalendarUnitMonth].month;
}
-(NSInteger)year
{
    return [self component:NSCalendarUnitYear].year;
}
-(NSDateComponents *)component
{
    return [self component:9999];
}
-(NSDateComponents *)component:(NSCalendarUnit)unit
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    //这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；
    unsigned int unitFlags =unit;
    if(unitFlags==9999)
    {
        unitFlags=NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitNanosecond ;
    }
    return [cal components:unitFlags fromDate:self];//把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；
}
-(NSDate *)addSecond:(NSInteger)second
{
    return [NSDate dateWithTimeInterval:second sinceDate:self];
}
-(NSDate *)addMinute:(NSInteger)minute
{
    return [self addSecond:minute*60];
}
-(NSDate *)addHour:(NSInteger)hour
{
    return [self addMinute:hour*60];
}
-(NSDate *)addDay:(NSInteger)day
{
    return [self addHour:day*24];
}
-(NSDate *)addMonth:(NSInteger)month
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calender dateByAddingComponents:comps toDate:self options:0];
}
-(NSDate *)addYear:(NSInteger)year
{
    return [self addMonth:year*12];
}
@end


@implementation NSDateComponents(ST)
-(NSString *)toString{return [self toString:nil];}
-(NSString *)toString:(NSString*)formatter{
    if(self.date!=nil)
    {
        return [self.date toString:formatter];
    }
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:self];
    return [date toString:formatter];
}
@end
