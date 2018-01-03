//
//  STUIViewEvent.m
//  IT恋
//
//  Created by 陈裕强 on 2017/12/25.
//  Copyright © 2017年. All rights reserved.
//

#import "STUIViewEvent.h"
#import <objc/runtime.h>
#import "STDefine.h"
#import "STString.h"
#import "STView.h"
@implementation UIView (STUIViewEvent)
//可以附加的点击事件 (存档在keyvalue中时，无法传参（内存地址失效），只能针对性存runtime的属性)
static char clickChar='c';
static char longPressChar='p';
-(void)setClickBlock:(OnClick)block
{
    objc_setAssociatedObject(self, &clickChar, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(void)setLongPressBlock:(OnLongPress)block
{
    objc_setAssociatedObject(self, &longPressChar, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(void)callBlock:(NSString*)eventType view:(UIView*)view
{
    if([eventType isEqualToString:@"click"])
    {
        OnClick event = (OnClick)objc_getAssociatedObject(self, &clickChar);
        if(event)
        {
            STWeakObj(view);
            event(viewWeak);
        }
    }
    else if([eventType isEqualToString:@"longPress"])
    {
        OnLongPress event = (OnLongPress)objc_getAssociatedObject(self, &longPressChar);
        if(event)
        {
            STWeakObj(view);
            event(viewWeak);
        }
    }
}
#pragma mark 系统公用方法
-(BOOL)removeGesture:(Class)class
{
    if(self.gestureRecognizers!=nil)
    {
        for (NSInteger i=0; i<self.gestureRecognizers.count; i++)
        {
            UIGestureRecognizer *gestrue=self.gestureRecognizers[i];
            if([gestrue isKindOfClass:class])
            {
                [self removeGestureRecognizer:gestrue];
                gestrue=nil;
                return YES;
            }
        }
    }
    return NO;
}
-(UIGestureRecognizer*)addGesture:(NSString*)eventType
{
    self.userInteractionEnabled=YES;
    if(self.superview!=nil)
    {
        self.superview.userInteractionEnabled=YES;
    }
    if([eventType isEqualToString:@"click"])
    {
        [self removeClick];
        
        UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
        [self addGestureRecognizer:click];
        return click;
    }
    else if([eventType isEqualToString:@"longPress"])
    {
        [self removeLongPress];
        
        UILongPressGestureRecognizer *longPress= [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressStart:)];
        [self addGestureRecognizer:longPress];
        return longPress;
    }
    return nil;
}
-(UIView*)addEvent:(NSString*)eventType event:(NSString *)eventName target:(UIViewController*)eventTarget
{
    if([NSString isNilOrEmpty:eventName]){return self;}
     [self addGesture:eventType];//先添加事件（内部有清除参数）
    //检测event是否带.号
    NSArray<NSString*> *items=[eventName split:@"."];
    if(items.count>1)
    {
        NSString *pointViewKey=[eventType append:@"PointView"];
        [self key:pointViewKey value:items.firstObject];//指定这一条即可。
    }
    else
    {
        NSString *viewKey=[eventType append:@"View"];
        NSString *selKey=[eventType append:@"Sel"];
        NSString *targetKey=[eventType append:@"Target"];
        
        UIView *view=self;
        NSString *sel=items.lastObject;
        id target=eventTarget;
        
        if(target==nil)
        {
            //发现这招成功了，不过要配合Controller的delloc方法执行view removeAllView，不然控制器释放后，有消息发来时，就出现野指针错误，很压抑。
            target=@"1";
            //不能存档自身指向的Controller，会引发双向引用，内存不释放问题，所以只存标识1,用的时候再拿就可以了。
//            if(self.stController!=nil)
//            {
//                target=self.stController;
//            }
//            else
//            {
//                target=self;
//            }
        }
        else if(target==self)
        {
            target=@"0";
        }
        [self key:viewKey value:view];
        [self key:selKey value:sel];
        [self key:targetKey value:target];
        //[Sagit.Cache set:eventName value:target];//这招也失败了....
    }
    return self;
}
-(UIView*)exeEvent:(NSString*)eventType
{
    //检测有没有指向的View
    NSString *pointViewKey=[eventType append:@"PointView"];
    if(self.stView!=nil)
    {
        NSString *name=[self key:pointViewKey];
        if(name)
        {
            UIView *pointView=self.stView.UIList[name];
            if(pointView!=nil)
            {
               return [pointView exeEvent:eventType];
            }
        }
    }
    
    NSString *selKey=[eventType append:@"Sel"];
    NSString *targetKey=[eventType append:@"Target"];
    NSString *viewKey=[eventType append:@"View"];
    UIView *view=[self key:viewKey];
    if(view==nil){view=self;}
    
    id target=[self key:targetKey];
    //id target= [Sagit.Cache get:[self key:selKey]];
    if(target!=nil)
    {
        if([target isKindOfClass:[NSString class]])
        {
            NSString*type=(NSString*)target;
            if([type isEqualToString:@"1"] && self.stController!=nil)
            {
                target=self.stController;
            }
            else
            {
                target=self;
            }
        }
        SEL sel=[self getSel:[self key:selKey] controller:target];
        if(sel!=nil && target!=nil)
        {
            [target performSelector:sel withObject:view];
        }
    }
    else
    {
        [self callBlock:eventType view:view];
    }
    return self;
}
-(SEL*)getSel:(NSString*)event controller:(UIViewController*)controller
{
    if(controller==nil)
    {
        controller=self.stController;
    }
    if(controller==nil)
    {
        return nil;
    }
    SEL sel=nil;
    BOOL isEvent=NO;
    if(event!=nil)
    {
        sel=NSSelectorFromString(event);
        isEvent=[controller respondsToSelector:sel];
        if(!isEvent && ![event endWith:@"Click"] && ![event endWith:@":"] && ![event endWith:@"Controller"])
        {
            sel=NSSelectorFromString([event append:@":"]);
            isEvent=[controller respondsToSelector:sel];
            if(!isEvent)
            {
                sel=NSSelectorFromString([event append:@"Click"]);
                isEvent=[controller respondsToSelector:sel];
                if(!isEvent)
                {
                    sel=NSSelectorFromString([event append:@"Click:"]);
                    isEvent=[controller respondsToSelector:sel];
                    if(!isEvent)
                    {
                        Class class= NSClassFromString([event append:@"Controller"]);
                        if(class!=nil)
                        {
                            sel=NSSelectorFromString(@"redirect:");
                            isEvent=YES;
                        }
                        
                    }
                }
            }
        }
    }
    if(isEvent)
    {
        //self.userInteractionEnabled=YES;
        return sel;
    }
    return nil;
}
#pragma mark click 事件
-(UIView*)click
{
    return [self exeEvent:@"click"];
}
-(UIView*)addClick:(NSString *)event
{
    return [self addClick:event target:nil];
}
-(UIView*)addClick:(NSString *)event target:(UIViewController*)target
{
    return [self addEvent:@"click" event:event target:target];
}
-(UIView*)onClick:(OnClick)block
{
    if(block!=nil)
    {
        [self addGesture:@"click"];//内部有清除参数，放在前面
        [self key:@"clickView" value:self];
        [self setClickBlock:block];
        
    }
    return self;
}
-(UIView *)removeClick
{
    if([self removeGesture:[UITapGestureRecognizer class]])
    {
        //移除参数
        [self.keyValue remove:@"clickView,clickSel,clickTarget,clickPointView"];
        [self setClickBlock:nil];
    }
    return self;
}

#pragma mark longPress 事件
- (UIView *)longPressStart:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
       return [self longPress];
    }
    return nil;
}
-(UIView *)longPress
{
    return [self exeEvent:@"longPress"];
}
-(UIView *)addLongPress:(NSString *)event
{
    return [self addLongPress:event target:nil];
}
-(UIView *)addLongPress:(NSString *)event target:(UIViewController *)target
{
    return [self addEvent:@"longPress" event:event target:target];
}
-(UIView *)onLongPress:(OnLongPress)block
{
    if(block!=nil)
    {
        [self addGesture:@"longPress"];//放在前面，内部有清除参数。
        [self key:@"longPressView" value:self];
        [self setLongPressBlock:block];
        
    }
    return self;
}
-(UIView *)removeLongPress
{
    if([self removeGesture:[UILongPressGestureRecognizer class]])
    {
        //移除参数
        [self.keyValue remove:@"longPressView,longPressSel,longPressTarget,longPressPointView"];
        [self setLongPressBlock:nil];
    }
    return self;
}
#pragma mark 增加描述
//用于格式化增加描述的方法
-(void)block:(NSString *)description on:(ViewDescription)descBlock
{
    if(descBlock!=nil)
    {
        STWeakSelf;
        descBlock(this);
    }
}
@end
