//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
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
@end
