//
//  开源：https://github.com/cyq1162/Sagit
//  作者：陈裕强 create on 2017/12/12.
//  博客：(昵称：路过秋天） http://www.cnblogs.com/cyq1162/
//
//  Copyright © 2017-2027年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "STEnum.h"

@interface STLayoutTracer : NSObject
@property (nonatomic, weak) UIView* view;
@property (nonatomic,assign) XYLocation location;
@property (nonatomic,assign) XYFlag xyFlag;
@property (nonatomic,assign) CGFloat v1;
@property (nonatomic,assign) CGFloat v2;
@property (nonatomic,assign) CGFloat v3;
@property (nonatomic,assign) CGFloat v4;

#pragma mark 属性方法
-(BOOL) hasRelateLeft;
-(CGFloat)relateLeftPx;
-(BOOL) hasRelateTop;
-(CGFloat)relateTopPx;
-(BOOL) hasRelateRight;
-(CGFloat)relateRightPx;
-(BOOL) hasRelateBottom;
-(CGFloat)relateBottomPx;
@end
