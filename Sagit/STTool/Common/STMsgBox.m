//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STMsgBox.h"

@interface STMsgBox()<UIActionSheetDelegate>
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
-(STController*)dialogController{
    if(!_dialogController)
    {
        _dialogController=[STController new];
        [_dialogController initView];
        //[_dialogController needStatusBar:NO];
    }
    return _dialogController;
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
    [self prompt:msg second:3];
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
-(void)input:(id)title before:(OnBeforeShow)beforeShow click:(OnInputClick)click okText:(NSString *)okText cancelText:(NSString *)cancelText
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
    if(alertView.alertViewStyle==UIAlertViewStyleDefault)
    {
        OnConfirmClick click=[alertView key:@"click"];
        if(click!=nil)
        {
            click(buttonIndex,alertView);
            click=nil;
        }
    }
    else
    {
        OnInputClick click=[alertView key:@"click"];
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
}
-(void)menu:(OnMenuClick)click names:(id)names, ...
{

        UIActionSheet * actiongSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil,nil];
        
        if([names isKindOfClass:[NSMutableArray class]] || [names isKindOfClass:[NSArray class]])
        {
            NSArray *array=names;
            for (id item in array)
            {
                [actiongSheet addButtonWithTitle:item];
            }
        }
        else
        {
            va_list args;
            va_start(args, names);
            [actiongSheet addButtonWithTitle:names];
            id otherName;
            while ((otherName = va_arg(args, id)))
            {
                [actiongSheet addButtonWithTitle:otherName];
            }
            va_end(args);
        }
        [actiongSheet key:@"click" value:[click copy]];
        /////添加cancel 按钮
        [actiongSheet addButtonWithTitle:@"取消"];
        //////设置刚添加的 取消 按钮为系统默认的 cancel 按钮
        actiongSheet.cancelButtonIndex = actiongSheet.numberOfButtons-1;
        actiongSheet.actionSheetStyle = UIActionSheetStyleDefault;
[Sagit runOnMainThread:^{
        [actiongSheet showInView:self.window];
  }];
}
///////点击触发方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

        OnMenuClick click=[actionSheet key:@"click"];
        if(click!=nil)
        {
            click(buttonIndex,actionSheet);
            click=nil;
        }
}
- (void)dialog:(OnDialogShow)dialog
{
    [self dialog:dialog beforeHide:nil];
}
- (void)dialog:(OnDialogShow)dialog beforeHide:(OnBeforeDialogHide) beforeHide
{
    
    UIWindow *window=self.window;
    UIView *statusView=window.statusBar;
    self.isDialoging=YES;
    
    __block OnBeforeDialogHide beforeHideBlock=beforeHide;
    __block OnDialogShow block=dialog;

    STView *view=self.dialogController.stView;
    [statusView alpha:0.1];
    [window addSubview:view];
    [[[view x:0 y:0 width:1 height:1] backgroundColor:[ColorBlack alpha:0.5]] block:nil on:^(UIView* winView) {
        [winView onClick:^(UIView* view) {
            BOOL result=YES;
            if(beforeHideBlock)
            {
                UIView *clickView=[self getSubClickView:view allowNil:NO];
                self.isDialoging=NO;
                result=beforeHideBlock(winView,clickView);
                self.isDialoging=!result;
            }
            else if([winView key:@"clickPoint"]!=nil)//[ImageView show]
            {
                UIView *subViewClick=[self getSubClickView:view allowNil:NO];
                result=[view isEqual:subViewClick];
            }
            if(result)
            {
                self.isDialoging=NO;
                beforeHideBlock=nil;
                [winView hidden:YES];
                [winView removeSelf];//内部有dispose
                [statusView alpha:1];
            }
        }];
        [winView onDbClick:^(id view) {
            //双击事件存在是，屏蔽单击事件触发。
        }];
        [winView hidden:NO];
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
            if(view.gestureRecognizers.count>0)
            {
                for (int k=0; k<view.gestureRecognizers.count; k++) {
                    
                    if(view.gestureRecognizers[k].state!=UIGestureRecognizerStatePossible)
                    {
                        returnView=[self getSubClickView:view allowNil:NO];
                        break;
                    }
                }
            }
            if(returnView==nil)
            {
                returnView=[self getSubClickView:view allowNil:YES];
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


