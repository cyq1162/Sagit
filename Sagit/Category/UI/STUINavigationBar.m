//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUINavigationBar.h"
#import "STDefineUI.h"
#import "STUIView.h"

@implementation UINavigationBar (ST)

+(UINavigationBarSetting*)globalSetting
{
    return [UINavigationBarSetting new];
}
@end

@implementation UINavigationBarSetting
#pragma mark 扩展系统属性
-(UINavigationBarSetting*)tintColor:(id)colorOrHex
{
    [UINavigationBar appearance].tintColor=[UIView toColor:(colorOrHex)];
    return self;
}
-(UINavigationBarSetting*)barTintColor:(id)colorOrHex
{
    [UINavigationBar appearance].barTintColor=[UIView toColor:(colorOrHex)];
    return self;
}
-(UINavigationBarSetting*)backgroundImage:(id)img
{
    return [self backgroundImage:img stretch:NO];
}
-(UINavigationBarSetting*)backgroundImage:(id)img stretch:(BOOL)stretch
{
    UIImage *uiImg=nil;
    if(img==nil)
    {
        uiImg=[UIImage new];
    }
    else
    {
        uiImg=[UIView toImage:img];
    }
    if(stretch)
    {
        uiImg=[uiImg resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    }
    [[UINavigationBar appearance] setBackgroundImage:uiImg forBarMetrics:UIBarMetricsDefault];
    return self;
}
-(UINavigationBarSetting*)shadowImage:(id)img
{
    if(img==nil)
    {
        [[UINavigationBar appearance] setShadowImage: [[UIImage alloc] init]];
    }
    else{[[UINavigationBar appearance] setShadowImage:[UIView toImage:img]];}
    return self;
}
-(UINavigationBarSetting*)titleTextAttributes:(NSDictionary<NSAttributedStringKey,id> *)dic
{
    [[UINavigationBar appearance] setTitleTextAttributes:dic];
    return self;
}
-(UINavigationBarSetting*)translucent:(BOOL)yesNo
{
    [UINavigationBar appearance].translucent=yesNo;
    return self;
}
@end
