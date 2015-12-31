//
//  RNDeviceInfo.m
//  Learnium
//
//  Created by Rebecca Hughes on 03/08/2015.
//  Copyright © 2015 Learnium Limited. All rights reserved.
//

#import "RNDeviceInfo.h"
#import "RCTLog.h"

#import <ifaddrs.h>
#import <arpa/inet.h>

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

// 获取MAC地址
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface RNDeviceInfo()

@end

@implementation RNDeviceInfo
{

}

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

- (NSString*) deviceId
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                                    encoding:NSUTF8StringEncoding];
}

- (NSString*) deviceName
{
    static NSDictionary* deviceNamesByCode = nil;
    
    if (!deviceNamesByCode) {
        
        deviceNamesByCode = @{@"i386"      :@"Simulator",
                              @"x86_64"    :@"Simulator",
                              @"iPod1,1"   :@"iPod Touch",      // (Original)
                              @"iPod2,1"   :@"iPod Touch",      // (Second Generation)
                              @"iPod3,1"   :@"iPod Touch",      // (Third Generation)
                              @"iPod4,1"   :@"iPod Touch",      // (Fourth Generation)
                              @"iPod5,1"   :@"iPod Touch",      // (Fifth Generation)
                              @"iPod7,1"   :@"iPod Touch",      // (Sixth Generation)
                              @"iPhone1,1" :@"iPhone",          // (Original)
                              @"iPhone1,2" :@"iPhone 3G",       // (3G)
                              @"iPhone2,1" :@"iPhone 3GS",      // (3GS)
                              @"iPad1,1"   :@"iPad",            // (Original)
                              @"iPad2,1"   :@"iPad 2",          //
                              @"iPad2,2"   :@"iPad 2",          //
                              @"iPad2,3"   :@"iPad 2",          //
                              @"iPad2,4"   :@"iPad 2",          //
                              @"iPad3,1"   :@"iPad",            // (3rd Generation)
                              @"iPad3,2"   :@"iPad",            // (3rd Generation)
                              @"iPad3,3"   :@"iPad",            // (3rd Generation)
                              @"iPhone3,1" :@"iPhone 4",        // (GSM)
                              @"iPhone3,2" :@"iPhone 4",        // iPhone 4
                              @"iPhone3,3" :@"iPhone 4",        // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" :@"iPhone 4S",       //
                              @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
                              @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
                              @"iPad3,4"   :@"iPad",            // (4th Generation)
                              @"iPad3,5"   :@"iPad",            // (4th Generation)
                              @"iPad3,6"   :@"iPad",            // (4th Generation)
                              @"iPad2,5"   :@"iPad Mini",       // (Original)
                              @"iPad2,6"   :@"iPad Mini",       // (Original)
                              @"iPad2,7"   :@"iPad Mini",       // (Original)
                              @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
                              @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
                              @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" :@"iPhone 6 Plus",   //
                              @"iPhone7,2" :@"iPhone 6",        //
                              @"iPhone8,1" :@"iPhone 6S",       //
                              @"iPhone8,2" :@"iPhone 6S Plus",  //
                              @"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,3"   :@"iPad Air",        // 5th Generation iPad (iPad Air)
                              @"iPad4,4"   :@"iPad Mini 2",     // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5"   :@"iPad Mini 2",     // (2nd Generation iPad Mini - Cellular)
                              @"iPad4,6"   :@"iPad Mini 2",     // (2nd Generation iPad Mini)
                              @"iPad4,7"   :@"iPad Mini 3",     // (3rd Generation iPad Mini)
                              @"iPad4,8"   :@"iPad Mini 3",     // (3rd Generation iPad Mini)
                              @"iPad4,9"   :@"iPad Mini 3",     // (3rd Generation iPad Mini)
                              @"iPad5,1"   :@"iPad Mini 4",     // (4th Generation iPad Mini)
                              @"iPad5,2"   :@"iPad Mini 4",     // (4th Generation iPad Mini)
                              @"iPad5,3"   :@"iPad Air 2",      // 6th Generation iPad (iPad Air 2)
                              @"iPad5,4"   :@"iPad Air 2",      // 6th Generation iPad (iPad Air 2)
                              @"iPad6,7"   :@"iPad Pro",        // iPad Pro
                              @"iPad6,8"   :@"iPad Pro",        // iPad Pro
                              @"AppleTV2,1":@"Apple TV",        // Apple TV (2nd Generation)
                              @"AppleTV3,1":@"Apple TV",        // Apple TV (3rd Generation)
                              @"AppleTV3,2":@"Apple TV",        // Apple TV (3rd Generation - Rev A)
                              @"AppleTV5,3":@"Apple TV",        // Apple TV (4th Generation)
                              };
    }
    
    NSString* deviceName = [deviceNamesByCode objectForKey:self.deviceId];
    
    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:
        
        if ([self.deviceId rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([self.deviceId rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([self.deviceId rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
    }
    
    return deviceName;
}

- (NSString *)deviceIPAddress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    struct sockaddr_in *temp_addr_p = (struct sockaddr_in *)temp_addr->ifa_addr;
                    address = [NSString stringWithUTF8String:inet_ntoa(temp_addr_p->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);

    return address;
}

- (NSString *)carrierName{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mCarrier = [NSString stringWithFormat:@"%@",[carrier carrierName]];
    return mCarrier;
}

- (NSString *)connectType{
    /*
     CTRadioAccessTechnologyGPRS         //介于2G和3G之间，也叫2.5G ,过度技术
     CTRadioAccessTechnologyEdge         //EDGE为GPRS到第三代移动通信的过渡，EDGE俗称2.75G
     CTRadioAccessTechnologyWCDMA
     CTRadioAccessTechnologyHSDPA            //亦称为3.5G(3?G)
     CTRadioAccessTechnologyHSUPA            //3G到4G的过度技术
     CTRadioAccessTechnologyCDMA1x       //3G
     CTRadioAccessTechnologyCDMAEVDORev0    //3G标准
     CTRadioAccessTechnologyCDMAEVDORevA
     CTRadioAccessTechnologyCDMAEVDORevB
     CTRadioAccessTechnologyeHRPD        //电信使用的一种3G到4G的演进技术， 3.75G
     CTRadioAccessTechnologyLTE          //接近4G
     */
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    NSString *mConnectType = [[NSString alloc] initWithFormat:@"%@",info.currentRadioAccessTechnology];
    return mConnectType;
}

- (NSString *)macAddress{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    free(buf);
    
    return [outstring uppercaseString];
}

- (NSDictionary *)constantsToExport
{
    UIDevice *currentDevice = [UIDevice currentDevice];

    NSUUID *identifierForVendor = [currentDevice identifierForVendor];
    NSString *uniqueId = [identifierForVendor UUIDString];

    return @{
             @"systemName": currentDevice.systemName,//设备运行的系统
             @"systemVersion": currentDevice.systemVersion,//当前系统的版本
             @"model": currentDevice.model,//设备的类别
             @"localizedModel":currentDevice.localizedModel,//设备的的本地化版本
             @"deviceId": self.deviceId,
             @"deviceName": currentDevice.name,//设备所有者的名称
             @"uniqueId": uniqueId,//设备识别码
             @"bundleId": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"],
             @"appVersion": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
             @"buildNumber": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
             @"ipAddress":self.deviceIPAddress,
             @"carrierName":self.carrierName,//当前运营商
             @"connectType":self.connectType,//网络类型
             @"macAddress":self.macAddress,//MAC地址
             };
}

@end

