//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUIButton.h"
//#import <objc/runtime.h>
#import "STDefineUI.h"
@implementation UIButton (ST)

//static char ActionTag;
//
//- (void)addAction:(onAction)block {
//    objc_setAssociatedObject(self, &ActionTag, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
//    [self addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
//}
//
//- (void)addClick:(onAction)block {
//    
//    [self addAction:block forControlEvents:UIControlEventTouchUpInside];
//}
//
//- (void)addAction:(onAction)block forControlEvents:(UIControlEvents)controlEvents {
//    objc_setAssociatedObject(self, &ActionTag, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
//    [self addTarget:self action:@selector(action:) forControlEvents:controlEvents];
//}
//
//- (void)action:(id)sender {
//    onAction blockAction = (onAction)objc_getAssociatedObject(self, &ActionTag);
//    if (blockAction) {
//        blockAction(self);
//    }
//}
//复盖UIView的方法。
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
//    CGRect bounds = self.bounds;
//    //若原热区小于44x44，则放大热区，否则保持原大小不变
//    CGFloat widthDelta = MAX(50.0 - bounds.size.width, 0);
//    CGFloat heightDelta = MAX(50.0 - bounds.size.height, 0);
//    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
//    return CGRectContainsPoint(bounds, point);
//}
#pragma mark 扩展系统属性
-(UIButton*)backgroundImage:(NSString*)imgName
{
    [self setBackgroundImage:STImage(imgName) forState:UIControlStateNormal];
    return self;
}
-(UIButton*)backgroundImage:(NSString*)imgName forState:(UIControlState)state
{
    [self setBackgroundImage:STImage(imgName) forState:state];
    return self;
}
-(UIButton*)image:(NSString*)imgName
{
    [self setImage:STImage(imgName) forState:UIControlStateNormal];
    return self;
}
-(UIButton*)image:(NSString*)imgName forState:(UIControlState)state
{
    [self setImage:imgName forState:state];
    return self;
}
-(UIButton*)title:(NSString*)title
{
    [self setTitle:title forState:UIControlStateNormal];
    return self;
}
-(UIButton*)title:(NSString*)title forState:(UIControlState)state
{
    [self setTitle:title forState:state];
    return self;
}
-(UIButton*)titleColor:(id)colorOrHex
{
    [self titleColor:colorOrHex forState:UIControlStateNormal];
    return self;
}
-(UIButton*)titleColor:(id)colorOrHex forState:(UIControlState)state
{
    [self setTitleColor:[self toColor:colorOrHex] forState:state];
    return self;
}
-(UIButton*)titleFont:(NSInteger)px
{
    self.titleLabel.font=STFont(px);
    return self;
}
//-(UIButton*)buttonType:(UIButtonType)type
//{
//    self.buttonType=type;
//    return self;
//}
@end
