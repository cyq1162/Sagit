//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUINavigationBar.h"
#import "STDefineUI.h"
@implementation UINavigationController (ST)
- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item
{
    if(navigationBar!=nil && [navigationBar.lastSubView isKindOfClass:[UIButton class]])
    {
        [navigationBar.lastSubView height:0];//取消自定义复盖的UIButton
    }
    //如果上级就是根视图，就隐藏，否则仍显示
    if(self.viewControllers!=nil && self.viewControllers.count==1 && self.navigationBar!=nil)
    {
        if(![self.viewControllers[0].view needNavigationBar])
        {
            self.navigationBar.hidden=YES;
        }
        //显示返回导航工具条，如果是滑动的话，View会自动归位，但自定义事件返回，不归位（所以在自定义事件中也设置一下次）
    }
}
//- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
//{
//    NSLog(@"should...");
//    long count=self.viewControllers.count;
//    return YES;
//}
@end

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
