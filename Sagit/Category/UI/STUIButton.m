//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUIButton.h"
//#import <objc/runtime.h>
#import "STDefineUI.h"
#import "STUIView.h"
#import "STUIViewAutoLayout.h"
#import "STString.h"
#import "STUIControl.h"
@implementation UIButton (ST)

//static char ActionTag;
//
//- (void)addAction:(onAction)block {
//    objc_setAssociatedObject(self, &ActionTag, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
//    [self addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
//}
//
//- (void)addClick:(onAction)block {
//    
//    [self addAction:block forControlEvents:UIControlEventTouchUpInside];
//}
//
//- (void)addAction:(onAction)block forControlEvents:(UIControlEvents)controlEvents {
//    objc_setAssociatedObject(self, &ActionTag, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
//    [self addTarget:self action:@selector(action:) forControlEvents:controlEvents];
//}
//
//- (void)action:(id)sender {
//    onAction blockAction = (onAction)objc_getAssociatedObject(self, &ActionTag);
//    if (blockAction) {
//        blockAction(self);
//    }
//}
//复盖UIView的方法。
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
//    CGRect bounds = self.bounds;
//    //若原热区小于44x44，则放大热区，否则保持原大小不变
//    CGFloat widthDelta = MAX(50.0 - bounds.size.width, 0);
//    CGFloat heightDelta = MAX(50.0 - bounds.size.height, 0);
//    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
//    return CGRectContainsPoint(bounds, point);
//}
#pragma mark 扩展系统属性
-(UIButton*)backgroundImage:(id)img
{
    [self backgroundImage:img forState:UIControlStateNormal];
    return self;
}
-(UIButton*)backgroundImage:(id)img forState:(UIControlState)state
{
    [self setBackgroundImage:[UIImage toImage:img] forState:state];
    return self;
}
-(UIButton*)image:(id)img
{
    [self image:img forState:UIControlStateNormal];
    return self;
}
-(UIButton*)image:(id)img forState:(UIControlState)state
{
    
    [self setImage:[UIImage toImage:img] forState:state];
    
    return self;
}
-(UIButton*)title:(NSString*)title
{
    [self setTitle:title forState:UIControlStateNormal];
    return self;
}
-(UIButton*)title:(NSString*)title forState:(UIControlState)state
{
    [self setTitle:title forState:state];
    return self;
}
-(UIButton*)titleColor:(id)colorOrHex
{
    [self titleColor:colorOrHex forState:UIControlStateNormal];
    return self;
}
-(UIButton*)titleColor:(id)colorOrHex forState:(UIControlState)state
{
    [self setTitleColor:[UIColor toColor:colorOrHex] forState:state];
    return self;
}
-(UIButton*)titleFont:(CGFloat)px
{
    self.titleLabel.font=[UIFont toFont:px];
    return self;
}
-(UIButton*)adjustsImageWhenHighlighted:(BOOL)yesNo
{
    self.adjustsImageWhenHighlighted=yesNo;
    return self;
}
-(UIButton*)stWidthToFit
{
    [self layoutIfNeeded];//Button setImage 后，Lable的坐标不是即时移动的。
    UILabel *label=self.titleLabel;
    CGFloat labelWidth=label.stWidth;
    if(label.text.length>0)
    {
        CGSize size=[self.titleLabel.text sizeWithFont:label.font maxSize:self.frame.size];
        //计算文字的长度
        labelWidth=MAX(labelWidth, size.width*Xpx);
    }
    CGFloat width=MAX(labelWidth+label.stX, self.imageView.stX+self.imageView.stWidth);
    [self width:width];
    return self;
}

-(UIButton *)showTime:(NSInteger)second
{
    return [self showTime:second resetStateOnEnd:YES];
}
-(UIButton *)showTime:(NSInteger)second resetStateOnEnd:(BOOL)resetStateOnEnd
{
    if(second>0)
    {
        if([self key:@"NSTimer"])
        {
            [self key:@"newSecond" value:STNumString(second)];
            return self;//直接返回
        }
        
        [self enabled:NO];
        NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        
        [self key:@"NSTimer" value:timer];
        if(resetStateOnEnd)
        {
            [self key:@"defaultTitle" value:self.currentTitle];
        }
        interval=second;
        [timer fire];//开启
    }
    return self;
}
static int interval=0;
-(void)onTimer
{
    
    NSString *newSecond=[self key:@"newSecond"];
    if(newSecond)
    {
        interval=newSecond.integerValue;
        [self key:@"newSecond" value:nil];//移除key
    }
    else
    {
        [self title:[[@(interval)stringValue] append:@"s"]];
    }
    interval--;
    if(interval<=-1)//==0的话到2s就恢复了，也不解为什么少了1。
    {
        if([self key:@"defaultTitle"])
        {
            [self title:[self key:@"defaultTitle"]];
            [self key:@"defaultTitle" value:nil];
        }
        [self enabled:YES];
        NSTimer *timer=[self key:@"NSTimer"];
        if(timer)
        {
            [timer invalidate];
            timer=nil;
            [self key:@"NSTimer" value:nil];
        }
        if(self.onAfter)
        {
            self.onAfter(@"showTime",self);
        }
    }
}
-(void)dispose
{
    NSTimer *timer=[self key:@"NSTimer"];
    if(timer)
    {
        [timer invalidate];
        timer=nil;
    }
    [super dispose];
}
@end
