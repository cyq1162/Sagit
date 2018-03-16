//
//  STUIWindow.h
//  IT恋
//
//  Created by 陈裕强 on 2018/1/24.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (ST)
-(instancetype)initWithBackgoundColor:(id)colorOrHex;
//当前编辑的文本框
@property (nonatomic,retain) UIView *editingTextUI;
@property (nonatomic,assign) CGFloat keyboardHeight;
@end

