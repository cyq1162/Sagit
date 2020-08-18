//
//  STNSMapTable.m
//
//  Created by 陈裕强 on 2020/8/18.
//  Copyright © 2020 . All rights reserved.
//

#import "STNSMapTable.h"


@implementation NSMapTable(ST)

-(id)get:(NSString*)key
{
    return [self objectForKey:key];
}
-(BOOL)has:(NSString*)key
{
    return [self objectForKey:key]!=nil;
}
-(void)set:(NSString*)key value:(id)value
{
    if(value!=nil)
    {
        [self setObject:value forKey:key];
    }
    else
    {
        [self remove:key];
    }
}

-(void)remove:(NSString*)key
{
    NSArray *items=[key split:@","];
    for (NSString* item in items)
    {
        [self removeObjectForKey:item];
    }
    
}
@end
