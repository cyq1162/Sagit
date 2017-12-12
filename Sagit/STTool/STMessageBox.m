//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STMessageBox.h"
#import "MBProgressHUD.h"
#import "STCategory.h"
#import "STDefineUI.h"
@interface STMessageBox ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@property (nonatomic,assign) UIWindow *window;
@property (nonatomic,copy) OnClick click;
@property (nonatomic,retain)UIAlertView *confirmView;

@end
@implementation STMessageBox
+(STMessageBox*)share {
    static STMessageBox *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[STMessageBox alloc]init];
    });
    return obj;
}
- (UIWindow*)window {
    if (!_window) {
        _window = [[UIApplication sharedApplication].delegate window];
        
    }
    return _window;
}

-(void)showWaitViewInView:(UIView *)view animation:(BOOL)animated withText:(NSString *)text  withDetailsText:(NSString *)detailsText withDuration:(CGFloat)duration hideWhenFinish:(BOOL)hideWhenFinish{
    HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = MBProgressHUDModeText;
    HUD.bezelView.color = [UIColor colorWithWhite:0.0f alpha:0.4f];
    HUD.bezelView.layer.cornerRadius = 10.0f;
    
    HUD.label.text = text;
    //NSUInteger aa=30*Ypt;
    HUD.label.font = STFont(30);
    HUD.label.textColor = [UIColor hex:@"#ffffff"];
    HUD.detailsLabel.text = detailsText;
    HUD.detailsLabel.font = STFont(15);
    HUD.margin = 13.f;
    HUD.delegate = self;
    //HUD.yOffset = -200.f;
    
    HUD.removeFromSuperViewOnHide = hideWhenFinish;
    HUD.userInteractionEnabled = NO;
    [HUD hideAnimated:YES afterDelay:duration];
}
-(void)showWaitViewWithIcon:(UIView*)view
                   withText:(NSString*)text
                       icon:(NSString*)icon{
    HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    HUD.label.text = text;
    HUD.yOffset = -150.f;
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:3];
}
- (void)showWhileExecuting:(UIView*)view
                  withText:(NSString*)text
       whileExecutingBlock:(dispatch_block_t)block complete:(Complete)complete{
    HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.delegate = self;
    HUD.label.text = text;
    [view addSubview:HUD];
    [HUD showAnimated:YES whileExecutingBlock:^{
        block();
    } completionBlock:^{
        [HUD removeFromSuperview];
        complete();
    }];
}
-(void)showWithCustomView:(UIView*)view gifName:(NSString*)gifName{
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc]initWithView:view];
        [view addSubview:HUD];
    }
    CGRect frame = CGRectMake(0,0,30,20);
    frame.size = [UIImage imageNamed:[[NSString alloc]initWithFormat:@"%@.gif", gifName]].size;
    //读取gif图片数据
    NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"]];
    //view生成
    frame = CGRectMake(-10,30,frame.size.width + 10,frame.size.height);
    UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
    webView.userInteractionEnabled = YES;//用户不可交互
    webView.scalesPageToFit = YES;
    webView.backgroundColor = [UIColor clearColor];
    [webView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    HUD.customView = webView;
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.userInteractionEnabled = NO;
    HUD.color = [UIColor whiteColor];
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD showAnimated:YES];
}
-(void)showCustomViewText:(NSString*)text{
    HUD.label.text = text;
    HUD.label.textColor = [UIColor blackColor];
}
-(void)hideView{
    if(HUD!=nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{

        });
        [HUD hideAnimated:YES];
        [HUD removeFromSuperview];
        HUD = nil;
    }
}
#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    //Remove HUD from screen when the HUD was hidded
    [HUD.customView removeFromSuperview];
    [HUD removeFromSuperview];
    HUD = nil;
}


- (void)showLoadingViewOnView:(UIView *)view text:(NSString *)text{
    HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.label.text = text;
    HUD.label.font = [UIFont systemFontOfSize:17];
}

- (void)viewDidUnload {
}

#pragma mark alertView
-(void)loading{
    [self loading:nil];
}
-(void)loading:(NSString*)text{
    if(text!=nil && HUD!=nil)
    {
        [self showLoadingViewOnView:self.window text:text];
    }
}
-(void)hideLoading{
    [self hideView];
}
-(void)prompt:(NSString*)text {
    [self prompt:text duration:1];
}
-(void)prompt:(NSString*)text duration:(int)duration {
    [self prompt:text duration:duration withDetailText:nil];
}
-(void)prompt:(NSString*)text duration:(int)duration withDetailText:(NSString *)detailText;
{
    [self showWaitViewInView:self.window animation:YES withText:text withDetailsText:detailText withDuration:duration hideWhenFinish:YES];
}
-(void)alert:(NSString *)text{
    [self alert:@"消息提示" msg:text];
}
-(void)alert:(NSString*)title msg:(NSString *)text{
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:title message:text delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    alert=nil;
}
-(void)confirm:(NSString *)title msg:(NSString *)message click:(OnClick)click
{
    [self confirm:title msg:message click:click okText:@"确定"];
}
-(void)confirm:(NSString *)title msg:(NSString *)message click:(OnClick)click okText:(NSString*)okText
{
    [self confirm:title msg:message click:click okText:okText cancelText:@"取消"];
}
-(void)confirm:(NSString *)title msg:(NSString *)message click:(OnClick)click okText:(NSString*)okText cancelText:(NSString*)cancelText;
{
    _click=click;
    if(_confirmView==nil)
    {

    _confirmView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                                cancelButtonTitle:cancelText
                                                otherButtonTitles:okText,nil];
    }
    else
    {
        _confirmView.title=title;
        _confirmView.message=message;
        _confirmView.delegate=self;
    }
    [_confirmView show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(_click!=nil)
    {
        _click(buttonIndex>0);
        _click=nil;
    }
}
@end

