//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUITextField.h"
#import "STUIView.h"
#import "STDefineUI.h"
#import "STCategory.h"

@implementation UITextField(ST)
-(OnTextFieldEdit)onEdit
{
    return [self key:@"onEdit"];
}
-(void)setOnEdit:(OnTextFieldEdit)onEdit
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
- (UITextField*)maxLength:(NSInteger)length
{
    if(length>0 && self.maxLength==0)
    {
        //注册事件
        [self addTarget:self action:@selector(onTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    [self key:@"maxLength" value:[@(length) stringValue]];
    
    return self;
}

#pragma mark 扩展系统属性
-(UITextField*)keyboardType:(UIKeyboardType)type
{
    self.keyboardType=type;
    return self;
}
-(UITextField*)secureTextEntry:(BOOL)yesNo
{
    self.secureTextEntry=yesNo;
    return self;
}
-(UITextField*)text:(NSString*)text
{
    if([text isKindOfClass:[NSNull class]])
    {
        text=@"";
    }
    if(self.maxLength>0 && text.length>self.maxLength)
    {
        text=[text substringToIndex:self.maxLength-1];
    }
    self.text=text;
    return self;
}
-(UITextField*)font:(CGFloat)px
{
    self.font=[UIFont toFont:px];
    return self;
}
-(UITextField*)textColor:(id)colorOrHex
{
    self.textColor=[UIColor toColor:colorOrHex];
    return self;
}
-(UITextField*)textAlignment:(NSTextAlignment)value
{
    self.textAlignment=value;
    return self;
}
-(UITextField*)placeholder:(NSString*)text
{
    if([text isKindOfClass:[NSNull class]])
    {
        text=@"";
    }
    self.placeholder=text;
    return self;
}
-(UITextField*)borderStyle:(UITextBorderStyle)style
{
    self.borderStyle=style;
    return self;
}
-(UITextField*)enabled:(BOOL)yesNo
{
    self.enabled=yesNo;
    return self;
}
#pragma mark TextFiled 协议实现
-(void)onTextChange:(UITextField*)textField
{
    if(self.onEdit)
    {
        self.onEdit(textField,NO);
    }
    NSString *text=textField.text;
    if(self.maxLength>0 && text.length>self.maxLength)
    {
        textField.text=[text substringWithRange:NSMakeRange(0, self.maxLength)];
    }
}
//ios 13
- (void)textFieldDidChangeSelection:(UITextField *)textField
{
    [self resetCursorToEnd:textField];
    [self onTextChange:textField];
}

-(void)resetCursorToEnd:(UITextField *)textField
{
    if(textField.text.length>0)
    {
        NSRange rang= [self getRange:textField];
        if(rang.location==0)
        {
            switch (textField.keyboardType)
            {
                case UIKeyboardTypePhonePad:
                case UIKeyboardTypeNumberPad:
                case UIKeyboardTypeNumbersAndPunctuation:
                case UIKeyboardTypeDecimalPad:
                case UIKeyboardTypeASCIICapableNumberPad:
                     [self cursorLocation:textField index:textField.text.length];
                    break;
            }
       }
    }
}

// 获取光标位置
-(NSRange)getRange:(UITextField *)textField
{
    UITextPosition* beginning = textField.beginningOfDocument;
    
    UITextRange* selectedRange = textField.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    NSInteger location = [textField offsetFromPosition:beginning toPosition:selectionStart];
    NSInteger length = [textField offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}
- (void)cursorLocation:(UITextField*)textField index:(NSInteger)index

{
    NSRange range =NSMakeRange(index,0);
    UITextPosition *start = [textField positionFromPosition:[textField beginningOfDocument]offset:range.location];
    UITextPosition *end = [textField positionFromPosition:start offset:range.length];
    [textField setSelectedTextRange:[textField textRangeFromPosition:start toPosition:end]];
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{//此方法不支持中文（只能在change事件中处理）
//    if (textField.maxLength>0 && range.location >=textField.maxLength) {
//        return NO;
//    }
//    return YES;


//}
- (void)textFieldDidBeginEditing:(UITextField *)textField           // became first responder
{
    self.window.editingTextUI=textField;//注册键盘遮挡事件
    if(self.onEdit)
    {
        self.onEdit(textField,NO);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.onEdit)
    {
        self.onEdit(textField,YES);
    }
}
-(void)dispose
{
    if(self.maxLength>0)
    {
        [self removeTarget:self action:@selector(onTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
}
@end
