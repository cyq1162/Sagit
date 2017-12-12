//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary(ST)
-(BOOL)has:(NSString*)key;
-(void)set:(NSString*)key value:(id)value;
-(NSString*)toJson;
@end

@interface NSDictionary(ST)
-(BOOL)has:(NSString*)key;
-(NSString*)toJson;
@end
