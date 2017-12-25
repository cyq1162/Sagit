//
//  STUIViewAddUI.m
//  IT恋
//
//  Created by 陈裕强 on 2017/12/23.
//  Copyright © 2017年 . All rights reserved.
//

#import "STUIViewAddUI.h"
#import "STDefineUI.h"
#import "STUIView.h"
//#import "STUITableView.h"

@implementation UIView (STUIViewAddUI)


#pragma mark UI属性
-(UIView*)lastAddView
{
    UIView *lastAddView=[self baseView].keyValue[@"lastAddView"];
    
    if(lastAddView==nil)
    {
        lastAddView= [self lastSubView];
    }
    return lastAddView;
}
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
// Name
- (BOOL)isFormUI{
    NSString* value= [self key:@"isFormUI"];
    return value!=nil && [value isEqualToString:@"1"];
}
- (UIView*)isFormUI:(BOOL)yesNo
{
    return [self key:@"isFormUI" value:yesNo?@"1":@"0"];
}

// Name
- (UIView*)preView{
    return [self key:@"preView"];
}
- (UIView*)preView:(UIView*)view
{
    return [self key:@"preView" value:view];
}

- (UIView*)nextView{
    return [self key:@"nextView"];
}
- (UIView*)nextView:(UIView*)view
{
    return [self key:@"nextView" value:view];
}

#pragma mark addUI
-(UIView*)removeView:(UIView*)view{
    if(view!=nil)
    {
        if(view.preView!=nil)
        {
            [view.preView nextView:view.nextView];
        }
        if(view.nextView!=nil)
        {
            [view.nextView preView:view.preView];
        }
        [view removeFromSuperview];
        view=nil;//释放
    }
    return self;
}
-(UIView*)removeAllViews
{
    NSInteger count=self.subviews.count;
    if(count>0)
    {
        for (NSInteger i=count-1; i>=0; i--) {
            UIView *view=self.subviews[i];
            [view removeFromSuperview];
            view=nil;
        }
    }
    return self;
}
-(UIView*)addView:(UIView *)view name:(NSString*)name{
    if(name!=nil)
    {
        [view name:name];
        STView *stView=[self stView];
        if(stView!=nil)
        {
            [stView.UIList set:name value:view];
        }
    }
    if(self.subviews.count>0)//非第一个控件
    {
        UIView* lastView=[self lastSubView];
        [lastView nextView:view];
        [view preView:lastView];
    }
    [[self baseView].keyValue set:@"lastAddView" value:view];
    if([view isSTView])//子控件STView
    {
        view.stView.Controller=self.STController;
        [view.stView initView];//这里才初始化（可以让事件在指定Controller后再绑定）
    }
    [self addSubview:view];
    return view;
}
-(UIView*)addUIView:(NSString*)name
{
    UIView *ui=[[UIView alloc] initWithFrame:STEmptyRect];
    [self addView:ui name:name];
    return ui;
}
-(UISwitch *)addSwitch:(NSString *)name
{
    UISwitch *ui=[[UISwitch alloc] initWithFrame:STEmptyRect];
    [self addView:ui name:name];
    [ui isFormUI:YES];
    return ui;
}
-(UIStepper *)addStepper:(NSString *)name
{
    UIStepper *ui=[[UIStepper alloc] initWithFrame:STEmptyRect];
    [self addView:ui name:name];
    [ui isFormUI:YES];
    
    return ui;
}
-(UISlider *)addSlider:(NSString *)name
{
    UISlider *ui=[[UISlider alloc] initWithFrame:STEmptyRect];
    [self addView:ui name:name];
    [ui isFormUI:YES];
    return ui;
}
-(UIProgressView *)addProgress:(NSString *)name
{
    UIProgressView *ui=[[UIProgressView alloc] initWithFrame:STEmptyRect];
    [self addView:ui name:name];
    [ui isFormUI:YES];
    return ui;
}

-(UILabel*)addLabel:(NSString*)name text:(NSString*)text font:(NSInteger)px color:(id)colorOrHex
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
    if(colorOrHex!=nil)
    {
        [ui textColor:colorOrHex];
    }
    [ui sizeToFit];
    [self addView:ui name:name];
    return ui;
}
-(UILabel*)addLabel:(NSString*)name text:(NSString*)text font:(NSInteger)px
{
    return [self addLabel:name text:text font:px color:nil];
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
    STView *view=[self stView];//追加到UITextFieldList中
    if(view!=nil)
    {
        [view.UITextList addObject:ui];
    }
    [ui isFormUI:YES];
    [self addView:ui name:name];
    return ui;
}
-(UITextView *)addTextView:(NSString *)name
{
    UITextView* ui=[[UITextView alloc] initWithFrame:STEmptyRect];
    STView *view=[self stView];//追加到UITextFieldList中
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
    else if(imgName!=nil)
    {
        UIImage *img=[self toImage:imgName];
        [ui setImage:img forState:UIControlStateNormal];
        [ui width:img.size.width*Xpx height:img.size.height*Ypx];
    }
    [self addView:ui name:name];
    if(name!=nil)
    {
        [ui click:name];//加入控件后，才找的到STController
    }
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
    [self addView:ui name:name];
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
-(UITableView*)addTableView:(NSString*)name
{
    return [self addTableView:name style:UITableViewStylePlain];
}
-(UITableView*)addTableView:(NSString*)name style:(UITableViewStyle)style
{
    UITableView *ui=[[UITableView alloc] initWithFrame:STFullRect style:style];
    ui.delegate=(id)self.STController;
    ui.dataSource=(id)self.STController;
    [self addView:ui name:name];
    return ui;
}
//-(STTable*)addTable:(NSString*)name
//{
//    return [self addTable:name style:UITableViewStylePlain];
//}
//-(STTable*)addTable:(NSString*)name style:(UITableViewStyle)style
//{
//    STTable *ui=[[STTable alloc] initWithFrame:STFullRect style:style];
//    ui.delegate=(id)self.STController;
//    ui.dataSource=(id)self.STController;
//   // self register
//    [ui registerClass:[STTableCell class] forCellReuseIdentifier:@"STTableCell"];
//    [self addView:ui name:name];
//    return ui;
//}
@end
