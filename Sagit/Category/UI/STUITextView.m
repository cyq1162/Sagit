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
    if(self.STController!=nil)
    {
        self.delegate=self.STController;
    }
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
    if(self.STController!=nil)
    {
        self.delegate=self.STController;
    }
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
    self.text=text;
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
        UILabel *placeholer=[[self addLabel:nil text:text] relate:LeftTop v:10 v2:10];
        [placeholer textColor:@"#cccccc"];
        placeholer.font=self.font;
        [self key:@"placeholderLabel" value:placeholer];
    }
    [self key:@"placeholder" value:text];
    self.delegate = (id)self;
    return self;
}
- (void)textViewDidChange:(UITextView *)textView
{
    
    UILabel *label=[textView key:@"placeholderLabel"];
    if(label!=nil)
    {
        label.alpha=textView.hasText?0:1;
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


