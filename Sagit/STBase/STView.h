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
//!所对应的Controller
@property (nonatomic,retain) STController *Controller;
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

//!将指定的数据批量赋值到所有的UI中：data可以是字典、是json，是实体等
-(void)setToAll:(id)data;
//!将指定的数据批量赋值到所有的UI中：data可以是字典、是json，是实体等 toChild:是否检测子控件并对子控件也批量赋值，默认NO。
-(void)setToAll:(id)data toChild:(BOOL)toChild;
//!从UIList中遍历获取属性isFormUI的表单数据列表
-(NSMutableDictionary*)formData;
//!从UIList中遍历获取属性isFormUI的表单数据列表 superView ：指定一个父，不指定则为根视图
-(NSMutableDictionary*)formData:(id)superView;

@end
