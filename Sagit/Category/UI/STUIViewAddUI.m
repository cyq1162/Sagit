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
-(STMapTable *)UIList
{
    UIView *baseView=self.baseView;
    if(baseView==nil){return nil;}
    STMapTable *dic=[baseView key:@"UIList"];
    if(dic==nil)
    {
        dic=[STMapTable new];
        [baseView key:@"UIList" value:dic];
//        NSArray<NSString*> * dicKeys=[NSArray<NSString*> new];
//        [baseView key:@"UIListKeys" value:dicKeys];
    }
    return dic;
}
//-(NSArray<NSString*>*)UIListKeys
//{
//    UIView *baseView=self.baseView;
//    if(baseView==nil){return nil;}
//    return [baseView key:@"UIListKeys"];
//}
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
    for (NSString *key in self.UIList.keys)
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
    if(![NSString isNilOrEmpty:text])
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
    if(num!=1)
    {
        [ui numberOfLines:num];
    }
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
    return [self addImageView:name img:STDefaultForImageView direction:XY];
}
-(UIImageView*)addImageView:(NSString*)name img:(id)imgOrName
{
    return [self addImageView:name img:imgOrName direction:XY];
}
-(UIImageView*)addImageView:(NSString*)name img:(id)imgOrName direction:(XYFlag)direction
{
    CGRect frame=self.frame;
    NSInteger tagIndex=0;
    BOOL isScrollView=[self isKindOfClass:[UIScrollView class]];
    UIScrollView *scroll=nil;
    if(isScrollView)//计算ImageView的位置和UIScrollView的contentSize
    {
        scroll= (UIScrollView*)self;
        tagIndex=scroll.subviews.count;
        [scroll addPageSizeContent:1];
        if(direction==X)
        {
            frame.origin.x=frame.size.width*(scroll.subviews.count);
        }
        else if(direction==Y)
        {
            frame.origin.y=frame.size.height*(scroll.subviews.count);
        }
    }
    UIImageView *ui =nil;
    if([imgOrName isKindOfClass:[UIImageView class]])
    {
        ui=(UIImageView*)imgOrName;
    }
    else
    {
        ui=[[UIImageView alloc] initWithFrame:frame];
        BOOL isUrl=NO;
        if([imgOrName isKindOfClass:[NSString class]])
        {
            NSString *name=(NSString*)imgOrName;
            if([name startWith:@"http://"] || [name startWith:@"https://"])
            {
                [ui onAfter:^(NSString *eventType, UIImageView* para) {
                   [para reSize:ui.frame.size];
                    if(isScrollView)
                    {
                        CGSize s=ui.image.size;
                        if(s.width>=frame.size.width){s.width=frame.size.width;}
                        else
                        {
                            //居中处理
                            [ui x:ui.stX+((frame.size.width-s.width)/2)*Xpx];
                        }
                        if(s.height>=frame.size.height){s.height=frame.size.height;}
                        else
                        {
                            //居中处理
                            [ui y:ui.stY+((frame.size.height-s.height)/2)*Ypx];
                        }
                    }
                    
                }];
                [ui url:name];
                isUrl=YES;
            }
        }
        if(!isUrl && imgOrName)
        {
            [ui image:imgOrName];
            if(isScrollView)
            {
                if(scroll.isImageFull)
                {
                    [ui width:self.frame.size.width*Xpx height:self.frame.size.height*Ypx];
                }
                else
                {
                        CGSize s=ui.image.size;
                        if(s.width>=frame.size.width){s.width=frame.size.width;}
                        else
                        {
                            //居中处理
                            [ui x:ui.stX+((frame.size.width-s.width)/2)*Xpx];
                        }
                        if(s.height>=frame.size.height){s.height=frame.size.height;}
                        else
                        {
                            //居中处理
                            [ui y:ui.stY+((frame.size.height-s.height)/2)*Ypx];
                        }
                }
            }
            else
            {
                [ui reSize:ui.image.size];
            }
        }
    }
    ui.tag=tagIndex;//设置tag，方便后续点击事件通过索引找到对应的UI
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
    ui.delegate=(id)ui;
    if(px>0)
    {
        [ui font:px];
    }
    if(![NSString isNilOrEmpty:placeholder])
    {
        [ui placeholder:placeholder];
    }
    if(colorOrHex)
    {
        [ui textColor:colorOrHex];
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
    ui.delegate=(id)ui;
    if(px>0)
    {
        [ui font:px];
    }
    if(![NSString isNilOrEmpty:placeholder])
    {
        [ui placeholder:placeholder];
    }
    if(colorOrHex)
    {
        [ui textColor:colorOrHex];
    }
 //   STView *view=[self stView];
//    if(view!=nil)
//    {
//        [view.UITextList addObject:ui];
//    }
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
    return [self addButton:name title:nil font:0 color:nil img:nil bgImg:nil buttonType:0];
}
-(UIButton *)addButton:(NSString *)name buttonType:(UIButtonType)buttonType
{
    return [self addButton:name title:nil font:0 color:nil img:nil bgImg:nil buttonType:buttonType];
}
-(UIButton*)addButton:(NSString*)name img:(id)imgOrName
{
    return [self addButton:name title:nil font:0 color:nil img:imgOrName bgImg:nil buttonType:0];
}
-(UIButton*)addButton:(NSString*)name title:(NSString*)title
{
    return [self addButton:name title:title font:0 color:nil img:nil bgImg:nil buttonType:0];
}
-(UIButton*)addButton:(NSString*)name title:(NSString*)title font:(NSInteger)px
{
   return [self addButton:name title:title font:px color:nil img:nil bgImg:nil buttonType:0];
}
-(UIButton*)addButton:(NSString*)name title:(NSString*)title font:(NSInteger)px color:(id)colorOrHex
{
    return [self addButton:name title:title font:px color:colorOrHex img:nil bgImg:nil buttonType:0];
}
-(UIButton*)addButton:(NSString*)name title:(NSString*)title font:(NSInteger)px color:(id)colorOrHex img:(id)imgOrName
{
    return [self addButton:name title:title font:px color:colorOrHex img:imgOrName bgImg:nil buttonType:0];
}
-(UIButton*)addButton:(NSString*)name title:(NSString*)title font:(NSInteger)px color:(id)colorOrHex bgImg:(id)bgImgOrName
{
    return [self addButton:name title:title font:px color:colorOrHex img:nil bgImg:bgImgOrName buttonType:0];
}
//此方法不对外开放。
-(UIButton*)addButton:(NSString*)name title:(NSString*)title font:(NSInteger)px  color:(id)colorOrHex img:(id)imgOrName bgImg:(id)bgImgOrName buttonType:(UIButtonType)buttonType
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
    else if(bgImgOrName)
    {
        [ui backgroundImage:bgImgOrName];
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
    return [self addScrollView:name direction:X isImageFull:NO];
}
-(UIScrollView *)addScrollView:(NSString*)name direction:(XYFlag)direction
{
    return [self addScrollView:name direction:direction isImageFull:NO];
}
-(UIScrollView *)addScrollView:(NSString*)name direction:(XYFlag)direction isImageFull:(BOOL)isImageFull
{
    UIScrollView *ui=[[UIScrollView alloc] initWithFrame:STFullRect];
    //ui.contentSize=STFullSize;
    //设置边缘不弹跳
    ui.bounces = NO;
    //整页滚动
    ui.pagingEnabled = YES;
    ui.showsHorizontalScrollIndicator=NO;//需要先关掉，因为系统在后面会自动追加滚动条图片
    ui.showsVerticalScrollIndicator=NO;
    ui.direction=direction;
    ui.isImageFull=isImageFull;
    ui.delegate=(id)ui;
    if(direction!=Y && self.stController && self.stController.navigationController)
    {
        //禁用
        [ui.panGestureRecognizer  requireGestureRecognizerToFail:self.stController.navigationController.interactivePopGestureRecognizer];
    }
    [self addView:ui name:name];
    return ui;
}
//-(UIScrollView *)addScrollView:(NSString*)name  direction:(XYFlag)direction imgArray:(NSArray*)imgArray
//{
//    UIScrollView *ui=[self addScrollView:name];
//    ui.direction=direction;
//    if(imgArray && imgArray.count>0)
//    {
//        for (id item in imgArray) {
//            [ui addImageView:nil img:item direction:direction];//内部会重设contentSize属性
//        }
//    }
//
//    return ui;
//}
//-(UIScrollView *)addScrollView:(NSString*)name  direction:(XYFlag)direction  img:(id)imgOrName,...NS_REQUIRES_NIL_TERMINATION
//{
//    return [self addScrollView:name direction:direction img:imgOrName, nil];
//}
//-(UIScrollView *)addScrollView:(NSString*)name  direction:(XYFlag)direction isImageFull:(BOOL)yesNo img:(id)imgOrName,...NS_REQUIRES_NIL_TERMINATION
//{
//
//    return self;
//    //return [self addScrollView:name direction:direction imgArray:imgArray];
//}
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
    ui.tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01f)];
    ui.tableFooterView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01f)];//去掉空白行。
    
//    ui.estimatedSectionHeaderHeight=0.01f;
//    ui.estimatedSectionFooterHeight=0.01f;
 //   self.stController.automaticallyAdjustsScrollViewInsets=NO;
    ui.delegate=(id)self.stController;
    ui.dataSource=(id)self.stController;
//    if (STOSVersion>=11) {
    if(![self.stController needNavBar])//无导航栏时多了状态栏高度偏移。
    {
        ui.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
////        ui.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
////        ui.scrollIndicatorInsets = ui.contentInset;
//    }
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
