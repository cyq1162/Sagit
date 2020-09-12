//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//

#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>
#import "STFile.h"
#import "STHttp.h"
#import "STCache.h"
#import "STMsgBox.h"
#import "STLocation.h"

//!所有单例的入口，可以扩展此类，来增加不同的方法，达到如：Sagit.Global之类的用法。
@interface Sagit : NSObject
//!单例，目前没啥用。
//+ (instancetype)share;
//@property(nonatomic,weak)UIView* Layout;

//!默认对应于NSCache沙盒目录（用于存档数据到plist文件中）
+(STFile*)File;
//!用于存档到内存的全局唯一字典。
+(STCache*)Cache;
//!用于发起网络请求的单例类,，在STController中时用self.http调用
+(STHttp*)Http;
//!用于弹窗消息的单例类，在STController中时用self.msgBox调用
+(STMsgBox*)MsgBox;
//!用于GPS坐标定位
+(STLocation*)Location;
#pragma mark 扩展一些全局的方法
typedef void (^DelayExecuteBlock)();
//延时N秒后执行
+(void)delayExecute:(double)second onMainThread:(BOOL)onMainThread block:(DelayExecuteBlock)block;
//回主线程处理代码
+(void)runOnMainThread:(DelayExecuteBlock)block;
@end



