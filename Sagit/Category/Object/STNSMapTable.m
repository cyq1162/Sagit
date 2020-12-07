//
//  STNSMapTable.m
//
//  Created by 陈裕强 on 2020/8/18.
//  Copyright © 2020 . All rights reserved.
//

#import "STNSMapTable.h"
#import "STCategory.h"
#pragma mark NSMapTable(ST)
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


#pragma mark STMapTable
@implementation STMapTable

-(instancetype)init
{
    _keys=[NSMutableArray<NSString*> new];
    _mapTable=[NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsStrongMemory];
    return self;
}
- (NSMutableArray<NSString *> *)keys
{
    return _keys;
}
-(NSMapTable *)mapTable
{
    return _mapTable;;
}
-(id)get:(NSString*)key
{
    return [self.mapTable objectForKey:key];
}
-(id)getWithIgnoreCase:(NSString *)key
{
    id v=[self get:key];
    if(v!=nil)
    {
        return v;
    }
    NSString *lowerKey=[key toLower];
    for (NSString* k in self.keys) {
        if([lowerKey isEqual:[k toLower]])
        {
            return [self get:k];
        }
    }
    return nil;
}
-(BOOL)has:(NSString*)key
{
    return [self.mapTable objectForKey:key]!=nil;
}
-(void)set:(NSString*)key value:(id)value
{
    if(value!=nil)
    {
        if(![self has:key])
        {
            [self.keys addObject:key];
        }
        [self.mapTable setObject:value forKey:key];
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
        [self.mapTable removeObjectForKey:item];
        [self.keys removeObject:item];
    }
    
}
@end


