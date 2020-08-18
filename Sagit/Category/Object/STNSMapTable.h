//
//  STNSMapTable.h
//
//  Created by 陈裕强 on 2020/8/18.
//  Copyright © 2020 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMapTable(ST)
-(id)get:(NSString*)key;
-(BOOL)has:(NSString*)key;
-(void)set:(NSString*)key value:(id)value;
-(void)remove:(NSString*)key;
@end
