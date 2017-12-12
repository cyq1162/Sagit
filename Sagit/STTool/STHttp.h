//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STModel.h"
#import "STMessageBox.h"

typedef void(^Success)(STModel *result);
typedef void(^Error)(NSString *errMsg);

@interface STHttp : NSObject

@property (nonatomic,strong) STMessageBox *box;

- (instancetype)init:(STMessageBox*)box;
- (void)get:(NSString *)url paras:(NSDictionary *)paras success:(Success)succese;
- (void)get:(NSString *)url paras:(NSDictionary *)paras success:(Success)success error:(Error)error;

- (void)post:(NSString *)url paras:(NSDictionary *)paras success:(Success)success;
- (void)post:(NSString *)url paras:(NSDictionary *)paras success:(Success)success error:(Error)error;

- (void)upload:(NSString *)url data:(NSData *)data success:(Success)success;
- (void)upload:(NSString *)url data:(NSData *)data success:(Success)success error:(Error)error;

- (void)upload:(NSString *)url paras:(NSDictionary *)paras success:(Success)success;
- (void)upload:(NSString *)url paras:(NSDictionary *)paras success:(Success)success error:(Error)error;
- (void)setHeader:(NSString*)key v:(NSString*)value;

+ (instancetype)share;
+ (instancetype)shareWithLoading;
-(void)networkState;
@end
