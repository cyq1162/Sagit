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
//!获取图片的地址
-(NSString*)url;
//!为图片设置一个网络地址 （默认超过256K时会进行压缩）
-(UIImageView*)url:(NSString*)url;
//!为图片设置一个网络地址 maxKb 指定超过大小时压缩显示（设置为0不压缩）
-(UIImageView *)url:(NSString *)url maxKb:(NSInteger)compress;

#pragma mark 扩展属性
-(UIImageView*)image:(id)imgOrName;

@end

@interface UIImage(ST)
//!获取图片压缩后的字节数据，当前图片不受变化
-(NSData*)compress:(NSInteger)maxKb;
//!将图片压缩到指定的宽高，当前图片受变化
-(UIImage*)reSize:(CGSize)maxSize;
@end
