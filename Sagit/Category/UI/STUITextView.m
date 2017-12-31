//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUITextView.h"
#import "STUIView.h"
//#import "objc/runtime.h"

//@interface UITextView()
//@property (nonatomic,assign) NSInteger MaxLength;
//@property (nonatomic,assign) CGFloat MaxHeight;
//@end
@implementation UITextView(ST)

#pragma mark 自定义追加属系统
- (NSInteger)maxLength
{
    NSString *max=[self key:@"maxLength"];
    if(max)
    {
        return [max intValue];
    }
    return 0;
}
- (UITextField*)maxLength:(NSInteger)length{
    [self key:@"maxLength" value:[@(length) stringValue]];
    self.delegate = (id)self;
    return self;
    
}

- (CGFloat)maxHeight
{
    NSString *max=[self key:@"maxHeight"];
    if(max)
    {
        return [max floatValue];
    }
    return 0;
}
-(UITextView *)maxHeight:(CGFloat)px
{
    [self key:@"maxHeight" value:[@(px) stringValue]];
    self.delegate = (id)self;
    return self;
}
#pragma mark 扩展系统属性
-(UITextView*)keyboardType:(UIKeyboardType)value
{
    self.keyboardType=value;
    return self;
}
-(UITextView*)secureTextEntry:(BOOL)value
{
    self.secureTextEntry=value;
    return self;
}
-(UITextView*)text:(NSString*)text
{
    if(self.maxLength>0 && text.length>self.maxLength)
    {
        text=[text substringToIndex:self.maxLength-1];
    }
    self.text=text;
    [self textViewDidChange:self];//手工触发事件
    return self;
}
-(UITextView*)font:(NSInteger)px
{
    self.font=STFont(px);
    return self;
}
-(UITextView*)textColor:(id)colorOrHex
{
    self.textColor=[self toColor:colorOrHex];
    return self;
}
-(UITextView*)textAlignment:(NSTextAlignment)value
{
    self.textAlignment=value;
    return self;
}
-(UITextView*)placeholder
{
    return  [self key:@"placeholder"];
}
-(UITextView*)placeholder:(NSString*)text
{
    if([self key:@"placeholder"]==nil)
    {
        UILabel *placeholer=[[self addLabel:nil text:text font:self.font.pointSize*Ypx color:@"#cccccc"] relate:LeftTop v:8 v2:8];
        [self key:@"placeholderLabel" value:placeholer];
    }
    [self key:@"placeholder" value:text];
    self.delegate = (id)self;
    return self;
}

#pragma mark TextView 协议实现
- (void)textViewDidChange:(UITextView *)textView
{
    UILabel *label=[textView key:@"placeholderLabel"];
    if(label!=nil)
    {
        label.alpha=textView.hasText?0:1;
    }
    if(self.maxHeight>0)
    {
        [self changeHeight];
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.maxLength>0 && range.location >=textView.maxLength)
    {
        return NO;
    }
    return YES;
}

#pragma mark 实现高度自适应变化
//UITextView
-(void)changeHeight
{
    CGRect frame=self.frame;
    NSInteger margin=8;//根据观察：contentSize 默认上下margin 4个pt，比height少8个pt
    NSInteger maxHeightPt=self.maxHeight*Ypt;
    if(CGRectEqualToRect(self.OriginFrame, CGRectZero))//第一次先记录原始坐标
    {
        self.OriginFrame=self.frame;
    }
    if(maxHeightPt<self.frame.size.height){return;}//初始比最大行高还大，则无需要调整
    
    CGFloat addHeight= self.contentSize.height-frame.size.height-margin;
    if(addHeight!=0)//差值发生变化，
    {
        //修正差值，不能大于最大值，不能小于初始值
        if(addHeight>0 && frame.size.height+addHeight>maxHeightPt)
        {
            addHeight=maxHeightPt-frame.size.height;
        }
        else if(addHeight<0 && frame.size.height+addHeight<self.OriginFrame.size.height)
        {
            addHeight=self.OriginFrame.size.height-frame.size.height;//负数
        }
        if(addHeight==0){return;}
        [self height:(frame.size.height+addHeight)*Ypx];
        [self findSuperToFixHeight:self fix:addHeight];
        //[self.superview stSizeToFit:addHeight];
        //        if([textView isOnSTView])//上一层就是根视图
        //        {
        //            if(frame.origin.y-addHeight>64)//导航栏和状态栏之下，则往上移
        //            {
        //                frame.origin.y=frame.origin.y-addHeight;
        //            }
        //        }
        //        else //子控件里
        //
        //        {
        //
        //            UIView *superView=[self findSuperToFixHeight:self.superview fix:addHeight];
        //            [superView refleshLayout:NO];
        //            CGRect superFrame=textView.superview.frame;
        //            superFrame.origin.y-=addHeight;
        //            if(addHeight>0 && superFrame.origin.y<0)//上面到顶，无法上移，尝试下移
        //            {
        //                if([textView.LayoutTracer has:@"onBottom"] || frame.origin.y+frame.size.height>superFrame.size.height)//下面到顶，无法下移
        //                {
        //                    return;
        //                }
        //                //往下增加高度
        //                superFrame.origin.y+=addHeight;//还原坐标
        //            }
        //            superFrame.size.height+=addHeight;
        //            textView.superview.frame=superFrame;
        //        }
        
        //        NSString *text=textView.text;
        //        textView.text=nil;
        //        [UIView animateWithDuration:0.5 animations:^{
        //            textView.frame = frame;
        //        } completion:nil];
        //        textView.text=text;
        //        [self.baseView refleshLayout:NO];
        
    }
    
}
//往上找，找到最后一个根视图，再自上而下刷新布局
-(void)findSuperToFixHeight:(UIView*)me fix:(NSInteger)fixHeight
{
    if([me isKindOfClass:[UITableViewCell class]]) // 表格内的特殊处理。
    {
        UITableView *table= ((UITableViewCell*)me).table;
        if(table.autoHeight)
        {
            if(table.contentSize.height<table.frame.size.height)
            {
                //在加载的过程被触发（高度还没重设）
                table.contentSize=CGSizeMake(table.contentSize.width, table.contentSize.height+fixHeight);
            }
            else //加载完后的修改
            {
                [table beginUpdates];
                [table endUpdates];
                [table height:table.stHeight+fixHeight*Ypx];
            }
        }
        [me refleshLayout:NO];
        return;
    }
    
    UIView *superView=me.superview;
    if(superView==nil){[me refleshLayout:NO];return;}
    if([superView isKindOfClass:[STView class]] || [superView isKindOfClass:[UIWindow class]])
    {
        [me refleshLayout:NO];//最高级别不刷新
        return;
    }
    if(fixHeight>0)
    {
        if(me.frame.size.height>superView.frame.size.height)
        {
            [superView height:(superView.frame.size.height+fixHeight)*Ypx];
            [superView key:@"maxHeightAutoFix" value:@"yes"];
            return [self findSuperToFixHeight:superView fix:fixHeight];
        }
    }
    else
    {
        if([superView key:@"maxHeightAutoFix"]!=nil)
        {
            [superView height:(superView.frame.size.height+fixHeight)*Ypx];//减少高度
            return [self findSuperToFixHeight:superView fix:fixHeight];
        }
    }
    
}
//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    if(self.hasText){
//        textView.text = @"我是placeholder";
//        textView.textColor = [UIColor grayColor];
//    }
//}
//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    if([textView.text isEqualToString:@"我是placeholder"]){
//        textView.text=@"";
//        textView.textColor=[UIColor blackColor];
//    }
//}

@end


