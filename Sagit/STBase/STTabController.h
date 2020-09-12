//
//  STTabController.h
//
//  Created by 陈裕强 on 2017/12/24.
//  Copyright © 2017年. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STTabController : UITabBarController
//!事件在UI初始化之前执行
-(void)onInit;
//!UI初始化
-(void)initUI;
//!事件在UI初始化之后执行
-(void)initData;

#pragma mark 系统的2个事件方法
//呈现UI之前【执行N次】
-(void)beforeViewAppear;
//UI消失之前【执行N次】
-(void)beforeViewDisappear;

@end
