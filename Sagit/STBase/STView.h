//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STController.h"

@interface STView : UIView
//!所对应的Controller (弱引用，不然就双向引用内存不保)
@property (nonatomic,weak) STController *Controller;
////!所有name的控件的集合
//@property (nonatomic,retain)NSMutableDictionary *UIList;
//!存档文本框的列表
@property (nonatomic,retain) NSMutableArray *UITextList;
//!开启针对文本的高度自适应、键盘遮档事件
@property (nonatomic,assign) BOOL isStartTextChageEvent;
//!是否开启手机旋转刷新布局功能。
@property (nonatomic,assign) BOOL isStartRotateEvent;
//!初始化
-(instancetype)initWithController:(STController*)controller;
//!加载UI（系统内部调用）
-(void)loadUI;
#pragma mark 通用的两个事件方法：initUI、initData #pragma mark (还有一个位于基类的：reloadData)
//!UI初始化
-(void)initUI;
//!事件在UI初始化之后执行
-(void)initData;



@end
