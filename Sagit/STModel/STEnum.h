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
typedef NS_ENUM(NSUInteger,XYLocation)  {
    Left,
    LeftTop,
    LeftTopRight,
    LeftTopBottom,
    LeftRight,
    LeftBottom,
    LeftBottomRight,
    
    Top,
    TopRight,
    TopBottom,
    TopRightBottom,
    
    Right,
    RightBottom,
    
    Bottom,
    //相对四边
    LeftTopRightBottom
};

#endif /* Header_h */
