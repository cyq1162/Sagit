//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STString.h"
#import "STDefine.h"
@implementation NSString(ST)

-(NSString *)reverse
{
    NSMutableString *newString = [[NSMutableString alloc] initWithCapacity:self.length];
    for (long i = self.length - 1; i >=0 ; i --) {
        unichar ch = [self characterAtIndex:i];
        [newString appendFormat:@"%c",ch];
    }
    return newString;
    
}

- (BOOL)isInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：

- (BOOL)isFloat{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
-(NSString *)append:(NSString *)string{
    return [NSString stringWithFormat:@"%@%@",self,string];
}
-(NSString *)replace:(NSString *)a with:(NSString *)b
{
    return [self replace:a with:b isCase:NO];
}
-(NSString *)replace:(NSString *)a with:(NSString *)b isCase:(BOOL)isCase
{
    if(a==nil){return self;}
    if(b==nil){b=@"";}
    if(!isCase)
    {
        return [self stringByReplacingOccurrencesOfString:a withString:b];
    }
    NSRange range = NSMakeRange(0, [self length]);
    return [self stringByReplacingOccurrencesOfString:a withString:b options:NSCaseInsensitiveSearch range:range];
}
-(NSArray<NSString*>*)split:(NSString*)separator
{
    return [self componentsSeparatedByString:separator];
}
-(NSString*)toUpper{return [self uppercaseString];}
-(NSString*)toLower{return [self lowercaseString];}
-(BOOL)startWith:(NSString *)value{return [self hasPrefix:value];}
-(BOOL)endWith:(NSString *)value{return [self hasSuffix:value];}
-(BOOL)contains:(NSString *)value{return [self containsString:value];}
-(BOOL)contains:(NSString *)value isCase:(BOOL)isCase{return [self indexOf:value isCase:isCase]>=0;}
-(BOOL)isEmpty{return [self isEqualToString:@""];}
+(BOOL)isNilOrEmpty:(NSString*)value{return value==nil || [value isEmpty];}
+(NSString *)toString:(id)value{return [NSString stringWithFormat:@"%@",value];}
-(NSString*)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(NSInteger)indexOf:(NSString*)searchString
{
    return [self indexOf:searchString isCase:NO];
}
-(NSInteger)indexOf:(NSString*)searchString isCase:(BOOL)isCase
{
    NSRange rnd=NSMakeRange(-1, 0);
    if(!isCase)
    {
        rnd=[self rangeOfString:searchString];
    }
    else
    {
        rnd=[self rangeOfString:searchString options:NSCaseInsensitiveSearch];
    }
    return rnd.length>0?rnd.location:-1;
}
-(NSString*)firstCharUpper
{
    if(self.length>0)
    {
        if(self.length==0)
        {
            return [NSString stringWithFormat:@"%c",STCharUpper([self characterAtIndex:0])];
        }
        return [NSString stringWithFormat:@"%c%@",STCharUpper([self characterAtIndex:0]),[self substringFromIndex:1]];
    }
    return self;
}
-(NSString*)firstCharLower
{
    if(self.length>0)
    {
        if(self.length==0)
        {
            return [NSString stringWithFormat:@"%c",STCharLower([self characterAtIndex:0])];
        }
        return [NSString stringWithFormat:@"%c%@",STCharLower([self characterAtIndex:0]),[self substringFromIndex:1]];
    }
    return self;
}
@end
