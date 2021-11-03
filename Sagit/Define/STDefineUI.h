//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//





#ifndef STStandardScale
    //【可手动更改，也可代码修改】选择编码标准：1倍（375*667）、2倍（750*1334）【默认】、3倍（1125*2001）
    #define STStandardScale Sagit.Define.StandardScale
#endif



#ifndef STDefineUI_h//
#define STDefineUI_h


#pragma mark 以下为UI布局定义：（可使用、而不可更改）

//-其他：
//iphone se分辨率：320 * 568  640 *1136
//iphone 6s分辨率：375 * 667  750 *1334  ----多数机型、设计稿。
//iphone xs分辨率：375 * 812  1125 *2436
//ip xs max分辨率：414 * 896  1242 *2688

//定义私有变量
#define _STScreenScale [UIScreen mainScreen].scale
#define _STScreenSize [UIScreen mainScreen].bounds.size
#define _STIsIPhoneX (_STScreenSize.height>800 || _STScreenSize.width>800)
#define _STIsLandscape (_STScreenSize.width>_STScreenSize.height)

//当前屏幕的参数
//#define STScreeWidthPt _STScreenSize.width
//#define STScreeHeightPt _STScreenSize.height


//特别说明，本系素不用能用于frame，因为frame不是标准
#define _STStandardWidthPt 375
#define _STStandardHeightPt (_STIsIPhoneX?812:667)//;[UIView stStandardHeightPt:self]
#define _STStandardWidthPx (_STStandardWidthPt*STStandardScale)
#define _STStandardHeightPx (_STStandardHeightPt*STStandardScale)

//用于表示全屏（标准px)
#define STScreenWidthPx (!_STIsLandscape?_STStandardWidthPx:_STStandardHeightPx)
#define STScreenHeightPx (!_STIsLandscape?_STStandardHeightPx:_STStandardWidthPx)

//比例系数 (标准)像素px*比例系数，得到对应的pt
#define Xpt (_STScreenSize.width/STScreenWidthPx) // 1242/750
#define Ypt (_STScreenSize.height/STScreenHeightPx) //2208/1334

//比例系数  pt*比例系数,得到对应的px(标准)
#define Xpx (STScreenWidthPx/_STScreenSize.width) // 1242/750    320 *
#define Ypx (STScreenHeightPx/_STScreenSize.height) //2208/1334


//得到的是750下转换的像素 88+40+98
#define STNavHeightPt 44.0f
#define STStatusHeightPt (_STIsIPhoneX?44.0f:20.0f)
#define STTabHeightPt 49.0f

//固定的，不会被等比而改变。
#define STNavHeightPx STNavHeightPt*STStandardScale
#define STStatusHeightPx STStatusHeightPt*STStandardScale
#define STTabHeightPx STTabHeightPt*STStandardScale

//750,1334        414,736 *3


//全屏
#define STFullRect [UIScreen mainScreen].bounds
#define STFullSize [UIScreen mainScreen].bounds.size
//空屏
#define STEmptyRect CGRectMake(0,0,0,0)

//坐标系
#define STRectMake(x,y,width,height) CGRectMake(round(x*Xpt),round(y*Ypt),round(width*Xpt),round(height*Ypt))
#define STSizeMake(width,height) CGSizeMake(round(width*Xpt),round(height*Ypt))
#define STPointMake(x,y) CGPointMake(round(x*Xpt),round(y*Ypt))
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
#define STLastScrollView ((UIScrollView*)STLastView)

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
#define STFirstScroll ((UIScrollView*)[sagit firstView:@"UIScrollView"])

//获取UI值
# define STValue(name) [STUIView(name) stValue]
# define STGetValue(name) [STUIView(name) stValue]
# define STSetValue(name,value) [STUIView(name) stValue:value]
# define STSelectValue(name) [STUIView(name) selectValue]
# define STSelectText(name) [STUIView(name) selectText]

//原始图片大小，不需要转
//#define UIEdgeInsetsMake(top, left, bottom, right) UIEdgeInsetsMake(top*Ypt, left*Xpt, bottom*Ypt, right*Xpt)
//(770,100)

//字体像素
#define STFont(px) [UIFont toFont:px]
//加粗
#define STFontBold(px) [UIFont boldSystemFontOfSize:px*Ypt]
#pragma mark 颜色

//设备颜色
//#define STDeviceColor [UIColor hex:@"#f4f4f4"]//米白
#define ColorDevice [UIColor hex:@"#f4f4f4"]//米白
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
