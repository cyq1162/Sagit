//
//  STUIWindow.m
//  IT恋
//
//  Created by 陈裕强 on 2018/1/24.
//  Copyright © 2018年 . All rights reserved.
//

#import "STUIWindow.h"

@implementation UIWindow(ST)

-(instancetype)initWithBackgoundColor:(id)colorOrHex
{
    self=[self initWithFrame:STFullRect];
    [self backgroundColor:colorOrHex];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
   //注册键盘出现与隐藏时候的通知(键盘有两个高度，中英文，所以不能关。)
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
    if(newText)
    {
        [self moveView:newText];//处理键盘高度（键盘出现的时候也有该方法调用执行，因为你不知道键盘和这个赋值哪个先出现，而且键盘还有两次事件）
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
    NSInteger kbHeight=self.keyboardHeight;
    UIView *baseView=textView.baseView; //self.rootViewController.view;
    if(kbHeight>0 && textView.isFirstResponder)// && CGPointEqualToPoint(CGPointZero, baseView.frame.origin)
    {
        NSInteger screenY=textView.stScreenY*Ypt;
        NSInteger textHeight=textView.frame.size.height;
        NSInteger moveY=screenY+textHeight+kbHeight-STScreeHeightPt;
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
//第一次执行了两次（216､258) 先没有文字，然后出现提示文字（+42pt）
-(void)keyboardShow:(NSNotification*)notify
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    NSDictionary *info = [notify userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];//键盘的frame
    self.keyboardHeight=keyboardRect.size.height;
    //键盘高度遮挡事件处理
    UIView *textView=self.editingTextUI;
    if(textView && textView.isFirstResponder)
    {
        UIView *baseView=textView.baseView;// self.rootViewController.view;//这个view包含已
        [baseView backToOrigin];
        [self moveView:textView];
    }
}
-(void)keyboardHide:(NSNotification*)notify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    UIView *textView=self.editingTextUI;
    if(textView)
    {
        UIView *baseView=textView.baseView;// self.rootViewController.view;//这个view包含已
       [baseView backToOrigin];
    }
}

+(id)mainWindow
{
    
    UIApplication *app=[UIApplication sharedApplication];
    Class c= NSClassFromString(@"SceneDelegate");
    if(c==nil)
    {
        if(app.delegate && app.delegate.window)
        {
            return app.delegate.window;
        }
        
    }
    if (@available(iOS 13.0, *)) {
         // 获取keywindow
         NSArray *array = app.windows;
         UIWindow *window = [array objectAtIndex:0];
      
          //  判断取到的window是不是keywidow
         if (!window.hidden || window.isKeyWindow) {
             return window;
         }
      
         //  如果上面的方式取到的window 不是keywidow时  通过遍历windows取keywindow
         for (UIWindow *window in array) {
             if (!window.hidden || window.isKeyWindow) {
                 return window;
             }
         }
    }
    
    UIWindow *win=app.keyWindow;
    if(win!=nil)
    {
        return win;
    }
    return app.delegate.window;
}
@end

