//
//  UIFont+Extend.m
//  HRLibrary
//
//  Created by vision on 2019/5/14.
//  Copyright © 2019 vision. All rights reserved.
//

#import "UIFont+Extend.h"

@implementation UIFont (Extend)

+ (UIFont *)pingFangSCWithWeight:(FontWeightStyle)fontWeight size:(CGFloat)fontSize {
    if (fontWeight < FontWeightStyleMedium || fontWeight > FontWeightStyleThin) {
        fontWeight = FontWeightStyleRegular;
    }
    
    NSString *fontName = @"PingFangSC-Regular";
    switch (fontWeight) {
        case FontWeightStyleMedium:
            fontName = @"PingFangSC-Medium";
            break;
        case FontWeightStyleSemibold:
            fontName = @"PingFangSC-Semibold";
            break;
        case FontWeightStyleLight:
            fontName = @"PingFangSC-Light";
            break;
        case FontWeightStyleUltralight:
            fontName = @"PingFangSC-Ultralight";
            break;
        case FontWeightStyleRegular:
            fontName = @"PingFangSC-Regular";
            break;
        case FontWeightStyleThin:
            fontName = @"PingFangSC-Thin";
            break;
    }
    
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    return font ?: [UIFont systemFontOfSize:fontSize];
}


+(UIFont *)regularFontWithSize:(CGFloat)fontSize{
    return [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:fontSize];
}

+(UIFont *)mediumFontWithSize:(CGFloat)fontSize{
    return [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:fontSize];
}

@end
