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

#pragma mark 扩展系统属性
-(UINavigationBar*)tintColor:(id)colorOrHex
{
    self.tintColor=[self toColor:(colorOrHex)];
    return self;
}
-(UINavigationBar*)barTintColor:(id)colorOrHex
{
    self.barTintColor=[self toColor:(colorOrHex)];
    return self;
}
-(UINavigationBar*)backgroundImage:(NSString*)imgName
{
    if([NSString isNilOrEmpty:imgName])
    {
        [self setBackgroundImage: [[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    }
    else{[self setBackgroundImage:STImage(imgName) forBarMetrics:UIBarMetricsDefault];}
    return self;
}
-(UINavigationBar*)shadowImage:(NSString*)imgName
{
    if([NSString isNilOrEmpty:imgName])
    {
        [self setShadowImage: [[UIImage alloc] init]];
    }
    else{[self setShadowImage:STImage(imgName)];}
    return self;
}
-(UINavigationBar*)titleTextAttributes:(NSDictionary<NSAttributedStringKey,id> *)dic
{
    [self setTitleTextAttributes:dic];
    return self;
}
@end
