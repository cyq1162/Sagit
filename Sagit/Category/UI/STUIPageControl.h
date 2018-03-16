//
//  STUIPageControl.h
//  IT恋
//
//  Created by 陈裕强 on 2018/2/1.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPageControl(ST)
@property (readonly,nonatomic,weak)UIScrollView* scrollView;
-(UIPageControl*)numberOfPages:(NSInteger)num;
-(UIPageControl*)currentPage:(NSInteger)pagerIndex;
-(UIPageControl*)pageColor:(id)colorOrHex;
-(UIPageControl*)currentColor:(id)colorOrHex;
#pragma mark 定时切换
typedef void (^OnPageTimer)(NSTimer* timer);
@property (readonly,nonatomic,assign)BOOL isTimering;

-(UIPageControl*)startTimer:(NSInteger)second onTimer:(OnPageTimer)onTimer;
-(UIPageControl*)stopTimer;

#pragma mark 值改变事件
@property (nonatomic,assign)BOOL allowClickPager;
typedef void (^OnPagerChange)(UIPageControl* pager);
@property (nonatomic,copy)OnPagerChange onPagerChange;
@end
