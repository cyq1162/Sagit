//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUITextField.h"
#import "STUIView.h"
#import "objc/runtime.h"

@implementation UITextField(ST)
#pragma mark 自定义追加属系统
static char textFieldMaxLength='m';
- (NSInteger)maxLength{
    return [objc_getAssociatedObject(self, &textFieldMaxLength) integerValue];
}
- (UITextField*)maxLength:(NSInteger)length{
    return [self setMaxLength:length];
}
- (UITextField*)setMaxLength:(NSInteger)length{
    objc_setAssociatedObject(self, &textFieldMaxLength, [@(length) stringValue],OBJC_ASSOCIATION_COPY_NONATOMIC);
    if(self.STController!=nil)
    {
        self.delegate=self.STController;
    }
    return self;
}
#pragma mark 扩展系统属性
-(UITextField*)keyboardType:(UIKeyboardType)value
{
    self.keyboardType=value;
    return self;
}
-(UITextField*)secureTextEntry:(BOOL)value
{
    self.secureTextEntry=value;
    return self;
}
@end
