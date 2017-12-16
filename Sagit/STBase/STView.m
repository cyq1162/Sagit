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

//
-(void)initView{
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
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextChange:) name:UITextViewTextDidChangeNotification object:ui];
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
//UITextView
-(void)onTextChange:(NSNotification *)notify
{
    UITextView *textView=notify.object;
    
    //if(textView.text.length==0){return;}
    CGRect frame=textView.frame;
    if(CGRectEqualToRect(textView.OriginFrame, CGRectZero))
    {
        textView.OriginFrame=textView.frame;
        textView.tag=textView.contentSize.height-frame.size.height;//用于ContentSize的高和文本框的差值
        if(textView.maxHeight==0)
        {
            textView.MaxHeight=floorf(textView.font.lineHeight)*6;
        }
        return;
    }
    if(textView.maxHeight<textView.frame.size.height){return;}//初始比最大行高还大，则无需要调整
    CGFloat addHeight=textView.contentSize.height-frame.size.height-textView.tag;
    if(addHeight!=0)//差值发生变化，
    {
        //修正差值，不能大于最大值，不能小于初始值
        if(addHeight>0 && frame.size.height+addHeight>textView.maxHeight)
        {
            addHeight=textView.maxHeight-frame.size.height;
        }
        else if(addHeight<0 && frame.size.height+addHeight<textView.OriginFrame.size.height)
        {
            addHeight=textView.OriginFrame.size.height-frame.size.height;//负数
        }
        if(addHeight==0){return;}
        frame.size.height+=addHeight;
        if([textView isOnSTView])
        {
            if(frame.origin.y-addHeight>64)//不能超过导航栏和状态栏之上
            {
                frame.origin.y=frame.origin.y-addHeight;
            }
        }
        else //子控件里
        {
            
            CGRect superFrame=textView.superview.frame;
            superFrame.origin.y-=addHeight;
            if(addHeight>0 && superFrame.origin.y<0)//上面到顶，无法上移，尝试下移
            {
                if([textView.LayoutTracer has:@"onBottom"] || frame.origin.y+frame.size.height>superFrame.size.height)//下面到顶，无法下移
                {
                    return;
                }
                //往下增加高度
                superFrame.origin.y+=addHeight;//还原坐标
            }
            superFrame.size.height+=addHeight;
            textView.superview.frame=superFrame;
        }
        
        NSString *text=textView.text;
        textView.text=nil;
        [UIView animateWithDuration:0.5 animations:^{
            textView.frame = frame;
        } completion:nil];
        textView.text=text;
        [self refleshLayout:NO];

    }

}

-(void)onTextClick:(NSNotification*)notify{
    
    [self resignKeyboard];//取消其它可能的键盘事件
    self.editingTextUI =notify.object;//设置被点击的对象
    [self moveTextView];
}
//初始化[子类重写该方法]
-(void)initUI{}

- (instancetype)initWithController:(STController*)controller
{
    self = [super init];
    if (self && controller) {
        self.frame = controller.view.bounds;//事件问题
        self.OriginFrame=self.frame;
        self.backgroundColor=[UIColor whiteColor];//卡的问题
        
        self.UIList=[NSMutableDictionary new];
        self.UITextList=[NSMutableArray new];
        
        controller.UIList=self.UIList;
        self.Controller=controller;
    }
    return [self init];
}
-(void)loadData:(NSDictionary*)data
{
    for (NSString*key in data) {
        UIView *ui=self.UIList[key];
        if(ui!=nil)
        {
            [ui stValue:data[key]];
        }
    }
}
-(NSMutableDictionary *)formData
{
    return [self formData:nil];
}
//获取当前窗体的表单数据
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

