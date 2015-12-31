//
//  BDMapView.m
//  ReactNativeStudy
//
//  Created by 彭玉良 on 15/12/30.
//  Copyright © 2015年 Facebook. All rights reserved.
//

#import "RCTBDMapManager.h"
#import "RCTBDMap.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import "RCTBridge.h"
#import "RCTUIManager.h"
#import "UIView+React.h"


@interface RCTBDMapManager()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
  BMKLocationService *_locService;
  BMKGeoCodeSearch *_searcher;
}
@property (strong, nonatomic) RCTBDMap *mapView;
@end

@implementation RCTBDMapManager

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(asynReactTag:(nonnull NSNumber *)reactTag) {
  [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
    UIView *view = viewRegistry[reactTag];
    if ([view isKindOfClass:[RCTBDMap class]]) {
      self.mapView.reactTag = reactTag;
    }
  }];
}

RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)

- (RCTBDMap *)mapView{
  if (_mapView==nil) {
    _mapView = [[RCTBDMap alloc] init];
    _mapView.delegate = self;
    
    // 设置地图类型
    [_mapView setMapType:BMKMapTypeStandard];
    
    // 普通定位模式
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    
    // 设置缩放比例 3-20
    _mapView.zoomLevel = 17;
  }
  return _mapView;
}

- (UIView *)view
{
  //初始化BMKLocationService
  if (_locService==nil) {
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
    // 距离筛选器
    _locService.distanceFilter = 10;
    
    // 定位精度
    _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
  }
  
  // 地理编码查询器
  if (_searcher==nil) {
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
  }
  
  return self.mapView;
}


//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
  // 普通态
  // 以下_mapView为BMKMapView对象
  self.mapView.showsUserLocation = YES;//显示定位图层
  [self.mapView updateLocationData:userLocation];
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
  NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
  
  // 普通态
  // 以下_mapView为BMKMapView对象
  self.mapView.showsUserLocation = YES;//显示定位图层
  [self.mapView updateLocationData:userLocation];
  
  // 发起反向地理编码检索
  CLLocationCoordinate2D pt = userLocation.location.coordinate;
  BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
  reverseGeoCodeSearchOption.reverseGeoPoint = pt;
  
  [_searcher reverseGeoCode:reverseGeoCodeSearchOption];

}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
    // 在此处理正常结果 BMKPoiInfo 对象 包含了地理名称和具体地址 默认10个

    NSMutableArray *data=[NSMutableArray arrayWithCapacity:result.poiList.count];

    for (BMKPoiInfo *info in result.poiList) {
      NSDictionary *dict=@{@"name":info.name,
                           @"city":info.city,
                           @"address":info.address};
      [data addObject:dict];
    }

    NSLog(@"reactTag == %@",self.mapView.reactTag);

    if (self.mapView.reactTag!=nil) {
      self.mapView.onChange(@{@"data":data});
    }
  }
  else {
    NSLog(@"抱歉，未找到结果");
  }
}



@end

