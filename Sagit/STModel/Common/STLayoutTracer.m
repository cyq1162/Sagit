//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STLayoutTracer.h"
#import "STCategory.h"
@implementation STLayoutTracer
-(BOOL)hasRelateTop
{
    NSString *relate=[@(self.location) stringValue];
    return [relate contains:@"2"];
}
-(BOOL)hasRelateLeft
{
    NSString *relate=[@(self.location) stringValue];
    return [relate contains:@"1"];
}
-(BOOL)hasRelateRight
{
    NSString *relate=[@(self.location) stringValue];
    return [relate contains:@"3"];
}
-(BOOL)hasRelateBottom
{
    NSString *relate=[@(self.location) stringValue];
    return [relate contains:@"4"];
}
-(CGFloat)relateTopPx
{
    return [self relatePx:Top];
}
-(CGFloat)relateLeftPx
{
    return [self relatePx:Left];
}
-(CGFloat)relateRightPx
{
    return [self relatePx:Right];
}
-(CGFloat)relateBottomPx
{
    return [self relatePx:Bottom];
}
-(CGFloat)relatePx:(XYLocation)location
{
    NSString *relate=[@(self.location) stringValue];
    if(relate)
    {
        NSInteger index=-1;
        switch (location) {
            case Top:
                index=[relate indexOf:@"2"];
                break;
            case Left:
                index=[relate indexOf:@"1"];
                break;
            case Right:
                index=[relate indexOf:@"3"];
                break;
            case Bottom:
                index=[relate indexOf:@"4"];
                break;
            default:
                break;
        }
        if(index==0){return self.v1;}
        if(index==1){return self.v2;}
        if(index==2){return self.v3;}
        if(index==3){return self.v4;}
    }
    return 0;
}
@end
