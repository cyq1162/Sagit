//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//
//  Copyright © 2017-2027年. All rights reserved.
//

// UIView 的自动布局分离出来
#import "STDefineUI.h"
#import "STUIViewAutoLayout.h"
#import "STLayoutTracer.h"
#import "STCategory.h"
#import "STSagit.h"
#import "STDefineFunc.h"
#import <objc/runtime.h>
#import "Reachability.h"
@implementation UIView(STAutoLayout)
#pragma mark 属性定义
static NSInteger nullValue=-99999;
// Name
- (NSMutableDictionary*)LayoutTracer
{
    return [self key:@"LayoutTracer"];
}
- (UIView*)setLayoutTracer:(NSMutableDictionary*)tracer
{
    [self key:@"LayoutTracer" value:tracer];
    return self;
}
- (CGRect)OriginFrame
{
    NSString *rect=[self key:@"OriginFrame"];
    if(rect)
    {
        return CGRectFromString(rect);
    }
    return CGRectZero;
}
- (UIView*)setOriginFrame:(CGRect)frame
{
    [self key:@"OriginFrame" value:NSStringFromCGRect(frame)];
    return self;
}
#pragma mark [相对布局方法] RelativeLayout
-(UIView*)getViewBy:(id)ui
{
    if([ui isKindOfClass:[NSString class]])
    {
        return [self.baseView.UIList get:(NSString*)ui];
        //STView *vi=self.stView;
        //NSDictionary *dic=self.stView.UIList;
        //        if(self.stView!=nil && [self.stView.UIList has:(NSString*)ui])
        //        {
        //            return self.stView.UIList[(NSString*)ui];
        //        }
    }
    else if([ui isKindOfClass:[UIView class]])
    {
        return (UIView*)ui;
    }
    return self;
}
//如果当前没设置frame，则用指定的frame，返回新的frame，避免改变原来的行为
-(CGRect)checkFrameIsEmpty:(CGRect)uiFrame
{
    if(CGRectEqualToRect(self.frame, STEmptyRect))// || CGRectEqualToRect(self.frame, STFullRect))
    {
        return STRectCopy(uiFrame);
    }
    return STRectCopy(self.frame);
}
-(CGSize)superSizeWithFix
{
    CGSize size=STFullSize;
    if(self.superview)
    {
        size=self.superview.frame.size;
        if([self.superview isKindOfClass:[UIScrollView class]])
        {
            UIScrollView *scroll=(UIScrollView*)self.superview;
            if(scroll.direction==X)
            {
                size.height=scroll.contentSize.height>0?scroll.contentSize.height:scroll.frame.size.height;
            }
            else if(scroll.direction==Y)
            {
                size.width=scroll.contentSize.width>0?scroll.contentSize.width:scroll.frame.size.width;
            }
        }
        
    }
    else if([self isKindOfClass:[UITableViewCell class]])
    {
        size=((UITableViewCell*)self).table.frame.size;
    }
    CGFloat screenHeight= [UIScreen mainScreen].bounds.size.height;
    if(size.height==screenHeight || size.height==screenHeight-STNavHeightPt-STStatusHeightPt)
    {
        //计算去掉超出父窗体或屏幕的部分
        //检测页面有没有导航条或Tarbar条
        if(self.stView && self.stView.stController)
        {
            UIViewController *controller=self.stView.stController;
            if(size.height==screenHeight && [controller needNavBar])
            {
                size.height-=(STNavHeightPt+STStatusHeightPt);
            }
            if([controller needTabBar])
            {
                size.height-=STTabHeightPt;
            }
        }
    }
    return size;
}
-(CGPoint)superOrigin
{
    if(self.superview==nil)
    {
        return STEmptyRect.origin;
    }
    return self.superview.frame.origin;
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
-(UIView*)onRight:(id)uiOrName
{
    return [self onRight:uiOrName x:0 y:0];
}
-(UIView*)onRight:(id)uiOrName x:(CGFloat)x
{
    return [self onRight:uiOrName x:x y:0];
}
-(UIView*)onRight:(id)uiOrName x:(CGFloat)x y:(CGFloat)y
{
    UIView *ui=[self getViewBy:uiOrName];
    [self addTracer:ui method:@"onRight" v1:x v2:y v3:0 v4:0 location:0 xyFlag:0];
    CGRect uiFrame=[self getUIFrame:ui];
    CGRect frame=[self checkFrameIsEmpty:uiFrame];
    
    //检测是否有onLeft、relate:Right规则，若有，调整宽度
    if([self.LayoutTracer has:@"onLeft"])
    {
        frame.size.width=(self.frame.origin.x+self.frame.size.width)-(uiFrame.origin.x+uiFrame.size.width)-x*Xpt;
        frame.origin.x=floor(uiFrame.size.width+uiFrame.origin.x+x*Xpt);
    }
    else
    {
        frame.origin.x=floor(uiFrame.size.width+uiFrame.origin.x+x*Xpt);
        STLayoutTracer *tracer= self.LayoutTracer[@"relate"];
        if(tracer!=nil && tracer.hasRelateRight)
        {
            frame.size.width-=(frame.origin.x-self.frame.origin.x);
        }
    }
    
    
    BOOL needSetY=YES;
    if(y==0)
    {
        STLayoutTracer *tracer= self.LayoutTracer[@"relate"];
        if(tracer!=nil)
        {
            NSString *relate=[@(tracer.location) stringValue];
            needSetY=!([relate contains:@"2"] || [relate contains:@"4"]);//包含左右则不设置
        }
    }
    if(needSetY)//未设置相对时，才设置
    {
        frame.origin.y=floor(uiFrame.origin.y+y*Ypt);
    }
    [self frame:frame];
    return self;
}
//在左边
-(UIView*)onLeft:(id)uiOrName
{
    return [self onLeft:uiOrName x:0 y:0];
}
-(UIView*)onLeft:(id)uiOrName x:(CGFloat)x
{
    return [self onLeft:uiOrName x:x y:0];
    
}
-(UIView*)onLeft:(id)uiOrName x:(CGFloat)x y:(CGFloat)y
{
    UIView *ui=[self getViewBy:uiOrName];
    [self addTracer:ui method:@"onLeft" v1:x v2:y v3:0 v4:0 location:0 xyFlag:0];
    
    CGRect uiFrame=[self getUIFrame:ui];
    CGRect frame=[self checkFrameIsEmpty:uiFrame];
    
    //检测是否有onRight、relate:Left规则，若有，调整宽度
    if([self.LayoutTracer has:@"onRight"])
    {
        frame.size.width=uiFrame.origin.x-x*Xpt-self.frame.origin.x;
    }
    else
    {
        STLayoutTracer *tracer= self.LayoutTracer[@"relate"];
        if(tracer!=nil && tracer.hasRelateLeft)
        {
            frame.size.width=uiFrame.origin.x-x*Xpt-self.frame.origin.x;
        }
        else
        {
            frame.origin.x=floor(uiFrame.origin.x-self.frame.size.width-x*Xpt);
        }
       
    }
    BOOL needSetY=YES;
    if(y==0)
    {
        STLayoutTracer *tracer= self.LayoutTracer[@"relate"];
        if(tracer!=nil)
        {
            NSString *relate=[@(tracer.location) stringValue];
            needSetY=!([relate contains:@"2"] || [relate contains:@"4"]);//包含左右则不设置
        }
    }
    if(needSetY)//未设置相对时，才设置
    {
        frame.origin.y=floor(uiFrame.origin.y+y*Ypt);
    }
    
    
    
    [self frame:frame];
    return self;
}
//在上边
-(UIView*)onTop:(id)uiOrName
{
    return [self onTop:uiOrName y:0 x:0];
}
-(UIView*)onTop:(id)uiOrName y:(CGFloat)y
{
    return [self onTop:uiOrName y:y x:0];
}
-(UIView*)onTop:(id)uiOrName y:(CGFloat)y x:(CGFloat)x
{
    UIView *ui=[self getViewBy:uiOrName];
    [self addTracer:ui method:@"onTop" v1:y v2:x v3:0 v4:0 location:0 xyFlag:0];
    CGRect uiFrame=[self getUIFrame:ui];
    CGRect frame=[self checkFrameIsEmpty:uiFrame];
    
    //检测是否有onBottom、relate：Top 规则，若有，调整高度
    if([self.LayoutTracer has:@"onBottom"])
    {
        frame.size.height=uiFrame.origin.y-y*Ypt-self.frame.origin.y;
    }
    else
    {
        STLayoutTracer *tracer= self.LayoutTracer[@"relate"];
        if(tracer!=nil && tracer.hasRelateTop)
        {
            frame.size.height=uiFrame.origin.y-y*Ypt-self.frame.origin.y;
        }
        else
        {
            frame.origin.y=floor(uiFrame.origin.y-self.frame.size.height-y*Ypt);
        }
    }
    
    BOOL needSetX=YES;
    if(x==0)
    {
        STLayoutTracer *tracer= self.LayoutTracer[@"relate"];
        if(tracer!=nil)
        {
            NSString *relate=[@(tracer.location) stringValue];
            needSetX=!([relate contains:@"1"] || [relate contains:@"3"]);//包含则不设置
        }
    }
    if(needSetX)//未设置相对时，才设置
    {
        frame.origin.x=floor(uiFrame.origin.x+x*Xpt);
    }
    
    
    [self frame:frame];
    return self;
}
//在下边
-(UIView *)onBottom:(id)uiOrName
{
    return [self onBottom:uiOrName y:0 x:0];
}
-(UIView *)onBottom:(id)uiOrName y:(CGFloat)y
{
    return [self onBottom:uiOrName y:y x:0];
}
-(UIView *)onBottom:(id)uiOrName y:(CGFloat)y x:(CGFloat)x
{
    UIView *ui=[self getViewBy:uiOrName];
    [self addTracer:ui method:@"onBottom" v1:y v2:x v3:0 v4:0 location:0 xyFlag:0];
    CGRect uiFrame=[self getUIFrame:ui];
    CGRect frame=[self checkFrameIsEmpty:uiFrame];
    //检测是否有onTop、relate：Bottom 规则，若有，调整高度
    if([self.LayoutTracer has:@"onTop"])
    {
        frame.size.height=(self.frame.origin.y+self.frame.size.height)-(uiFrame.origin.y+uiFrame.size.height)-y*Ypt;
        frame.origin.y=floor(uiFrame.origin.y+uiFrame.size.height+y*Ypt);
    }
    else
    {
        frame.origin.y=floor(uiFrame.origin.y+uiFrame.size.height+y*Ypt);
        STLayoutTracer *tracer= self.LayoutTracer[@"relate"];
        if(tracer!=nil && tracer.hasRelateBottom)
        {
            frame.size.height-=(frame.origin.y-self.frame.origin.y);
        }
    }
    
    
    
    BOOL needSetX=YES;
    if(x==0)
    {
        STLayoutTracer *tracer= self.LayoutTracer[@"relate"];
        if(tracer!=nil)
        {
            NSString *relate=[@(tracer.location) stringValue];
            needSetX=!([relate contains:@"1"] || [relate contains:@"3"]);//包含则不设置
        }
    }
    if(needSetX)//未设置相对时，才设置
    {
        frame.origin.x=floor(uiFrame.origin.x+x*Xpt);
    }
    [self frame:frame];
    return self;
}
-(UIView*)relate:(XYLocation)location v:(CGFloat)value
{
    return [self relate:location v:value v2:nullValue v3:nullValue v4:nullValue];
}
-(UIView*)relate:(XYLocation)location v:(CGFloat)value v2:(CGFloat)value2
{
    return [self relate:location v:value v2:value2 v3:nullValue v4:nullValue];
}
-(UIView*)relate:(XYLocation)location v:(CGFloat)value v2:(CGFloat)value2 v3:(CGFloat)value3
{
    return [self relate:location v:value v2:value2 v3:value3 v4:nullValue];
}
-(UIView*)relate:(XYLocation)location v:(CGFloat)value v2:(CGFloat)value2 v3:(CGFloat)value3 v4:(CGFloat)value4
{
    [self addTracer:nil method:@"relate" v1:value v2:value2 v3:value3 v4:value4 location:location xyFlag:0];
    CGFloat left=nullValue,top=nullValue,right=nullValue,bottom=nullValue;
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
            top=value2==nullValue?value:value2;
            break;
        case LeftRight:
            left=value;
            right=value2==nullValue?value:value2;
            break;
        case LeftBottom:
            left=value;
            bottom=value2==nullValue?value:value2;
            break;
        case TopRight:
            top=value;
            right=value2==nullValue?value:value2;
            break;
        case RightBottom:
            right=value;
            bottom=value2==nullValue?value:value2;
            break;
        case TopBottom:
            top=value;
            bottom=value2==nullValue?value:value2;
            break;
            //three values
        case LeftTopRight:
            left=value;
            top=value2==nullValue?value:value2;
            right=value3==nullValue?left:value3;
            break;
        case LeftTopBottom:
            left=value;
            top=value2==nullValue?value:value2;
            bottom=value3==nullValue?top:value3;
            break;
        case LeftBottomRight:
            left=value;
            bottom=value2==nullValue?value:value2;
            right=value3==nullValue?left:value3;
            break;
        case TopRightBottom:
            top=value;
            right=value2==nullValue?value:value2;
            bottom=value3==nullValue?top:value3;
            break;
            //four values
        default:
        case LeftTopRightBottom:
            left=value;
            top=value2==nullValue?value:value2;
            right=value3==nullValue?left:value3;
            bottom=value4==nullValue?top:value4;
            break;
    }
    return [self relate:LeftTopRightBottom left:left top:top right:right bottom:bottom];
}
-(UIView*)relate:(XYLocation)location left:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom
{
    CGSize superSize=[self superSizeWithFix];
    if(left>=-1 && left<=1){left=superSize.width*Xpx*left;}
    if(top>=-1 && top<=1){top=superSize.height*Ypx*top;}
    
    if(right>=-1 && right<=1){right=superSize.width*Xpx*right;}
    if(bottom>=-1 && bottom<=1){bottom=superSize.height*Ypx*bottom;}
    
    
    
    CGRect frame=STRectCopy(self.frame);
    //frame.origin=CGPointZero;//归零处理 后来没想通为什么要归零，只能去掉。
    if(left!=nullValue && right!=nullValue)
    {
        frame.size.width=superSize.width-left*Xpt-right*Xpt;
    }
    if(top!=nullValue && bottom!=nullValue)
    {
        frame.size.height=superSize.height-top*Ypt-bottom*Ypt;
    }
    if(left!=nullValue)
    {
        CGFloat changeValue=frame.origin.x-floor(left*Xpt);//X发生变化的值
        frame.origin.x=floor(left*Xpt);
        //检测是否有onLeft规则，若有，调整宽度
        if([self.LayoutTracer has:@"onLeft"])
        {
            frame.size.width=frame.size.width+changeValue;
        }
    }
    else if(right!=nullValue)
    {
        if([self.LayoutTracer has:@"onRight"])
        {
            frame.size.width=superSize.width-frame.origin.x-floor(right*Xpt);
        }
        else
        {
            frame.origin.x=floor(superSize.width-frame.size.width-right*Xpt);
        }
    }
    if(top!=nullValue)
    {
        CGFloat changeValue=frame.origin.y-floor(top*Ypt);//Y发生变化的值
        frame.origin.y=floor(top*Ypt);
        //检测是否有onLeft规则，若有，调整宽度
        if([self.LayoutTracer has:@"onTop"])
        {
            frame.size.height=frame.size.height+changeValue;
        }
    }
    else if(bottom!=nullValue)
    {
        if([self.LayoutTracer has:@"onBottom"])
        {
            frame.size.height=superSize.height-frame.origin.y-bottom*Ypt;
        }
        else
        {
            frame.origin.y=floor(superSize.height-frame.size.height-bottom*Ypt);
        }
    }
    [self frame:frame];
    return self;
}


