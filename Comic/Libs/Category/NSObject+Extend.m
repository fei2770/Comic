//
//  NSObject+Extend.m
//  SRZNetworkDemo
//
//  Created by vision on 16/7/21.
//  Copyright © 2016年 shuruzhi. All rights reserved.
//

#import "NSObject+Extend.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation NSObject (Extend)

#pragma mark --字典转模型
- (void)setValues:(NSDictionary *)values{
    Class c = [self class];
    while (c) {
        // 1.获得所有的成员变量
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList(c, &outCount);
        for (int i = 0; i<outCount; i++) {
            Ivar ivar = ivars[i];
            // 2.属性名
            NSMutableString *name = [NSMutableString stringWithUTF8String:ivar_getName(ivar)];
            // 删除最前面的_
            [name replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
            // 3.取出属性值
            NSString *key = name;
            if ([key isEqualToString:@"desc"]) {
                key = @"description";
            }
            if ([key isEqualToString:@"ID"]) {
                key = @"id";
            }
            id value = values[key];
            if (!value) continue;
            // 4.SEL
            // 首字母
            NSString *cap = [name substringToIndex:1];
            // 变大写
            cap = cap.uppercaseString;
            // 将大写字母调换掉原首字母
            [name replaceCharactersInRange:NSMakeRange(0, 1) withString:cap];
            // 拼接set
            [name insertString:@"set" atIndex:0];
            // 拼接冒号:
            [name appendString:@":"];
            SEL selector = NSSelectorFromString(name);
            
            // 5.属性类型
            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            
            if ([type hasPrefix:@"@"]) { // 对象类型
                //           前面加上一个类型强转。把objc_msgSend转换成 (void(*)(id,SEL,id,.... )), 形参的个数与实际用objc_msgSend的参数个数一致。
                ((void(*)(id, SEL, id))objc_msgSend)(self, selector, value);
            } else  { // 非对象类型
                if ([type isEqualToString:@"d"]) {
                    ((void(*)(id, SEL, double))objc_msgSend)(self, selector, [value doubleValue]);
                } else if ([type isEqualToString:@"f"]) {
                    ((void(*)(id, SEL, float))objc_msgSend)(self, selector, [value floatValue]);
                } else if ([type isEqualToString:@"i"]) {
                    ((void(*)(id, SEL,int))objc_msgSend)(self, selector, [value intValue]);
                }  else {
                    ((void(*)(id, SEL, long long))objc_msgSend)(self, selector, [value longLongValue]);
                }
            }
        }
        c = class_getSuperclass(c);
    }
}

#pragma mark --转json字符串
+ (NSString *)toJsonStringWithObject:(id)object{
    NSMutableData *data=[self toJsonDataWithObject:object];
    if (data.length) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

#pragma mark--
+ (NSMutableData *)toJsonDataWithObject:(id)object{
    NSMutableData *jsonData=nil;
    if ([NSJSONSerialization isValidJSONObject:object]) {
        NSError *error=nil;
        NSData *data=[NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        if (error) {
            NSLog(@"error:%@",error.description);
        }else{
            jsonData=[[NSMutableData alloc] initWithData:data];
        }
    }
    return jsonData;
}



@end
