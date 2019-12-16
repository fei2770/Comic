//
//  UIFont+Extend.h
//  HRLibrary
//
//  Created by vision on 2019/5/14.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FontWeightStyle) {
    FontWeightStyleMedium, // 中黑体
    FontWeightStyleSemibold, // 中粗体
    FontWeightStyleLight, // 细体
    FontWeightStyleUltralight, // 极细体
    FontWeightStyleRegular, // 常规体
    FontWeightStyleThin, // 纤细体
};

@interface UIFont (Extend)

/**
 * 苹方字体
 *  @param fontWeight 字体粗细（字重)
 *  @param fontSize 字体大小
 *  @return 返回指定字重大小的苹方字体
 */
+ (UIFont *)pingFangSCWithWeight:(FontWeightStyle)fontWeight size:(CGFloat)fontSize;

/**
 *  常规字体
 *  @param fontSize 字体大小
 *  @return 返回指定字重大小的字体
 */
+ (UIFont *)regularFontWithSize:(CGFloat)fontSize;

/**
 *  粗体
 *  @param fontSize 字体大小
 *  @return 返回指定字重大小的字体
 */
+ (UIFont *)mediumFontWithSize:(CGFloat)fontSize;

@end

