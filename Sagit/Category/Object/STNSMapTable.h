//
//  STNSMapTable.h
//
//  Created by 陈裕强 on 2020/8/18.
//  Copyright © 2020 . All rights reserved.
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



