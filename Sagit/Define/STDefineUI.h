//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

//#import "STUITableView.h"
#ifndef STDefineUI_h
#define STDefineUI_h


//全屏 以IPhone6的像素为标准参考 750*1334

#define STScreenScale [UIScreen mainScreen].scale
#define STScreeWidthPt [UIScreen mainScreen].bounds.size.width
#define STScreeHeightPt [UIScreen mainScreen].bounds.size.height

#define STScreenWidthPx (STScreeWidthPt<STScreeHeightPt?750:1334)
#define STScreenHeightPx (STScreeWidthPt<STScreeHeightPt?1334:750)

//比例系数 750下的像素 px*比例像素，得到对应的pt
//特别说明，本系素不用能用于frame，因为frame不是标准
#define Xpt (STScreeWidthPt/STScreenWidthPx) // 1242/750
#define Ypt (STScreeHeightPt/STScreenHeightPx) //2208/1334

//pt*比例像素,得到对于750标准下的px(以便后续都是用750标准计算）
#define Xpx (STScreenWidthPx/STScreeWidthPt) // 1242/750
#define Ypx (STScreenHeightPx/STScreeHeightPt) //2208/1334

//得到的是750下转换的像素
#define STNavHeightPx 44.0f*Ypx
#define STStatusBarHeightPx 20.0f*Ypx
#define STToolBarHeightPx 49.0f*Ypx

//750,1334        414,736 *3


//全屏
#define STFullRect [UIScreen mainScreen].bounds
#define STFullSize [UIScreen mainScreen].bounds.size
//空屏
#define STEmptyRect CGRectMake(0,0,0,0)


#define STRectMake(x,y,width,height) CGRectMake(x*Xpt,y*Ypt,width*Xpt,height*Ypt)
#define STSizeMake(width,height) CGSizeMake(width*Xpt,height*Ypt)
#define STPointMake(x,y) CGPointMake(x*Xpt,y*Ypt)

#define STRectCopy(frame) CGRectMake(frame.origin.x,frame.origin.y, frame.size.width, frame.size.height);

//上一个UI控件的简写
#define STPreView self.stView.lastAddView.preView
#define STLastView self.stView.lastAddView
#define STLastButton ((UIButton*)STLastView)
#define STLastTextField ((UITextField*)STLastView)
#define STLastTextView ((UITextView*)STLastView)
#define STLastImageView ((UIImageView*)STLastView)
#define STLastLabel ((UILabel*)STLastView)
#define STLastSwitch ((UISwitch*)STLastView)
#define STLastStepper ((UIStepper*)STLastView)
#define STLastSlider ((UISlider*)STLastView)
#define STLastProgressView ((UIProgressView*)STLastView)
#define STLastTableView ((UITableView*)STLastView)

//获取控件
#define STSTView(name)    ((STView*)self.stView.UIList[name])
#define STButton(name) ((UIButton*)self.stView.UIList[name])
#define STTextField(name) ((UITextField*)self.stView.UIList[name])
#define STTextView(name) ((UITextView*)self.stView.UIList[name])
#define STImageView(name) ((UIImageView*)self.stView.UIList[name])
#define STLabel(name) ((UILabel*)self.stView.UIList[name])
#define STSwitch(name) ((UISwitch*)self.stView.UIList[name])
#define STStepper(name) ((UIStepper*)self.stView.UIList[name])
#define STSlider(name) ((UISlider*)self.stView.UIList[name])
#define STProgressView(name) ((UIProgressView*)self.stView.UIList[name])
#define STTableView(name) ((UITableView*)self.stView.UIList[name])
#define STFirstTable ((UITableView*)[self.stView firstView:@"UITableView"])
//#define STSTTable(name) ((STTable*)self.stView.UIList[name])

//原始图片大小，不需要转
//#define UIEdgeInsetsMake(top, left, bottom, right) UIEdgeInsetsMake(top*Ypt, left*Xpt, bottom*Ypt, right*Xpt)
//(770,100)

//字体
#define STFont(px) [UIFont systemFontOfSize:px*Ypt]

#pragma mark 颜色
//颜色
#define STColor(color) [UIColor hex:color]

#define ColorBlack [UIColor blackColor]      // 0.0 white
#define ColorBlue [UIColor blueColor]
#define ColorDarkGray [UIColor darkGrayColor]
#define ColorLightGray [UIColor lightGrayColor]
#define ColorWhite [UIColor whiteColor]
#define ColorGray [UIColor grayColor]
#define ColorRed [UIColor redColor]
#define ColorGreen [UIColor greenColor]
#define ColorCyan [UIColor cyanColor]
#define ColorYellow [UIColor yellowColor]
#define ColorMagenta [UIColor magentaColor]
#define ColorOrange [UIColor orangeColor]
#define ColorPurple [UIColor purpleColor]
#define ColorBrown [UIColor brownColor]
#define ColorClear [UIColor clearColor]


//导航栏的参数
#define STNavConfig @"STNavConfig"
#define STNavLeftTitle @"STNavLeftTitle"
#define STNavLeftImage @"STNavLeftImage"
#define STNavTitle @"STNavTitle"
#define STNavRightTitle @"STNavRightTitle"
#define STNavRightImage @"STNavRightImage"

//图片
#define STImage(imgName) [UIImage imageNamed:imgName]
#define STImageOriginal(imgName) [[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
#endif /* STDefineUI_h */
