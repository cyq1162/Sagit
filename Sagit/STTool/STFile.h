//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//!用于存档数据到plist文件中,默认存档沙盒的Library/Cache目录
@interface STFile : NSObject

//!对应沙盒的Home目录
@property (nonatomic,retain) STFile* Home;
//!对应沙盒的Document目录
@property (nonatomic,retain) STFile* Document;
//!对应沙盒的Libaray目录
@property (nonatomic,retain) STFile* Libaray;
//!对应沙盒的Tmp目录
@property (nonatomic,retain) STFile* Temp;
//!存档系统配置信息，对应沙盒的Tmp目录 Library/Preferences
@property (nonatomic,retain)NSUserDefaults* Setting;
//!存档的文件名。
@property (readonly,nonatomic,copy) NSString* fileName;


+ (instancetype)share;
//!获取文件的大小
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
