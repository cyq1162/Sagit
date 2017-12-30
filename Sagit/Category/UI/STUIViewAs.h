//
//  STUIViewAs.h
//  IT恋
//
//  Created by 陈裕强 on 2017/12/30.
//  Copyright © 2017年 Silan Xie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(STUIViewAs)
-(UISwitch*)asSwitch;
-(UIStepper*)asStepper;
-(UIProgressView*)asProgressView;
-(UILabel*)asLabel;
-(UIImageView*)asImageView;
-(UITextField*)asTextField;
-(UITextView*)asTextView;
-(UIButton*)asButton;
-(UIScrollView*)asScrollView;
-(UITableView*)asTableView;
-(UICollectionView*)asCollectionView;
@end
