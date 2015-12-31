/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "AppDelegate.h"

#import "RCTRootView.h"

// 百度地图
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//引入地图功能所有的头文件
@interface AppDelegate ()<BMKGeneralDelegate>
{
  BMKMapManager *_mapManager;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  NSURL *jsCodeLocation;

  /**
   * Loading JavaScript code - uncomment the one you want.
   *
   * OPTION 1
   * Load from development server. Start the server from the repository root:
   *
   * $ npm start
   *
   * To run on device, change `localhost` to the IP address of your computer
   * (you can get this by typing `ifconfig` into the terminal and selecting the
   * `inet` value under `en0:`) and make sure your computer and iOS device are
   * on the same Wi-Fi network.
   */

  jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.ios.bundle?platform=ios&dev=true"];

  /**
   * OPTION 2
   * Load from pre-bundled file on disk. The static bundle is automatically
   * generated by "Bundle React Native code and images" build step.
   */

//   jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];

  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"ReactNativeStudy"
                                               initialProperties:nil
                                                   launchOptions:launchOptions];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  
  // 百度地图t1ZP9h6F8WGnZKzBYkjXd14h
  // 要使用百度地图，请先启动BaiduMapManager
  _mapManager = [[BMKMapManager alloc]init];
  
  // 鉴权操作 --> 每个第三方SDK都会干的事, 相当于请求网络授权
  // 如果要关注网络及授权验证事件，请设定 generalDelegate参数
  BOOL ret = [_mapManager start:@"t1ZP9h6F8WGnZKzBYkjXd14h" generalDelegate:self];
  if (!ret) {
    NSLog(@"manager start failed!");
  }
  

  return YES;
}
// app在前后台切换时，需要使用下面的代码停止地图的渲染和openGL的绘制
- (void)applicationWillResignActive:(UIApplication *)application {
  [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
  [BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
}

- (void)onGetNetworkState:(int)iError
{
  if (0 == iError) {
    NSLog(@"联网成功");
  }
  else{
    NSLog(@"onGetNetworkState %d",iError);
  }
}

- (void)onGetPermissionState:(int)iError
{
  if (0 == iError) {
    NSLog(@"授权成功");
  }
  else {
    NSLog(@"onGetPermissionState %d",iError);
  }
}

@end
