//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//!用于存档数据到plist文件中,默认存档沙盒的Library/Cache目录（iTunes不会备份此目录，此目录下文件不会在应用退出删除。一般存放体积比较大，不是特别重要的资源，比如缓存数据。缓存数据在设备低存储空间时可能会被删除。）
@interface STFile : NSObject

//!对应沙盒的Home目录（主目录）
@property (nonatomic,retain) STFile* Home;
//!对应沙盒的Document目录：用于存储用户数据，该目录下的所有文件会进行iCloud或iTunes备份
@property (nonatomic,retain) STFile* Document;
//!对应沙盒的Libaray目录（该路径下的文件夹，除Caches以外，都会被iTunes备份。）
@property (nonatomic,retain) STFile* Libaray;
//!对应沙盒的Tmp目录（目录用于存放临时文件，APP重新启动时会清除这个路径下的文件。该路径下的文件不会被iTunes备份。一般用来保存临时文件，比如:相机拍摄完成时的照片视频都会被暂时保存到这个路径。）
@property (nonatomic,retain) STFile* Temp;
//!存档系统配置信息，对应沙盒的Tmp目录 Library/Preferences（包含应用程序的偏好设置文件。NSUserDefaults就是默认存放在此文件夹下面。）
@property (nonatomic,retain)NSUserDefaults* Setting;
//!存档的文件名（plist）。
@property (readonly,nonatomic,copy) NSString* fileName;


+ (instancetype)share;
//!获取文件的大小(单位：MB)
- (CGFloat)size;
//!清除所有文件缓存
- (void)clear:(void(^)(BOOL success))block;
//!设置文件缓存
- (void)set:(NSString*)key value:(id)value;
//!获取文件缓存
- (id)get:(NSString*)key;
//!移除文件缓存
- (void)remove:(NSString*)key;
@end
