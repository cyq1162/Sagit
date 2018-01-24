//
//  STUIWindow.m
//  IT恋
//
//  Created by 陈裕强 on 2018/1/24.
//  Copyright © 2018年 Silan Xie. All rights reserved.
//

#import "STUIWindow.h"

@implementation UIWindow(ST)

-(instancetype)initWithBackgoundColor:(id)colorOrHex
{
    self=[self initWithFrame:STFullRect];
    [self backgroundColor:colorOrHex];
   //注册键盘出现与隐藏时候的通知
   [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
    return self;
}

#pragma mark 处理广本框键盘回收
-(CGFloat)keyboardHeight
{
    NSString *height=[self key:@"keyboardHeight"];
    if (height) {
        return [height floatValue];
    }
    return 0;
}
-(void)setKeyboardHeight:(CGFloat)keyboardHeight
{
    [self key:@"keyboardHeight" value:[@(keyboardHeight) stringValue]];
}
-(UIView *)editingTextUI
{
    return [self key:@"editingTextUI"];
}
-(void)setEditingTextUI:(UIView *)newText
{
    [self key:@"editingTextUI" valueWeak:newText];
//    if(self.keyboardHeight==0)
//    {
//        //注册键盘出现与隐藏时候的通知
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardShow:)
//                                                     name:UIKeyboardWillShowNotification
//                                                   object:nil];
//    }
    if(newText)
    {
        //键盘高度遮挡事件处理
        [self moveView:newText];
        //键盘取消事件处理
        if(![self key:@"hasClick"])
        {
            [self key:@"hasClick" value:@"1"];
           
            [self onClick:^(id view)
            {
                UIView *editUI=self.editingTextUI;
                if(editUI)
                {
                    [self.editingTextUI resignFirstResponder];
                    [self key:@"editingTextUI" value:nil];
                }
                [self removeClick];
                [self key:@"hasClick" value:nil];
            }];
        }
    }
}
-(void)moveView:(UIView *)textView
{
    UIView *baseView=self.rootViewController.view;
    if(self.keyboardHeight>0 && textView.isFirstResponder && CGPointEqualToPoint(CGPointZero, baseView.OriginFrame.origin))
    {
        NSInteger moveY=self.editingTextUI.stAbsY*Ypt+self.editingTextUI.frame.size.height+self.keyboardHeight-STScreeHeightPt;
        if(moveY>0)
        {
            CGRect frame=baseView.frame;
            frame.origin.y-=(moveY+8);
            [baseView moveTo:frame];
            //注册键盘回收事件
            //注册键盘出现与隐藏时候的通知
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardHide:)
                                                         name:UIKeyboardWillHideNotification
                                                       object:nil];
        }
    }
}

-(void)keyboardShow:(NSNotification*)notify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    NSDictionary *info = [notify userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];//键盘的frame
    self.keyboardHeight=keyboardRect.size.height;
}
-(void)keyboardHide:(NSNotification*)notify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    UIView *baseView=self.rootViewController.view;
    if(baseView)
    {
        [baseView backToOrigin];
    }
    
}
@end

