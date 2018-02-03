//
//  STUIScrollView.m
//  IT恋
//
//  Created by 陈裕强 on 2018/1/29.
//  Copyright © 2018年 Silan Xie. All rights reserved.
//

#import "STUIScrollView.h"
#import "STUIPageControl.h"
@implementation UIScrollView(ST)



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{    //拖动前的起始坐标
    self.startPoint=self.contentOffset;
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{    //将要停止前的坐标
    self.endPoint=self.contentOffset;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint nowPoint= scrollView.contentOffset;
    //滑动的方向是：
    BOOL isPre=NO,isNext=NO;
    if(self.direction==X)
    {
        isPre=nowPoint.x < self.endPoint.x && self.endPoint.x < self.startPoint.x;
        isNext=nowPoint.x > self.endPoint.x && self.endPoint.x > self.startPoint.x;
    }
    else if(self.direction==Y)
    {
        isPre=nowPoint.y < self.endPoint.y && self.endPoint.y < self.startPoint.y;
        isNext=nowPoint.y > self.endPoint.y && self.endPoint.y > self.startPoint.y;
    }
    if(isPre)
    {
        if(self.onPrePager)
        {
            self.onPrePager(self);
        }
        if(self.pager)
        {
            [self.pager currentPage:self.pagerIndex];
        }
    }
    else if(isNext)
    {
        if(self.onNextPager)
        {
            self.onNextPager(self);
        }
        if(self.pager)
        {
            [self.pager currentPage:self.pagerIndex];
        }
    }
}
#pragma mark 属性、方法
-(CGPoint)startPoint
{
    NSString *point=[self key:@"startPoint"];
    if(point)
    {
        return CGPointFromString(point);
    }
    return self.contentOffset;
}
-(void)setStartPoint:(CGPoint)startPoint
{
    [self key:@"startPoint" value:NSStringFromCGPoint(startPoint)];
}

-(CGPoint)endPoint
{
    NSString *point=[self key:@"endPoint"];
    if(point)
    {
        return CGPointFromString(point);
    }
    return self.contentOffset;
}
-(void)setEndPoint:(CGPoint)endPoint
{
    [self key:@"endPoint" value:NSStringFromCGPoint(endPoint)];
}
-(XYFlag)direction
{
    NSNumber *num=[self key:@"direction"];
    if(num!=nil)
    {
        return (XYFlag)num.integerValue;
    }
    return X;
}
-(void)setDirection:(XYFlag)direction
{
    [self key:@"direction" value:@(direction)];
}
-(NSInteger)pagerIndex
{
    if(self.direction==X)
    {
        return self.contentOffset.x/self.frame.size.width;
    }
    else if(self.direction==Y)
    {
        return self.contentOffset.y/self.frame.size.height;
    }
//    NSNumber *num=[self key:@"pagerIndex"];
//    if(num!=nil)
//    {
//        return num.integerValue;
//    }
    return 0;
}
-(void)setPagerIndex:(NSInteger)pagerIndex
{
    NSInteger flag=self.pagerIndex-pagerIndex;
    
    CGPoint offset= self.contentOffset;
    if(self.direction==X)
    {
        offset.x= pagerIndex*self.frame.size.width;
    }
    else if(self.direction==Y)
    {
        offset.y=pagerIndex*self.frame.size.height;
    }
    self.contentOffset=offset;
    if(self.pager && self.pager.currentPage!=pagerIndex)//加个判断，避免死循环
    {
        [self.pager currentPage:self.pagerIndex];
    }
    //触发事件
    if(flag>0 &&self.onPrePager)
    {
        self.onPrePager(self);
    }
    else if(flag<0 && self.onNextPager)
    {
        self.onNextPager(self);
    }
   
}
#pragma mark 事件
-(UIScrollView *)onSubviewClick:(OnViewClick)block
{
    for (UIView *subview in self.subviews) {
        [subview onClick:block];
    }
    return self;
}
-(UIScrollView *)removeAt:(NSInteger)index
{
    return [self removeAt:index moveXY:NO];
}
-(UIScrollView *)removeAt:(NSInteger)index moveXY:(BOOL)yesNO
{
    NSInteger count=self.subviews.count;
    if(self.showsVerticalScrollIndicator){count--;}
    if(self.showsHorizontalScrollIndicator){count--;}
    if(index>=count){return self;}
    NSInteger adjustXY=self.direction==X?self.contentSize.width/count:self.contentSize.height/count;
    [self.subviews[index] removeSelf];//移除;
    //调整坐标，宽高。
    for (NSInteger i=index; i<count-1; i++)
    {
        UIView *sub=self.subviews[i];
        switch (self.direction)
        {
            case X:
                [sub x:sub.stX-adjustXY*Xpx];
                break;
            case Y:
            default:
                [sub y:sub.stY-adjustXY*Ypx];
                break;
        }
    }
    //调整自已的宽高
    CGSize size=self.contentSize;
    CGPoint offset=self.contentOffset;
    switch (self.direction) {
        case X:
           
            size.width-=adjustXY;
            if(yesNO)
            {
                offset.x-=adjustXY;//
                //self.contentOffset.x-
                //[self x:self.stX-adjustXY*Xpx];
            }
            break;
        default:
        case Y:
           size.height-=adjustXY;
            if(yesNO)
            {
                offset.y-=adjustXY;
                //[self y:self.stY-adjustXY*Xpx];
            }
            break;
    }
    
    
    self.contentSize=size;
    self.contentOffset=offset;
    self.pagerIndex=self.pagerIndex;//内部调整分页组件的数字。
    return self;
}
-(OnScrollPrePager)onPrePager
{
    return [self key:@"onPrePager"];
}
-(void)setOnPrePager:(OnScrollPrePager)onPrePager
{
    [self key:@"onPrePager" value:onPrePager];
}
-(OnScrollNextPager)onNextPager
{
    return [self key:@"onNextPager"];
}
-(void)setOnNextPager:(OnScrollNextPager)onNextPager
{
    [self key:@"onNextPager" value:onNextPager];
}

#pragma mark 分页组件
-(UIPageControl *)pager
{
    return [self key:@"pager"];
}
-(BOOL)showPager
{
    return [self key:@"showPager"];
}
-(UIScrollView *)showPager:(BOOL)yesNo
{
    if(!yesNo)
    {
        UIPageControl *pager=self.pager;
        if(pager)
        {
            [pager removeSelf];
            pager=nil;
        }
        [self key:@"pager" valueWeak:nil];
    }
    else if(![self key:@"pager"] && self.superview!=nil)
    {
        UIPageControl *pager=[UIPageControl new];
        pager.numberOfPages=self.subviews.count;
        NSInteger i=self.pagerIndex;
        pager.currentPage=i;
        pager.allowClickPager=YES;
        [pager key:@"scrollView" valueWeak:self];
        [self key:@"pager" valueWeak:pager];
        [[[self.superview addView:pager name:nil] width:self.stWidth height:40] onBottom:self y:-100];// backgroundColor:ColorRandom];
        
    }
    return self;
}
@end
