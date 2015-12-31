//
//  RCTBDMap.h
//  ReactNativeStudy
//
//  Created by 彭玉良 on 15/12/30.
//  Copyright © 2015年 Facebook. All rights reserved.
//

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import "RCTComponent.h"
@interface RCTBDMap : BMKMapView

@property (nonatomic, copy) RCTBubblingEventBlock onChange;

@end
