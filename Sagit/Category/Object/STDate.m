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
+(NSDateComponents *)now
{
    NSDate *date = [NSDate beiJinDate];//这个是NSDate类型的日期，所要获取的年月日都放在这里；
    NSCalendar *cal = [NSCalendar currentCalendar];
    //这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；
    unsigned int unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitNanosecond ;
    
    return [cal components:unitFlags fromDate:date];//把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；

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
