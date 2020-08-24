//
//  STLocation.m
//
//  Created by 陈裕强 on 2020/8/21.
//

#import "STLocation.h"

#import <CoreLocation/CoreLocation.h>

@interface STLocation () <CLLocationManagerDelegate>
{
    OnLocationEnd onLocation;
    BOOL hasValue;
    CLLocationManager     *_locationManager;
}
@end
@implementation STLocation
-(STLocationModel *)cityModel
{
    if(!_cityModel)
    {
        _cityModel=[STLocationModel new];
    }
    return _cityModel;
}
+ (instancetype)share {
    static STLocation *_share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _share = [[STLocation alloc] init];
        [_share initializeLocationService];
    });
    return _share;
}

- (void)initializeLocationService {
    //初始化定位管理器
    _locationManager = [[CLLocationManager alloc]init];
    //设置代理
    _locationManager.delegate = self;
    //设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
}
-(BOOL)isEnabled
{
    if(STOSVersion>8.0)
    {
        int status=[CLLocationManager authorizationStatus];
        return status>=3;
    }
    else
    {
        return [CLLocationManager locationServicesEnabled];
    }
}

-(void)runOnce
{
    [self start:nil];
}
-(void)start:(OnLocationEnd )locationEnd
{
    onLocation=locationEnd;
    //开始定位，不检测是否启用，第一次会弹出确定提示。
    if(STOSVersion>8.0)
    {
        [_locationManager  requestWhenInUseAuthorization];//这句话ios8以上版本使用。
    }
    hasValue=NO;
    [_locationManager  startUpdatingLocation];//启动
}

#pragma mark 定位代理
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
   
    if(!hasValue)
    {
        hasValue=YES;
        [manager stopUpdatingLocation];
        [self reverseGeocodeLocation:newLocation];
    }
}
-(void)reverseGeocodeLocation:(CLLocation *)location
{
    if(location)
    {
        self.cityModel.Latitude=STNumString(location.coordinate.latitude);//保留完整精度
        self.cityModel.Longitude=STNumString(location.coordinate.longitude);
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        //根据经纬度反向地理编译出地址信息
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error)
         {
             NSString *city=@"";
             NSString*gpsAddress=@"";
             if (placemarks && placemarks.count > 0)
             {
                 CLPlacemark *mark = [placemarks objectAtIndex:0];
                 //获取城市
                 city = mark.locality;
                 if (!city) {
                     //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                     city = mark.administrativeArea;
                 }
                 if(city)
                 {
                     city=[city replace:@"市" with:@""];
                 }
                 gpsAddress=STString(@"%@%@%@",mark.administrativeArea==nil?@"":mark.administrativeArea,mark.locality==nil?@"":mark.locality,mark.subLocality==nil?@"":mark.subLocality);
                 self.cityModel.City=city;
                 self.cityModel.GPSAddress=gpsAddress;
             }
             if(onLocation)
             {
                 onLocation(self.cityModel);
                 onLocation=nil;
             }
         }];
    }
}
//!单位米
-(double)distince:(double)lat1 lng1:(double)lng1 lat2:(double)lat2 lng2:(double)lng2
{
    
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    
    double  distance  = [curLocation distanceFromLocation:otherLocation];
    
    return  distance;
    
}
#pragma mark 跳转
-(void)redirectToSetting
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url];
}
-(void)redirectToMap
{
    [self redirectToMap:self.cityModel];
}
-(void)redirectToMap:(STLocationModel *)model
{
    if(model==nil || !model.Latitude)
    {
        [self start:^(STLocationModel *model) {
            [self showMap:model];
        }];
    }
    else
    {
        [self showMap:model];
    }
}

- (void)showMap:(STLocationModel*)city {
    NSDictionary *maps=@{@"百度地图":@"baidumap://",@"高德地图":@"iosamap://",@"谷歌地图":@"comgooglemaps://",@"腾讯地图":@"qqmap://"};
    NSString *canUseMap=@"苹果地图";
    for (NSString* key in maps) {
           if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:maps[key]]])
           {
               canUseMap=[canUseMap append:STString(@",%@",key)];
           }
    }
    canUseMap=[canUseMap append:@",取消"];
    [Sagit.MsgBox confirm:nil title:@"选择要跳转的地图类型" click:^void(NSInteger btnIndex, UIAlertView *view) {
        NSString* name=[canUseMap split:@","][btnIndex];
        if([name isEqual:@"百度地图"]){[self baiduMap:city];}
        else if([name isEqual:@"高德地图"]){[self iosaMap:city];}
        else if([name isEqual:@"谷歌地图"]){[self comgoogleMaps:city];}
        else if([name isEqual:@"腾讯地图"]){[self qqMap:city];}
        else if([name isEqual:@"苹果地图"]){[self appleMap:city];}
    } okText:canUseMap cancelText:nil];
}
//国内拿到的是：中国国测局地理坐标（GCJ-02）<火星坐标>
//高德地图、腾讯地图以及谷歌中国区地图使用的是GCJ-02坐标系
//百度地图使用的是BD-09坐标系
//苹果自带地图在国内使用高德提供的数据,所以使用的是GCJ-02坐标系

-(void)baiduMap:(STLocationModel*)city
{
    CLLocationCoordinate2D gps= [LocationConverter gcj02ToBd09:CLLocationCoordinate2DMake(city.Latitude.doubleValue,city.Longitude.doubleValue)];

    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=%@&mode=driving&coord_type=gcj02",gps.latitude,gps.longitude,city.City] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

-(void)iosaMap:(STLocationModel*)city
{
    NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"导航功能",@"poapoaaldoerccbadersvsruhdk",city.Latitude,city.Longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}
-(void)comgoogleMaps:(STLocationModel*)city
{
   NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",@"驾车导航",@"poapoaaldoerccbadersvsruhdk",city.Latitude,city.Longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}
-(void)qqMap:(STLocationModel*)city
{
     NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=终点&coord_type=1&policy=0",city.Latitude,city.Longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}
-(void)appleMap:(STLocationModel*)city
{

    CLLocationCoordinate2D gps= CLLocationCoordinate2DMake(city.Latitude.doubleValue,city.Longitude.doubleValue);
            MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:gps addressDictionary:nil]];
    toLocation.name = city.GPSAddress;
            NSArray *items = @[currentLoc,toLocation];
            NSDictionary *dic = @{
                                  MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                                  MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                                  MKLaunchOptionsShowsTrafficKey : @(YES)
                                  };
    
            [MKMapItem openMapsWithItems:items launchOptions:dic];

}


@end
