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
//#import <objc/runtime.h>

@interface STView()

//当前编辑的文本框 
@property (nonatomic,retain) UIView *editingTextUI;
@property (nonatomic,assign) CGFloat keyboardHeight;
@property (nonatomic,retain) NSLock *lock;
@end
@implementation STView

//这个方法可以重写，如果想在这里搞点事情的话
-(void)loadUI{
    [self initUI];
    [self regEvent];
}
-(void)regEvent{
    if(self.lock==nil){self.lock=[NSLock new];}
    if(self.UITextList!=nil && self.isStartTextChageEvent)
    {
        //注册键盘回收事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboard)];
        [self addGestureRecognizer:tap];
        for (id ui in self.UITextList)
        {
            if([ui isKindOfClass:[UITextView class]])
            {
                //文本修改事件
//                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextChange:) name:UITextViewTextDidChangeNotification object:ui];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextClick:) name:UITextViewTextDidBeginEditingNotification object:ui];
            }
            else
            {
                //文本点击事件
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextClick:) name:UITextFieldTextDidBeginEditingNotification object:ui];
            }
        }
        //注册键盘出现与隐藏时候的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
    }
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
    [self resignKeyboard];//键盘会导致xy坐标问题，要先还原，取消键盘
    if(!CGRectEqualToRect(self.frame, self.OriginFrame))//宽高反转
    {
        [self.lock lock];
        self.OriginFrame=self.frame;
        self.keyboardHeight=0;//高度变更了。
        [self refleshLayout];
        [self.lock unlock];
    }
}
-(void)setKeyboardHeightValue:(NSNotification*)notify
{
    if(self.keyboardHeight<=0)
    {
        NSDictionary *info = [notify userInfo];
        CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];//键盘的frame
        self.keyboardHeight=keyboardRect.size.height;
    }
}
-(void)moveTextView
{
    //NSLog(@"frame:%@",NSStringFromCGRect( self.OriginFrame ));
    
    if(self.keyboardHeight>0 && self.editingTextUI!=nil && [self.editingTextUI isFirstResponder]
       && CGPointEqualToPoint(CGPointZero, self.OriginFrame.origin))
    {
        
        if(self.editingTextUI.stAbsY*Ypt+self.editingTextUI.frame.size.height+self.keyboardHeight>STScreeHeightPt)
        {
            CGRect frame=self.frame;
            frame.origin.y-=self.keyboardHeight;
            [self moveTo:frame];
        }
    }
}
-(void)keyboardShow:(NSNotification *)notify{
    [self setKeyboardHeightValue:notify];
    [self moveTextView];
    
}
-(void)resignKeyboard{
    if(self.editingTextUI!=nil)
    {
        if([self.editingTextUI isFirstResponder])
        {
            [self.editingTextUI resignFirstResponder];
        }
        [self backToOrigin];
        self.editingTextUI=nil;
    }
}


-(void)onTextClick:(NSNotification*)notify{
    
    [self resignKeyboard];//取消其它可能的键盘事件
    self.editingTextUI =notify.object;//设置被点击的对象
    [self moveTextView];
}
//初始化[子类重写该方法]
-(void)initUI
{
    //触发子控件事件(该事件由UIView的AddSTView内部触发)
    //    for (NSString *key in self.UIList)
    //    {
    //        if([self.UIList[key] isKindOfClass:[STView class]])
    //        {
    //            [self.UIList[key] initUI];
    //        }
    //    }
}
-(void)initData
{
    //触发子控件事件
    for (NSString *key in self.UIList)
    {
        if([self.UIList[key] isKindOfClass:[STView class]])
        {
            [self.UIList[key] initData];
        }
    }
}
-(void)reloadData
{
    //触发子控件事件
    for (NSString *key in self.UIList)
    {
        if([self.UIList[key] isKindOfClass:[STView class]])
        {
            [self.UIList[key] reloadData];
        }
    }
}

-(instancetype)init
{
    self = [super init];
    self.frame=STFullRect;
    self.backgroundColor=[UIColor whiteColor];//卡的问题
    self.OriginFrame=self.frame;
    return self;
}
- (instancetype)initWithController:(STController*)controller
{
    self=[self init];
    if (controller) {
        //self.frame = controller.view.bounds;//事件问题
        self.Controller=controller;
    }
    return self;
}
////延时加载
//-(NSMutableDictionary*)UIList
//{
//    return [super.baseView key:@"UIList"];
//}
-(NSMutableArray*)UITextList
{
    if(_UITextList==nil)
    {
        _UITextList=[NSMutableArray new];
    }
    return _UITextList;
}
-(void)setToAll:(id)data
{
    [self setToAll:data toChild:NO];
}
-(void)setToAll:(id)data toChild:(BOOL)toChild
{
    NSDictionary *dic;
    if([data isKindOfClass:[NSDictionary class]])
    {
        dic=data;
    }
    else if([data isKindOfClass:[NSString class]])
    {
        dic=[NSDictionary dictionaryWithJson:data];
    }
    else if([data isKindOfClass:[STModelBase class]])
    {
        dic=[data toDictionary];
    }
    if(dic==nil){return;}
    for (NSString*key in dic) {
        
        UIView *ui=self.UIList[key];
        if(ui!=nil)
        {
            id value=dic[key];
            
            if(value!=nil && [value isKindOfClass:[NSNumber class]])
            {
                value=[((NSNumber*)value) stringValue];
            }
            [ui stValue:value];
        }
    }
    if(toChild)
    {
        //触发子控件事件
        for (NSString *key in self.UIList)
        {
            if([self.UIList[key] isKindOfClass:[STView class]])
            {
                [self.UIList[key] setToAll:dic toChild:toChild];
            }
        }
    }
}
-(NSMutableDictionary *)formData
{
    return [self formData:nil];
}
//!获取当前窗体的表单数据
-(NSMutableDictionary *)formData:(id)superView
{
    NSMutableDictionary *formData=[NSMutableDictionary new];
    for (NSString*key in self.UIList) {
        UIView *ui=self.UIList[key];
        if([ui isFormUI] && (superView==nil || ui.superview==superView))
        {
            [formData setObject:[ui stValue] forKey:key];
        }
    }
    return formData;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];//在视图控制器消除时，移除键盘事件的通知
}
@end

