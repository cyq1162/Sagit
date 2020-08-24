//
//  STLocation.h
//
//  Created by 陈裕强 on 2020/8/21.
//


#import <Foundation/Foundation.h>
#import <MapKit/Mapkit.h>
#import "STLocationModel.h"
#import "LocationConverter.h"

@interface STLocation : NSObject
typedef void (^OnLocationEnd)(STLocationModel *model);
@property (nonatomic,retain) STLocationModel *cityModel;
+ (instancetype)share;
-(void)runOnce;
-(void)start:(OnLocationEnd)locationEnd;
//!是否可用GPS
-(BOOL)isEnabled;

//!获取坐标间的距离(单位米)
-(double)distince:(double) lat1 lng1:(double) lng1 lat2:(double) lat2 lng2:(double) lng2;
#pragma mark 跳转
//!跳转到系统设置界面
-(void)redirectToSetting;
//!跳转到第3方地图
-(void)redirectToMap;
-(void)redirectToMap:(STLocationModel*)mode;
@end
