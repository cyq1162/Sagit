//
//  STDefineDefault.h
//
//  Created by 陈裕强 on 2020/9/11.
//
#pragma mark 以下为UI布局默认值定义：（可使用、可更改[可定义覆盖]）

//状态栏、导航栏、Tab栏 默认显示定义
#ifndef STDefaultShowStatus
        #define STDefaultShowStatus YES // 状态栏 的默认显示
#endif
#ifndef STDefaultShowNav
        #define STDefaultShowNav YES  // 有NavController 的默认显示
#endif
#ifndef STDefaultShowTab
        #define STDefaultShowTab YES  // 有TabController 的默认显示
#endif


//可定义左侧导航栏的【默认文字、或 图标显示】
#ifndef STDefaultForNavLeftTitle
        #define STDefaultForNavLeftTitle @"STEmpty"
#endif
#ifndef STDefaultForNavLeftImage
        #define STDefaultForNavLeftImage nil   //可设定图标名称
#endif


//手机屏幕默认的显示方向（默认：竖立）
#ifndef STDefaultOrientation
        #define STDefaultOrientation UIInterfaceOrientationPortrait  //可设定手机屏幕默认的显示方向
#endif
//手机屏幕默认支持的显示方向（默认：竖立+左右 ）UIInterfaceOrientationMaskPortrait
#ifndef STDefaultOrientationMask
        #define STDefaultOrientationMask UIInterfaceOrientationMaskAllButUpsideDown  //可设定手机屏幕默认支持的显示方向
#endif



