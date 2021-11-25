//
//  STUIViewEvent.m
//  IT恋
//
//  Created by 陈裕强 on 2017/12/25.
//  Copyright © 2017年. All rights reserved.
//

#import "STUIViewEvent.h"
#import <objc/runtime.h>
#import "STDefineFunc.h"
#import "STString.h"
#import "STUIView.h"
#import "STUIViewAddUI.h"
#import "STDictionary.h"
#import "STCategory.h"
#import "STSagit.h"
#import "STEnum.h"
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
    else if([eventType isEqualToString:@"dbClick"])
    {
        OnViewDbClick event = [self key:@"onDbClick"];
        if(event)
        {
            event(view);
        }
    }
    else if([eventType isEqualToString:@"longPress"])
    {
        OnViewLongPress event = [self key:@"onLongPress"];//(OnLongPress)objc_getAssociatedObject(self, &longPressChar);
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
            BOOL dragResult= event(view,recognizer);
            [self key:@"dragResult" value:@(dragResult)];
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
    else if([eventType isEqualToString:@"screenLeftEdgeSlide"])
    {
        OnScreenEdgeSlide event = [self key:@"onScreenLeftEdgeSlide"];// (OnViewDrag)objc_getAssociatedObject(self, &dragChar);
        if(event)
        {
            //NSString * to= [self key:@"slideTo"];
            UIScreenEdgePanGestureRecognizer *recognizer=(UIScreenEdgePanGestureRecognizer*)[self key:@"screenLeftEdgeSlideRecognizer"];
            event(view,recognizer);
        }
    }
    else if([eventType isEqualToString:@"screenRightEdgeSlide"])
    {
        OnScreenEdgeSlide event = [self key:@"onScreenRightEdgeSlide"];// (OnViewDrag)objc_getAssociatedObject(self, &dragChar);
        if(event)
        {
            //NSString * to= [self key:@"slideTo"];
            UIScreenEdgePanGestureRecognizer *recognizer=(UIScreenEdgePanGestureRecognizer*)[self key:@"screenRightEdgeSlideRecognizer"];
            event(view,recognizer);
        }
    }
}
#pragma mark 系统公用方法
-(BOOL)removeGesture:(Class)class flag:(NSInteger)flag
{
    BOOL result=NO;
    if(self.gestureRecognizers!=nil)
    {
        for (NSInteger i=0; i<self.gestureRecognizers.count; i++)
        {
            UIGestureRecognizer *gestrue=self.gestureRecognizers[i];
            if([gestrue isKindOfClass:class])
            {
                
                if(flag==9998 || flag==9997)//click、dbClick
                {
                    UITapGestureRecognizer *re=(UITapGestureRecognizer*)gestrue;
                    if(re.numberOfTapsRequired!=9999-flag)
                    {
                        continue;
                    }
                }
                else if(flag<10)
                {
                    UIScreenEdgePanGestureRecognizer *re=(UIScreenEdgePanGestureRecognizer*)gestrue;
                    if(re.edges!=flag)
                    {
                        continue;
                    }
                }
                
                //gestrue.name
                [self removeGestureRecognizer:gestrue];
                gestrue=nil;
                result=YES;
            }
        }
    }
    return result;
}
#pragma mark 处理手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *view=gestureRecognizer.view;
    STView *stView=view.stView;
    if(stView)
    {
        //兼容：IOS13.6 Sagit.Msg dialog： UITableView 点击拿不到点击View
        NSString *name=stView.name;
        if([name eq:@"stDialogView"])
        {
            if(![view isEqual:stView])
            {
                [stView key:@"eventViewCount" value:@(1)];
                [stView key:@"eventView" value:view];//Sagit.Msg dialog 获取点击View
            }
            else
            {
                NSNumber *num=[stView key:@"eventViewCount"];
                //进来两次。
                if(!num)
                {
                    [stView key:@"eventView" value:nil];
                }
                else if(num.intValue==1)
                {
                    [stView key:@"eventViewCount" value:@(2)];
                }
                else if(num.intValue>1)
                {
                    [stView key:@"eventViewCount" value:nil];
                }
            }
        }
    }
    if(![gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){return YES;}
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
//    BOOL isSame=[[gestureRecognizer class] isEqual: [otherGestureRecognizer class]];
//    if(isSame)
//    {
//       return [gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]];
//    }
//    return !isSame;
//    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]) {
//        return YES;
//    }
//    return NO;
}
-(void)failSuper:(Class)superRecclass thisRec:(UIGestureRecognizer*)thisRec
{
    UIView *superView=self.superview;
    if(superView!=nil && superView.userInteractionEnabled)
    {
        //禁用
        for (int i=0; i<superView.gestureRecognizers.count; i++) {
            UITapGestureRecognizer *rec=superView.gestureRecognizers[i];
            if([rec isKindOfClass:superRecclass])
            {
                [rec requireGestureRecognizerToFail:thisRec];//和super比，thisRec优先级更高。
            }
        }
        [superView failSuper:superRecclass thisRec:thisRec];//一直往上。
    }
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
        
        UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickStart:)];
        click.delegate=(id)self;
        click.numberOfTapsRequired=1;//设置点按次数，默认为1
        click.numberOfTouchesRequired=1;//点按的手指数
        for (int i=0; i<self.gestureRecognizers.count; i++) {
            UITapGestureRecognizer *rec=self.gestureRecognizers[i];
            if([rec isKindOfClass:[UITapGestureRecognizer class]])
            {
                [click requireGestureRecognizerToFail:rec];//只要有点击，rec优先级更高。
            }
        }
        [self failSuper:[UITapGestureRecognizer class] thisRec:click];
        [self addGestureRecognizer:click];
        
        return click;
    }
    else if([eventType isEqualToString:@"dbClick"])
    {
        [self removeDbClick];
        
        UITapGestureRecognizer *dbClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dbClickStart:)];
        dbClick.delegate=(id)self;
        dbClick.numberOfTapsRequired=2;//设置点按次数，默认为2
        dbClick.numberOfTouchesRequired=1;//点按的手指数
        for (int i=0; i<self.gestureRecognizers.count; i++) {
            if([self.gestureRecognizers[i] isKindOfClass:[UITapGestureRecognizer class]])
            {
                UITapGestureRecognizer *tap=(UITapGestureRecognizer*)self.gestureRecognizers[i];
                if(tap.numberOfTapsRequired==1)
                {
                    [tap requireGestureRecognizerToFail:dbClick];
                }
                else if(tap.numberOfTapsRequired>2)
                {
                    [dbClick requireGestureRecognizerToFail:tap];
                }
                
            }
        }
        [self failSuper:[UITapGestureRecognizer class] thisRec:dbClick];
        [self addGestureRecognizer:dbClick];
        return dbClick;
    }
    else if([eventType isEqualToString:@"longPress"])
    {
        [self removeLongPress];
        UILongPressGestureRecognizer *longPress= [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressStart:)];
        [self failSuper:[UILongPressGestureRecognizer class] thisRec:longPress];
        [self addGestureRecognizer:longPress];
        return longPress;
    }
    else if([eventType isEqualToString:@"drag"])
    {
        [self removeDrag];
        UIPanGestureRecognizer *drag= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragStart:)];
        [self failSuper:[UIPanGestureRecognizer class] thisRec:drag];
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
        
        [self failSuper:[UISwipeGestureRecognizer class] thisRec:slideLeft];
        [self failSuper:[UISwipeGestureRecognizer class] thisRec:slideRight];
        [self failSuper:[UISwipeGestureRecognizer class] thisRec:slideUp];
        [self failSuper:[UISwipeGestureRecognizer class] thisRec:slideDown];
        return slideLeft;
    }
    else if([eventType isEqualToString:@"screenLeftEdgeSlide"])
    {
        [self removeScreenLeftEdgeSlide];
        if(self.stController!=nil && self.stController.navigationController!=nil)
        {
            self.stController.navigationController.interactivePopGestureRecognizer.enabled=NO;
        }
        UIScreenEdgePanGestureRecognizer *edgeSlideLeft= [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(screenEdgeSlideStart:)];
        [edgeSlideLeft setEdges:UIRectEdgeLeft];
        [self failSuper:[UIScreenEdgePanGestureRecognizer class] thisRec:edgeSlideLeft];
        [self addGestureRecognizer:edgeSlideLeft];

        
        return edgeSlideLeft;
    }
    else if([eventType isEqualToString:@"screenRightEdgeSlide"])
    {
        [self removeScreenRightEdgeSlide];
        UIScreenEdgePanGestureRecognizer *edgeSlideRight= [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(screenEdgeSlideStart:)];
        [edgeSlideRight setEdges:UIRectEdgeRight];
        [self addGestureRecognizer:edgeSlideRight];
        [self failSuper:[UIScreenEdgePanGestureRecognizer class] thisRec:edgeSlideRight];
        return edgeSlideRight;
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
#pragma mark click 点击事件
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
-(UIView*)clickStart:(UITapGestureRecognizer*)recognizer
{
    NSNumber *value= [self key:@"requireBeforeClick"];
    if(value!=nil && value.boolValue)
    {
        if(![self exeRequire])
        {
            return self;
        }
    }
    CGPoint p=[recognizer locationInView:recognizer.view];
    [self key:@"clickPoint" value:@(p)];
    return [self click];
}
-(UIView*)click
{
    if(self.userInteractionEnabled)
    {
        if(self.clickInterval>0)
        {
            self.userInteractionEnabled=NO;
        }
        [self exeEvent:@"click"];
         [self key:@"clickPoint" value:nil];
        if(self.clickInterval>0)
        {
            [Sagit delayExecute:self.clickInterval onMainThread:YES block:^{
                @try
                {
                  self.userInteractionEnabled=YES;
                }
                @catch(NSException *err){}
            }];
        }

    }
    return self;
}
-(UIView*)addClick:(NSString *)event
{
    return [self addClick:event target:nil enlarge:0 top:0 right:0 bottom:0];
}
-(UIView *)addClick:(NSString *)event enlarge:(CGFloat)value
{
    return [self addClick:event target:nil enlarge:value top:value right:value bottom:value];
}
-(UIView *)addClick:(NSString *)event enlarge:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom
{
    return [self addClick:event target:nil enlarge:left top:top right:right bottom:bottom];
}
-(UIView*)addClick:(NSString *)event target:(UIViewController*)target
{
    return [self addClick:event target:target enlarge:0 top:0 right:0 bottom:0];
}
-(UIView *)addClick:(NSString *)event target:(UIViewController *)target enlarge:(CGFloat)value
{
    return [self addClick:event target:target enlarge:value top:value right:value bottom:value];
}
-(UIView *)addClick:(NSString *)event target:(UIViewController *)target enlarge:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom
{
    if(left>0 || top>0 || right>0 || bottom>0)
    {
        [[[self.superview addUIView:nil] x:self.stX-left y:self.stY-top width:self.stWidth+left+right height:self.stHeight+top+bottom] block:^(UIView* view) {
            [self.superview bringSubviewToFront:self];//系统会自动调整了subviews的索引位置到最后一个。
            [view backgroundColor:ColorClear];//.layer.zPosition=self.layer.zPosition-1;
            [view onClick:^(id view) {
                [self click];
            }];
            
        }];
    }
    else
    {
        if (@available(iOS 15.0, *)) {
            if(self.isSTView && self.frame.origin.x<=0)
            {
                //兼容：ios15 x坐标为0无法触发点击事件。
                [[self ios15View] onClick:^(id view) {
                    [self click];
                }];
                return self;
            }
        }
    }
    [self addEvent:@"click" event:event target:target];
    return self;
}
-(UIView*)ios15View
{
    UIView* view=[self find:@"for15"];
    if(!view)
    {
        CGFloat y=self.stY;
        CGFloat height=self.stHeight;
        if(self.stController)
        {
            if(self.stController.needNavBar)
            {
                height-=STNavHeightPx;
                //y+=STNavHeightPx;
            }
            if(self.stController.needTabBar)
            {
                height-=STTabHeightPx;
            }
        }
        view=[[[self addUIView:@"for15"] x:3 y:y width:self.stWidth height:height] block:^(UIView* view) {
            //[self.superview bringSubviewToFront:view];//系统会自动调整了subviews的索引位置到最后一个。
            [view backgroundColor:ColorClear].layer.zPosition=self.layer.zPosition-1;
//            [view onDrag:^BOOL(id view, UIPanGestureRecognizer *recognizer) {
//                return YES;
//            }];
        }];
    }
    return view;
}
-(UIView*)onClick:(OnViewClick)block
{
    return [self onClick:block enlarge:0 top:0 right:0 bottom:0];
}
-(UIView *)onClick:(OnViewClick)block enlarge:(CGFloat)value
{
    return [self onClick:block enlarge:value top:value right:value bottom:value];
}
-(UIView *)onClick:(OnViewClick)block enlarge:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom
{
    if(left>0 || top>0 || right>0 || bottom>0)
    {
        [[[self.superview addUIView:nil] x:self.stX-left y:self.stY-top width:self.stWidth+left+right height:self.stHeight+top+bottom] block:^(UIView* view) {
            [self.superview bringSubviewToFront:self];//系统会自动调整了subviews的索引位置到最后一个。
            //[self.superview sendSubviewToBack:view];//用这句IOS15会丢失事件。
            [[view backgroundColor:ColorClear] onClick:block view:self];//.layer.zPosition=self.layer.zPosition-1;
          
        }];
    }
    else
    {
        if (@available(iOS 15.0, *)) {
            if(self.isSTView && self.frame.origin.x<=0)
            {
                //兼容：ios15 x坐标为0无法触发点击事件。
                [[self ios15View]onClick:block view:self];
                return self;//原始View会触发导航栏，所以返回，不加入事件。
            }
        }
    }
    [self onClick:block view:self];
    return self;
}
-(UIView*)onClick:(OnViewClick)block view:(UIView*)view
{
    if(block!=nil)
    {
        [self addGesture:@"click"];//内部有清除参数，放在前面
        [self key:@"clickView" value:view];
        [self key:@"onClick" value:block];
        
    }
    return self;
}

-(UIView *)removeClick
{
    if([self removeGesture:[UITapGestureRecognizer class] flag:9998])
    {
        //移除参数
        [self.keyValue remove:@"clickView,clickSel,clickTarget,clickPointView,onClick,clickPoint"];
        if (@available(iOS 15.0, *)) {
            if(self.isSTView && self.frame.origin.x<=0)
            {
                //兼容：ios15 x坐标为0无法触发点击事件。
                [[self ios15View] removeClick];
            }
        }
    }
    return self;
}
#pragma mark click 双击事件
-(UIView*)dbClickStart:(UITapGestureRecognizer*)recognizer
{
        CGPoint p=[recognizer locationInView:recognizer.view];
        [self key:@"dbClickPoint" value:@(p)];
        return [self dbClick];
}
-(UIView*)dbClick
{
    if(self.userInteractionEnabled)
    {
        if(self.clickInterval>0)
        {
            self.userInteractionEnabled=NO;
        }
        [self exeEvent:@"dbClick"];
        [self key:@"dbClickPoint" value:nil];
        if(self.clickInterval>0)
        {
            [Sagit delayExecute:self.clickInterval onMainThread:YES block:^{
                @try
                {
                  self.userInteractionEnabled=YES;
                }
                @catch(NSException *err){}
            }];
        }
    }
    return self;
}
-(UIView*)addDbClick:(NSString *)event
{
    return [self addDbClick:event target:nil enlarge:0 top:0 right:0 bottom:0];
}
-(UIView *)addDbClick:(NSString *)event enlarge:(CGFloat)value
{
    return [self addDbClick:event target:nil enlarge:value top:value right:value bottom:value];
}
-(UIView *)addDbClick:(NSString *)event enlarge:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom
{
    return [self addDbClick:event target:nil enlarge:left top:top right:right bottom:bottom];
}
-(UIView*)addDbClick:(NSString *)event target:(UIViewController*)target
{
    return [self addDbClick:event target:target enlarge:0 top:0 right:0 bottom:0];
}
-(UIView *)addDbClick:(NSString *)event target:(UIViewController *)target enlarge:(CGFloat)value
{
    return [self addDbClick:event target:target enlarge:value top:value right:value bottom:value];
}
-(UIView *)addDbClick:(NSString *)event target:(UIViewController *)target enlarge:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom
{
    if(left>0 || top>0 || right>0 || bottom>0)
    {
        [[[self.superview addUIView:nil] x:self.stX-left y:self.stY-top width:self.stWidth+left+right height:self.stHeight+top+bottom] block:^(UIView* view) {
            [self.superview bringSubviewToFront:self];//系统会自动调整了subviews的索引位置到最后一个。
            [view backgroundColor:ColorClear];//.layer.zPosition=self.layer.zPosition-1;
            [view onDbClick:^(id view) {
                [self dbClick];
            }];
        }];
    }
    else
    {
        if (@available(iOS 15.0, *)) {
            if(self.isSTView && self.frame.origin.x<=0)
            {
                //兼容：ios15 x坐标为0无法触发点击事件。
                [[self ios15View] onDbClick:^(id view) {
                    [self dbClick];
                }];
                return self;
            }
        }
    }
    [self addEvent:@"dbClick" event:event target:target];
    return self;
    
}
-(UIView*)onDbClick:(OnViewDbClick)block
{
    return [self onDbClick:block enlarge:0 top:0 right:0 bottom:0];
}
-(UIView *)onDbClick:(OnViewDbClick)block enlarge:(CGFloat)value
{
    return [self onDbClick:block enlarge:value top:value right:value bottom:value];
}
-(UIView *)onDbClick:(OnViewDbClick)block enlarge:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom
{
    if(left>0 || top>0 || right>0 || bottom>0)
    {
        [[[self.superview addUIView:nil] x:self.stX-left y:self.stY-top width:self.stWidth+left+right height:self.stHeight+top+bottom] block:^(UIView* view) {
            [self.superview bringSubviewToFront:self];//系统会自动调整了subviews的索引位置到最后一个。
            [[view backgroundColor:ColorClear] onDbClick:block view:self];//.layer.zPosition=self.layer.zPosition-1;
        }];
    }
    else
    {
        if (@available(iOS 15.0, *)) {
            if(self.isSTView && self.frame.origin.x<=0)
            {
                //兼容：ios15 x坐标为0无法触发点击事件。
                [[self ios15View]onDbClick:block view:self];
                return self;
            }
        }
    }
    [self onDbClick:block view:self];
    return self;
}
-(UIView*)onDbClick:(OnViewDbClick)block view:(UIView*)dbClickView
{
    if(block!=nil)
    {
        [self addGesture:@"dbClick"];//内部有清除参数，放在前面
        [self key:@"dbClickView" value:dbClickView];
        [self key:@"onDbClick" value:block];
    }
    return self;
}
-(UIView *)removeDbClick
{
    if([self removeGesture:[UITapGestureRecognizer class] flag:9997])
    {
        //移除参数
        [self.keyValue remove:@"dbClickView,dbClickSel,dbClickTarget,dbClickPointView,onDbClick"];
        if (@available(iOS 15.0, *)) {
            if(self.isSTView && self.frame.origin.x<=0)
            {
                //兼容：ios15 x坐标为0无法触发点击事件。
                [[self ios15View] removeDbClick];
            }
        }
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
-(UIView*)addLongPress:(NSString *)event
{
    return [self addLongPress:event target:nil enlarge:0 top:0 right:0 bottom:0];
}
-(UIView *)addLongPress:(NSString *)event enlarge:(CGFloat)value
{
    return [self addLongPress:event target:nil enlarge:value top:value right:value bottom:value];
}
-(UIView *)addLongPress:(NSString *)event enlarge:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom
{
    return [self addLongPress:event target:nil enlarge:left top:top right:right bottom:bottom];
}
-(UIView*)addLongPress:(NSString *)event target:(UIViewController*)target
{
    return [self addLongPress:event target:target enlarge:0 top:0 right:0 bottom:0];
}
-(UIView *)addLongPress:(NSString *)event target:(UIViewController *)target enlarge:(CGFloat)value
{
    return [self addLongPress:event target:target enlarge:value top:value right:value bottom:value];
}
-(UIView *)addLongPress:(NSString *)event target:(UIViewController *)target enlarge:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom
{
    if(left>0 || top>0 || right>0 || bottom>0)
    {
        [[[self.superview addUIView:nil] x:self.stX-left y:self.stY-top width:self.stWidth+left+right height:self.stHeight+top+bottom] block:^(UIView* view) {
            [self.superview bringSubviewToFront:self];//系统会自动调整了subviews的索引位置到最后一个。
            [view backgroundColor:ColorClear];//.layer.zPosition=self.layer.zPosition-1;
            [view onLongPress:^(id view) {
                [self longPress];
            }];
        }];
    }
    else
    {
        if (@available(iOS 15.0, *)) {
            if(self.isSTView && self.frame.origin.x<=0)
            {
                //兼容：ios15 x坐标为0无法触发点击事件。
                [[self ios15View] onLongPress:^(id view) {
                    [self longPress];
                }];
                return self;
            }
        }
    }
    [self addEvent:@"longPress" event:event target:target];
    return self;
}
-(UIView*)onLongPress:(OnViewLongPress)block
{
    return [self onLongPress:block enlarge:0 top:0 right:0 bottom:0];
}
-(UIView *)onLongPress:(OnViewLongPress)block enlarge:(CGFloat)value
{
    return [self onLongPress:block enlarge:value top:value right:value bottom:value];
}
-(UIView *)onLongPress:(OnViewLongPress)block enlarge:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom
{
    if(left>0 || top>0 || right>0 || bottom>0)
    {
        [[[self.superview addUIView:nil] x:self.stX-left y:self.stY-top width:self.stWidth+left+right height:self.stHeight+top+bottom] block:^(UIView* view) {
            [self.superview bringSubviewToFront:self];//系统会自动调整了subviews的索引位置到最后一个。
            [[view backgroundColor:ColorClear] onLongPress:block view:self];//.layer.zPosition=self.layer.zPosition-1;
        }];
    }
    else
    {
        if (@available(iOS 15.0, *)) {
            if(self.isSTView && self.frame.origin.x<=0)
            {
                //兼容：ios15 x坐标为0无法触发点击事件。
                [[self ios15View] onLongPress:block view:self];
            }
            return self;
        }
    }
    [self onLongPress:block view:self];
    return self;
}
-(UIView *)onLongPress:(OnViewLongPress)block  view:(UIView*)pressView
{
    if(block!=nil)
    {
        [self addGesture:@"longPress"];//放在前面，内部有清除参数。
        [self key:@"longPressView" value:pressView];
        [self key:@"onLongPress" value:block];
    }
    return self;
}
-(UIView *)removeLongPress
{
    if([self removeGesture:[UILongPressGestureRecognizer class] flag:9999])
    {
        //移除参数
        [self.keyValue remove:@"longPressView,longPressSel,longPressTarget,longPressPointView,onLongPress"];
        if (@available(iOS 15.0, *)) {
            if(self.isSTView && self.frame.origin.x<=0)
            {
                //兼容：ios15 x坐标为0无法触发点击事件。
                [[self ios15View] removeLongPress];
            }
        }
    }
    return self;
}
#pragma mark 扩展系统事件 - 拖动
- (UIView *)dragStart:(UIPanGestureRecognizer *)recognizer
{
    if(CGRectEqualToRect(CGRectZero, self.OriginFrame))
    {
        self.OriginFrame=self.frame;
    }
    [self key:@"dragRecognizer" value:recognizer];
    [self drag];
    NSNumber *slideResult=[self key:@"dragResult"];
       if(slideResult!=nil && slideResult.boolValue)
       {
           
           CGPoint point = [recognizer translationInView:self];
           
           NSNumber *value=[self key:@"dragDirection"];
           DragDirection direction=(DragDirection)value.intValue;
           
           switch (direction) {
               case DragToLeft:
                   if(point.x<0)
                   {
                       self.center = CGPointMake(recognizer.view.center.x + point.x, recognizer.view.center.y);
                   }
                   break;
               case DragToRight:
                   if(point.x>0)
                   {
                       self.center = CGPointMake(recognizer.view.center.x + point.x, recognizer.view.center.y);
                   }
                   break;
               case DragToLeftRight:
                   self.center = CGPointMake(recognizer.view.center.x + point.x, recognizer.view.center.y);
                   break;
               case DragToUp:
                   if(point.y<0)
                   {
                       self.center = CGPointMake(recognizer.view.center.x, recognizer.view.center.y + point.y);
                   }
                   break;
               case DragToDown:
                   if(point.y>0)
                   {
                       self.center = CGPointMake(recognizer.view.center.x, recognizer.view.center.y + point.y);
                   }
                   break;
              case DragToUpDown:
                   self.center = CGPointMake(recognizer.view.center.x, recognizer.view.center.y + point.y);
                   break;
               case DragToAll:
                   self.center = CGPointMake(recognizer.view.center.x + point.x, recognizer.view.center.y + point.y);
                   break;
               default:
                   break;
           }
           
           if(recognizer.state==UIGestureRecognizerStateEnded && direction!=DragToAll)
           {
               [self backToOrigin];
           }
           [recognizer setTranslation:CGPointMake(0, 0) inView:self];
       }
       return self;
   
    
   
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
    return [self onDrag:block direction:DragToAll];
}
-(UIView *)onDrag:(OnViewDrag)block direction:(DragDirection)direction
{
    if(block!=nil)
    {
        [self addGesture:@"drag"];//放在前面，内部有清除参数。
        [self key:@"dragView" value:self];
        [self key:@"onDrag" value:block];
        [self key:@"dragDirection" value:@(direction)];
        
    }
    return self;
}
-(UIView *)removeDrag
{
    if([self removeGesture:[UIPanGestureRecognizer class] flag:9999])
    {
        //移除参数
        [self.keyValue remove:@"dragView,dragSel,dragTarget,dragPointView,onDrag,dragRecognizer,dragDirection"];
        //[self setDragBlock:nil];
    }
    return self;
}

#pragma mark 扩展系统事件 - slide 滑动事件
- (UIView *)slideStart:(UISwipeGestureRecognizer *)recognizer
{
    if(CGRectEqualToRect(CGRectZero, self.OriginFrame))
    {
        self.OriginFrame=self.frame;
    }
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
    if([self removeGesture:[UISwipeGestureRecognizer class] flag:9999])
    {
        //移除参数
        [self.keyValue remove:@"slideView,slideSel,slideTarget,slidePointView,onSlide,slideRecognizer"];
    }
    return self;
}
#pragma mark 扩展系统事件 - edgeSlide 侧滑事件
- (UIView *)screenEdgeSlideStart:(UIScreenEdgePanGestureRecognizer *)recognizer
{
   
    if(recognizer.edges==UIRectEdgeLeft)
    {
        [self key:@"screenLeftEdgeSlideRecognizer" value:recognizer];
        [self screenLeftEdgeSlide];
    }
    else if (recognizer.edges==UIRectEdgeRight)
    {
        [self key:@"screenRightEdgeSlideRecognizer" value:recognizer];
        [self screenRightEdgeSlide];
    }
    if(recognizer.edges==UIRectEdgeLeft || recognizer.edges==UIRectEdgeRight)
    {
        if(CGRectEqualToRect(CGRectZero, self.OriginFrame))
        {
            self.OriginFrame=self.frame;
        }
        CGPoint point = [recognizer translationInView:self];
        self.center = CGPointMake(recognizer.view.center.x + point.x, recognizer.view.center.y);
    }
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
//    if(recognizer.state==UIGestureRecognizerStateEnded || recognizer.state==UIGestureRecognizerStateCancelled)
//    {
//        [self backToOrigin];
//    }
    return self;
}
#pragma mark 扩展系统事件 - edgeSlide 左侧滑事件
-(UIView *)screenLeftEdgeSlide
{
    if(self.userInteractionEnabled)
    {
        return [self exeEvent:@"screenLeftEdgeSlide"];
    }
    return self;
}
-(UIView *)addScreenLeftEdgeSlide:(NSString *)event
{
    return [self addScreenLeftEdgeSlide:event target:nil];
}
-(UIView *)addScreenLeftEdgeSlide:(NSString *)event target:(UIViewController *)target
{
    return [self addEvent:@"screenLeftEdgeSlide" event:event target:target];
}
-(UIView *)onScreenLeftEdgeSlide:(OnScreenEdgeSlide)block
{
    if(block!=nil)
    {
        [self addGesture:@"screenLeftEdgeSlide"];//放在前面，内部有清除参数。
        [self key:@"screenLeftEdgeSlideView" value:self];
        [self key:@"onScreenLeftEdgeSlide" value:block];
    }
    return self;
}
-(UIView *)removeScreenLeftEdgeSlide
{
    if([self removeGesture:[UIScreenEdgePanGestureRecognizer class] flag:UIRectEdgeLeft])
    {
        //移除参数
        [self.keyValue remove:@"screenLeftEdgeSlideView,screenLeftEdgeSlideSel,screenLeftEdgeSlideTarget,screenLeftEdgeSlidePointView,onScreenLeftEdgeSlide,screenLeftEdgeSlideRecognizer"];
    }
    return self;
}
#pragma mark 扩展系统事件 - edgeSlide 右侧滑事件
-(UIView *)screenRightEdgeSlide
{
    if(self.userInteractionEnabled)
    {
        return [self exeEvent:@"screenRightEdgeSlide"];
    }
    return self;
}
-(UIView *)addScreenRightEdgeSlide:(NSString *)event
{
    return [self addScreenRightEdgeSlide:event target:nil];
}
-(UIView *)addScreenRightEdgeSlide:(NSString *)event target:(UIViewController *)target
{
    return [self addEvent:@"screenRightEdgeSlide" event:event target:target];
}
-(UIView *)onScreenRightEdgeSlide:(OnScreenEdgeSlide)block
{
    if(block!=nil)
    {
        [self addGesture:@"screenRightEdgeSlide"];//放在前面，内部有清除参数。
        [self key:@"screenRightEdgeSlideView" value:self];
        [self key:@"onScreenRightEdgeSlide" value:block];
    }
    return self;
}
-(UIView *)removeScreenRightEdgeSlide
{
    if([self removeGesture:[UIScreenEdgePanGestureRecognizer class] flag:UIRectEdgeRight])
    {
        //移除参数
        [self.keyValue remove:@"screenRightEdgeSlideView,screenRightEdgeSlideSel,screenRightEdgeSlideTarget,screenRightEdgeSlidePointView,onScreenRightEdgeSlide,screenRightEdgeSlideRecognizer"];
    }
    return self;
}


#pragma mark 定时器事件
- (UIView *)timerStart:(NSTimer *)timer
{
    OnTimer timerEvent= [self key:@"onTimer"];
    if(timerEvent)
    {
        NSNumber *value=[self key:@"timerCount"];
        if(value==nil)
        {
            value=@(1);
        }
        else
        {
            value=@(value.intValue+1);
        }
        [self key:@"timerCount" value:value];
        timerEvent(self,timer,value.intValue);
    }
    return self;
    
}
//!绑定事件 用代码块的形式
-(UIView*)onTimer:(OnTimer)block
{
    return [self onTimer:block interval:1];
}
-(UIView*)onTimer:(OnTimer)block interval:(double)sencond
{
    NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:sencond target:self selector:@selector(timerStart:) userInfo:nil repeats:YES];
    [self key:@"timer" value:timer];
    [self key:@"onTimer" value:block];
    [timer fire];//开启
    return self;
}
//!移除绑定事件
-(UIView*)removeTimer
{
    NSTimer *timer=[self key:@"timer"];
    if(timer)
    {
        [timer invalidate];
        timer=nil;
        [self.keyValue remove:@"timer,onTimer,timerCount"];
    }
    return self;
}

#pragma mark 扩展的回调事件
-(OnAfterEvent)onAfter
{
    return [self key:@"onAfter"];
}
-(UIView *)onAfter:(OnAfterEvent)block
{
    [self key:@"onAfter" value:block];
    return self;
}
#pragma mark 增加描述
//用于格式化增加描述的方法
-(UIView*)block:(NSString *)description on:(OnViewDescription)descBlock
{
    if(descBlock!=nil)
    {
       //STWeakSelf;
       descBlock(self);//对于自身对自身的引用，无需弱引用。
       descBlock=nil;
    }
    return self;
}
-(UIView *)block:(OnViewDescription)descBlock
{
    return [self block:nil on:descBlock];
}
@end
