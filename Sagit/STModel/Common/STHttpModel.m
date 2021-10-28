//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STHttpModel.h"

@implementation STHttpModel

-(BOOL)isIgnore:(NSString *)name
{
    if([name eq:@"msgArray"] || [name eq:@"msgDic"] ||[name eq:@"msgString"])
    {
        return YES;
    }
    return [super isIgnore:name];
}

-(NSArray*)msgArray
{
    if(self.msg && [self.msg isKindOfClass:[NSArray class]])
    {
        return (NSArray*)self.msg;
    }
    return nil;
}
-(NSDictionary *)msgDic
{
    if(self.msg && [self.msg isKindOfClass:[NSDictionary class]])
    {
        return (NSDictionary*)self.msg;
    }
    return nil;
}
-(NSString *)msgString
{
    if(self.msg && [self.msg isKindOfClass:[NSString class]])
    {
        return (NSString*)self.msg;
    }
    return nil;
}
@end
