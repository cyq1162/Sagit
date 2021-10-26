//
//  STDefine.m
//  Created by 陈裕强 on 2020/9/11.
//

#import "STDefine.h"
@interface STDefine()
@property (nonatomic,assign) NSInteger _StandardScale;
@property (nonatomic,assign) NSInteger _DefaultShowNav;
@property (nonatomic,assign) NSInteger _DefaultShowTab;
@property (nonatomic,assign) NSInteger _DefaultShowStatus;
@property (nonatomic,copy) NSString *_DefaultNavLeftTitle;
@property (nonatomic,copy) NSString *_DefaultNavLeftImage;
@property (nonatomic,assign) NSUInteger _DefaultOrientation;
@property (nonatomic,assign) NSUInteger _DefaultOrientationMask;

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
-(NSString *)Version
{
    return @"V2.1.0";
}
-(NSString *)VersionNum
{
    return @"202110261100";
}
- (NSInteger)StandardScale
{
    if(self._StandardScale>0 && self._StandardScale<4)
    {
        return self._StandardScale;
    }
    return 2;
}
-(void)setStandardScale:(NSInteger)StandardScale
{
    self._StandardScale=StandardScale;
}
- (BOOL)DefaultShowNav
{
    if(self._DefaultShowNav>0)
    {
        return self._DefaultShowNav==1;
    }
    return YES;
}
- (void)setDefaultShowNav:(BOOL)DefaultShowNav
{
    self._DefaultShowNav=DefaultShowNav?1:2;
}

- (BOOL)DefaultShowTab
{
    if(self._DefaultShowTab>0)
    {
        return self._DefaultShowTab==1;
    }
    return YES;
}
- (void)setDefaultShowTab:(BOOL)DefaultShowTab
{
    self._DefaultShowTab=DefaultShowTab?1:2;
}
-(BOOL)DefaultShowStatus
{
    if(self._DefaultShowStatus>0)
    {
        return self._DefaultShowStatus==1;
    }
    return YES;
}
- (void)setDefaultShowStatus:(BOOL)DefaultShowStatus
{
    self._DefaultShowStatus=DefaultShowStatus?1:2;
}
- (NSString *)DefaultNavLeftTitle
{
    if(self._DefaultNavLeftTitle!=nil)
    {
        return self._DefaultNavLeftTitle;
    }
    return @"STEmpty";
}
-(void)setDefaultNavLeftTitle:(NSString *)DefaultNavLeftTitle
{
    self._DefaultNavLeftTitle=DefaultNavLeftTitle;
}
-(NSString *)DefaultNavLeftImage
{
    return self._DefaultNavLeftImage;
}
-(void)setDefaultNavLeftImage:(NSString *)DefaultNavLeftImage
{
    self._DefaultNavLeftImage=DefaultNavLeftImage;
}


- (UIInterfaceOrientation)DefaultOrientation
{
    if(self._DefaultOrientation!= 0)
    {
        return (UIInterfaceOrientation)self._DefaultOrientation;
    }
    return UIInterfaceOrientationPortrait;
}
-(void)setDefaultOrientation:(UIInterfaceOrientation)DefaultOrientation
{
    self._DefaultOrientation=(NSInteger)DefaultOrientation;
}


-(UIInterfaceOrientationMask)DefaultOrientationMask
{
    if(self._DefaultOrientationMask!= 0)
    {
        return (UIInterfaceOrientationMask)self._DefaultOrientationMask;
    }
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
-(void)setDefaultOrientationMask:(UIInterfaceOrientationMask)DefaultOrientationMask
{
    self._DefaultOrientationMask=(NSInteger)DefaultOrientationMask;
}
@end
