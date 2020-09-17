//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUIControl.h"
#import "STUIView.h"
//#import "STDefine.h"
@implementation UIControl (ST)

#pragma mark 系统事件

//!执行点击事件
//-(UIControl*)action;
//!绑定事件 event：指定事件名称，也可以是控制器名称，也可以指向其它UI的事件，如：Age.click (Age是其它UI的name）
//-(UIControl*)addAction:(NSString*)event;
//!绑定事件 并指定target
//-(UIControl*)addAction:(NSString *)event target:(UIViewController*)target
//{
//
//    return self;
//}
//!绑定事件 用代码块的形式
-(UIControl*)onAction:(UIControlEvents)event on:(OnAction)block
{
    if(block)
    {
        SEL sel=NSSelectorFromString(@"exeAction:a1");
        NSString *eventKey=@"event1";
        for (int i=1; i<10; i++) {
            NSString *key=[@"event" append:STNumString(i)];
            if(![self.keyValue has:key])
            {
                eventKey=key;
                sel=NSSelectorFromString(STString(@"exeAction:a%d:",i));
                break;
            }
        }
       
        NSString *searchKey=[@"event_"append:STNumString(event)];
        NSString *searchValue=[self key:searchKey];//用于移除查找事件。
        if(searchValue==nil)
        {
            [self key:searchKey value:eventKey];
        }
        else
        {
            [self key:searchKey value:STString(@"%@,%@",searchValue,eventKey)];//指向同一个事件。
        }
        [self key:eventKey value:block];
        [self addTarget:self action:sel forControlEvents:event];
    }
    return self;
}
//由于无法知道事件来源，只能事先定义多个不同参方法来识别。
-(void)exeAction:(id)sender a1:(id)a{[self exeAction:1];}
-(void)exeAction:(id)sender a2:(id)a{[self exeAction:2];}
-(void)exeAction:(id)sender a3:(id)a{[self exeAction:3];}
-(void)exeAction:(id)sender a4:(id)a{[self exeAction:4];}
-(void)exeAction:(id)sender a5:(id)a{[self exeAction:5];}
-(void)exeAction:(id)sender a6:(id)a{[self exeAction:6];}
-(void)exeAction:(id)sender a7:(id)a{[self exeAction:7];}
-(void)exeAction:(id)sender a8:(id)a{[self exeAction:8];}
-(void)exeAction:(id)sender a9:(id)a{[self exeAction:9];}
-(void)exeAction:(NSInteger)num
{
    //目前只处理一个
    OnAction action=[self key:[@"event" append:STNumString(num)]];
    if(action)
    {
        action(self);
    }
}
//!移除绑定点击事件
-(UIControl*)removeAction:(UIControlEvents)event
{
    [self removeTarget:self action:nil forControlEvents:event];
    NSString *key=[self key:[@"event_"append:STNumString(event)]];
    if(key!=nil)
    {
        NSArray *items=[key split:@","];
        for (NSString *item in items) {
             [self key:item value:nil];//移除方法block
        }

    }
    return self;
}

#pragma mark 系统属性
-(UIControl *)enabled:(BOOL)yesNo
{
    [self alpha:yesNo?1:0.4];
    [self setEnabled:yesNo];
    return self;
}
-(UIControl *)selected:(BOOL)yesNo
{
    [self setSelected:yesNo];
    return self;
}
-(UIControl *)highlighted:(BOOL)yesNo
{
    [self setHighlighted:yesNo];
    return self;
}
//-(void)dealloc
//{
//    //[self removeTarget:self action:nil forControlEvents:nil];
//}
@end