-(UIView*)toCenter
{
    return [self toCenter:XY];
}
-(UIView*)toCenter:(XYFlag)flag
{
    [self addTracer:nil method:@"toCenter" v1:0 v2:0 v3:0 v4:0 location:0 xyFlag:flag];
    CGRect frame=self.frame;
    CGSize superSize=[self superSizeWithFix];
    
    //检测约束
    BOOL relateTop=NO,relateBottom=NO,relateLeft=NO,relateRight=NO;//检测有没有上下左右的约束。
    STLayoutTracer *tracer= self.LayoutTracer[@"relate"];
    if(tracer!=nil)
    {
        NSString *relate=[@(tracer.location) stringValue];
        relateLeft=[relate contains:@"1"];
        relateTop=[relate contains:@"2"];
        relateRight=[relate contains:@"3"];
        relateBottom=[relate contains:@"4"];
    }
    //X坐标[宽度居中]
    if(flag==1 || flag==0)
    {
        if((relateRight || [self.LayoutTracer has:@"onLeft"]) && frame.origin.x+frame.size.width<superSize.width)
        {
            frame.origin.x=frame.origin.x/2;
        }
        else if((relateLeft || [self.LayoutTracer has:@"onRight"]) && frame.origin.x>0)
        {
            frame.origin.x=frame.origin.x+(superSize.width-frame.size.width-frame.origin.x)/2;
        }
        else
        {
            frame.origin.x=(superSize.width-frame.size.width)/2;
        }
    }
    //Y坐标[高度居中]
    if(flag==2 || flag==0)
    {
//        //计算去掉超出父窗体或屏幕的部分
//        if(CGSizeEqualToSize(superSize, STFullSize))
//        {
//            //检测页面有没有导航条或Tarbar条
//            if(self.stView && self.stView.stController)
//            {
//                UIViewController *controller=self.stView.stController;
//                if([controller needNavBar])
//                {
//                    superSize.height=superSize.height-STNavHeightPt-STStatusHeightPt;
//                }
//                if([controller needTabBar])
//                {
//                    superSize.height-=STTabHeightPt;
//                }
//            }
//        }
        if((relateBottom || [self.LayoutTracer has:@"onTop"]) && frame.origin.y+frame.size.height<superSize.height)
        {
            frame.origin.y=frame.origin.y/2;
        }
        else if((relateTop || [self.LayoutTracer has:@"onBottom"]) && frame.origin.y>0)
        {
            frame.origin.y=frame.origin.y+(superSize.height-frame.size.height-frame.origin.y)/2;
        }
        else
        {
            frame.origin.y=(superSize.height-frame.size.height)/2;
        }
    }
    [self frame:frame];
    return self;
}
-(UIView*)x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
{
    [self width:width height:height];
    return [self relate:LeftTop v:x v2:y];
}
-(UIView*)frame:(CGRect)frame
{
    frame.origin.x=ceilf(frame.origin.x);
    frame.origin.y=ceilf(frame.origin.y);
    if(![self key:@"denyFixWidthHeight"])
    {
        frame.size.width=ceilf(frame.size.width);
        frame.size.height=ceilf(frame.size.height);
    }
    
    self.frame=frame;
    return self;
}
-(CGFloat)stX{return self.frame.origin.x*Xpx;}
-(CGFloat)stY{return self.frame.origin.y*Ypx;}
-(CGFloat)stWidth
{
    return self.frame.size.width*Xpx;
    
}
-(CGFloat)stHeight{return self.frame.size.height*Ypx;}
-(CGFloat)stScreenX{
    return ([self convertPoint:self.frame.origin toView:nil].x-self.frame.origin.x)*Xpx;
//    if(self.superview!=nil)
//    {
//        return self.stX+self.superview.stScreenX;
//    }
//    return self.stX;
}
-(CGFloat)stScreenY
{
    return ([self convertPoint:self.frame.origin toView:nil].y-self.frame.origin.y) *Ypx;
//    if(self.superview!=nil)
//    {
//        return self.stY+self.superview.stScreenY;
//    }
//    return self.stY;
}
-(UIView*)x:(CGFloat)x
{
    return [self x:x y:nullValue];
}
-(UIView*)x:(CGFloat)x y:(CGFloat)y
{
    if(x!=nullValue && y!=nullValue)
    {
        return [self relate:LeftTop v:x v2:y];
    }
    else if(x!=nullValue)
    {
        return [self relate:Left v:x];
    }
    else if(y!=nullValue)
    {
        return [self relate:Top v:y];
    }
    return self;
}

