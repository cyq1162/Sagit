//
//  STDefine.m
//  Created by 陈裕强 on 2020/9/11.
//

#import "STDefine.h"
@interface STDefine()
@end
@implementation STDefine

+ (instancetype)share
{
    
    static STDefine *_share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _share = [[STDefine alloc] init];
    });
    return _share;
}
- (NSInteger)StandardScale
{
    return 2;
}
- (BOOL)DefaultShowNav
{
    return YES;
}
- (BOOL)DefaultShowTab
{
    return YES;
}
- (NSString *)DefaultNavLeftTitle
{
    return @"STEmpty";
}
-(NSString *)DefaultNavLeftImage
{
    return nil;
}
- (UIInterfaceOrientation)DefaultOrientation
{
    return UIInterfaceOrientationPortrait;
}
-(UIInterfaceOrientationMask)DefaultOrientationMask
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
@end
