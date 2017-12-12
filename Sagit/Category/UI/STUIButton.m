//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//  起源：IT恋、IT连 创业App http://www.itlinks.cn
//  Copyright © 2017-2027年. All rights reserved.
//

#import "STUIButton.h"
#import <objc/runtime.h>

@implementation UIButton (ST)

static char ActionTag;

- (void)addAction:(onAction)block {
    objc_setAssociatedObject(self, &ActionTag, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addClick:(onAction)block {
    
    [self addAction:block forControlEvents:UIControlEventTouchUpInside];
}

- (void)addAction:(onAction)block forControlEvents:(UIControlEvents)controlEvents {
    objc_setAssociatedObject(self, &ActionTag, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(action:) forControlEvents:controlEvents];
}

- (void)action:(id)sender {
    onAction blockAction = (onAction)objc_getAssociatedObject(self, &ActionTag);
    if (blockAction) {
        blockAction(self);
    }
}
//复盖UIView的方法。
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat widthDelta = MAX(50.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(50.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}
#pragma mark 扩展系统属性
-(UIButton*)backgroundImage:(NSString*)imgName
{
    return [self backgroundImage:imgName forState:UIControlStateNormal];
}
-(UIButton*)backgroundImage:(NSString*)imgName forState:(UIControlState)state
{
    [self setBackgroundImage:STImage(imgName) forState:state];
    return self;
}
-(UIButton*)titleColor:(UIColor*)color
{
    [self titleColor:color forState:UIControlStateNormal];
    return self;
}
-(UIButton*)titleColor:(UIColor*)color forState:(UIControlState)state
{
    [self setTitleColor:color forState:state];
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