-(UIView*)y:(CGFloat)y
{
    return [self x:nullValue y:y];
}
-(UIView*)width:(CGFloat)width
{
    return [self width:width height:self.stHeight];
}
-(UIView*)width:(CGFloat)width height:(CGFloat)height
{
    
    if((width>=-1 && width<=1) || (height>=-1 && height<=1) || width==STSameToHeight || height==STSameToWidth )
    {
        [self addTracer:nil method:@"widthHeight" v1:width v2:height v3:0 v4:0 location:0 xyFlag:0];
        if(width>=-1 && width<=1){width=[self superSizeWithFix].width*Xpx*width;}
        if(height>=-1 && height<=1){height=[self superSizeWithFix].height*Ypx*height;}
    }
    if(width==STSameToHeight)
    {
        width=height;
    }
    else if(height==STSameToWidth)
    {
        height=width;
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
        [UIView setAnimationDuration:0.5];
        [self frame:frame];
        [UIView commitAnimations];
    }
    return self;
}
-(UIView*)backToOrigin
{
    if(!CGRectEqualToRect(self.OriginFrame,CGRectZero) && !CGRectEqualToRect(self.OriginFrame, self.frame))
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
#pragma mark [布局刷新] refleshLayout
-(UIView*)refleshLayout
{
    return [self refleshLayout:YES ignoreSelf:NO];
}
-(UIView*)refleshLayout:(BOOL)withWidthHeight
{
    return [self refleshLayout:withWidthHeight ignoreSelf:NO];
}
-(UIView*)refleshLayout:(BOOL)withWidthHeight ignoreSelf:(BOOL)ignoreSelf
{
    if(!ignoreSelf)
    {
        NSMutableDictionary* tracer=self.LayoutTracer;
        if(tracer!=nil && tracer.count>0)
        {
            [self key:@"denyFixWidthHeight" value:@"1"];
            for (NSString*method in tracer)
            {
                STLayoutTracer *v=tracer[method];
                if ([method isEqualToString:@"relate"])
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
                else if ([method isEqualToString:@"toCenter"])
                {
                    [self toCenter:v.xyFlag];
                }
                else if (withWidthHeight && [method isEqualToString:@"widthHeight"])
                {
                    [self width:v.v1 height:v.v2];
                }
            }
             [self key:@"denyFixWidthHeight" value:nil];
        }
    }
    if(self.subviews!=nil && self.subviews.count>0)
    {
        for (int i=0; i<self.subviews.count; i++) {
            [self.subviews[i] refleshLayout:withWidthHeight ignoreSelf:NO];
        }
    }
    return self;
}

-(void)refleshLayoutAfterRotate
{
    
    [self endEditing:YES];
    STController *st=self.stController;
    if(st!=nil)
    {
        if(CGRectEqualToRect(self.OriginFrame,CGRectZero))
        {
            self.OriginFrame=self.frame;
            if(st.preferredInterfaceOrientationForPresentation==Sagit.Define.DefaultOrientation)
            {
                return;
            }
        }
        //屏幕坐标变化木有屏幕旋转快。
        [Sagit delayExecute:0.5 onMainThread:YES block:^{
            if(!CGRectEqualToRect(self.frame, self.OriginFrame))
            {
                NSLog(@"retry...refleshLayout : %@,%@ ",NSStringFromCGRect(self.frame),NSStringFromCGRect(self.OriginFrame));
                self.OriginFrame=self.frame;
                //检查设备
                [UIView animateWithDuration:0.4 animations:^{
                    if (@available(ios 13.0, *)) {
                        if(st.needStatusBar)
                        {
                            UIView *status=self.statusBar;
                            if(_STIsLandscape)
                            {
                                [status width:1];
                                UIColor *color=ColorBlack;
                                if(st.preferredStatusBarStyle==UIStatusBarStyleLightContent)
                                {
                                    color=ColorWhite;
                                }
                                // 当前的电池电量
                                [UIDevice currentDevice].batteryMonitoringEnabled = YES;
                                UILabel *wifi=[[[[status addLabel:nil text:@"..." font:15*STStandardScale color:color] relate:Left v:30*STStandardScale ] toCenter:Y] width:120];
                                UILabel *battery=[[[[status addLabel:nil text:@"100%" font:15*STStandardScale color:color] relate:Right v:30*STStandardScale ] toCenter:Y] width:120];
                                [[[status addLabel:nil text:[NSDate.beiJinDate toString:@"HH:mm"] font:15*STStandardScale color:color] toCenter] onTimer:^(UILabel* view,NSTimer *timer, NSInteger count) {
                                    //时间
                                    [view text:[NSDate.beiJinDate toString:@"HH:mm"]];
                                    //电池
                                    CGFloat batteryLevel = [UIDevice currentDevice].batteryLevel;
                                    [battery text:STString(@"%.f%%",batteryLevel*100)];
                                    //wifi
                                    Reachability *reach=[Reachability reachabilityWithHostName:@"www.baidu.com"];
                                    NetworkStatus status= reach.currentReachabilityStatus;
                                    if(status==ReachableViaWiFi)
                                    {
                                        [wifi text:@"Wi-Fi"];
                                    }
                                    else
                                    {
                                        [wifi text:@"No Wifi"];
                                    }
                                } interval:60];
                            }
                            else
                            {
                                [status removeAllSubViews];
                            }
                        }
                    }
                    [self refleshLayout];
                }];
            }
        }];
    }
  
}

-(UIView*)stSizeToFit
{
    return [self stSizeToFit:0 y:0];
}
//仅遍历一级
-(UIView*)stSizeToFit:(NSInteger)widthPx y:(NSInteger)heightPx
{
    if(self.subviews.count>0)
    {
        NSInteger xValue=0,yValue=0;
        BOOL xYes=NO,yYes=NO;
        for (NSInteger i=0; i<self.subviews.count; i++)
        {
            CGRect subFrame= self.subviews[i].frame;
            CGRect myFrame=self.frame;
            xValue=subFrame.origin.x+subFrame.size.width -myFrame.size.width;
            yValue=subFrame.origin.y+subFrame.size.height -myFrame.size.height;
            if(xValue>0)
            {
                xYes=YES;
                [self width: (myFrame.size.width+xValue)*Xpx];
            }
            if(yValue>0)
            {
                yYes=YES;
                [self height:(myFrame.size.height+yValue)*Ypx];
            }
        }
        if(xYes){[self width:self.stWidth+widthPx];}
        if(yYes){[self height:self.stHeight+heightPx];}
    }
    return self;
}
-(UIView*)stretch
{
    return [self stretch:0 y:0];
}
-(UIView*)stretch:(CGFloat)x
{
    return [self stretch:x y:0];
}
-(UIView*)stretch:(CGFloat)x y:(CGFloat)y
{
    if([self isKindOfClass:[UIImageView class]])
    {
        UIImageView *me=(UIImageView*)self;
        if(me.image!=nil)
        {
            CGFloat left,right,top,bottom;
            if(x==0){left=right=me.image.size.width/2;}
            else
            {
                left=x*Xpt;
                right=me.image.size.width-left-2*Xpt;
            }
            if(y==0)
            {
                top=bottom=me.image.size.height/2;
            }
            else
            {
                top=y*Ypt;
                bottom=me.image.size.height-top-2*Ypt;
            }
            
            
            // 设置端盖的值
            UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
            // 拉伸图片
            me.image = [me.image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
        }
    }
    return self;
    
}
-(UIView *)cut:(NSInteger)widthPx height:(NSInteger)heightPx
{
    [self x:self.stX+widthPx/2 y:self.stY+heightPx/2 width:self.stWidth-widthPx height:self.stHeight-heightPx];
    return self;
}

//#pragma mark 【px<=>pt】动态转换系数
//+(NSInteger)stStandardWidthPt:(id)viewOrController
//{
//   return 375;
//}
//+(NSInteger)stStandardHeightPt:(id)viewOrController
//{
//    NSInteger hpt=_STIsIPhoneX?_STScreenSize.height:667;
//    if(viewOrController!=nil)
//    {
//        UIViewController *c=viewOrController;
//        if([viewOrController isKindOfClass:[UIView class]])
//        {
//            c=((UIView*)viewOrController).stController;
//        }
//        if(c!=nil)
//        {
//            if(c.needNavBar)
//            {
//                hpt=hpt-STNavHeightPt-STStatusHeightPt;
//            }
//            if(c.needTabBar)
//            {
//                hpt=hpt-STTabHeightPt;
//            }
//        }
//    }
//    return hpt;
//}
//+(CGFloat)xToPx
//{
//    return 0;
//}
//+(CGFloat)yToPx
//{
//   return 0;
//}
//+(CGFloat)xToPt
//{
//   return 0;
//}
//+(CGFloat)yToPt
//{
//   return 0;
//}
@end
