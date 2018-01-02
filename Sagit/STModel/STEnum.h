//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#ifndef STEnum_h
#define STEnum_h
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,RootViewControllerType)  {
    RootViewDefaultType,
    RootViewNavigationType,
    RootViewTabBarType
};

typedef NS_ENUM(NSUInteger,XYFlag)  {
    XYNone=0,
    X=1,
    Y=2
};
//!布局时的相对位置（取值的依据为：Left:1 Top:2 Ritht:3 Bottom:4 可以根据值来检测所相对哪些位置）
typedef NS_ENUM(NSUInteger,XYLocation)  {
    Left = 1,
    LeftTop = 12,
    LeftTopRight = 123,
    LeftTopBottom = 124,
    LeftRight = 13,
    LeftBottom = 14,
    LeftBottomRight = 143,
    
    Top = 2,
    TopRight = 23,
    TopBottom = 24,
    TopRightBottom = 234,
    
    Right = 3,
    RightBottom = 34,
    
    Bottom = 4,
    //相对四边
    LeftTopRightBottom = 1234
};

#endif /* Header_h */
