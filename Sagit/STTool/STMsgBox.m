//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STMsgBox.h"
#import "STCategory.h"
#import "STDefineUI.h"

@interface STMsgBox()
@property (nonatomic,assign) UIWindow *window;
@property (nonatomic,retain) UIView *lodingView;
@property (nonatomic,assign) NSInteger hiddenFlag;

@end

@implementation STMsgBox
+(STMsgBox*)share {
    static STMsgBox *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [STMsgBox new];
    });
    return obj;
}
- (UIWindow*)window {
    if (!_window)
    {
       _window = [UIWindow mainWindow];
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
    [Sagit runOnMainThread:^{
        
        [[[self.window addUIView:nil] backgroundColor:[UIColor colorWithWhite:0.0f alpha:0.4f]] block:nil on:^(UIView* view) {
            
            [[view addLabel:nil text:msg font:30 color:@"ffffff" row:0] block:nil on:^(UILabel *label)
             {
                if(STScreenWidthPx-label.stWidth<150)
                {
                    [label width:STScreenWidthPx-150];
                    [label sizeToFit];
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
    }];
}

-(void)alert:(id)msg{
    [self confirm:msg title:nil click:nil okText:@"确定" cancelText:nil];
}
-(void)alert:(id)msg title:(NSString *)title
{
    [self confirm:msg title:title click:nil okText:@"确定" cancelText:nil];
}
-(void)alert:(id)msg title:(NSString *)title okText:(NSString*)okText
{
    [self confirm:msg title:title click:nil okText:okText cancelText:nil];
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
    [Sagit runOnMainThread:^{
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:msg
                                                           delegate:self
                                                  cancelButtonTitle:cancelText
                                                  otherButtonTitles:nil];
        
        if(okText)
        {
            NSArray<NSString*> *items=[okText split:@","];
            for (NSString *item in items) {
                [alertView addButtonWithTitle:item];
            }
        }
        [alertView key:@"click" value:[click copy]];
        [alertView show];
    }];
}
-(void)input:(id)title before:(OnBeforeShow)beforeShow click:(OnConfirmClick)click okText:(NSString *)okText cancelText:(NSString *)cancelText
{
    [Sagit runOnMainThread:^{
        UIAlertView* alertView = [[STUIAlertView alloc] initWithTitle:title
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:cancelText
                                                    otherButtonTitles:nil];
        if(okText)
        {
            NSArray<NSString*> *items=[okText split:@","];
            for (NSString *item in items) {
                [alertView addButtonWithTitle:item];
            }
        }
        alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
        if(beforeShow)
        {
            beforeShow(alertView);
        }
        [alertView key:@"click" value:[click copy]];
        [alertView show];
    }];
    if(beforeShow)
    {
        beforeShow=nil;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView allowDismiss:YES];
    OnConfirmClick click=[alertView key:@"click"];
    if(click!=nil)
    {
        BOOL yesNo=click(buttonIndex,alertView);
        [alertView allowDismiss:yesNo];
        if(!yesNo)
        {
            return;
        }
        click=nil;
    }
}
- (void)dialog:(OnDialogShow)dialog
{
    [self dialog:dialog beforeHide:nil];
}
- (void)dialog:(OnDialogShow)dialog beforeHide:(OnBeforeDialogHide) beforeHide
{
    self.isDailoging=YES;
    UIWindow *window=self.window;
    UIView *statusView=window.statusBar;
    
    UIImage *bgImage=statusView.backgroundImage;
    UIColor *bgColor=statusView.backgroundColor;
    __block OnBeforeDialogHide beforeHideBlock=beforeHide;
    __block OnDialogShow block=dialog;
    [[statusView backgroundImage:nil] backgroundColor:[ColorBlack alpha:0.5]];
    [[[[window addUIView:nil] x:0 y:0 width:1 height:1] backgroundColor:[ColorBlack alpha:0.5]] block:nil on:^(UIView* winView) {
        [winView onClick:^(UIView* view) {
            BOOL result=YES;
            if(beforeHideBlock)
            {
                result=beforeHideBlock(winView,[self getSubClickView:view allowNil:NO]);
            }
            else if(!winView.isHidden)//[ImageView show]
            {
                UIView *subViewClick=[self getSubClickView:view allowNil:NO];
                result=[view isEqual:subViewClick];
            }
            if(result)
            {
                self.isDailoging=NO;
                beforeHideBlock=nil;
                [winView hidden:YES];
                [winView removeSelf];
                [[statusView backgroundImage:bgImage] backgroundColor:bgColor];
            }
        }];
        [winView onDbClick:^(id view) {
            //双击事件存在是，屏蔽单击事件触发。
        }];
        if(block)
        {
            block(winView);
            block=nil;
        }
    }];
}
-(UIView*)getSubClickView:(UIView*)winView allowNil:(BOOL)allowNil
{
    UIView *returnView=nil;
    for (int i=0; i<winView.subviews.count; i++) {
        UIView *view=winView.subviews[i];
        if(view.userInteractionEnabled)
        {
            if(view.gestureRecognizers.count==0)
            {
                returnView=[self getSubClickView:view allowNil:YES];
            }
            else
            {
                for (int k=0; k<view.gestureRecognizers.count; k++) {
                    
                    if(view.gestureRecognizers[k].state!=UIGestureRecognizerStatePossible)
                    {
                        returnView=[self getSubClickView:view allowNil:NO];
                        break;
                    }
                }
            }
            if(returnView!=nil)
            {
                return returnView;
            }
        }
    }
    if(allowNil)
    {
        return nil;
    }
    return winView;
}
@end


