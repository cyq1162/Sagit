//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "Sagit.h"

@implementation Sagit
//+(instancetype)share
//{
//    static Sagit *_share = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _share = [Sagit new];
//    });
//    return _share;
//}
+(STFile *)File
{
    return [STFile share];
}
+(STCache *)Cache
{
    return [STCache share];
}
+(STHttp *)Http
{
    return [STHttp share];
}
+(STMsgBox *)MsgBox
{
    return [STMsgBox share];
}
#pragma mark 扩展一些全局的方法
+(void)delayExecute:(NSInteger)second onMainThread:(BOOL)onMainThread block:(DelayExecuteBlock)block
{
    if(!block){return;}
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:second];
        if(onMainThread)
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                block();
            });
        }
        else
        {
            block();
        }
    });
}
+(void)runOnMainThread:(DelayExecuteBlock)block
{
    if(!block){return;}
    if([NSThread isMainThread]){block();return;}
    dispatch_sync(dispatch_get_main_queue(), ^{
        block();
    });
}
@end
