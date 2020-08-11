//
//  STCache.h
//  IT恋
//
//  Created by 陈裕强 on 2018/1/10.
//  Copyright © 2018年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STCache : NSObject

+(instancetype)share;
@property (readonly,nonatomic,retain)NSMutableDictionary*cacheObj;
//!获取缓存：
-(id)get:(NSString*)key;
//!是否存在指定的缓存。
-(BOOL)has:(NSString*)key;
//!设置缓存。
-(void)set:(NSString*)key value:(id)value;
//!设置缓存：可以设置过期的时间。
-(void)set:(NSString*)key value:(id)value second:(NSInteger)timeOutSecond;
//!移除指定缓存
-(void)remove:(NSString*)key;
//!清除所有缓存
-(void)clear;
@end
