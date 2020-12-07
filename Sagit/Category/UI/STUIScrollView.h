//
//  STUIScrollView.h
//  IT恋
//
//  Created by 陈裕强 on 2018/1/29.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STEnum.h"
#import "STUIViewEvent.h"
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
//!分页的长度、或高度（px单位）。
@property (nonatomic,assign) NSInteger pagerPx;
//!开始滑动的坐标
@property (nonatomic,assign)CGPoint startPoint;
//!手放开时的坐标
@property (nonatomic,assign)CGPoint endPoint;
//!滑动的方向
@property (nonatomic,assign)XYFlag direction;
//!图片是否全屏
@property (nonatomic,assign)BOOL isImageFull;

//!绑定事件 用代码块的形式，为所有子View添加事件
-(UIScrollView*)onSubviewClick:(OnViewClick)block;
-(UIScrollView*)removeAt:(NSInteger) index;
-(UIScrollView *)removeAt:(NSInteger)index moveXY:(BOOL)yesNO;
#pragma mark 分页组件
@property (readonly,nonatomic,retain)UIPageControl *pager;
-(BOOL)showPager;
-(UIScrollView*)showPager:(BOOL)yesNo;
//!图片是否允许保存
-(BOOL)isAllowSaveImage;
-(UIScrollView*)isAllowSaveImage:(BOOL)yesNo;

#pragma mark Add Images
-(UIScrollView *)addImages:(id)imgOrNameOrArray,...NS_REQUIRES_NIL_TERMINATION;
//扩展N页内容大小
-(UIScrollView *)addPageSizeContent:(NSInteger)num;
@end
