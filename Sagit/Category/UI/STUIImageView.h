//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView(ST)<UIImagePickerControllerDelegate>

typedef void (^OnPick)(NSData *data,UIImagePickerController *picker,NSDictionary<NSString *,id> *info);
//typedef void (^AfterSetImageUrl)(UIImageView* img);
//!长按时提示用户保存图片
-(UIImageView*)longPressSave:(BOOL)yesNo;
//!执行保存图片事件
-(void)save;
//!设置图片是否圆角
-(UIImageView*)corner:(BOOL)yesNo;
//!获取图片的地址
-(NSString*)url;
//!为图片设置一个网络地址 （默认超过256K时会进行压缩）
-(UIImageView*)url:(NSString*)url;
//!为图片设置一个网络地址 （默认超过256K时会进行压缩）afterSet为设置后的回调函数
//-(UIImageView *)url:(NSString *)url after:(AfterSetImageUrl)block;
//!为图片设置一个网络地址 （默认超过256K时会进行压缩）default:设置一张默认图片
-(UIImageView *)url:(NSString *)url default:(id)imgOrName;
//!为图片设置一个网络地址 maxKb 指定超过大小时压缩显示（设置为0不压缩）
//-(UIImageView *)url:(NSString *)url maxKb:(NSInteger)compress;
//!为图片设置一个网络地址 （默认超过256K时会进行压缩） maxKb 指定超过大小时压缩显示（设置为0不压缩） default:设置一张默认图片
-(UIImageView *)url:(NSString *)url  default:(id)imgOrName maxKb:(NSInteger)compress;
//!为图片设置一个网络地址 （默认超过256K时会进行压缩） maxKb 指定超过大小时压缩显示（设置为0不压缩） default:设置一张默认图片 afterSet为设置后的回调函数
//-(UIImageView *)url:(NSString *)url maxKb:(NSInteger)compress default:(id)imgOrName after:(AfterSetImageUrl)block;
//!图片选择 edit:是否出现裁剪框
-(UIImageView*)pick:(OnPick)pick edit:(BOOL)yesNo;
//!图片选择 edit:是否出现裁剪框 maxKb:指定压缩的大小
-(UIImageView*)pick:(OnPick)pick edit:(BOOL)yesNo maxKb:(NSInteger)maxKb;

//!将图片压缩到指定的宽高，当前图片受变化
-(UIImageView*)reSize:(CGSize)maxSize;
#pragma mark 扩展属性
//!获取图片的名称
-(NSString*)imageName;
-(UIImageView*)image:(id)imgOrName;
#pragma mark 浏览查看大图、（去掉第3方图片查看）
//!双击切换放大查看
-(void)zoom;
-(UIImageView *)zoom:(BOOL)yesNo;
//!点击发大查看
-(void)show;
-(UIImageView *)show:(BOOL)yesNo;
+(void)show:(NSInteger)startIndex images:(id)imgOrNameOrArray,...NS_REQUIRES_NIL_TERMINATION;
#pragma mark 本地验证码
-(NSString*)VerifyCode;
//!生成指定长度验证码（随机背景色）。
-(UIImageView*)VerifyCode:(NSInteger)length;
//!生成指定长度验证码（指定背景色，随机字体颜色）。
-(UIImageView*)VerifyCode:(NSInteger)length fixBgColor:(id)fixBgColor;
//!生成指定长度验证码（指定背景色，指定字体颜色）。
-(UIImageView *)VerifyCode:(NSInteger)length fixBgColor:(id)fixBgColor fixFontColor:(id)fixFontColor;
@end
