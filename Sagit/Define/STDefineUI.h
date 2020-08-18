//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//




#ifndef STDefineUI_h
#define STDefineUI_h


//选择编码标准：1倍（375*667）、2倍（750*1334）、3倍（1125*2001）
#define STStandardScale 2

#define STStandardWidthPx [UIScreen mainScreen].bounds.size.width*STStandardScale
#define STStandardHeightPx [UIScreen mainScreen].bounds.size.height*STStandardScale

//状态栏、导航栏、Tab栏 默认显示定义
#define STDefaultShowStatus YES //默认显示
#define STDefaultShowNav YES   // 有NavController 的默认显示
#define STDefaultShowTab YES   // 有TabController 的默认显示

#define STIsIPhoneX ([UIScreen mainScreen].bounds.size.height>800)

#define STScreenScale [UIScreen mainScreen].scale
#define STScreeWidthPt [UIScreen mainScreen].bounds.size.width
#define STScreeHeightPt [UIScreen mainScreen].bounds.size.height

#define STScreenWidthPx (STScreeWidthPt<STScreeHeightPt?STStandardWidthPx:STStandardHeightPx)
#define STScreenHeightPx (STScreeWidthPt<STScreeHeightPt?STStandardHeightPx:STStandardWidthPx)

//#define STIsIPhoneX (STScreeWidthPt==812 || STScreeHeightPt==812)

//比例系数 750下的像素 px*比例像素，得到对应的pt
//特别说明，本系素不用能用于frame，因为frame不是标准
#define Xpt (STScreeWidthPt/STScreenWidthPx) // 1242/750
#define Ypt (STScreeHeightPt/STScreenHeightPx) //2208/1334

//pt*比例像素,得到对于750标准下的px(以便后续都是用750标准计算）
#define Xpx (STScreenWidthPx/STScreeWidthPt) // 1242/750
#define Ypx (STScreenHeightPx/STScreeHeightPt) //2208/1334

//得到的是750下转换的像素 88+40+98
#define STNavHeightPt 44.0f
#define STStatusHeightPt (STIsIPhoneX?44.0f:20.0f)
#define STTabHeightPt 49.0f

#define STNavHeightPx STNavHeightPt*Ypx
#define STStatusHeightPx STStatusHeightPt*Ypx
#define STTabHeightPx STTabHeightPt*Ypx

//750,1334        414,736 *3


//全屏
#define STFullRect [UIScreen mainScreen].bounds
#define STFullSize [UIScreen mainScreen].bounds.size
//空屏
#define STEmptyRect CGRectMake(0,0,0,0)

//坐标系
#define STRectMake(x,y,width,height) CGRectMake(x*Xpt,y*Ypt,width*Xpt,height*Ypt)
#define STSizeMake(width,height) CGSizeMake(width*Xpt,height*Ypt)
#define STPointMake(x,y) CGPointMake(x*Xpt,y*Ypt)
#define STRectCopy(frame) CGRectMake(frame.origin.x,frame.origin.y, frame.size.width, frame.size.height);

//定义两个布局的宽高参数 (用于自动布局时可以刷新约束)
#define STSameToWidth  -99990
#define STSameToHeight -99991

#ifndef sagit
//!定义一个可以在view和Controller中共同使用的布局标识
#define sagit self.baseView

#endif

//上一个UI控件的简写
#define STPreView sagit.lastAddView.preView
#define STLastView sagit.lastAddView
#define STLastControl ((UIControl*)STLastView)
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
#define STLastCollectoinView ((UICollectionView*)STLastView)
//获取控件
#define STUIView(name)    [sagit find:name]
#define STSTView(name)    ((STView*)STUIView(name))
#define STControl(name) ((UIControl*)STUIView(name))
#define STButton(name) ((UIButton*)STUIView(name))
#define STTextField(name) ((UITextField*)STUIView(name))
#define STTextView(name) ((UITextView*)STUIView(name))
#define STImageView(name) ((UIImageView*)STUIView(name))
#define STLabel(name) ((UILabel*)STUIView(name))
#define STSwitch(name) ((UISwitch*)STUIView(name))
#define STStepper(name) ((UIStepper*)STUIView(name))
#define STSlider(name) ((UISlider*)STUIView(name))
#define STProgressView(name) ((UIProgressView*)STUIView(name))
#define STTableView(name) ((UITableView*)STUIView(name))
#define STCollectionView(name) ((UICollectionView*)STUIView(name))
#define STFirstTable ((UITableView*)[sagit firstView:@"UITableView"])
#define STFirstCollection ((UICollectionView*)[sagit firstView:@"UICollectionView"])

//获取UI值
# define STValue(name) [STUIView(name) stValue]
# define STSetValue(name,value) [STUIView(name) stValue:value]
# define STSelectValue(name) [STUIView(name) selectValue]
# define STSelectText(name) [STUIView(name) selectText]

//原始图片大小，不需要转
//#define UIEdgeInsetsMake(top, left, bottom, right) UIEdgeInsetsMake(top*Ypt, left*Xpt, bottom*Ypt, right*Xpt)
//(770,100)

//字体像素
#define STFont(px) [UIFont systemFontOfSize:px*Ypt]
//加粗
#define STFontBold(px) [UIFont boldSystemFontOfSize:px*Ypt]
#pragma mark 颜色

//设备颜色
#define STDeviceColor [UIColor hex:@"#f4f4f4"]//米白
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
#define ColorRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define ColorRandom ColorRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

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

//定义一些可被修改的默认值
//定义两个左侧导航的默认值
#ifndef STDefaultForNavLeftTitle
#define STDefaultForNavLeftTitle @"STEmpty"
#endif
#ifndef STDefaultForNavLeftImage
#define STDefaultForNavLeftImage nil
#endif
#ifndef STDefaultForImageView
#define STDefaultForImageView nil
#endif

