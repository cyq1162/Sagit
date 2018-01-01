//
//  STUISwitch.m
//  IT恋
//
//  Created by 陈裕强 on 2018/1/1.
//  Copyright © 2018年 Silan Xie. All rights reserved.
//

#import "STUISwitch.h"

@implementation UISwitch(ST)
-(UISwitch*)on:(BOOL)yesNo
{
    [self setOn:yesNo];
    return self;
}
-(UISwitch*)tintColor:(id)colorOrHex
{
    self.tintColor=[self toColor:colorOrHex];
    return self;
}
-(UISwitch*)onTintColor:(id)colorOrHex
{
    self.onTintColor=[self toColor:colorOrHex];
    return self;
}
-(UISwitch*)enabled:(BOOL)yesNo
{
    [self setEnabled:yesNo];
    return self;
}
-(UISwitch*)onImage:(id)imgOrName
{
    [self setOnImage:[self toImage:imgOrName]];
    return self;
}
-(UISwitch*)offImage:(id)imgOrName
{
    [self setOffImage:[self toImage:imgOrName]];
    return self;
}

#pragma mark 事件
-(UIView *)onSwitch:(onSwitch)block
{
    [self onAction:UIControlEventValueChanged on:block];
    return self;
}
@end
