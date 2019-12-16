//
//  UIColor+Extend.h
//  SRZCommonTool
//
//  Created by vision on 16/7/21.
//  Copyright © 2016年 SRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 渐变方式
 
 - IHGradientChangeDirectionLevel:              水平渐变
 - IHGradientChangeDirectionVertical:           竖直渐变
 - IHGradientChangeDirectionUpwardDiagonalLine: 向下对角线渐变
 - IHGradientChangeDirectionDownDiagonalLine:   向上对角线渐变
 */
typedef NS_ENUM(NSInteger, IHGradientChangeDirection) {
    IHGradientChangeDirectionLevel,
    IHGradientChangeDirectionVertical,
    IHGradientChangeDirectionUpwardDiagonalLine,
    IHGradientChangeDirectionDownDiagonalLine,
};

@interface UIColor (Extend)

/**
 *  十六进制转颜色
 *
 *  @param color 颜色的十六进制数值
 *
 */
+ (UIColor *) colorWithHexString: (NSString *)color;

/**
 *  十六进制转颜色
 *
 *  @param hexValue   颜色的十六进制值
 *  @param alphaValue 透明度
 *
 *  @return 颜色
 */
+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue ;

/**
 创建渐变颜色
 
 @param size       渐变的size
 @param direction  渐变方式
 @param startcolor 开始颜色
 @param endColor   结束颜色
 
 @return 创建的渐变颜色
 */
+ (UIColor *)bm_colorGradientChangeWithSize:(CGSize)size
                                     direction:(IHGradientChangeDirection)direction
                                    startColor:(UIColor *)startcolor
                                      endColor:(UIColor *)endColor;


/**
 * 灰色背景
 */
+ (UIColor *)bgColor_Gray;

/**
 * 系统主色
 */
+ (UIColor *)systemColor;

/**
 * 常用黑色
 */
+ (UIColor *)commonColor_black;

/**
 * 常用灰色
 */
+ (UIColor *)commonColor_gray;

/**
 * 常用红色
 */
+ (UIColor *)commonColor_red;

@end
