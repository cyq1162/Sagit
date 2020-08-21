//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STHttpModel.h"
#import "STMsgBox.h"

typedef void(^Success)(STHttpModel *result);
typedef void(^Error)(NSString *errMsg);
typedef void(^Before)(NSMutableURLRequest *request);

//!提供基础的网络请求（get、post、upload(图片上传））
@interface STHttp : NSObject
//!消息弹窗。
@property (nonatomic,strong) STMsgBox *msgBox;
//!请求的默认编码：默认Utf8
@property (nonatomic,assign) NSStringEncoding defautEncoding;

- (instancetype)init:(STMsgBox*)msgBox;
+ (STHttp*)share;
#pragma mark 调用方法
- (void)get:(NSString *)url paras:(NSDictionary *)paras success:(Success)succese;
- (void)get:(NSString *)url paras:(NSDictionary *)paras success:(Success)success error:(Error)error;
- (void)get:(NSString *)url paras:(NSDictionary *)paras before:(Before)before  success:(Success)success;
- (void)get:(NSString *)url paras:(NSDictionary *)paras before:(Before)before success:(Success)success error:(Error)error;

- (void)post:(NSString *)url paras:(NSDictionary *)paras success:(Success)success;
- (void)post:(NSString *)url paras:(NSDictionary *)paras success:(Success)success error:(Error)error;
- (void)post:(NSString *)url paras:(NSDictionary *)paras before:(Before)before success:(Success)success;
- (void)post:(NSString *)url paras:(NSDictionary *)paras before:(Before)before success:(Success)success error:(Error)error;

- (void)upload:(NSString *)url paras:(id)dicOrNSData success:(Success)success;
- (void)upload:(NSString *)url paras:(id)dicOrNSData success:(Success)success error:(Error)error;
- (void)upload:(NSString *)url paras:(id)dicOrNSData before:(Before)before success:(Success)success;
- (void)upload:(NSString *)url paras:(id)dicOrNSData before:(Before)before success:(Success)success error:(Error)error;

#pragma mark 全局可覆盖方法
//!全局追加默认请求头（覆盖方法）
-(void)globalHeader:(NSMutableURLRequest*)request;
//!全局修改默认请求URL（覆盖方法）
-(NSString*)globalSetUrl:(NSString*)url;
@end
