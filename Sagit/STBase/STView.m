//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//
//  Copyright © 2017-2027年. All rights reserved.
//
#import "STCategory.h"
#import "STView.h"
#import "STLayoutTracer.h"
#import "STDefineUI.h"
#import "STModelBase.h"
//#import <objc/runtime.h>

@implementation STView

-(instancetype)init
{
    self = [super init];
    self.frame=STFullRect;//页面加载完后，IOS系统会根据导航状态栏等情况修改坐标和高度
    self.backgroundColor=ColorDevice;//卡的问题
    return self;
}

- (instancetype)initWithController:(STController*)controller
{
    self=[self init];
    if (controller) {
        self.Controller=controller;
    }
    return self;
}


//初始化[子类重写该方法]
-(void)initUI
{
    
}
-(void)initData
{
    //触发子控件事件
    for (NSString *key in self.UIList.keys)
    {
        STView*view=[self.UIList get:key];
        if([view isKindOfClass:[STView class]])
        {
            [view initData];
        }
    }
}
-(void)reloadData
{
    //触发子控件事件
    for (NSString *key in self.UIList.keys)
    {
        STView*view=[self.UIList get:key];
        if([view isKindOfClass:[STView class]])
        {
            [view reloadData];
        }
    }
}


////延时加载
//-(NSMutableDictionary*)UIList
//{
//    return [super.baseView key:@"UIList"];
//}
//-(NSMutableArray*)UITextList
//{
//    if(_UITextList==nil)
//    {
//        _UITextList=[NSMutableArray new];
//    }
//    return _UITextList;
//}


-(void)dealloc{
    //[[NSNotificationCenter defaultCenter] removeObserver:self];//在视图控制器消除时，移除键盘事件的通知
    
    NSLog(@"STView relase -> %@",[self class]);
}
@end

