//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "STEnum.h"

@interface UIViewController(ST)
//上一个Push来的页面
-(UIViewController*)preController;
-(UIViewController*)asRoot;
-(UIViewController*)asRoot:(RootViewControllerType) rootType;

#pragma mark keyvalue
//为每个UI增加一个可以存档临时值的字典
-(NSMutableDictionary<NSString*,id>*)keyValue;
-(id)key:(NSString*)key;
-(UIView*)key:(NSString*)key value:(id)value;

#pragma mark 代码说明块
typedef  void(^onDescription)(UIView *view);
-(void)block:(NSString*)description on:(onDescription)descBlock;
#pragma mark 导航栏功能
- (void)stPush:(UIViewController *)viewController title:(NSString *)title img:(id)imgOrName;
- (void)stPop;
//简单设置右侧导航栏功能
-(UIViewController*)rightNav:(NSString*)title img:(id)imgOrName;
-(void)onRightNavBarClick:(UIView*)view;
#pragma mark 共用接口
//子类重写
-(void)reloadData;
-(void)reloadData:(NSString*)para;
#pragma mark for TabBar 属性扩展
-(UIViewController*)title:(NSString*)title;
-(UIViewController*)tabTitle:(NSString*)title;
-(UIViewController*)tabImage:(NSString*)imgName;
-(UIViewController*)tabSelectedImage:(NSString*)imgName;
-(UIViewController*)tabBadgeValue:(NSString*)value;
-(UIViewController*)tabBadgeColor:(id)colorOrHex;
-(UINavigationController*)toUINavigationController;

@end
