//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUITextView.h"
#import "STUIView.h"
#import "STDefineUI.h"
#import "STUIViewAddUI.h"
#import "STUIViewAutoLayout.h"
#import "STUITableView.h"
#import "STUITableViewCell.h"
//#import "objc/runtime.h"

//@interface UITextView()
//@property (nonatomic,assign) NSInteger MaxLength;
//@property (nonatomic,assign) CGFloat MaxHeight;
//@end
@implementation UITextView(ST)

-(OnTextViewEdit)onEdit
{
    return [self key:@"onEdit"];
}
-(void)setOnEdit:(OnTextViewEdit)onEdit
{
    [self key:@"onEdit" value:onEdit];
}
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
- (UITextView*)maxLength:(NSInteger)length{
    [self key:@"maxLength" value:[@(length) stringValue]];
    //self.delegate = (id)self;
    return self;
    
}

- (NSInteger)maxRow
{
    NSString *max=[self key:@"maxRow"];
    if(max)
    {
        return [max integerValue];
    }
    return 1;
}
-(UITextView *)maxRow:(NSInteger)num
{
    [self key:@"maxRow" value:[@(num) stringValue]];
    //self.delegate = (id)self;
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
        UILabel *placeholer=[[self addLabel:nil text:text font:self.font.pointSize*Ypx color:@"#cccccc"] relate:LeftTop v:8 v2:16];
        [self key:@"placeholderLabel" value:placeholer];
    }
    [self key:@"placeholder" value:text];
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
    if (textView.maxLength>0 && textView.text.length >=textView.maxLength)
    {
        textView.text=[textView.text substringWithRange:NSMakeRange(0, textView.maxLength)];
    }
    if(self.maxRow!=1)
    {
        [self changeHeight];
    }
}
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{ //此方法不支持中文（只能在change事件中处理）
//    if (textView.maxLength>0 && range.location >=textView.maxLength)
//    {
//        return NO;
//    }
//    return YES;
//}

#pragma mark 实现高度自适应变化
//UITextView
-(void)changeHeight
{
    
    if(CGRectEqualToRect(self.OriginFrame, CGRectZero))//第一次先记录原始坐标
    {
        self.OriginFrame=self.frame;
    }
    CGRect frame=self.frame;
    NSInteger fontHeight=floor(self.font.lineHeight);
    //根据观察：contentSize 默认上下margin 4个pt，比height少8个pt。
    NSInteger nowRows=round((self.frame.size.height-8)/fontHeight);
    NSInteger needRows=MIN(round(self.contentSize.height/fontHeight)-1,self.maxRow);
    if(needRows==nowRows){return;}//没变化
    CGFloat addHeight=0;
    if(needRows==1)
    {
        //恢复到原来的状态，得到负数，降低高度。
        addHeight=self.OriginFrame.size.height-self.frame.size.height;
    }
    else
    {
        addHeight=ceil(needRows*fontHeight)+8-self.frame.size.height;//要修正的高度
    }
    if(addHeight!=0)//差值发生变化，
    {
        [self height:(frame.size.height+addHeight)*Ypx];
        [self findSuperToFixHeight:self fix:addHeight]; 
    }
    
}
//往上找，找到最后一个根视图，再自上而下刷新布局
-(void)findSuperToFixHeight:(UIView*)me fix:(NSInteger)fixHeight
{
    if([me isKindOfClass:[UITableViewCell class]]) // 表格内的特殊处理。
    {
        UITableViewCell *cell=me;
        [cell resetHeightCache];
        UITableView *table= cell.table;
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
        [cell refleshLayout:NO ignoreSelf:YES];
        return;
    }
    
    UIView *superView=me.superview;
    if(superView==nil || [superView isKindOfClass:[STView class]] || [superView isKindOfClass:[UIWindow class]])
    {
        [me refleshLayout:NO ignoreSelf:NO];//最高级别不刷新
        return;
    }
    if(fixHeight>0)
    {
        if(me.frame.size.height+me.frame.origin.y>superView.frame.size.height)
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
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.window.editingTextUI=textView;//注册键盘遮挡事件
    if(self.onEdit)
    {
        self.onEdit(textView,NO);
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(self.onEdit)
    {
        self.onEdit(textView,YES);
    }
    
}
@end


