//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STHttpModel.h"
#import "STMsgBox.h"

typedef void(^OnSuccess)(STHttpModel *result);
typedef void(^OnError)(NSString *errMsg);
typedef void(^OnBefore)(NSMutableURLRequest *request);

//!提供基础的网络请求（get、post、upload(图片上传））
@interface STHttp : NSObject
//!消息弹窗。
@property (nonatomic,strong) STMsgBox *msgBox;
//!请求的默认编码：默认Utf8
@property (nonatomic,assign) NSStringEncoding defautEncoding;

- (instancetype)init:(STMsgBox*)msgBox;
+ (STHttp*)share;
#pragma mark 调用方法
- (void)get:(NSString *)url paras:(NSDictionary *)paras success:(OnSuccess)succese;
- (void)get:(NSString *)url paras:(NSDictionary *)paras success:(OnSuccess)success error:(OnError)error;
- (void)get:(NSString *)url paras:(NSDictionary *)paras before:(OnBefore)before  success:(OnSuccess)success;
- (void)get:(NSString *)url paras:(NSDictionary *)paras before:(OnBefore)before success:(OnSuccess)success error:(OnError)error;

- (void)post:(NSString *)url paras:(NSDictionary *)paras success:(OnSuccess)success;
- (void)post:(NSString *)url paras:(NSDictionary *)paras success:(OnSuccess)success error:(OnError)error;
- (void)post:(NSString *)url paras:(NSDictionary *)paras before:(OnBefore)before success:(OnSuccess)success;
- (void)post:(NSString *)url paras:(NSDictionary *)paras before:(OnBefore)before success:(OnSuccess)success error:(OnError)error;

- (void)upload:(NSString *)url paras:(id)dicOrNSData success:(OnSuccess)success;
- (void)upload:(NSString *)url paras:(id)dicOrNSData success:(OnSuccess)success error:(OnError)error;
- (void)upload:(NSString *)url paras:(id)dicOrNSData before:(OnBefore)before success:(OnSuccess)success;
- (void)upload:(NSString *)url paras:(id)dicOrNSData before:(OnBefore)before success:(OnSuccess)success error:(OnError)error;

#pragma mark 全局可覆盖方法
//!全局追加默认请求头（覆盖方法）
-(void)globalHeader:(NSMutableURLRequest*)request;
//!全局修改默认请求URL（覆盖方法）
-(NSString*)globalSetUrl:(NSString*)url;
@end
