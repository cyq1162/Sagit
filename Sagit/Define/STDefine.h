//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#ifndef STDefine_h
#define STDefine_h

#pragma mark 函数

//将字符从大写转化成小写
#define STCharLower(c)      ((c >= 'A' && c <= 'Z') ? (c | 0x20) : c)
//将字符从小写转化成大写
#define STCharUpper(c)      ((c >= 'a' && c <= 'z') ? (c & ~0x20) : c)
//数字转字符串
#define STToString(value)  ([NSString stringWithFormat: @"%ld", value]);
//系统的版本号
#define STOSVersion [[[UIDevice currentDevice] systemVersion] doubleValue]

#endif /* Constants_h */
