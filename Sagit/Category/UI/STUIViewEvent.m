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
#import "STUIView.h"
#import "STUIViewAddUI.h"
#import "STDictionary.h"
#import "Sagit.h"
@class STView;
@implementation UIView (STUIViewEvent)
//可以附加的点击事件 (存档在keyvalue中时，无法传参（内存地址失效），只能针对性存runtime的属性)
//static char clickChar='c';
//static char longPressChar='p';
//static char dragChar='d';

//-(void)setClickBlock:(OnViewClick)block
//{
//    objc_setAssociatedObject(self, &clickChar, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}
//-(void)setLongPressBlock:(OnLongPress)block
//{
//    objc_setAssociatedObject(self, &longPressChar, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}
//-(void)setDragBlock:(OnViewDrag)block
//{
//    objc_setAssociatedObject(self, &dragChar, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}
-(void)callBlock:(NSString*)eventType view:(UIView*)view
{
    if([eventType isEqualToString:@"click"])
    {
        OnViewClick event = [self key:@"onClick"];//(OnViewClick)objc_getAssociatedObject(self, &clickChar);
        if(event)
        {
            event(view);
        }
    }
    else if([eventType isEqualToString:@"longPress"])
    {
        OnLongPress event = [self key:@"onLongPress"];//(OnLongPress)objc_getAssociatedObject(self, &longPressChar);
        if(event)
        {
            event(view);
        }
    }
    else if([eventType isEqualToString:@"drag"])
    {
        OnViewDrag event = [self key:@"onDrag"];// (OnViewDrag)objc_getAssociatedObject(self, &dragChar);
        if(event)
        {
            UIPanGestureRecognizer *recognizer= (UIPanGestureRecognizer*)[self key:@"dragRecognizer"];
            event(view,recognizer);
        }
    }
    else if([eventType isEqualToString:@"slide"])
    {
        OnViewSlide event = [self key:@"onSlide"];// (OnViewDrag)objc_getAssociatedObject(self, &dragChar);
        if(event)
        {
            //NSString * to= [self key:@"slideTo"];
            UISwipeGestureRecognizer *recognizer=(UISwipeGestureRecognizer*)[self key:@"slideRecognizer"];
            event(view,recognizer);
        }
    }
}
#pragma mark 系统公用方法
-(BOOL)removeGesture:(Class)class
{
    BOOL result=NO;
    if(self.gestureRecognizers!=nil)
    {
        for (NSInteger i=0; i<self.gestureRecognizers.count; i++)
        {
            UIGestureRecognizer *gestrue=self.gestureRecognizers[i];
            if([gestrue isKindOfClass:class])
            {
                //gestrue.name
                [self removeGestureRecognizer:gestrue];
                gestrue=nil;
                result=YES;
            }
        }
    }
    return result;
}
#pragma 处理手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(![gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){return YES;}
    UIView *view=gestureRecognizer.view;
    if([view isKindOfClass:[UITextField class]])
    {
        for (NSInteger i=view.gestureRecognizers.count-1; i>=0; i--)
        {
            UIGestureRecognizer *gestrue=self.gestureRecognizers[i];
            NSString *name=NSStringFromClass([gestrue class]);
            if([name eq:@"UITextTapRecognizer"])//该手势在10.3.1系统下，会抢占默认的Tap事件，导致点击失效
            {
                [view removeGestureRecognizer:gestrue];
                gestrue=nil;
            }
        }
    }
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
//    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]) {
//        return YES;
//    }
//    return NO;
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
        click.delegate=(id)self;
        click.numberOfTapsRequired=1;//设置点按次数，默认为1
        click.numberOfTouchesRequired=1;//点按的手指数
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
    else if([eventType isEqualToString:@"drag"])
    {
        [self removeDrag];
        UIPanGestureRecognizer *drag= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragStart:)];
        [self addGestureRecognizer:drag];
        return drag;
    }
        else if([eventType isEqualToString:@"slide"])
        {
            [self removeSlide];
            UISwipeGestureRecognizer *slideLeft= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideStart:)];
            [slideLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
            [self addGestureRecognizer:slideLeft];
            
            UISwipeGestureRecognizer *slideRight= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideStart:)];
            [slideRight setDirection:UISwipeGestureRecognizerDirectionRight];
            [self addGestureRecognizer:slideRight];
            
            UISwipeGestureRecognizer *slideUp =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideStart:)];
            [slideUp setDirection:UISwipeGestureRecognizerDirectionUp];
            [self addGestureRecognizer:slideUp];
            
            UISwipeGestureRecognizer *slideDown= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideStart:)];
            [slideDown setDirection:UISwipeGestureRecognizerDirectionDown];
            [self addGestureRecognizer:slideDown];
            
            return slideLeft;
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
        [self key:viewKey valueWeak:view];
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
            UIView *pointView=[self.stView.UIList get:name];
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
#pragma clang diagnostic push //忽略系统的内存泄漏警告。
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:sel withObject:view];
#pragma clang diagnostic pop
            
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
-(NSInteger)clickInterval
{
    NSString *second=[self key:@"clickInterval"];
    if(second!=nil)
    {
        return  second.integerValue;
    }
    return 0;
}
-(UIView *)clickInterval:(NSInteger)sencond
{
    [self key:@"clickInterval" value:STNumString(sencond)];
    return  self;
}
-(UIView*)click
{
//    if(self.userInteractionEnabled)
//    {
//        [self exeEvent:@"click"];
//    }
    if(self.userInteractionEnabled)
    {
        self.userInteractionEnabled=NO;
        [self exeEvent:@"click"];
        [Sagit delayExecute:self.clickInterval onMainThread:YES block:^{
            @try
            {
              self.userInteractionEnabled=YES;
            }
            @catch(NSException *err){}
        }];

    }
    return self;
}
-(UIView*)addClick:(NSString *)event
{
    return [self addClick:event target:nil];
}
-(UIView*)addClick:(NSString *)event target:(UIViewController*)target
{
    return [self addEvent:@"click" event:event target:target];
}
-(UIView*)onClick:(OnViewClick)block
{
    if(block!=nil)
    {
        [self addGesture:@"click"];//内部有清除参数，放在前面
        [self key:@"clickView" value:self];
        [self key:@"onClick" value:block];
        //[self setClickBlock:block];
        
    }
    return self;
}
-(UIView *)removeClick
{
    if([self removeGesture:[UITapGestureRecognizer class]])
    {
        //移除参数
        [self.keyValue remove:@"clickView,clickSel,clickTarget,clickPointView,onClick"];
        //[self setClickBlock:nil];
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
    if(self.userInteractionEnabled)
    {
        return [self exeEvent:@"longPress"];
    }
    return self;
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
        [self key:@"onLongPress" value:block];
        //[self setLongPressBlock:block];
        
    }
    return self;
}
-(UIView *)removeLongPress
{
    if([self removeGesture:[UILongPressGestureRecognizer class]])
    {
        //移除参数
        [self.keyValue remove:@"longPressView,longPressSel,longPressTarget,longPressPointView,onLongPress"];
        //[self setLongPressBlock:nil];
    }
    return self;
}
#pragma mark 扩展系统事件 - 拖动
- (UIView *)dragStart:(UIPanGestureRecognizer *)recognizer
{
    [self key:@"dragRecognizer" value:recognizer];
    [self drag];
    CGPoint point = [recognizer translationInView:self];
    self.center = CGPointMake(recognizer.view.center.x + point.x, recognizer.view.center.y + point.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
    return self;
}
-(UIView *)drag
{
    if(self.userInteractionEnabled)
    {
        return [self exeEvent:@"drag"];
    }
    return self;
}
-(UIView *)addDrag:(NSString *)event
{
    return [self addDrag:event target:nil];
}
-(UIView *)addDrag:(NSString *)event target:(UIViewController *)target
{
    return [self addEvent:@"drag" event:event target:target];
}
-(UIView *)onDrag:(OnViewDrag)block
{
    if(block!=nil)
    {
        [self addGesture:@"drag"];//放在前面，内部有清除参数。
        [self key:@"dragView" value:self];
        [self key:@"onDrag" value:block];
        //[self setDragBlock:block];
        
    }
    return self;
}
-(UIView *)removeDrag
{
    if([self removeGesture:[UIPanGestureRecognizer class]])
    {
        //移除参数
        [self.keyValue remove:@"dragView,dragSel,dragTarget,dragPointView,onDrag,dragRecognizer"];
        //[self setDragBlock:nil];
    }
    return self;
}

#pragma mark 扩展系统事件 - slide 滑动事件
- (UIView *)slideStart:(UISwipeGestureRecognizer *)recognizer
{
    [self key:@"slideRecognizer" value:recognizer];
    return [self slide];
}
-(UIView *)slide
{
    if(self.userInteractionEnabled)
    {
        return [self exeEvent:@"slide"];
    }
    return self;
}
-(UIView *)addSlide:(NSString *)event
{
    return [self addSlide:event target:nil];
}
-(UIView *)addSlide:(NSString *)event target:(UIViewController *)target
{
    return [self addEvent:@"slide" event:event target:target];
}
-(UIView *)onSlide:(OnViewSlide)block
{
    if(block!=nil)
    {
        [self addGesture:@"slide"];//放在前面，内部有清除参数。
        [self key:@"slideView" value:self];
        [self key:@"onSlide" value:block];
    }
    return self;
}
-(UIView *)removeSlide
{
    if([self removeGesture:[UISwipeGestureRecognizer class]])
    {
        //移除参数
        [self.keyValue remove:@"slideView,slideSel,slideTarget,slidePointView,onSlide,slideRecognizer"];
    }
    return self;
}
#pragma mark 扩展的回调事件
-(AfterEvent)onAfter
{
    return [self key:@"onAfter"];
}
-(UIView *)onAfter:(AfterEvent)block
{
    [self key:@"onAfter" value:block];
    return self;
}
#pragma mark 增加描述
//用于格式化增加描述的方法
-(UIView*)block:(NSString *)description on:(ViewDescription)descBlock
{
    if(descBlock!=nil)
    {
       //STWeakSelf;
       descBlock(self);//对于自身对自身的引用，无需弱引用。
       descBlock=nil;
    }
    return self;
}
-(UIView *)block:(ViewDescription)descBlock
{
    return [self block:nil on:descBlock];
}
@end
