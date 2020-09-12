//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STHttp.h"
#import "STMsgBox.h"
#import "STCategory.h"
#import "STDefineFunc.h"
#import "STSagit.h"

#define Boundary @"sagitframework"
#define Start @"--sagitframework"
#define End @"--sagitframework--"
#define NewLine @"\r\n"

@interface STHttp()<NSURLSessionDelegate>
@property (nonatomic,strong) NSURLSession *session;

@end

@implementation STHttp

-(instancetype)init:(STMsgBox*)msgBox{
    _msgBox=msgBox;
    return self;
}
+(STHttp*)share {
    static STHttp *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [STHttp new];
    });
    return obj;
}
#pragma mark 全局实例
-(NSStringEncoding)defautEncoding
{
    return NSUTF8StringEncoding;
}
-(NSURLSession *)session
{
    if(_session==nil)
    {
        /**NSURLSessionConfiguration(会话配置)
         defaultSessionConfiguration;       // 磁盘缓存,适用于大的文件上传下载
         ephemeralSessionConfiguration;     // 内存缓存,以用于小的文件交互,GET一个头像
         backgroundSessionConfiguration:(NSString *)identifier; // 后台上传和下载      */
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        // config.connectionProxyDictionary=@{ @"HTTPEnable":@YES,@"HTTPProxy":@"192.168.0.116", @"HTTPPort":@(8888)};
        _session=[NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue new]];
    }
    return _session;
}
-(NSMutableURLRequest*)createRequest:(NSString*)method url:(NSString*)url timeout:(NSInteger)timeout
{
    url=[self globalSetUrl:url];
    NSURL *nsUrl=[NSURL URLWithString:url];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeout];
    request.HTTPMethod=method;
    [self globalHeader:request];
    return request;
}
#pragma mark 调用方法
-(void)get:(NSString *)url paras:(NSDictionary *)paras success:(Success)success
{
    [self get:url paras:paras before:nil success:success error:nil];
}
-(void)get:(NSString *)url paras:(NSDictionary *)paras success:(Success)success error:(Error)error{
    [self get:url paras:paras before:nil success:success error:error];
}
-(void)get:(NSString *)url paras:(NSDictionary *)paras before:(Before)before success:(Success)success
{
    [self get:url paras:paras before:before success:success error:nil];
}
- (void)get:(NSString *)url paras:(NSDictionary *)paras before:(Before)before success:(Success)success error:(Error)error{
    url=[self reSetGetUrl:url paras:paras];
    NSMutableURLRequest *request=[self createRequest:@"GET" url:url timeout:10];
    [self exeTask:request before:before success:success error:error];
}
-(void)post:(NSString *)url paras:(NSDictionary *)paras success:(Success)success
{
    [self post:url paras:paras before:nil success:success error:nil];
}
- (void)post:(NSString *)url paras:(NSDictionary *)paras success:(Success)success error:(Error)error
{
    [self post:url paras:paras before:nil success:success error:error];
}
-(void)post:(NSString *)url paras:(NSDictionary *)paras before:(Before)before success:(Success)success
{
    [self post:url paras:paras before:before success:success error:nil];
}
-(void)post:(NSString *)url paras:(NSDictionary *)paras before:(Before)before success:(Success)success error:(Error)error
{
    NSMutableURLRequest *request=[self createRequest:@"POST" url:url timeout:20];
    [request setHTTPBody:[self toPostData:paras]];
    [self exeTask:request before:before success:success error:error];
}

-(void)upload:(NSString *)url paras:(id)dicOrNSData success:(Success)success
{
    [self upload:url paras:dicOrNSData before:nil success:success error:nil];
}
-(void)upload:(NSString *)url paras:(id)dicOrNSData success:(Success)success error:(Error)error{
    [self upload:url paras:dicOrNSData before:nil success:success error:error];
}
-(void)upload:(NSString *)url paras:(id)dicOrNSData before:(Before)before success:(Success)success{
    [self upload:url paras:dicOrNSData before:before success:success error:nil];
}
-(void)upload:(NSString *)url paras:(id)dicOrNSData before:(Before)before success:(Success)success error:(Error)error
{
    NSDictionary *paras=nil;
    if([paras isKindOfClass:[NSData class]])
    {
        paras=@{@"img":dicOrNSData};
    }
    else
    {
        paras=dicOrNSData;
    }
    
    NSMutableURLRequest *request=[self createRequest:@"POST" url:url timeout:20];
    [request addValue:[@"multipart/form-data; boundary=" append:Boundary] forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[self toUploadData:paras]];
    [self exeTask:request before:before success:success error:error];
    
}
-(void)exeTask:(NSMutableURLRequest*)request before:(Before)before success:(Success)success error:(Error)error{
    if(before!=nil)
    {
        before(request);
        before = nil;
    }
    [self showLoading];
    NSURLSessionDataTask *task= [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable err) {
        if(err!=nil)
        {
            [self onError:err error:error];
        }
        else
        {
            if(data==nil || data.length==0)
            {
                [self onSucess:@{@"success":@"YES",@"msg":@""} success:success];
                return;
            }
            NSDictionary *dic=nil;
            NSString *result=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if([result startWith:@"{"] && [result endWith:@"}"])
            {
                dic= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            }
            else if([result startWith:@"["] && [result endWith:@"]"])
            {
                NSArray<NSDictionary*> *array=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                dic=@{@"success":@"YES",@"msg":array};
            }
            else
            {
                dic= @{@"success":@"YES",@"msg":result};
            }
            [self onSucess:dic success:success];
        }
        
        
    }];
    [task resume];
    
}

