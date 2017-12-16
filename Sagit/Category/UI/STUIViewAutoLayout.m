//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

// UIView 的自动布局分离出来
#import "STDefineUI.h"
#import "STUIViewAutoLayout.h"
#import "STLayoutTracer.h"
#import "STCategory.h"
#import <objc/runtime.h>

@implementation UIView(STAutoLayout)
#pragma mark 属性定义
static char layoutTracerChar='l';
static char originFrameChar='o';
static NSInteger xyNone=-99999;
// Name
- (NSMutableDictionary*)LayoutTracer{
    return (NSMutableDictionary*)objc_getAssociatedObject(self, &layoutTracerChar);
}
- (UIView*)setLayoutTracer:(NSMutableDictionary*)tracer{
    objc_setAssociatedObject(self, &layoutTracerChar, tracer,OBJC_ASSOCIATION_RETAIN);
    return self;
}
- (CGRect)OriginFrame{
    return CGRectFromString(objc_getAssociatedObject(self, &originFrameChar));
}
- (UIView*)setOriginFrame:(CGRect)frame{
    objc_setAssociatedObject(self, &originFrameChar,NSStringFromCGRect(frame),OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}
#pragma mark [相对布局方法] RelativeLayout
-(UIView*)getViewBy:(id)ui
{
    if([ui isKindOfClass:[NSString class]])
    {
        if(self.STView!=nil && [self.STView.UIList has:(NSString*)ui])
        {
            return self.STView.UIList[(NSString*)ui];
        }
    }
    else if([ui isKindOfClass:[UIView class]])
    {
        return (UIView*)ui;
    }
    return self;
}
//如果当前没设置frame，则用指定的frame，返回新的frame，避免改变原来的行为
-(CGRect)checkFrameIsEmptyOrFull:(CGRect)uiFrame
{
    if(CGRectEqualToRect(self.frame, STEmptyRect) || CGRectEqualToRect(self.frame, STFullRect))
    {
        return STRectCopy(uiFrame);
    }
    return STRectCopy(self.frame);
}
-(CGSize)superSize
{
    if(self.superview==nil)
    {
        return STFullSize;
    }
    return self.superview.frame.size;
}
-(CGRect)getUIFrame:(UIView*)ui
{
    if(ui==nil)
    {
        if(self.superview==nil)
        {
            return STFullRect;
        }
        
        return self.superview.frame;
    }
    return ui.frame;
}
//在右边
-(UIView*)onRight:(id)uiOrName x:(CGFloat)x
{
    return [self onRight:uiOrName x:x y:0];
}
-(UIView*)onRight:(id)uiOrName x:(CGFloat)x y:(CGFloat)y
{
    UIView *ui=[self getViewBy:uiOrName];
    [self addTracer:ui method:@"onRight" v1:x v2:y v3:0 v4:0 location:0 xyFlag:0];
    CGRect uiFrame=[self getUIFrame:ui];
    CGRect frame=[self checkFrameIsEmptyOrFull:uiFrame];
    
    //检测是否有onLeft规则，若有，调整宽度
    if([self.LayoutTracer has:@"onLeft"])
    {
        frame.size.width=(frame.origin.x+frame.size.width)-uiFrame.origin.x-uiFrame.size.width-x*Xpt;
    }
    frame.origin.x=uiFrame.size.width+uiFrame.origin.x+x*Xpt;
    frame.origin.y=uiFrame.origin.y+y*Ypt;
    
    //检测是否有onLeft规则，若有，调整宽度
    
    [self frame:frame];
    return self;
}
//在左边
-(UIView*)onLeft:(id)uiOrName x:(CGFloat)x
{
    return [self onLeft:uiOrName x:x y:0];
    
}
-(UIView*)onLeft:(id)uiOrName x:(CGFloat)x y:(CGFloat)y
{
    UIView *ui=[self getViewBy:uiOrName];
    [self addTracer:ui method:@"onLeft" v1:x v2:y v3:0 v4:0 location:0 xyFlag:0];
    
    CGRect uiFrame=[self getUIFrame:ui];
    CGRect frame=[self checkFrameIsEmptyOrFull:uiFrame];
    
    //检测是否有onRight规则，若有，调整宽度
    if([self.LayoutTracer has:@"onRight"])
    {
        frame.size.width=uiFrame.origin.x-x*Xpt-frame.origin.x;;
    }
    else
    {
        frame.origin.x=uiFrame.origin.x-frame.size.width-x*Xpt;
    }
    frame.origin.y=uiFrame.origin.y+y*Ypt;
    
    [self frame:frame];
    return self;
}
//在上边
-(UIView*)onTop:(id)uiOrName y:(CGFloat)y
{
    return [self onTop:uiOrName y:y x:0];
}
-(UIView*)onTop:(id)uiOrName y:(CGFloat)y x:(CGFloat)x
{
    UIView *ui=[self getViewBy:uiOrName];
    [self addTracer:ui method:@"onTop" v1:y v2:x v3:0 v4:0 location:0 xyFlag:0];
    CGRect uiFrame=[self getUIFrame:ui];
    CGRect frame=[self checkFrameIsEmptyOrFull:uiFrame];
    
    //检测是否有onBottom规则，若有，调整高度
    if([self.LayoutTracer has:@"onBottom"])
    {
        frame.size.height=uiFrame.origin.y-y*Ypt-frame.origin.y;
    }
    else
    {
        frame.origin.y=uiFrame.origin.y-frame.size.height-y*Ypt;
    }
    
    frame.origin.x=uiFrame.origin.x+x*Xpt;
    [self frame:frame];
    return self;
}
//在下边
-(UIView *)onBottom:(id)uiOrName y:(CGFloat)y
{
    return [self onBottom:uiOrName y:y x:0];
}
-(UIView *)onBottom:(id)uiOrName y:(CGFloat)y x:(CGFloat)x
{
    UIView *ui=[self getViewBy:uiOrName];
    [self addTracer:ui method:@"onBottom" v1:y v2:x v3:0 v4:0 location:0 xyFlag:0];
    CGRect uiFrame=[self getUIFrame:ui];
    CGRect frame=[self checkFrameIsEmptyOrFull:uiFrame];
    //检测是否有onTop规则，若有，调整高度
    if([self.LayoutTracer has:@"onTop"])
    {
        frame.size.height=(frame.origin.y+frame.size.height)-uiFrame.origin.y-uiFrame.size.height-y*Ypt;
    }
    frame.origin.y=uiFrame.origin.y+ui.frame.size.height+y*Ypt;
    frame.origin.x=uiFrame.origin.x+x*Xpt;
    [self frame:frame];
    return self;
}
-(UIView*)relate:(XYLocation)location v:(CGFloat)value
{
    return [self relate:location v:value v2:xyNone v3:xyNone v4:xyNone];
}
-(UIView*)relate:(XYLocation)location v:(CGFloat)value v2:(CGFloat)value2
{
    return [self relate:location v:value v2:value2 v3:xyNone v4:xyNone];
}
-(UIView*)relate:(XYLocation)location v:(CGFloat)value v2:(CGFloat)value2 v3:(CGFloat)value3
{
    return [self relate:location v:value v2:value2 v3:value3 v4:xyNone];
}
-(UIView*)relate:(XYLocation)location v:(CGFloat)value v2:(CGFloat)value2 v3:(CGFloat)value3 v4:(CGFloat)value4
{
    [self addTracer:nil method:@"relate" v1:value v2:value2 v3:value3 v4:value4 location:location xyFlag:0];
    CGFloat left=xyNone,top=xyNone,right=xyNone,bottom=xyNone;
    switch (location) {
        case Left:
            left=value;
            break;
        case Right:
            right=value;
            break;
        case Top:
            top=value;
            break;
        case Bottom:
            bottom=value;
            break;
            //tow values
        case LeftTop:
            left=value;
            top=value2==xyNone?value:value2;
            break;
        case LeftRight:
            left=value;
            right=value2==xyNone?value:value2;
            break;
        case LeftBottom:
            left=value;
            bottom=value2==xyNone?value:value2;
            break;
        case TopRight:
            right=value;
            top=value2==xyNone?value:value2;
            break;
        case RightBottom:
            right=value;
            bottom=value2==xyNone?value:value2;
            break;
        case TopBottom:
            top=value;
            bottom=value2==xyNone?value:value2;
            break;
            //three values
        case LeftTopRight:
            left=value;
            top=value2==xyNone?value:value2;
            right=value3==xyNone?left:value3;
            break;
        case LeftTopBottom:
            left=value;
            top=value2==xyNone?value:value2;
            bottom=value3==xyNone?top:value3;
            break;
        case LeftBottomRight:
            left=value;
            bottom=value2==xyNone?value:value2;
            right=value3==xyNone?left:value3;
            break;
        case TopRightBottom:
            top=value;
            right=value2==xyNone?value:value2;
            bottom=value3==xyNone?top:value3;
            break;
            //four values
        default:
        case LeftTopRightBottom:
            left=value;
            top=value2==xyNone?value:value2;
            right=value3==xyNone?left:value3;
            bottom=value4==xyNone?top:value4;
            break;
    }
    return [self relate:LeftTopRightBottom left:left top:top right:right bottom:bottom];
}
-(UIView*)relate:(XYLocation)location left:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom
{
    if(left>=0 && left<=1){left=[self superSize].width*Xpx*left;}
    if(top>=0 && top<=1){top=[self superSize].height*Ypx*top;}
    
    if(right>=0 && right<=1){right=[self superSize].width*Xpx*right;}
    if(bottom>=0 && bottom<=1){bottom=[self superSize].height*Ypx*bottom;}
    
    
    CGSize superSize=[self superSize];
    CGRect frame=STRectCopy(self.frame);
    frame.origin=CGPointZero;//归零处理
    if(left!=xyNone && right!=xyNone)
    {
        frame.size.width=superSize.width-left*Xpt-right*Xpt;
    }
    if(top!=xyNone && bottom!=xyNone)
    {
        frame.size.height=superSize.height-top*Ypt-bottom*Ypt;
    }
    if(left!=xyNone)
    {
        frame.origin.x=floor(left*Xpt);
    }
    else if(right!=xyNone)
    {
        frame.origin.x=floor(superSize.width-frame.size.width-right*Xpt);
    }
    if(top!=xyNone)
    {
        frame.origin.y=floor(top*Ypt);
    }
    else if(bottom!=xyNone)
    {
        frame.origin.y=floor(superSize.height-frame.size.height-bottom*Xpt);
    }
    [self frame:frame];
    return self;
}


-(UIView*)toCenter
{
    return [self toCenter:0];
}
-(UIView*)toCenter:(XYFlag)flag
{
    [self addTracer:nil method:@"toCenter" v1:0 v2:0 v3:0 v4:0 location:0 xyFlag:flag];
    CGRect frame=self.frame;
    CGSize superSize=[self superSize];
    if(flag==1 || flag==0)
    {
        frame.origin.x=superSize.width/2-frame.size.width/2;
    }
    if(flag==2 || flag==0)
    {
        frame.origin.y=superSize.height/2-frame.size.height/2;
    }
    [self frame:frame];
    return self;
}
-(UIView*)x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
{
    [self width:width height:height];
    return [self relate:LeftTop v:x v2:y];
}

-(CGFloat)stX{return self.frame.origin.x*Xpx;}
-(CGFloat)stY{return self.frame.origin.y*Ypx;}
-(CGFloat)stWidth
{
    return self.frame.size.width*Xpx;
    
}
-(CGFloat)stHeight{return self.frame.size.height*Ypx;}
-(CGFloat)stAbsX{
    if(self.superview!=nil)
    {
        return self.stX+self.superview.stAbsX;
    }
    return self.stX;
}
-(CGFloat)stAbsY{
    if(self.superview!=nil)
    {
        return self.stY+self.superview.stAbsY;
    }
    return self.stY;
}
-(UIView*)x:(CGFloat)x
{
    return [self x:x y:self.stX];
}
-(UIView*)x:(CGFloat)x y:(CGFloat)y
{
    return [self relate:LeftTop v:x v2:y];
}

-(UIView*)y:(CGFloat)y
{
    return [self x:self.stX y:y];
}
-(UIView*)width:(CGFloat)width
{
    return [self width:width height:self.stHeight];
}
-(UIView*)width:(CGFloat)width height:(CGFloat)height
{
    if((width>=0 && width<=1) ||(height>=0 && height<=1))
    {
        [self addTracer:nil method:@"widthHeight" v1:width v2:height v3:0 v4:0 location:0 xyFlag:0];
        if(width>=0 && width<=1){width=[self superSize].width*Xpx*width;}
        if(height>=0 && height<=1){height=[self superSize].height*Ypx*height;}
        
    }
    
    CGRect frame=self.frame;
    frame.size=STSizeMake(width, height);
    [self frame:frame];
    return self;
    
}
-(UIView*)width:(CGFloat)width height:(CGFloat)height x:(CGFloat)x y:(CGFloat)y
{
    [self width:width height:height];
    return [self x:x y:y];
}
-(UIView*)height:(CGFloat)height
{
    return [self width:self.stWidth height:height];
}
-(UIView*)moveTo:(CGRect)frame
{
    if(!CGPointEqualToPoint(frame.origin, self.frame.origin))
    {
        if(CGRectEqualToRect(self.OriginFrame, CGRectZero))
        {
            self.OriginFrame=self.frame;
        }
        [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
        [UIView setAnimationDuration:0.2];
        [self frame:frame];
        [UIView commitAnimations];
    }
    return self;
}
-(UIView*)backToOrigin
{
    if(!CGRectEqualToRect(self.OriginFrame, self.frame))
    {
        [self moveTo:self.OriginFrame];
    }
    return self;
}
-(void)addTracer:(UIView*)view method:(NSString*)method v1:(CGFloat)v1 v2:(CGFloat)v2 v3:(CGFloat)v3 v4:(CGFloat)v4
        location:(XYLocation)location xyFlag:(XYFlag)xyFlag
{
    if(self.LayoutTracer==nil)
    {
        self.LayoutTracer=[NSMutableDictionary new];
    }
    if(self.LayoutTracer[method]==nil)
    {
        STLayoutTracer *tracer=[STLayoutTracer new];
        tracer.view=view;
        tracer.v1=v1;
        tracer.v2=v2;
        tracer.v3=v3;
        tracer.v4=v4;
        tracer.location=location;
        tracer.xyFlag=xyFlag;
        
        [self.LayoutTracer setObject:tracer forKey:method];
    }
}
-(UIView*)refleshLayout
{
    return [self refleshLayout:YES];
}
-(UIView*)refleshLayout:(BOOL)withWidthHeight{
    NSMutableDictionary* tracer=self.LayoutTracer;
    if(tracer!=nil && tracer.count>0)
    {
        for (NSString*method in tracer)
        {
            STLayoutTracer *v=tracer[method];
            if ([method isEqualToString:@"toCenter"])
            {
                [self toCenter:v.xyFlag];
            }
            else if ([method isEqualToString:@"relate"])
            {
                [self relate:v.location v:v.v1 v2:v.v2 v3:v.v3 v4:v.v4];
            }
            else if ([method isEqualToString:@"onLeft"])
            {
                [self onLeft:v.view x:v.v1 y:v.v2];
            }
            else if ([method isEqualToString:@"onTop"])
            {
                [self onTop:v.view y:v.v1 x:v.v2];
            }
            else if ([method isEqualToString:@"onRight"])
            {
                [self onRight:v.view x:v.v1 y:v.v2];
            }
            else if ([method isEqualToString:@"onBottom"])
            {
                [self onBottom:v.view y:v.v1 x:v.v2];
            }
            else if (withWidthHeight && [method isEqualToString:@"widthHeight"])
            {
                CGRect frame=STRectCopy(self.frame);//处理百分比
                if(v.v1>=0 && v.v1<=1){frame.size.width=[self superSize].width*v.v1;}
                if(v.v2>=0 && v.v2<=1){frame.size.height=[self superSize].height*v.v2;}
                [self frame:frame];
            }
        }
    }
    if(self.subviews!=nil && self.subviews.count>0)
    {
        for (int i=0; i<self.subviews.count; i++) {
            [self.subviews[i] refleshLayout:withWidthHeight];
        }
    }
    return self;
}
//仅遍历一级
-(UIView*)stSizeToFit
{
    NSString *className=NSStringFromClass([self class]);
    if([className isEqualToString:@"UIView"])
    {
        if(self.subviews.count>0)
        {
            NSInteger xValue=0,yValue=0;
            
            for (NSInteger i=0; i<self.subviews.count; i++) {
                CGRect subFrame= self.subviews[i].frame;
                CGRect myFrame=self.frame;
                xValue=subFrame.origin.x+subFrame.size.width -myFrame.size.width;
                yValue=subFrame.origin.y+subFrame.size.height -myFrame.size.height;
                if(xValue>0)
                {
                    [self width: (myFrame.size.width+xValue)*Xpx];
                }
                if(yValue>0)
                {
                    [self height:(myFrame.size.height+yValue)*Ypx];
                }
            }
        }
    }
    else
    {
        [self sizeToFit];
    }
    return self;
}
@end
