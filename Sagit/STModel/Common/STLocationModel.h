//
//  STCityModel.h
//
//  Created by 陈裕强 on 2020/8/21.
//

#import <Foundation/Foundation.h>
#import "STModelBase.h"
@interface STLocationModel  : STModelBase
//!城市
@property (nonatomic,copy) NSString *City;
//!完整地址
@property (nonatomic,copy) NSString *GPSAddress;
//!经度
@property (nonatomic,copy) NSString *Longitude;
//!纬度
@property (nonatomic,copy) NSString *Latitude;

@end

