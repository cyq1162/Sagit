//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUIViewAs.h"

@implementation UIView(STUIViewAs)
-(UISwitch*)asSwitch
{
    return (UISwitch*)self;
}
-(UIStepper*)asStepper
{
    return (UIStepper*)self;
}
-(UIProgressView*)asProgressView
{
    return (UIProgressView*)self;
}
-(UILabel*)asLabel
{
    return (UILabel*)self;
}
-(UIImageView*)asImageView
{
    return (UIImageView*)self;
}
-(UITextField*)asTextField
{
    return (UITextField*)self;
}
-(UITextView*)asTextView
{
    return (UITextView*)self;
}
-(UIButton*)asButton
{
    return (UIButton*)self;
}
-(UIScrollView*)asScrollView
{
    return (UIScrollView*)self;
}
-(UITableView*)asTableView
{
    return (UITableView*)self;
}
-(UICollectionView*)asCollectionView
{
    return (UICollectionView*)self;
}
-(UIPickerView*)asPickerView
{
    return (UICollectionView*)self;
}
-(STView *)asSTView
{
    return (STView*)self;
}
-(UIView *)asBaseView
{
    [self key:@"isBaseView" value:@"1"];
    return self;
}
-(UIImage *)asImage
{
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
