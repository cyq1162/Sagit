//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STFile.h"
#import "STHttp.h"
#import "STMessageBox.h"
//!所有单例的入口，可以扩展此类，来增加不同的方法，达到如：Sagit.Globa之类的用法。
@interface Sagit : NSObject
//!用于存档数据到plist文件中
+(STFile*)File;
//!用于存档到内存的全局唯一字典。
+(NSMutableDictionary*)Cache;
//!用于发起网络请求的单例类,，在STController中时用self.http调用
+(STHttp*)Http;
//!用于弹窗消息的单例类，在STController中时用self.box调用
+(STMessageBox*)MsgBox;
@end



