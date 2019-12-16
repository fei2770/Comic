//
//  APPInfoManager.m
//  HRLibrary
//
//  Created by vision on 2019/5/14.
//  Copyright © 2019 vision. All rights reserved.
//

#import "APPInfoManager.h"
#import "SSKeychain.h"
#import "UIDevice+Extend.h"

#define kDeviceService @"com.HRLibrary.keychain.uuid"
#define kDeviceAccount @"UserIDFV"

@implementation APPInfoManager

singleton_implementation(APPInfoManager)

#pragma mark 获取设备标识符
-(NSString *)deviceIdentifier{
    NSString *password = [SSKeychain passwordForService:kDeviceService account:kDeviceAccount];
    NSString *identifier = nil;
    if (kIsEmptyString(password)) {
        identifier = [UIDevice getDeviceUUID];
        [SSKeychain setPassword:identifier forService:kDeviceService account:kDeviceAccount];
    }else{
        identifier = password;
    }
    return identifier;
}

#pragma mark 获取app名称
-(NSString *)appBundleDisplayName{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return  [infoDictionary objectForKey:@"CFBundleDisplayName"];
}

#pragma mark 获取app版本
-(NSString *)appBundleVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return  [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

#pragma mark App应用标识（包名）
-(NSString *)appBundleIdentifier{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleIdentifier"];
}

@end
