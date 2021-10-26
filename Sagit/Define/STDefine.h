//
//  STDefine.h
//
//  Created by 陈裕强 on 2020/9/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface STDefine : NSObject
+ (instancetype)share;
#pragma mark 框架版本
/// 版本号
@property (nonatomic,copy) NSString *Version;
/// 版本发布时间
@property (nonatomic,copy) NSString *VersionNum;

#pragma mark UI编码规范【重要】
///【可更改】选择编码标准：1倍（375*667）、2倍（750*1334）【默认值】、3倍（1125*2001）
@property (nonatomic,assign) NSInteger StandardScale;

#pragma mark 状态栏、导航栏、Tab栏 默认显示定义 【可选】
/// 状态栏 的默认显示 YES
@property (nonatomic,assign) BOOL DefaultShowStatus;
/// 有NavController 的默认显示 YES
@property (nonatomic,assign) BOOL DefaultShowNav;
/// 有TabController 的默认显示 YES
@property (nonatomic,assign) BOOL DefaultShowTab;

#pragma mark 导航栏 【可选】
/// 可设定名称 【默认返回文字】
@property (nonatomic,copy) NSString *DefaultNavLeftTitle;
/// 可设定图标 【默认返回图标】
@property (nonatomic,copy) NSString *DefaultNavLeftImage;
#pragma mark 手机屏幕默认的显示方向（默认：竖立） 【可选】
/// 可设定手机屏幕默认的显示方向
@property (nonatomic,assign) UIInterfaceOrientation DefaultOrientation;
/// 可设定手机屏幕默认支持的显示方向
@property (nonatomic,assign) UIInterfaceOrientationMask DefaultOrientationMask;
@end

