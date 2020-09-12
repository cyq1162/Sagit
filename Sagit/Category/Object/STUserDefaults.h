//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSUserDefaults(ST)
-(void)set:(NSString*)key value:(NSString*)value;
-(NSString*)get:(NSString*)key;
-(BOOL)has:(NSString*)key;
-(void)remove:(NSString *)key;
@end
