//
//  自定义栈：先进后出。
//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STStack<ObjectType>:NSObject
-(instancetype)init;
@property (readonly) NSUInteger count;
//!移除并返回位于 STStack<T> 顶处的对象。
-(ObjectType)pop;
//!返回位于 STStack<T> 顶处的对象但不将其移除。
-(ObjectType)peek;
//!将对象添加到 STStack<T> 的顶处
- (void)push:(ObjectType)anObject;

@end

