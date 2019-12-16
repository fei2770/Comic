

//
//  UIDevice+Extend.m
//  ThumbLocker
//
//  Created by Magic on 16/3/29.
//  Copyright © 2016年 VisionChina. All rights reserved.
//

#import "UIDevice+Extend.h"
#import <AdSupport/AdSupport.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <sys/utsname.h>
#import "AFNetworking.h"


typedef enum : NSUInteger {
    SSOperatorsTypeChinaTietong,//中国铁通
    SSOperatorsTypeTelecom,//中国电信
    SSOperatorsTypeChinaUnicom,//中国联通
    SSOperatorsTypeChinaMobile,//中国移动
    SSOperatorsTypeUnknown,//未知
} SSOperatorsType;


@implementation UIDevice (Extend)

#pragma mark 获取手机系统版本
+(NSString *)getSystemVersion{
    return [[UIDevice currentDevice] systemVersion];
}

#pragma mark 获取设备广告标识符
+(NSString *)getIDFA{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

#pragma mark 获取设备唯一标识符
+(NSString *)getDeviceUUID{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

#pragma mark 判断手机是否在充电
+(BOOL)isCharging{
    UIDeviceBatteryState deviceBatteryState = [UIDevice currentDevice].batteryState;
    if (deviceBatteryState == UIDeviceBatteryStateCharging || deviceBatteryState == UIDeviceBatteryStateFull) {
        return YES;
    }
    return NO;
}

#pragma mark 获取手机电池电量
+(float)screenLight{
    return  [[UIDevice currentDevice] batteryLevel];
}

#pragma mark 获取手机总空间容量
+(float)diskTotalSpace{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSDictionary *systemAttributes = [[NSFileManager defaultManager] fileSystemAttributesAtPath:NSHomeDirectory()];
 #pragma clang diagnostic pop
    NSString *diskTotalSize = [systemAttributes objectForKey:@"NSFileSystemSize"];
    return [diskTotalSize floatValue];
}

#pragma mark 获取手机剩余空间容量
+(float)diskFreeSpace{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSDictionary *systemAttributes = [[NSFileManager defaultManager] fileSystemAttributesAtPath:NSHomeDirectory()];
#pragma clang diagnostic pop
    NSString *diskFreeSize = [systemAttributes objectForKey:@"NSFileSystemFreeSize"];
    return [diskFreeSize floatValue];
}

#pragma mark 获取手机型号
+ (NSString *)iphoneType{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (GSM)";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (GSM)";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    
    if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    
    if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    
    if ([platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
    
    if ([platform isEqualToString:@"iPad1,2"]) return @"iPad 3G";
    
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2 (WiFi)";
    
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2 (CDMA)";
    
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini (WiFi)";
    
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini";
    
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3 (WiFi)";
    
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4 (WiFi)";
    
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air (WiFi)";
    
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air (Cellular)";
    
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2 (WiFi)";
    
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2 (Cellular)";
    
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2";
    
    if ([platform isEqualToString:@"iPad4,7"]) return @"iPad Mini 3";
    
    if ([platform isEqualToString:@"iPad4,8"]) return @"iPad Mini 3";
    
    if ([platform isEqualToString:@"iPad4,9"]) return @"iPad Mini 3";
    
    if ([platform isEqualToString:@"iPad5,1"]) return @"iPad Mini 4 (WiFi)";
    
    if ([platform isEqualToString:@"iPad5,2"]) return @"iPad Mini 4 (LTE)";
    
    if ([platform isEqualToString:@"iPad5,3"]) return @"iPad Air 2";
    
    if ([platform isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    
    if ([platform isEqualToString:@"iPad6,7"]) return @"iPad Pro (12.9-inch)";
    
    if ([platform isEqualToString:@"iPad6,8"]) return @"iPad Pro (12.9-inch)";
    
    if ([platform isEqualToString:@"iPad6,3"]) return @"iPad Pro (9.7-inch)";
    
    if ([platform isEqualToString:@"iPad6,4"]) return @"iPad Pro (9.7-inch)";
    
    if ([platform isEqualToString:@"iPad6,11"]) return @"iPad 5 (WiFi)";
    
    if ([platform isEqualToString:@"iPad6,12"]) return @"iPad 5 (Cellular)";
    
    if ([platform isEqualToString:@"iPad7,1"]) return @"iPad Pro 2 (12.9-inch) (WiFi)";
    
    if ([platform isEqualToString:@"iPad7,2"]) return @"iPad Pro 2 (12.9-inch) (Cellular)";
    
    if ([platform isEqualToString:@"iPad7,3"]) return @"iPad Pro (10.5-inch) (WiFi)";
    
    if ([platform isEqualToString:@"iPad7,4"]) return @"iPad Pro (10.5-inch) (Cellular)";
    
    if ([platform isEqualToString:@"iPad7,5"]) return @"iPad 6";
    
    if ([platform isEqualToString:@"iPad7,6"]) return @"iPad 6";
    
    if ([platform isEqualToString:@"iPad8,1"]) return @"iPad Pro (11-inch)";
    
    if ([platform isEqualToString:@"iPad8,2"]) return @"iPad Pro (11-inch)";
    
    if ([platform isEqualToString:@"iPad8,3"]) return @"iPad Pro (11-inch)";
    
    if ([platform isEqualToString:@"iPad8,4"]) return @"iPad Pro (11-inch)";
    
    if ([platform isEqualToString:@"iPad8,5"]) return @"iPad pro 3 (12.9-inch)";
    
    if ([platform isEqualToString:@"iPad8,6"]) return @"iPad pro 3 (12.9-inch)";
    
    if ([platform isEqualToString:@"iPad8,7"]) return @"iPad pro 3 (12.9-inch)";
    
    if ([platform isEqualToString:@"iPad8,8"]) return @"iPad pro 3 (12.9-inch)";
    
    if ([platform isEqualToString:@"iPad11,1"]) return @"iPad mini 5";
    
    if ([platform isEqualToString:@"iPad11,2"]) return @"iPad mini 5";
    
    if ([platform isEqualToString:@"iPad11,3"]) return @"iPad Air 3";
    
    if ([platform isEqualToString:@"iPad11,4"]) return @"iPad Air 3";

    if ([platform isEqualToString:@"i386"]) return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    return platform;
    
}

#pragma mark 获取手机运营商
+(NSString *)getCarrierName{
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *currentCarrier=[carrier carrierName];
    return currentCarrier;
}

#pragma mark 获取手机当前使用的语言
+(NSString *)deviceCurentLanguage{
    NSArray *languageArray = [NSLocale preferredLanguages];
    return [languageArray objectAtIndex:0];
}

#pragma mark  获取手机选中的国家
+(NSString *)deviceCountry{
    NSLocale *locale = [NSLocale currentLocale];
    return [locale localeIdentifier];
}

+(BOOL)isWifi{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    return manager.reachableViaWiFi;
}

@end
