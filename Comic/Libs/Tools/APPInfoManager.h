//
//  APPInfoManager.h
//  HRLibrary
//
//  Created by vision on 2019/5/14.
//  Copyright © 2019 vision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"


@interface APPInfoManager : NSObject

singleton_interface(APPInfoManager)

/**
 * 获取设备标识符
 */
-(NSString *)deviceIdentifier;

/**
 * App名称
 */
-(NSString *)appBundleDisplayName;

/**
 * App版本
 */
-(NSString *)appBundleVersion;

/**
 * App应用标识（包名）
 */
-(NSString *)appBundleIdentifier;

@end


