//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
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
+(STLocation *)Location
{
    return [STLocation share];
}
#pragma mark 扩展一些全局的方法
+(void)delayExecute:(double)second onMainThread:(BOOL)onMainThread block:(DelayExecuteBlock)block
{
    if(!block){return;}
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if(second>0)
        {
            [NSThread sleepForTimeInterval:second];
        }
        __block DelayExecuteBlock exeBlock=block;
        if(onMainThread && !NSThread.isMainThread)
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                exeBlock();
                exeBlock=nil;
            });
        }
        else
        {
            exeBlock();
            exeBlock=nil;
        }
    });
}
+(void)runOnMainThread:(DelayExecuteBlock)block
{
    if(!block){return;}
    __block DelayExecuteBlock exeBlock=block;
    if([NSThread isMainThread]){exeBlock();exeBlock=nil;return;}
    dispatch_sync(dispatch_get_main_queue(), ^{
        exeBlock();
        exeBlock=nil;
    });
}
@end
