//
//  NSUserDefaultsInfos.m
//  TonzeCloud
//
//  Created by vision on 17/2/20.
//  Copyright © 2017年 tonze. All rights reserved.
//

#import "NSUserDefaultsInfos.h"

@implementation NSUserDefaultsInfos

#pragma mark 保存数据
+(void)putKey:(NSString *)key andValue:(NSObject *)value{
    if (!kIsEmptyObject(value)) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:value forKey:key];
        [defaults synchronize];
    }
}

#pragma mark 获取数据
+(id )getValueforKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id result= [defaults objectForKey:key];
    if(!result){
        result = nil;
    }
    return result;
}

#pragma mark 删除数据
+(void)removeObjectForKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
}


@end
