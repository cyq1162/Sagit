//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUINavigationBar.h"
#import "STDefineUI.h"


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
-(UINavigationBarSetting*)backgroundImage:(NSString*)imgName
{
    return [self backgroundImage:imgName stretch:NO];
}
-(UINavigationBarSetting*)backgroundImage:(NSString*)imgName stretch:(BOOL)stretch
{
    UIImage *img=nil;
    if([NSString isNilOrEmpty:imgName])
    {
        img=[UIImage new];
    }
    else
    {
        img=STImage(imgName);
    }
    if(stretch)
    {
        img=[img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    }
    [[UINavigationBar appearance] setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    return self;
}
-(UINavigationBarSetting*)shadowImage:(NSString*)imgName
{
    if([NSString isNilOrEmpty:imgName])
    {
        [[UINavigationBar appearance] setShadowImage: [[UIImage alloc] init]];
    }
    else{[[UINavigationBar appearance] setShadowImage:STImage(imgName)];}
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
