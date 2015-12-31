//
//  LocationTool.m
//  ReactNativeStudy
//
//  Created by 彭玉良 on 15/12/29.
//  Copyright © 2015年 Facebook. All rights reserved.
//

#import "LocationTool.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@implementation LocationTool
RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(reverceGeocoder:(NSDictionary *)mapRegion callback:(RCTResponseSenderBlock)callback)
{
  NSMutableArray *result=[NSMutableArray array];
  
  //反向地理编码 --> 将经纬度 转换成 地球表面上的位置
  //1. 创建地理编码对象
  CLGeocoder *geocoder = [CLGeocoder new];
  
  //2. 创建一个位置对象
  CLLocation *location = [[CLLocation alloc] initWithLatitude:[mapRegion[@"latitude"] doubleValue] longitude:[mapRegion[@"longitude"] doubleValue]];
  
  //3. 调用反地理编码方法
  [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {

    //3.1 防错处理
    if (placemarks.count == 0 || error) {
      return ;
    }
    
    //3.2 遍历地标数组
    for (CLPlacemark * placemark in placemarks) {
      
      //使用locality有可能拿不到城市名
      //可以使用administrativeArea来代替, 防止出现为nill的状态
      
      //3.3 获取城市

      NSDictionary *dict = @{
                             @"country":placemark.country,
                             @"locality":placemark.locality,
                             @"subLocality":placemark.subLocality,
                             @"name":placemark.name
                             };
      [result addObject:dict];

    }
    
    callback(@[[NSNull null], result]);
  }];
}
@end
