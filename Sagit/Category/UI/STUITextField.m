//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUITextField.h"
#import "STUIView.h"

@implementation UITextField(ST)

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
@end
