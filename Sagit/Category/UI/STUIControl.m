//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUIControl.h"

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
        
        [self key:@"event" value:block];
        [self addTarget:self action:@selector(exeAction) forControlEvents:event];
    }
    return self;
}
//由于无法知道事件来源，只能事先定义多个不同参方法来识别(二进制 1100),回头有时间再处理。
//-(void)exeAction{[self exeAction:nil a:NO b:NO c:NO];}
-(void)exeAction:(id)sender{[self exeAction:sender a:NO b:NO c:NO];}
-(void)exeAction:(id)sender a:(BOOL)a{[self exeAction:sender a:YES b:NO c:NO];}
-(void)exeAction:(id)sender a:(BOOL)a b:(BOOL)b{[self exeAction:sender a:YES b:YES c:NO];}
-(void)exeAction:(id)sender a:(BOOL)a b:(BOOL)b c:(BOOL)c{}
-(void)exeAction
{
    //目前只处理一个
    OnAction action=[self key:@"event"];
    if(action)
    {
        STWeakObj(self);
        action(selfWeak);
    }
}
//!移除绑定点击事件
//-(UIControl*)removeAction:(UIControlEvents)event
//{
//    [self removeTarget:self action:nil forControlEvents:event];
//    return self;
//}

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
-(void)dealloc
{
    //[self removeTarget:self action:nil forControlEvents:nil];
}
@end
