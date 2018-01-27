//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
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
    self.backgroundColor=STDeviceColor;//卡的问题
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

//这个方法可以重写，如果想在这里搞点事情的话
-(void)loadUI{
    [self initUI];
    [self regEvent];
}
-(void)regEvent{
    if(self.isStartRotateEvent)
    {
        //手机旋转通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(rotate:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
}
-(void)rotate:(NSNotification *)notify
{
    [self endEditing:YES];
    if(!CGRectEqualToRect(self.frame, self.OriginFrame))//宽高反转
    {
        self.OriginFrame=self.frame;
        [self refleshLayout];
    }
}
//初始化[子类重写该方法]
-(void)initUI
{
    
}
-(void)initData
{
    //触发子控件事件
    for (NSString *key in self.UIList)
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
    for (NSString *key in self.UIList)
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
    NSLog(@"STView relase -> %@", [self class]);
}
@end