-(void)onSucess:(NSDictionary*) response success:(Success)success
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self hideLoading];
        if(success!=nil)
        {
            STHttpModel *model=[[STHttpModel alloc] initWithObject:response];
            success(model);
        }
    });
    if(success)
    {
        success=nil;
    }
}
-(void)onError:(NSError*)errorMsg error:(Error)error
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self hideLoading];
        if(error!=nil)
        {
            error([NSString toString:errorMsg]);
        }
        else
        {
            [self showError:[NSString toString:errorMsg]];
        }
    });
    if(error)
    {
        error=nil;
    }
}
//可以扩展此方法，以便增加初始的请求头。
-(void)globalHeader:(NSMutableURLRequest*)request{}
-(NSString*)globalSetUrl:(NSString*)url{return url;}
-(NSString*)reSetGetUrl:(NSString*)url paras:(NSDictionary*)paras
{
    if(paras!=nil && paras.count>0)
    {
        NSString *query=@"";
        for (NSString *key in paras) {
            query=[query append:STString(@"&%@=%@",key,paras[key])];
        }
        if(![url contains:@"?"])
        {
            url=[url append:@"?"];
            url=[url append:[query trimStart:@"&"]];
        }
        else
        {
            url=[url append:query];
        }
    }
    return  url;
}

-(void)showLoading{
    if(self.msgBox!=nil){[self.msgBox loading];}
}
-(void)hideLoading{
    if(self.msgBox!=nil){[self.msgBox hideLoading];}
}
-(void)showError:(NSString*)errMsg
{
    if(self.msgBox!=nil)
    {
        [self.msgBox alert:[@"网络连接错误:" append:errMsg]];
    }
    else{
        [Sagit.MsgBox alert:[@"网络连接错误:" append:errMsg]];
    }
}
#pragma mark 特殊字符处理
//文件、图片上传。
- (NSData *)toUploadData:(NSDictionary *)paras{
    NSMutableData *postData=[NSMutableData new];
    if(paras)
    {
        for (NSString*key in paras) {
            id v=paras[key];
            if([v isKindOfClass:[NSData class]])
            {
                [postData appendData:[self getImageBody:v imgName:key]];
            }
            else
            {
                [postData appendData:[self getStringBody:key v:v]];
            }
        }
        //10.请求体的结束 --AaB03x
        [postData appendData:[self toNsData:End]];
        //11.换行
        [postData appendData:[self toNsData:NewLine]];
        
    }
    return postData;
}
- (NSData*)toPostData:(NSDictionary *)params{
    if(params==nil || params.count==0){return nil;}
    NSMutableString *returnValue = [[NSMutableString alloc]initWithCapacity:0];
    
    NSArray *paramsAllKeys = [params allKeys];
    for(int i = 0;i < paramsAllKeys.count;i++)
    {
        NSString *value=STString(@"%@",[params objectForKey:[paramsAllKeys objectAtIndex:i]]);
        [returnValue appendFormat:@"%@=%@",[paramsAllKeys objectAtIndex:i],[self encodeURIComponent:value]];
        if(i < paramsAllKeys.count - 1)
        {
            [returnValue appendString:@"&"];
        }
    }
    return [self toNsData:returnValue];
}
//特殊字符处理
-(NSString*)encodeURIComponent:(NSString*)str{
    
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)str, NULL, (__bridge CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}

#pragma mark -------开始拼接 ---------
-(NSMutableData*)getStringBody:(NSString*)key v:(NSString*)v
{
    NSMutableData *bodyData=[NSMutableData new];
    [bodyData appendData:[self toNsData:Start]];
    [bodyData appendData:[self toNsData:NewLine]];
    NSString *contentDisposition=STString(@"Content-Disposition: form-data; name=\"%@\"",key);
    //3.设置数据对应的字段
    [bodyData appendData:[self toNsData:contentDisposition]];
    [bodyData appendData:[self toNsData:NewLine]];
    [bodyData appendData:[self toNsData:NewLine]];
    [bodyData appendData:[self toNsData:v]];
    [bodyData appendData:[self toNsData:NewLine]];
    return bodyData;
}
-(NSMutableData*)getImageBody:(NSData*) imgData imgName:(NSString*)imgName
{
    NSString *contentType=@"Content-Type: image/";
    if(imgName==nil)
    {
        imgName=@"img.jpg";
    }
    else if(![imgName contains:@"."])
    {
        imgName= [imgName append:@".jpg"];
    }
    contentType=[contentType append:[imgName pathExtension]];
    NSMutableData *bodyData=[NSMutableData new];
    //1.请求体的开始 --AaB03x
    [bodyData appendData:[self toNsData:Start]];
    
    //2.换行
    [bodyData appendData:[self toNsData:NewLine]];
    
    NSString *contentDisposition=STString(@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"",[imgName stringByDeletingPathExtension],imgName);
    //3.设置数据对应的字段
    [bodyData appendData:[self toNsData:contentDisposition]];
    
    //4.换行
    [bodyData appendData:[self toNsData:NewLine]];
    
    //5.设置文件的类型image/png   image/jpeg video/mp4
    [bodyData appendData:[self toNsData:contentType]];
    
    //6.换行
    [bodyData appendData:[self toNsData:NewLine]];
    
    //7.换行 真正的数据开始
    [bodyData appendData:[self toNsData:NewLine]];
    
    //8.设置数据
    [bodyData appendData:imgData];
    
    //9.换行 设置数据完毕
    [bodyData appendData:[self toNsData:NewLine]];
    
    
    return bodyData;
}
-(NSData*)toNsData:(NSString*)str
{
    return [str dataUsingEncoding:self.defautEncoding];
}
#pragma mark -------回调事件 ---------

@end
