//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUITextField.h"
#import "STUIView.h"
#import "STDefineUI.h"

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
    if(self.maxLength>0 && text.length>self.maxLength)
    {
        text=[text substringToIndex:self.maxLength-1];
    }
    self.text=text;
    return self;
}
-(UITextField*)font:(NSInteger)px
{
    self.font=STFont(px);
    return self;
}
-(UITextField*)textColor:(id)colorOrHex
{
    self.textColor=[self toColor:colorOrHex];
    return self;
}
-(UITextField*)textAlignment:(NSTextAlignment)value
{
    self.textAlignment=value;
    return self;
}
-(UITextField*)placeholder:(NSString*)text
{
    self.placeholder=text;
    return self;
}
-(UITextField*)borderStyle:(UITextBorderStyle)style
{
    self.borderStyle=style;
    return self;
}

#pragma mark TextFiled 协议实现
-(void)onTextChange:(UITextField*)textField
{
    NSString *text=textField.text;
    if(text.length>self.maxLength)
    {
        textField.text=[text substringWithRange:NSMakeRange(0, self.maxLength)];
    }
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
