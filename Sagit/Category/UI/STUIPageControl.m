//
//  STUIPageControl.m
//  IT恋
//
//  Created by 陈裕强 on 2018/2/1.
//  Copyright © 2018年 Silan Xie. All rights reserved.
//

#import "STUIPageControl.h"

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
    self.pageIndicatorTintColor=[self toColor:colorOrHex];
    return self;
}
-(UIPageControl*)currentColor:(id)colorOrHex
{
    self.currentPageIndicatorTintColor=[self toColor:colorOrHex];
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
        [NSTimer scheduledTimerWithTimeInterval:second repeats:YES block:^(NSTimer * _Nonnull timer) {
            if(!self.isTimering)
            {
                [timer invalidate];
                return;
            }
            NSInteger pagerIndex=self.currentPage;
            pagerIndex=pagerIndex+1;
            if(pagerIndex>=self.numberOfPages)
            {
                pagerIndex=0;
            }
            [self currentPage:pagerIndex];
            if(onTimer)
            {
                onTimer(timer);
            }
        }];
    }
    return self;
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
