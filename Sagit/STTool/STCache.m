//
//  STCache.m
//  IT恋
//
//  Created by 陈裕强 on 2018/1/10.
//  Copyright © 2018年 Silan Xie. All rights reserved.
//

#import "STCache.h"
@interface STCache()
@property (nonatomic,retain)NSMutableDictionary*timeOutDic;
@property (nonatomic,assign)NSInteger sleepSecond;
@end
@implementation STCache
+ (instancetype)share
{
    static STCache *_share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _share = [[STCache alloc] init];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [_share clearTimeOutCache];
        });
    });
    return _share;
}

//清除过期的缓存
-(void)clearTimeOutCache
{
    self.sleepSecond=1;
    NSMutableArray<NSString*> *keys=[NSMutableArray<NSString*> new];
    while (true) {
        [NSThread sleepForTimeInterval:self.sleepSecond];
        if(_timeOutDic && _timeOutDic.count>0)//有过期的Cache
        {
            @try
            {
                for (NSString*key in _timeOutDic)
                {
                    NSDate *date=_timeOutDic[key];
                    // 时间2与时间1之间的时间差（秒）
                    if([date timeIntervalSinceReferenceDate] - [NSDate.date timeIntervalSinceReferenceDate]<0)
                    {
                        [keys addObject:key];
                    }
                   
                }
                if(keys.count>0)
                {
                    for (NSString* key in keys) {
                        [self remove:key];
                        [_timeOutDic remove:key];
                    }
                    [keys removeAllObjects];
                }
            }
            @catch(NSException*err)
            {
                NSLog(err.description);
                return;//异常则退出，不清缓存了。
            }
        }
    }
}

-(NSMutableDictionary *)cacheObj
{
    return [NSMutableDictionary share];
}
-(NSMutableDictionary *)timeOutDic
{
    if(!_timeOutDic)
    {
        _timeOutDic=[NSMutableDictionary new];
    }
    return _timeOutDic;
}
#pragma 基本方法
-(BOOL)has:(NSString*)key{
    return [self.cacheObj has:key];
}
-(id)get:(NSString*)key
{
    return [self.cacheObj get:key];
}
-(void)set:(NSString*)key value:(id)value
{
   return [self.cacheObj set:key value:value];
}
-(void)set:(NSString *)key value:(id)value second:(NSInteger)timeOutSecond
{
    [self.cacheObj set:key value:value];
    if(timeOutSecond>0)
    {
        [self.timeOutDic set:key value:[NSDate.date addSecond:timeOutSecond]];
    }
}
-(void)remove:(NSString*)key
{
    return [self.cacheObj remove:key];
}

@end
