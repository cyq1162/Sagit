//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "Sagit.h"

@implementation Sagit

+(STFile *)File
{
    return [STFile share];
}
+(NSMutableDictionary *)Cache
{
    return [NSMutableDictionary share];
}
+(STHttp *)Http
{
    return [STHttp share];
}
+(STMessageBox *)MsgBox
{
    return [STMessageBox share];
}
+(instancetype)share
{
    static Sagit *_share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _share = [Sagit new];
    });
    return _share;
}
@end
