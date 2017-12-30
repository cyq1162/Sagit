//
//  STUIViewAs.m
//  IT恋
//
//  Created by 陈裕强 on 2017/12/30.
//  Copyright © 2017年 Silan Xie. All rights reserved.
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
@end
