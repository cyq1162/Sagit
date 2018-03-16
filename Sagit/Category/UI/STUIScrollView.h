//
//  STUIScrollView.h
//  IT恋
//
//  Created by 陈裕强 on 2018/1/29.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STEnum.h"
@interface UIScrollView (ST)
//定义两个事件，上一页和下一页
typedef void (^OnScrollPrePager)(UIScrollView *scrollView);
//定义两个事件，上一页和下一页
typedef void (^OnScrollNextPager)(UIScrollView *scrollView);
//!上一页事件
@property (nonatomic,copy)OnScrollPrePager onPrePager;
//!下一页事件
@property (nonatomic,copy)OnScrollNextPager onNextPager;
//!当前页的索引
@property (nonatomic,assign)NSInteger pagerIndex;
//!开始滑动的坐标
@property (nonatomic,assign)CGPoint startPoint;
//!手放开时的坐标
@property (nonatomic,assign)CGPoint endPoint;
//!最后定位的坐标
//@property (nonatomic,assign)CGPoint endPoint;
@property (nonatomic,assign)XYFlag direction;
//!绑定事件 用代码块的形式，为所有子View添加事件
-(UIScrollView*)onSubviewClick:(OnViewClick)block;
-(UIScrollView*)removeAt:(NSInteger) index;
-(UIScrollView *)removeAt:(NSInteger)index moveXY:(BOOL)yesNO;
#pragma mark 分页组件
@property (readonly,nonatomic,retain)UIPageControl *pager;
-(BOOL)showPager;
-(UIScrollView*)showPager:(BOOL)yesNo;
@end
