//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//
#import "STDefineUI.h"
#import "STUIView.h"
#import "STLayoutTracer.h"
#import "STCategory.h"
#import <objc/runtime.h>


@implementation UIView(ST)
static char namaChar='n';
static char isformUIChar='f';
static char preViewChar='p';
static char nextViewChar='e';


static char clickEventChar='e';


// Name
- (NSString*)name{
    return objc_getAssociatedObject(self, &namaChar);
}
- (UIView*)name:(NSString *)name
{
    return [self setName:name];
}
- (UIView*)setName:(NSString *)name{
    objc_setAssociatedObject(self, &namaChar, name,OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}
// Name
- (BOOL)isFormUI{
    return [objc_getAssociatedObject(self, &isformUIChar) boolValue];
}
- (UIView*)isFormUI:(BOOL)yesNo
{
    return [self setIsFormUI:yesNo];
}
- (UIView*)setIsFormUI:(BOOL)yesNo{
    objc_setAssociatedObject(self, &isformUIChar, [@(yesNo) stringValue],OBJC_ASSOCIATION_COPY_NONATOMIC);
    return self;
}
// Name
- (UIView*)preView{
    return (UIView*)objc_getAssociatedObject(self, &preViewChar);
}
- (UIView*)preView:(UIView*)view
{
    return [self setPreView:view];
}
- (UIView*)setPreView:(UIView*)view{
    objc_setAssociatedObject(self, &preViewChar, view,OBJC_ASSOCIATION_RETAIN);
    return self;
}
- (UIView*)nextView{
    return (UIView*)objc_getAssociatedObject(self, &nextViewChar);
}
- (UIView*)nextView:(UIView*)view
{
    return [self setNextView:view];
}
- (UIView*)setNextView:(UIView*)view{
    objc_setAssociatedObject(self, &nextViewChar, view,OBJC_ASSOCIATION_RETAIN);
    return self;
}




-(BOOL)isSTView
{
    return[self isKindOfClass:[STView class]];
}
-(BOOL)isOnSTView
{
    return self.superview!=nil && [self.superview isSTView];
}
-(STView*)STView
{
    if([self isSTView])
    {
        return (STView*)self;
    }
    else
    {
        UIView *view=[self superview];
        if(view!=nil)
        {
            return [view STView];
        }
        return nil;
    }
}
-(STController*)STController
{
    STView *stView=[self STView];
    if(stView!=nil){return stView.Controller;}
    return nil;
}
-(UIView*)stValue:(NSString*)value
{
    if([self isMemberOfClass:[UITextField class]])
    {
        ((UITextField*)self).text=value;
    }
    else if([self isMemberOfClass:[UITextView class]])
    {
        ((UITextView*)self).text=value;
    }
    else if([self isMemberOfClass:[UILabel class]])
    {
        ((UILabel*)self).text=value;
    }
    else if([self isMemberOfClass:[UIButton class]])
    {
        ((UIButton*)self).titleLabel.text=value;
    }
    //    else if([self isMemberOfClass:[UISegmentedControl class]])
    //    {
    //        ((UISegmentedControl*)self).selectedSegmentIndex=[value intValue];
    //    }
    else if([self isMemberOfClass:[UISlider class]])
    {
        ((UISlider*)self).value=[value floatValue];
    }
    else if([self isMemberOfClass:[UISwitch class]])
    {
        [((UISwitch*)self) setOn:[value boolValue]];
    }
    else if([self isMemberOfClass:[UIProgressView class]])
    {
        ((UIProgressView*)self).progress=[value floatValue];
    }
    else if([self isMemberOfClass:[UIStepper class]])
    {
        ((UIStepper*)self).value=[value doubleValue];
    }
    return self;
}
-(NSString*)stValue
{
    if([self isMemberOfClass:[UITextField class]])
    {
        return ((UITextField*)self).text;
    }
    else if([self isMemberOfClass:[UITextView class]])
    {
        return ((UITextView*)self).text;
    }
    else if([self isMemberOfClass:[UILabel class]])
    {
        return ((UILabel*)self).text;
    }
    else if([self isMemberOfClass:[UIButton class]])
    {
        return ((UIButton*)self).currentTitle;
    }
    else if([self isMemberOfClass:[UISegmentedControl class]])
    {
        return [@(((UISegmentedControl*)self).selectedSegmentIndex)stringValue];
    }
    else if([self isMemberOfClass:[UISlider class]])
    {
        return [@(((UISlider*)self).value)stringValue];
    }
    else if([self isMemberOfClass:[UISwitch class]])
    {
        return ((UISwitch*)self).isOn?@"1":@"0";
    }
    else if([self isMemberOfClass:[UIProgressView class]])
    {
        return [@(((UIProgressView*)self).progress) stringValue];
    }
    else if([self isMemberOfClass:[UIStepper class]])
    {
        return [@(((UIStepper*)self).value) stringValue];
    }
    return  nil;
}

#pragma mark addUIView
-(UIView *)lastSubView
{
    if(self.subviews.count>0)
    {
        return self.subviews[self.subviews.count-1];
    }
    return self;
}
-(UIView *)firstSubView
{
    if(self.subviews.count>0)
    {
        return self.subviews[0];
    }
    return self;
}

-(void)addView:(UIView *)view name:(NSString*)name{
    if(name!=nil)
    {
        view.Name=name;
        STView *stView=[self STView];
        if(stView!=nil)
        {
            [stView.UIList setObject:view forKey:name];
        }
    }
    if(self.subviews.count>0)//非第一个控件
    {
        UIView* lastView=[self lastSubView];
        lastView.NextView=view;
        view.PreView=lastView;
    }
    [self addSubview:view];
}
-(UIView*)addUIView:(NSString*)name
{
    UIView *ui=[[UIView alloc] initWithFrame:STEmptyRect];
    [self addView:ui name:name];
    return ui;
}
-(UIButton *)addSwitch:(NSString *)name
{
    UISwitch *ui=[[UISwitch alloc] initWithFrame:STEmptyRect];
    [self addView:ui name:name];
    [ui setIsFormUI:YES];
    return ui;
}
-(UIButton *)addStepper:(NSString *)name
{
    UIStepper *ui=[[UIStepper alloc] initWithFrame:STEmptyRect];
    [self addView:ui name:name];
    [ui setIsFormUI:YES];
    
    return ui;
}
-(UIButton *)addSlider:(NSString *)name
{
    UISlider *ui=[[UISlider alloc] initWithFrame:STEmptyRect];
    [self addView:ui name:name];
    [ui setIsFormUI:YES];
    return ui;
}
-(UIButton *)addProgress:(NSString *)name
{
    UIProgressView *ui=[[UIProgressView alloc] initWithFrame:STEmptyRect];
    [self addView:ui name:name];
    [ui setIsFormUI:YES];
    return ui;
}

-(UILabel*)addLabel:(NSString*)name text:(NSString*)text font:(NSInteger)px
{
    UILabel *ui = [[UILabel alloc] initWithFrame:STEmptyRect];
    if(text!=nil)
    {
        ui.text = text;
    }
    if(px>0)
    {
        [ui font:px];
    }
    [ui sizeToFit];
    [self addView:ui name:name];
    return ui;
}
-(UILabel*)addLabel:(NSString*)name text:(NSString*)text
{
    return [self addLabel:name text:text font:0];
}
-(UILabel*)addLabel:(NSString*)name
{
    return [self addLabel:name text:nil font:0];
}
-(UIImageView*)addImageView:(NSString*)name
{
    return [self addImageView:name imgName:nil xyFlag:XYNone];
}
-(UIImageView*)addImageView:(NSString*)name imgName:(NSString*)imgName
{
    return [self addImageView:name imgName:imgName xyFlag:XYNone];
}
-(UIImageView*)addImageView:(NSString*)name imgName:(NSString*)imgName xyFlag:(XYFlag)xyFlag
{
    CGRect frame=self.frame;
    NSInteger tagIndex=0;
    if([self isKindOfClass:[UIScrollView class]])//计算ImageView的位置和UIScrollView的contentSize
    {
        UIScrollView *scroll= (UIScrollView*)self;
        long count= self.subviews.count;//这么计算的话，ImageView必须先添加，然后才能添加其它控件。
        CGSize size=scroll.contentSize;
        if(xyFlag==X)
        {
            frame.origin.x=frame.size.width*(count);
            scroll.showsHorizontalScrollIndicator=NO;
            size.width=size.width+frame.size.width;
        }
        else if(xyFlag==Y)
        {
            scroll.showsVerticalScrollIndicator=NO;
            frame.origin.y=frame.size.height*(count);
            size.height=size.height+frame.size.height;
        }
        scroll.contentSize=size;
        tagIndex=scroll.subviews.count;
    }
    UIImageView *ui = [[UIImageView alloc] initWithFrame:frame];
    ui.tag=tagIndex;//设置tag，方便后续点击事件通过索引找到对应的UI
    if(imgName!=nil)
    {
        UIImage *image=[UIImage imageNamed:imgName];
        [ui setImage:image];
        [ui width:image.size.width*Xpx height:image.size.height*Ypx];
    }
    [self addView:ui name:name];
    return ui;
}
-(UITextField*)addTextField:(NSString*)name
{
    return [self addTextField:name placeholder:nil];
}
-(UITextField*)addTextField:(NSString*)name placeholder:(NSString*)placeholder
{
    UITextField *ui = [[UITextField alloc] initWithFrame:STEmptyRect];
    //    ui.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
    //    ui.layer.borderWidth = 1.0; // set borderWidth as you want.
    if(placeholder!=nil)
    {
        ui.placeholder=placeholder;
    }
    STView *view=[self STView];//追加到UITextFieldList中
    if(view!=nil)
    {
        [view.UITextList addObject:ui];
    }
    [ui setIsFormUI:YES];
    [self addView:ui name:name];
    return ui;
}
-(UITextView *)addTextView:(NSString *)name
{
    UITextView* ui=[[UITextView alloc] initWithFrame:STEmptyRect];
    STView *view=[self STView];//追加到UITextFieldList中
    //    ui.scrollEnabled = NO;
    //    ui.scrollsToTop = NO;
    ui.layer.cornerRadius = 4;
    ui.layer.borderWidth = 1;
    //当textview的字符串为0时发送（rerurn）键无效
    ui.enablesReturnKeyAutomatically = YES;
    ui.keyboardType = UIKeyboardTypeDefault;
    //键盘return样式变成发送
    ui.returnKeyType = UIReturnKeySend;
    
    ui.font =STFont(28);// [UIFont systemFontOfSize:14];
    //    ui.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
    //加下面一句话的目的是，是为了调整光标的位置，让光标出现在UITextView的正中间
    //ui.textContainerInset = UIEdgeInsetsMake(10,0, 0, 0);
    if(view!=nil)
    {
        [view.UITextList addObject:ui];
    }
    [ui isFormUI:YES];
    //[ui sizeToFit];
    [self addView:ui name:name];
    return ui;
    
}

-(UIButton*)addButton:(NSString*)name
{
    return [self addButton:name title:nil font:0 imgName:nil buttonType:0];
}
-(UIButton*)addButton:(NSString*)name imgName:(NSString*)imgName
{
    return [self addButton:name title:nil font:0 imgName:imgName buttonType:0];
}
-(UIButton*)addButton:(NSString*)name imgName:(NSString*)imgName buttonType:(UIButtonType)buttonType
{
    return [self addButton:name title:nil font:0 imgName:imgName buttonType:buttonType];
}
-(UIButton*)addButton:(NSString*)name title:(NSString*)title
{
    return [self addButton:name title:title font:0 imgName:nil buttonType:0];
}
-(UIButton*)addButton:(NSString*)name title:(NSString*)title font:(NSInteger)px
{
    return [self addButton:name title:title font:px imgName:nil buttonType:0];
}
-(UIButton*)addButton:(NSString*)name title:(NSString*)title font:(NSInteger)px buttonType:(UIButtonType)buttonType
{
    return [self addButton:name title:title font:px imgName:nil buttonType:buttonType];
}
//此方法不对外开放。
-(UIButton*)addButton:(NSString*)name title:(NSString*)title font:(NSInteger)px imgName:(NSString*)imgName buttonType:(UIButtonType)buttonType
{
    UIButton *ui=[UIButton buttonWithType:buttonType];
    if(title!=nil)
    {
        [ui setTitle:title forState:UIControlStateNormal];
        ui.titleLabel.textAlignment=NSTextAlignmentCenter;
        if(px>0)
        {
            [ui titleFont:px];
        }
        [ui.titleLabel sizeToFit];
        [ui width:ui.titleLabel.stWidth height:ui.titleLabel.stHeight];
    }
    if(imgName!=nil)
    {
        UIImage *img=[UIImage imageNamed:imgName];
        [ui setImage:img forState:UIControlStateNormal];
        [ui width:img.size.width*Xpx height:img.size.height*Ypx];
    }
    if(name!=nil)
    {
        SEL sel=[self getSel:name];
        if(sel!=nil)
        {
            [ui addTarget:self.STController action:sel forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [self addView:ui name:name];
    return ui;
}
-(UIView*)addLine:name color:(id)colorOrHex
{
    UIView *ui = [[UIView alloc] initWithFrame:STEmptyRect];
    [ui backgroundColor:colorOrHex];
    [self addView:ui name:name];
    return ui;
}

-(UIScrollView *)addScrollView:(NSString*)name
{
    UIScrollView *ui=[[UIScrollView alloc] initWithFrame:STFullRect];
    //设置边缘不弹跳
    ui.bounces = NO;
    //整页滚动
    ui.pagingEnabled = YES;
    //    ui.backgroundColor=[UIColor redColor];
    //ui.showsHorizontalScrollIndicator=NO;
    ui.delegate=(id)[self STController];
    [self addView:ui name:nil];
    return ui;
}
-(UIScrollView *)addScrollView:(NSString*)name  direction:(XYFlag)direction imgName:(NSString*)imgName,...NS_REQUIRES_NIL_TERMINATION
{
    UIScrollView *ui=[self addScrollView:name];
    if(imgName)
    {
        va_list args;
        va_start(args, imgName);
        [ui addImageView:nil imgName:imgName xyFlag:direction];//内部会重设contentSize属性
        NSString *otherImgName;
        
        while ((otherImgName = va_arg(args, NSString *))) {
            [ui addImageView:nil imgName:otherImgName xyFlag:direction];
        }
        va_end(args);
    }
    
    return ui;
}
-(UIView*)stretch
{
    return [self stretch:0 y:0];
}
-(UIView*)stretch:(CGFloat)x
{
    return [self stretch:x y:0];
}
-(UIView*)stretch:(CGFloat)x y:(CGFloat)y
{
    if([self isKindOfClass:[UIImageView class]])
    {
        UIImageView *me=(UIImageView*)self;
        if(me.image!=nil)
        {
            CGFloat left,right,top,bottom;
            if(x==0){left=right=me.image.size.width/2;}
            else
            {
                left=x*Xpt;
                right=me.image.size.width-left-2*Xpt;
            }
            if(y==0)
            {
                top=bottom=me.image.size.height/2;
            }
            else
            {
                top=y*Ypt;
                bottom=me.image.size.height-top-2*Ypt;
            }
            
            
            // 设置端盖的值
            UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
            // 拉伸图片
            me.image = [me.image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
        }
    }
    return self;
    
}

#pragma mark 扩展系统事件
-(UIView*)click:(NSString *)event
{
    if(![NSString isNilOrEmpty:event])
    {
        SEL sel=[self getSel:event];
        if(sel!=nil)
        {
            UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self.STController action:sel];
            if(self.name==nil)
            {
                self.name=event;
            }
            else if(![self.name isEqualToString:event])
            {
                click.accessibilityValue=event;//借一个属性用用。
            }
            [self addGestureRecognizer:click];
        }
    }
    return self;
}
-(UIView*)addClick:(onClick)block
{
    if(block!=nil)
    {
        self.userInteractionEnabled=YES;
        objc_setAssociatedObject(self, &clickEventChar, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
        UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickEvent:)];
        [self addGestureRecognizer:click];
    }
    return self;
}
-(void)onClickEvent:(UITapGestureRecognizer *)gesture {
    onClick clickEvent = (onClick)objc_getAssociatedObject(self, &clickEventChar);
    if (clickEvent) {
        clickEvent(gesture.view);
    }
}
-(SEL*)getSel:(NSString*)event{
    
    STController *controller=self.STController;
    if(controller==nil)
    {
        return nil;
    }
    SEL sel=nil;
    BOOL isEvent=NO;
    if(event!=nil)
    {
        sel=NSSelectorFromString(event);
        isEvent=[controller respondsToSelector:sel];
        if(!isEvent && ![event endWith:@"Click"] && ![event endWith:@":"] && ![event endWith:@"Controller"])
        {
            sel=NSSelectorFromString([event append:@"Click"]);
            isEvent=[controller respondsToSelector:sel];
            if(!isEvent)
            {
                sel=NSSelectorFromString([event append:@"Click:"]);
                isEvent=[controller respondsToSelector:sel];
                if(!isEvent)
                {
                    Class class= NSClassFromString([event append:@"Controller"]);
                    if(class!=nil)
                    {
                        sel=NSSelectorFromString(@"open:");
                        isEvent=YES;
                    }
                    
                }
            }
        }
    }
    if(isEvent)
    {
        self.userInteractionEnabled=YES;
        return sel;
    }
    return nil;
}
-(UIColor*)toColor:(id)hexOrColor
{
    if([hexOrColor isKindOfClass:([NSString class])])
    {
        return STColor(hexOrColor);
    }
    return (UIColor*)hexOrColor;
}
#pragma mark 扩展系统属性
-(UIView*)frame:(CGRect)frame
{
    frame.origin.x=roundf(frame.origin.x);
    frame.origin.y=roundf(frame.origin.y);
    frame.size.width=roundf(frame.size.width);
    frame.size.height=roundf(frame.size.height);
    self.frame=frame;
    return self;
}
-(UIView*)backgroundColor:(id)colorOrHex{
    self.backgroundColor=[self toColor:colorOrHex];
    return self;
}
-(UIView*)clipsToBounds:(BOOL)value
{
    self.clipsToBounds=value;
    return self;
}
@end
