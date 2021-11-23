//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STMsgBox.h"
#import "STSagit.h"
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
    }
    return _dialogController;
}
-(STQueue<UIAlertController *> *)alertQueue
{
    if(!_alertQueue)
    {
        _alertQueue=[STQueue<UIAlertController*> new];
    }
    return _alertQueue;
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
    [self alert:msg title:nil];
}
-(void)alert:(id)msg title:(NSString *)title
{
    [self alert:msg title:title okText:@"确定"];
}
-(void)alert:(id)msg title:(NSString *)title okText:(NSString*)okText
{
    if(self.alertQueue.count>0)//合并或重置重复的消息提示。
    {
        UIAlertController *alertController=[self.alertQueue peek];
        NSString *oldMsg=[alertController.message trimEnd:STString(@" X %@",@(alertController.view.tag))];
        if([oldMsg eq:msg])
        {
            alertController.title=title;
            alertController.view.tag=alertController.view.tag+1;
            msg=[msg append:STString(@" X %li",alertController.view.tag)];
            alertController.message=msg;
            return;
        }
    }
    [Sagit runOnMainThread:^{
        UIAlertController *alertController= [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action=[UIAlertAction actionWithTitle:okText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissAlert];
        }];
        [alertController addAction:action];
        alertController.view.tag=1;
       
        if(self.alertQueue.count==0)
        {
            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        }
        [self.alertQueue enqueue: alertController];
    }];
}
-(void)dismissAlert
{
    [self.alertQueue dequeue];
    UIAlertController *alertController=[self.alertQueue peek];
    if(alertController)
    {
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
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
        UIAlertController *alertController= [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        int i=0;
        if(cancelText)
        {
            UIAlertAction *action=[UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if(click)
                {
                    click(i,alertController);
                }
                [self dismissAlert];
            }];
            [alertController addAction:action];
            i++;
        }
        if(okText)
        {
            NSArray<NSString*> *items=[okText split:@","];
            for (NSString *item in items) {
                UIAlertAction *action=[UIAlertAction actionWithTitle:item style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if(click)
                    {
                        click(i,alertController);
                    }
                    [self dismissAlert];
                }];
                [alertController addAction:action];
                i++;
            }
        }
        else
        {
            UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if(click)
                {
                    click(i,alertController);
                }
                [self dismissAlert];
            }];
            [alertController addAction:action];
        }
        if(self.alertQueue.count==0)
        {
            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        }
        [self.alertQueue enqueue: alertController];
    }];
}
-(void)input:(id)title before:(OnBeforeShow)beforeShow click:(OnInputClick)click okText:(NSString *)okText cancelText:(NSString *)cancelText
{
    [Sagit runOnMainThread:^{
        UIAlertController *alertController= [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];

        //default textfield
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.borderStyle=UITextBorderStyleRoundedRect;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            }];
        if(beforeShow)
        {
            beforeShow(alertController);
        }
        int i=0;
        if(cancelText)
        {
            UIAlertAction *action=[UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if(click)
                {
                    if(!click(i,alertController))
                    {
                        UIAlertController *alertController=[self.alertQueue peek];
                        if(alertController)
                        {
                            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
                        }
                        return;
                    }
                }
                [self dismissAlert];
            }];
            [alertController addAction:action];
            i++;
        }
        if(okText)
        {
            NSArray<NSString*> *items=[okText split:@","];
            for (NSString *item in items) {
                UIAlertAction *action=[UIAlertAction actionWithTitle:item style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if(click)
                    {
                        if(!click(i,alertController))
                        {
                            UIAlertController *alertController=[self.alertQueue peek];
                            if(alertController)
                            {
                                [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
                            }
                            return;
                        }
                    }
                    [self dismissAlert];
                }];
                [alertController addAction:action];
                i++;
            }
        }
        else
        {
            UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if(click)
                {
                    if(!click(i,alertController))
                    {
                        UIAlertController *alertController=[self.alertQueue peek];
                        if(alertController)
                        {
                            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
                        }
                        return;
                    }
                }
                [self dismissAlert];
            }];
            [alertController addAction:action];
        }
        if(self.alertQueue.count==0)
        {
            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        }
        [self.alertQueue enqueue: alertController];

        
    }];
    if(beforeShow)
    {
        beforeShow=nil;
    }
}

