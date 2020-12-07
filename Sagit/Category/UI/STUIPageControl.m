//
//  STUIPageControl.m
//  IT恋
//
//  Created by 陈裕强 on 2018/2/1.
//  Copyright © 2018年 . All rights reserved.
//

#import "STUIPageControl.h"
#import "STUIScrollView.h"
#import "STCategory.h"
@implementation UIPageControl (ST)
-(UIPageControl*)numberOfPages:(NSInteger)num
{
    self.numberOfPages=num;
    return self;
}
-(UIPageControl*)currentPage:(NSInteger)pagerIndex
{
    self.currentPage=pagerIndex;
    if(self.scrollView && self.scrollView.pagerIndex!=pagerIndex)
    {
        self.scrollView.pagerIndex=pagerIndex;
    }
    return self;
}
-(UIPageControl*)pageColor:(id)colorOrHex
{
    self.pageIndicatorTintColor=[UIColor toColor:colorOrHex];
    return self;
}
-(UIPageControl*)currentColor:(id)colorOrHex
{
    self.currentPageIndicatorTintColor=[UIColor toColor:colorOrHex];
    return self;
}
#pragma mark 扩展
-(UIScrollView *)scrollView
{
    return [self key:@"scrollView"];
}
-(BOOL)isTimering
{
    NSString *flag=[self key:@"isTimering"];
    if(flag!=nil)
    {
        return [flag isEqualToString:@"1"];
    }
    return NO;
}
-(NSTimer *)timer
{
    return [self key:@"timer"];
}
-(UIPageControl *)startTimer:(NSInteger)second onTimer:(OnPageTimer)onTimer
{
    if(!self.isTimering)
    {
        [self key:@"isTimering" value:@"1"];
         NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(onTimering) userInfo:nil repeats:YES];
        [self key:@"NSTimer" value:timer];
        if(onTimer)
        {
            [self key:@"OnTimerEvent" value:onTimer];
        }
        [timer fire];
    }
    return self;
}
-(void)onTimering
{
    if(!self.isTimering)
    {
        NSTimer *timer=[self key:@"NSTimer"];
        if(timer)
        {
            [timer invalidate];
            timer=nil;
            [self key:@"NSTimer" value:nil];
            [self key:@"OnTimerEvent" value:nil];
        }
        return;
    }
    NSInteger pagerIndex=self.currentPage;
    pagerIndex=pagerIndex+1;
    if(pagerIndex>=self.numberOfPages)
    {
        pagerIndex=0;
    }
    [self currentPage:pagerIndex];
    OnPageTimer event=[self key:@"OnTimerEvent"];
    if(event)
    {
        event([self key:@"NSTimer"]);
    }
}
-(UIPageControl *)stopTimer
{
    [self key:@"isTimering" value:nil];
    return self;
}
#pragma mark 分页点击事件
-(OnPagerChange)onPagerChange
{
    return [self key:@"onPagerChange"];
}
-(void)setOnPagerChange:(OnPagerChange)onPagerChange
{
    [self key:@"onPagerChange" value:onPagerChange];
}
-(BOOL)allowClickPager
{
    return self.userInteractionEnabled;
}
-(void)setAllowClickPager:(BOOL)allowClickPager
{
    self.userInteractionEnabled=allowClickPager;
     [self removeTarget:self action:@selector(onValueChange) forControlEvents:UIControlEventValueChanged];
    if(allowClickPager)
    {
        [self addTarget:self action:@selector(onValueChange) forControlEvents:UIControlEventValueChanged];
    }
}
-(void)onValueChange
{
    if(self.onPagerChange)
    {
        self.onPagerChange(self);
    }
    [self currentPage:self.currentPage];//内部检测给滚动视图赋值。
}
-(void)dispose
{
    [self removeTarget:self action:@selector(onValueChange) forControlEvents:UIControlEventValueChanged];
}
@end
