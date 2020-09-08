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
#define STNumString(value)  [@(value) stringValue]
#define STString(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]
//系统的版本号
#define STOSVersion [[[UIDevice currentDevice] systemVersion] doubleValue]
//!为Controller定义的
#define STNew(className) ((UIViewController*)STNewClass([className appendIfNotEndWith:@"Controller"]))
//!为所有的class定义的
#define STNewClass(className) [NSClassFromString(className) new]
//block块中用的引用
#define STWeakSelf __weak typeof(self) selfWeak = self;__weak typeof(selfWeak) this = selfWeak;
#define STWeakObj(o) __weak typeof(o) o##Weak = o;
#define STStrongObj(o) __strong typeof(o) o = o##Weak;
//日志输出。
#define STLog(frame) NSLog(@”%@”, NSStringFromCGRect(frame));
#endif /* Constants_h */
