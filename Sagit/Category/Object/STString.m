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
//+(instancetype)format:(NSString *)format, ...
//{
//    va_list ap;
//    va_start(ap, format);
//    NSString *item;
//    while ((item = va_arg(ap, NSString *)))
//    {
//        if(item==nil)
//        {
//            item=@"";
//        }
//    }
//    NSString *result=[[NSString alloc] initWithFormat:format arguments:ap];
//    va_end(ap);
//    return result;
//}
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
-(NSString *)appendIfNotEndWith:(NSString *)string
{
    if(![self endWith:string])
    {
        return [self append:string];
    }
    return self;
}
-(NSString *)append:(NSString *)string
{
    return [NSString stringWithFormat:@"%@%@",self,string];
}
-(NSString *)replace:(NSString *)a with:(NSString *)b
{
    return [self replace:a with:b ignoreCase:NO];
}
-(NSString *)replace:(NSString *)a with:(NSString *)b ignoreCase:(BOOL)ignoreCase
{
    if(a==nil){return self;}
    if(b==nil){b=@"";}
    if(!ignoreCase)
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
-(BOOL)contains:(NSString *)value ignoreCase:(BOOL)ignoreCase{return [self indexOf:value ignoreCase:ignoreCase]>=0;}
-(BOOL)isEmpty{return [self isEqualToString:@""];}
+(BOOL)isNilOrEmpty:(NSString*)value{return value==nil || [value isKindOfClass:[NSNull class]] || [value isEmpty];}
-(BOOL)eq:(id)value
{
    if([value isKindOfClass:[NSNumber class]])
    {
        value=((NSNumber*)value).stringValue;
    }
    return [self isEqualToString:value];
}
+(NSString *)toString:(id)value
{
    return [NSString stringWithFormat:@"%@",value];
}
+(NSString *)newGuid
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}
-(NSString*)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
-(NSString *)trimStart:(NSString *)value
{
    if(value==nil || ![self startWith:value]){return self;}
    return [self substringFromIndex:value.length];
}
-(NSString *)trimEnd:(NSString *)value
{
    if(value==nil || ![self endWith:value]){return self;}
    return [self substringToIndex:self.length-value.length];
}
-(NSInteger)indexOf:(NSString*)searchString
{
    return [self indexOf:searchString ignoreCase:NO];
}
-(NSInteger)indexOf:(NSString*)searchString ignoreCase:(BOOL)ignoreCase
{
    NSRange rnd=NSMakeRange(-1, 0);
    if(!ignoreCase)
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
/**
 获取字符串的大小
 txt:label或button的title
 font:字体大小
 size:允许最大size
 */
-(CGSize) sizeWithFont:font maxSize:(CGSize)maxSize
{
    
    CGSize _size;
    #if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine |
    
    NSStringDrawingUsesLineFragmentOrigin |
    
    NSStringDrawingUsesFontLeading;
    
    _size = [self boundingRectWithSize:maxSize options: options attributes:attribute context:nil].size;
    
#else
    
    _size = [txt sizeWithFont:font constrainedToSize:maxSize];
    
#endif
    
    return _size;
    
}
@end