-(void)menu:(OnMenuClick)click names:(id)names, ...
{
    NSMutableArray *nameArray=[NSMutableArray new];
    [nameArray addObject:names];
    va_list args;
    va_start(args, names);
    id otherName;
    while ((otherName = va_arg(args, id)))
    {
        [nameArray addObject:otherName];
    }
    va_end(args);
    [self menu:nil title:nil click:click names:nameArray,nil];
}
-(void)menu:(id)msg title:(NSString *)title click:(OnMenuClick)click names:(id)names, ...
{
    UIAlertController *alertController= [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleActionSheet];
    int i=0;
    if([names isKindOfClass:[NSMutableArray class]] || [names isKindOfClass:[NSArray class]])
    {
        NSArray *array=names;
        for (id item in array)
        {
            UIAlertAction *action=[UIAlertAction actionWithTitle:item style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if(click)
                {
                    click(i,alertController);
                }
                [self dismissAlert];
            }];
            [alertController addAction:action];
            i++;
        }
    }
    else
    {
        va_list args;
        va_start(args, names);
        UIAlertAction *action=[UIAlertAction actionWithTitle:names style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if(click)
            {
                click(i,alertController);
            }
            [self dismissAlert];
        }];
        [alertController addAction:action];
        i++;
        id otherName;
        while ((otherName = va_arg(args, id)))
        {
            UIAlertAction *action=[UIAlertAction actionWithTitle:otherName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if(click)
                {
                    click(i,alertController);
                }
                [self dismissAlert];
            }];
            [alertController addAction:action];
            i++;
        }
        va_end(args);
    }
    
    ///添加cancel 按钮
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(click)
        {
            click(i,alertController);
        }
        [self dismissAlert];
    }];
    [alertController addAction:action];
    [Sagit runOnMainThread:^{
        if(self.alertQueue.count==0)
        {
            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        }
        [self.alertQueue enqueue: alertController];
    }];
}

- (void)dialog:(OnDialogShow)dialog
{
    [self dialog:dialog beforeHide:nil];
}
- (void)dialog:(OnDialogShow)dialog beforeHide:(OnBeforeDialogHide) beforeHide
{
    
    UIWindow *window=self.window;
    [window endEditing:YES];
    UIView *statusView=window.statusBar;
    self.isDialoging=YES;
    
    __block OnBeforeDialogHide beforeHideBlock=beforeHide;
    __block OnDialogShow block=dialog;

    STView *view=self.dialogController.stView;
    [view name:@"stDialogView"];
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
- (void)dialogClose
{
    if(self.isDialoging)
    {
        STView *winView=self.dialogController.stView;
        [winView key:@"eventView" value:winView];
        [winView click];
    }
    
}
-(UIView*)getSubClickView:(UIView*)winView allowNil:(BOOL)allowNil
{
    if(winView.isSTView)//兼容：IOS13.6 UITableView 点击拿不到点击View
    {
        UIView*eventView=[winView key:@"eventView"];//UIViewEvent 事件:shouldReceiveTouch有对应处理
        if(eventView)
        {
            [winView key:@"eventView" value:nil];
            return eventView;
        }
    }
    UIView *returnView=nil;
    for (int i=0; i<winView.subviews.count; i++) {
        UIView *view=winView.subviews[i];
        if(view.userInteractionEnabled)
        {
            if(view.gestureRecognizers.count>0)
            {
                for (int k=0; k<view.gestureRecognizers.count; k++) {
                    
                    UIGestureRecognizer *gr=view.gestureRecognizers[k];

                    UIGestureRecognizerState state=gr.state;
                    if(state!=UIGestureRecognizerStatePossible)
                    {
                        //UIGestureRecognizerStateEnded
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
    if([winView.name startWith:@"for15"])//兼容：ios15 x坐标为0无法触发点击事件。
    {
        return winView.superview;
    }
    return winView;
}
@end


