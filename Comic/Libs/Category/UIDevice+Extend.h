//
//  UIDevice+Extend.h
//  ThumbLocker
//
//  Created by Magic on 16/3/29.
//  Copyright © 2016年 VisionChina. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIDevice (Extend)

/*
 * 获取手机系统版本
 */
+ (NSString *)getSystemVersion;

/*
 * 获取设备广告标识符
 */
+(NSString *)getIDFA;

/*
 * 获取设备唯一标识符
 */
+(NSString *)getDeviceUUID;

/*
 * 判断手机是否在充电
 */
+(BOOL)isCharging;

/*
 * 获取手机电池电量
 */
+(float)screenLight;

/*
 * 获取手机总空间容量
 */
+(float)diskTotalSpace;

/*
 * 获取手机剩余空间容量
 */
+(float)diskFreeSpace;

/*
 * 获取手机型号
 */
+ (NSString *)iphoneType;

/*
 * 获取手机运营商
 */
+(NSString *)getCarrierName;

/*
 * 获取手机当前使用的语言
 */
+(NSString *)deviceCurentLanguage;

/*
 * 获取手机选中的国家
 */
+(NSString *)deviceCountry;

+(BOOL)isWifi;

@end
