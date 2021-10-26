//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark NSMapTable(ST)
@interface NSMapTable(ST)
-(id)get:(NSString*)key;
-(BOOL)has:(NSString*)key;
-(void)set:(NSString*)key value:(id)value;
-(void)remove:(NSString*)key;
@end

#pragma mark STMapTable
@interface STMapTable : NSObject
@property (nonatomic,retain)NSMutableArray<NSString*> *keys;
@property (nonatomic,retain) NSMapTable *mapTable;
-(instancetype)init;

-(id)get:(NSString*)key;
//!取值并忽略大小写。
-(id)getWithIgnoreCase:(NSString*)key;
-(BOOL)has:(NSString*)key;
-(void)set:(NSString*)key value:(id)value;
-(void)remove:(NSString*)key;
@end



