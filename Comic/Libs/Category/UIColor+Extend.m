//
//  UIColor+Extend.m
//  SRZCommonTool
//
//  Created by vision on 16/7/21.
//  Copyright © 2016年 SRZ. All rights reserved.
//

#import "UIColor+Extend.h"

#define kBgGrayColor  @"#F1F1F2"
#define kSystemColor  @"#915AFF"
#define kBlackColor   @"#303030"
#define kGrayColor    @"#808080"
#define kRedColor     @"#FF4757"

@implementation UIColor (Extend)

#pragma mark 十六进制转颜色
+ (UIColor *) colorWithHexString: (NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

#pragma mark 十六进制转颜色(含透明度)
+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

#pragma 创建渐变颜色
+ (UIColor *)bm_colorGradientChangeWithSize:(CGSize)size
                                     direction:(IHGradientChangeDirection)direction
                                    startColor:(UIColor *)startcolor
                                      endColor:(UIColor *)endColor {
    
    if (CGSizeEqualToSize(size, CGSizeZero) || !startcolor || !endColor) {
        return nil;
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    CGPoint startPoint = CGPointZero;
    if (direction == IHGradientChangeDirectionDownDiagonalLine) {
        startPoint = CGPointMake(0.0, 1.0);
    }
    gradientLayer.startPoint = startPoint;
    
    CGPoint endPoint = CGPointZero;
    switch (direction) {
        case IHGradientChangeDirectionLevel:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        case IHGradientChangeDirectionVertical:
            endPoint = CGPointMake(0.0, 1.0);
            break;
        case IHGradientChangeDirectionUpwardDiagonalLine:
            endPoint = CGPointMake(1.0, 1.0);
            break;
        case IHGradientChangeDirectionDownDiagonalLine:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        default:
            break;
    }
    gradientLayer.endPoint = endPoint;
    
    gradientLayer.colors = @[(__bridge id)startcolor.CGColor, (__bridge id)endColor.CGColor];
    UIGraphicsBeginImageContext(size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}

#pragma mark 灰色背景
+ (UIColor *)bgColor_Gray{
    return [UIColor colorWithHexString:kBgGrayColor];
}

#pragma mark 系统主色
+(UIColor *)systemColor{
    return [UIColor colorWithHexString:kSystemColor];
}

#pragma mark  常用黑色
+(UIColor *)commonColor_black{
    return [UIColor colorWithHexString:kBlackColor];
}

#pragma mark  常用灰色
+(UIColor *)commonColor_gray{
    return [UIColor colorWithHexString:kGrayColor];
}

#pragma mark  常用红色
+(UIColor *)commonColor_red{
    return [UIColor colorWithHexString:kRedColor];
}

@end
