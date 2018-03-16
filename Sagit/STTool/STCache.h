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
-(id)get:(NSString*)key;
-(BOOL)has:(NSString*)key;
-(void)set:(NSString*)key value:(id)value;
//!可以设置过期的时间。
-(void)set:(NSString*)key value:(id)value second:(NSInteger)timeOutSecond;
-(void)remove:(NSString*)key;
@end
