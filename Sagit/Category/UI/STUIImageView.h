//
//  STUIImageView.h
//  IT恋
//
//  Created by 陈裕强 on 2017/12/24.
//  Copyright © 2017年. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView(ST)
//!长按时提示用户保存图片
-(UIImageView*)longPressSave:(BOOL)yesNo;
//!执行保存图片事件
-(UIImageView*)save;
//!设置图片是否圆角
-(UIImageView*)corner:(BOOL)yesNo;
@end
