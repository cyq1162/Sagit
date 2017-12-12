//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUITextView.h"
#import "STUIView.h"
#import "objc/runtime.h"

//@interface UITextView()
//@property (nonatomic,assign) NSInteger MaxLength;
//@property (nonatomic,assign) CGFloat MaxHeight;
//@end

@implementation UITextView(ST)
#pragma mark 自定义追加属系统
static char maxLengthChar='l';
- (NSInteger)maxLength{
    return [objc_getAssociatedObject(self, &maxLengthChar) integerValue];
}
- (UITextView*)maxLength:(NSInteger)length{
    return [self setMaxLength:length];
}
- (UITextView*)setMaxLength:(NSInteger)length{
    objc_setAssociatedObject(self, &maxLengthChar, [@(length) stringValue],OBJC_ASSOCIATION_COPY_NONATOMIC);
    if(self.STController!=nil)
    {
        self.delegate=self.STController;
    }
    return self;
}

static char maxHeightChar='n';
- (CGFloat)maxHeight{
    return [objc_getAssociatedObject(self, &maxHeightChar) floatValue];
}
- (UITextView*)maxHeight:(NSInteger)length{
    return [self setMaxLength:length];
}
- (UITextView*)setMaxHeight:(CGFloat)pxValue{
    objc_setAssociatedObject(self, &maxHeightChar, [@(pxValue) stringValue],OBJC_ASSOCIATION_COPY_NONATOMIC);
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

//@interface UITextField()
//@property (nonatomic,assign) NSInteger MaxLength;
//@end



