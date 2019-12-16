//
//  NSObject+Extend.h
//  SRZNetworkDemo
//
//  Created by vision on 16/7/21.
//  Copyright © 2016年 shuruzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extend)

/**
 *  字典转模型对象
 *
 *  @param values 字典
 */
- (void)setValues:(NSDictionary *)values;

/**
 *  对象转json字符串
 *
 *  @param object 原对象
 *
 *  @return json字符串
 */
+(NSString *)toJsonStringWithObject:(id)object;


@end
