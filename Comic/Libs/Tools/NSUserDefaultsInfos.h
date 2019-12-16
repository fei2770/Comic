//
//  NSUserDefaultsInfos.h
//  TonzeCloud
//
//  Created by vision on 17/2/20.
//  Copyright © 2017年 tonze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaultsInfos : NSObject

+(void)putKey:(NSString *)key andValue:(id )value;

+(id )getValueforKey:(NSString *)key;

+(void)removeObjectForKey:(NSString *)key;


@end
