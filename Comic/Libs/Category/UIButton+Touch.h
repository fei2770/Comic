//
//  UIButton+Touch.h
//  ZuoYe
//
//  Created by vision on 2018/11/6.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

#define defaultInterval .7// 默认间隔时间

@interface UIButton (Touch)

/**设置点击时间间隔*/

@property (nonatomic, assign) NSTimeInterval timeInterval;

@end

NS_ASSUME_NONNULL_END
