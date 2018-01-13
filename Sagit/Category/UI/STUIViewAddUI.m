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
#import "STUIViewAutoLayout.h"
#import "STUIViewEvent.h"
#import "STDictionary.h"

#import "STUILabel.h"
#import "STUIButton.h"
#import "STUIImageView.h"
#import "STUITextView.h"
#import "STUITextField.h"
@implementation UIView (STUIViewAddUI)


#pragma mark UI属性
-(UIView*)lastAddView
{
    UIView *lastAddView=[self.baseView key:@"lastAddView"];
    
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
-(NSMapTable *)UIList
{
    NSMapTable *dic=[self key:@"UIList"];
    if(dic==nil)
    {
        dic=[NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsStrongMemory];
        [self key:@"UIList" value:dic];
    }
    return dic;
}
// Name
- (UIView*)preView{
    return [self key:@"preView"];
}
- (UIView*)preView:(UIView*)view
{
    return [self key:@"preView" valueWeak:view];
}

- (UIView*)nextView{
    return [self key:@"nextView"];
}
- (UIView*)nextView:(UIView*)view
{
    return [self key:@"nextView" valueWeak:view];
}
-(UIView *)find:(id)name
{
    if(name==nil){return nil;}
    if([name isKindOfClass:[NSString class]])
    {
        return [self.UIList get:name];
    }
    else if([name isKindOfClass:[UIView class]])
    {
        return name;
    }
    return nil;
}
-(UIView *)firstView:(NSString *)className
{
    for (NSString *key in self.UIList)
    {
        UIView *view=[self.UIList get:key];
        if([NSStringFromClass([view class]) isEqualToString:className])
        {
            return view;
        }
    }
    return nil;
}
#pragma mark addUI
-(void)removeSelf
{
    @try
    {
        if(self.preView!=nil)
        {
            [self.preView nextView:self.nextView];
        }
        if(self.nextView!=nil)
        {
            [self.nextView preView:self.preView];
        }
       // [self removeAllSubViews];
        [self dispose];
        [self removeFromSuperview];
    }
    @catch(NSException*err){}
}
-(UIView*)removeAllSubViews
{
    NSInteger count=self.subviews.count;
    if(count>0)
    {
        @try
        {
            for (NSInteger i=count-1; i>=0; i--)
            {
                UIView *view=self.subviews[i];
                if(view!=nil)
                {
                   // [view removeAllSubViews];
                    [view dispose];//disponse包含removeAllSubViews
                    [view removeFromSuperview];
                    view=nil;
                }
            }
        }
        @catch(NSException* err){}
    }
    return self;
}
-(UIView*)addView:(UIView *)view name:(NSString*)name{
    if(name!=nil)
    {
        [view name:name];
        [self.baseView.UIList set:name value:view];
    }
    if(self.subviews.count>0)//非第一个控件
    {
        UIView* lastView=[self lastSubView];
        [lastView nextView:view];
        [view preView:lastView];
    }
    [self.baseView key:@"lastAddView" valueWeak:view];
    if([view isSTView])//子控件STView
    {
        view.stView.Controller=self.stController;
        [view.stView loadUI];//这里才初始化（可以让事件在指定Controller后再绑定）
    }
    [self addSubview:view];
    return view;
}
-(STView*)addSTView:(NSString*)name
{
    Class viewClass=NSClassFromString(name);
    if(viewClass)
    {
        STView *ui=[viewClass new];
        [self addView:ui name:name];
        return ui;
    }
    return nil;
}
-(UIView*)addUIView:(NSString*)name
{
    UIView *ui=[[UIView alloc] initWithFrame:STEmptyRect];
    [self addView:ui name:name];
    return ui;
}
-(UISwitch *)addSwitch:(NSString *)name
{
    return [self addSwitch:name on:YES onColor:nil];
}
-(UISwitch *)addSwitch:(NSString *)name on:(BOOL)yesNo
{
    return [self addSwitch:name on:yesNo onColor:nil];
}
-(UISwitch *)addSwitch:(NSString *)name on:(BOOL)yesNo onColor:(id)colorOrHex
{
    UISwitch *ui=[[UISwitch alloc] initWithFrame:STEmptyRect];
    [ui setOn:yesNo];
    ui.onTintColor=[self toColor:colorOrHex];
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

-(UILabel*)addLabel:(NSString*)name text:(NSString*)text font:(NSInteger)px color:(id)colorOrHex row:(NSInteger)num
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
    [ui textAlignment:NSTextAlignmentLeft];
    [ui numberOfLines:num];
    [ui sizeToFit];
    [self addView:ui name:name];
    return ui;
}
-(UILabel*)addLabel:(NSString*)name text:(NSString*)text font:(NSInteger)px color:(id)colorOrHex
{
    return [self addLabel:name text:text font:px color:colorOrHex row:1];
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
    return [self addImageView:name img:STDefaultForImageInitName direction:XY];
}
-(UIImageView*)addImageView:(NSString*)name img:(id)imgOrName
{
    return [self addImageView:name img:imgOrName direction:XY];
}
-(UIImageView*)addImageView:(NSString*)name img:(id)imgOrName direction:(XYFlag)direction
{
    CGRect frame=self.frame;
    NSInteger tagIndex=0;
    if([self isKindOfClass:[UIScrollView class]])//计算ImageView的位置和UIScrollView的contentSize
    {
        UIScrollView *scroll= (UIScrollView*)self;
        long count= self.subviews.count;//这么计算的话，ImageView必须先添加，然后才能添加其它控件。
        CGSize size=scroll.contentSize;
        if(direction==X)
        {
            frame.origin.x=frame.size.width*(count);
            scroll.showsHorizontalScrollIndicator=NO;
            size.width=size.width+frame.size.width;
        }
        else if(direction==Y)
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
    if(imgOrName)
    {
        [ui image:imgOrName];
        [ui width:ui.image.size.width*Xpx height:ui.image.size.height*Ypx];
    }
    [self addView:ui name:name];
    return ui;
}
-(UITextField*)addTextField:(NSString*)name
{
    return [self addTextField:name placeholder:nil font:0 color:nil];
}
-(UITextField*)addTextField:(NSString*)name placeholder:(NSString*)placeholder
{
    return [self addTextField:name placeholder:placeholder font:0 color:nil];
}
-(UITextField*)addTextField:(NSString*)name placeholder:(NSString*)placeholder font:(NSInteger)px
{
    return [self addTextField:name placeholder:placeholder font:px color:nil];
}
-(UITextField*)addTextField:(NSString*)name placeholder:(NSString*)placeholder font:(NSInteger)px color:(id)colorOrHex
{
    UITextField *ui = [[UITextField alloc] initWithFrame:STEmptyRect];
    if(px>0)
    {
        [ui font:px];
    }
    if(placeholder!=nil)
    {
        [ui placeholder:placeholder];
    }
    if(colorOrHex)
    {
        [ui textColor:colorOrHex];
    }
    STView *view=[self stView];
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
    return [self addTextView:name placeholder:nil font:0 color:nil];
}
-(UITextView *)addTextView:(NSString *)name placeholder:(NSString*)placeholder
{
    return [self addTextView:name placeholder:placeholder font:0 color:nil];
}
-(UITextView *)addTextView:(NSString *)name placeholder:(NSString*)placeholder font:(NSInteger)px
{
    return [self addTextView:name placeholder:placeholder font:px color:nil];
}
-(UITextView *)addTextView:(NSString *)name placeholder:(NSString*)placeholder font:(NSInteger)px color:(id)colorOrHex
{
    UITextView* ui=[[UITextView alloc] initWithFrame:STEmptyRect];
    if(px>0)
    {
        [ui font:px];
    }
    if(placeholder!=nil)
    {
        [ui placeholder:placeholder];
    }
    if(colorOrHex)
    {
        [ui textColor:colorOrHex];
    }
    STView *view=[self stView];
    if(view!=nil)
    {
        [view.UITextList addObject:ui];
    }
//    ui.layer.cornerRadius = 4;
//    ui.layer.borderWidth = 1;
    //当textview的字符串为0时发送（rerurn）键无效
//    ui.enablesReturnKeyAutomatically = YES;
//    ui.keyboardType = UIKeyboardTypeDefault;

    //    ui.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
    //加下面一句话的目的是，是为了调整光标的位置，让光标出现在UITextView的正中间
    //ui.textContainerInset = UIEdgeInsetsMake(10,0, 0, 0);
    [ui isFormUI:YES];
    [self addView:ui name:name];
    return ui;
    
}

-(UIButton*)addButton:(NSString*)name
{
    return [self addButton:name title:nil font:0 color:nil img:nil buttonType:0];
}
-(UIButton *)addButton:(NSString *)name buttonType:(UIButtonType)buttonType
{
    return [self addButton:name title:nil font:0 color:nil img:nil buttonType:buttonType];
}
-(UIButton*)addButton:(NSString*)name img:(id)imgOrName
{
    return [self addButton:name title:nil font:0 color:nil img:imgOrName buttonType:0];
}
-(UIButton*)addButton:(NSString*)name title:(NSString*)title
{
    return [self addButton:name title:title font:0 color:nil img:nil buttonType:0];
}
-(UIButton*)addButton:(NSString*)name title:(NSString*)title font:(NSInteger)px
{
   return [self addButton:name title:title font:px color:nil img:nil buttonType:0];
}
-(UIButton*)addButton:(NSString*)name title:(NSString*)title font:(NSInteger)px color:(id)colorOrHex
{
    return [self addButton:name title:title font:px color:colorOrHex img:nil buttonType:0];
}
-(UIButton*)addButton:(NSString*)name title:(NSString*)title font:(NSInteger)px color:(id)colorOrHex img:(id)imgOrName;
{
    return [self addButton:name title:title font:px color:colorOrHex img:imgOrName buttonType:0];
}

//此方法不对外开放。
-(UIButton*)addButton:(NSString*)name title:(NSString*)title font:(NSInteger)px  color:(id)colorOrHex img:(id)imgOrName buttonType:(UIButtonType)buttonType
{
    UIButton *ui=[UIButton buttonWithType:buttonType];
    if(px>0)
    {
        [ui titleFont:px];
    }
    if(title)
    {
        [ui title:title];
        [ui.titleLabel textAlignment:NSTextAlignmentCenter];
        //[ui width:ui.titleLabel.stWidth height:ui.titleLabel.stHeight];
    }
    if(imgOrName)
    {
        [ui image:imgOrName];
//        if(!title)
//        {
//            [ui width:ui.imageView.image.size.width*Xpx height:ui.imageView.image.size.height*Ypx];
//        }
//        else
//        {
//            [ui stWidthToFit];
//        }
    }
    
    if(colorOrHex)
    {
        [ui titleColor:colorOrHex];
    }
    [ui sizeToFit];
//
//    if(title!=nil)
//    {
//        [ui setTitle:title forState:UIControlStateNormal];
//        ui.titleLabel.textAlignment=NSTextAlignmentCenter;
//        if(px>0)
//        {
//            [ui titleFont:px];
//        }
//        [ui.titleLabel sizeToFit];
//        [ui width:ui.titleLabel.stWidth height:ui.titleLabel.stHeight];
//    }
//    else if(imgName!=nil)
//    {
//        UIImage *img=[self toImage:imgName];
//        [ui setImage:img forState:UIControlStateNormal];
//        [ui width:img.size.width*Xpx height:img.size.height*Ypx];
//    }
    [self addView:ui name:name];
    if(name!=nil)
    {
        [ui addClick:name];//加入控件后，才找的到STController
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
    ui.delegate=(id)self.stController;
    [self addView:ui name:name];
    return ui;
}
-(UIScrollView *)addScrollView:(NSString*)name  direction:(XYFlag)direction img:(id)imgOrName,...NS_REQUIRES_NIL_TERMINATION
{
    UIScrollView *ui=[self addScrollView:name];
    if(imgOrName)
    {
        va_list args;
        va_start(args, imgOrName);
        [ui addImageView:nil img:imgOrName direction:direction];//内部会重设contentSize属性
        NSString *otherImgName;
        
        while ((otherImgName = va_arg(args, NSString *))) {
            [ui addImageView:nil img:otherImgName direction:direction];
        }
        va_end(args);
    }
    
    return ui;
}
-(UIPickerView *)addPickerView:(NSString *)name
{
    UIPickerView *ui=[[UIPickerView alloc]initWithFrame:STEmptyRect];
    [self addView:ui name:name];
    return ui;
}
-(UITableView*)addTableView:(NSString*)name
{
    return [self addTableView:name style:UITableViewStylePlain];
}
-(UITableView*)addTableView:(NSString*)name style:(UITableViewStyle)style
{
    if(name==nil){name=@"stFirstTable";}//避免STFirstTable找不到对象。
    UITableView *ui=[[UITableView alloc] initWithFrame:STFullRect style:style];
    ui.delegate=(id)self.stController;
    ui.dataSource=(id)self.stController;
    ui.tableFooterView=[UIView new];//去掉空白行。
    [self addView:ui name:name];
    return ui;
}
-(UICollectionView*)addCollectionView:(NSString*)name
{
    return [self addCollectionView:name layout:[UICollectionViewFlowLayout new]];
}
-(UICollectionView*)addCollectionView:(NSString*)name layout:(UICollectionViewLayout*)layout
{
    UICollectionView *ui=[[UICollectionView alloc] initWithFrame:STFullRect collectionViewLayout:layout];
    [ui registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    ui.delegate=(id)self.stController;
    ui.dataSource=(id)self.stController;
    [self addView:ui name:name];
    
    return ui;
}
@end
