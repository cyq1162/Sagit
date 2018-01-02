//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STMessageBox.h"
#import "STCategory.h"
#import "STDefineUI.h"

@interface STMessageBox()
@property (nonatomic,assign) UIWindow *window;
@property (nonatomic,copy) OnConfirmClick click;
@property (nonatomic,retain)UIAlertView *confirmView;
@property (nonatomic,retain)UIView *lodingView;
@property (nonatomic,assign) NSInteger hiddenFlag;
@end

@implementation STMessageBox
+(STMessageBox*)share {
    static STMessageBox *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [STMessageBox new];
    });
    return obj;
}
- (UIWindow*)window {
    if (!_window) {
        _window = [[UIApplication sharedApplication].delegate window];
        
    }
    return _window;
}

#pragma mark loding...
-(void)loading
{
    [self loading:@"Loding..."];
}
-(void)loading:(NSString*)text
{
    self.hiddenFlag=1;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:2];////延时2秒，如果事件在2秒内结束，就不显示加载框
        if(self.hiddenFlag==1)
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                //切回主线程处理
                if(text!=nil)
                {
                    UILabel *label= self.lodingView.subviews[0];
                    if(label!=nil)
                    {
                        [label text:text];
                    }
                }
                [self.lodingView alpha:1];
            });
           
        }
        
    });
}
-(void)hideLoading
{
    self.hiddenFlag=0;
    [self.lodingView alpha:0];
}
-(UIView *)lodingView
{
    if(_lodingView==nil)
    {
        [[[self.window addUIView:nil] backgroundColor:[UIColor colorWithWhite:0.0f alpha:0.4f]] block:nil on:^(UIView* view) {
            
            [[view addLabel:nil text:@"Loding..." font:30 color:@"ffffff"] block:nil on:^(UILabel *label)
             {
                 if(STScreenWidthPx-label.stWidth<200)
                 {
                     [label width:STScreenWidthPx-200];
                     [[label numberOfLines:0] sizeToFit];
                 }
                 [view width:label.stWidth+100 height:label.stHeight+50];
                 [label toCenter];
             }];
            
            [[view layerCornerRadius:10.f] toCenter];
            [view alpha:0];//默认隐藏
            _lodingView=view;
        }];
    }
   return _lodingView;
}
#pragma mark 消息提示
-(void)prompt:(id)msg {
    [self prompt:msg second:2];
}
-(void)prompt:(id)msg second:(NSInteger)second
{
    [[[self.window addUIView:nil] backgroundColor:[UIColor colorWithWhite:0.0f alpha:0.4f]] block:nil on:^(UIView* view) {
        
        [[view addLabel:nil text:msg font:30 color:@"ffffff"] block:nil on:^(UILabel *label)
        {
            if(STScreenWidthPx-label.stWidth<200)
            {
                [label width:STScreenWidthPx-200];
                [[label numberOfLines:0] sizeToFit];
            }
            [view width:label.stWidth+100 height:label.stHeight+50];
            [label toCenter];
        }];
        
        [[view layerCornerRadius:10.f] toCenter];
        [UIView animateWithDuration:second animations:^{
            view.alpha = 0.0f;//动画消失
        } completion:^(BOOL finished) {
            if(finished)
            {
                [view removeSelf];
            }
        }];
    }];
}

-(void)alert:(id)msg{
    [self confirm:msg title:nil click:nil okText:@"确定" cancelText:nil];
}
-(void)alert:(id)msg title:(NSString *)title
{
    [self confirm:msg title:nil click:nil okText:@"确定" cancelText:nil];
}
-(void)confirm:(id)msg title:(NSString *)title click:(OnConfirmClick)click
{
    [self confirm:msg title:title click:click okText:@"确定" cancelText:@"取消"];
}
-(void)confirm:(id)msg title:(NSString *)title click:(OnConfirmClick)click okText:(NSString *)okText
{
    [self confirm:msg title:title click:click okText:okText cancelText:@"取消"];
}
-(void)confirm:(id)msg title:(NSString *)title click:(OnConfirmClick)click okText:(NSString*)okText cancelText:(NSString*)cancelText
{
    _click=click;
    _confirmView=nil;
    _confirmView = [[UIAlertView alloc] initWithTitle:title
                                              message:msg
                                             delegate:self
                                    cancelButtonTitle:cancelText
                                    otherButtonTitles:nil];
    
    if(okText)
    {
        NSArray<NSString*> *items=[okText split:@","];
        for (NSString *item in items) {
            [_confirmView addButtonWithTitle:item];
        }
    }
    [_confirmView show];
}
-(void)custom:(id)title before:(OnBeforeShow)beforeShow click:(OnConfirmClick)click okText:(NSString *)okText cancelText:(NSString *)cancelText
{
    _click=click;
    _confirmView=nil;
    
    _confirmView = [[STUIAlertView alloc] initWithTitle:title
                                              message:nil
                                             delegate:self
                                    cancelButtonTitle:cancelText
                                      otherButtonTitles:nil];
    if(okText)
    {
        NSArray<NSString*> *items=[okText split:@","];
        for (NSString *item in items) {
            [_confirmView addButtonWithTitle:item];
        }
    }
    _confirmView.alertViewStyle=UIAlertViewStylePlainTextInput;
    if(beforeShow)
    {
        beforeShow(_confirmView);
    }
    [_confirmView show];
}

//- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//
//}
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    if(_confirmView!=nil)
//    {
//        _confirmView=nil;
//    }
//}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView allowDismiss:YES];
    if(_click!=nil)
    {
        BOOL yesNo=_click(buttonIndex,alertView);
        [alertView allowDismiss:yesNo];
        if(!yesNo)
        {
            return;
        }
        _click=nil;
    }
}
@end


