//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STModelBase.h"

@interface STModel : STModelBase
@property (nonatomic, assign) BOOL success;
@property (retain, nonatomic) id<NSObject> msg;
//将msg转成dictionary返回
@property (retain, nonatomic,readonly) NSDictionary* msgDic;
//将msg转成string返回
@property (copy, nonatomic,readonly) NSString* msgString;
@end


