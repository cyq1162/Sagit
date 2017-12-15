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
//所对应的Controller
@property (nonatomic,retain) STController *Controller;
//所有name的控件
@property (nonatomic,retain)NSMutableDictionary *UIList;
//存档文本框的列表
@property (nonatomic,retain) NSMutableArray *UITextList;
//开启针对文本的高度自适应、键盘遮档事件
@property (nonatomic,assign) BOOL isStartTextChageEvent;
//是否开启手机旋转刷新布局功能。
@property (nonatomic,assign) BOOL isStartRotateEvent;

-(void)initView;
//初始化[子类重写]
-(void)initUI;
-(instancetype)initWithController:(STController*)controller;
-(void)loadData:(NSDictionary*)data;
-(NSMutableDictionary*)formData;
-(NSMutableDictionary*)formData:(id)superView;
@end
