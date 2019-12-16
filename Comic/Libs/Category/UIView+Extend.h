//
//  UIView+Extend.h
//  HRLibrary
//
//  Created by vision on 2019/5/14.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    UIViewCornerTypeLeft,
    UIViewCornerTypeTop,
    UIViewCornerTypeBottom,
    UIViewCornerTypeAll,
} UIViewCornerType;


@interface UIView (Extend)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat left;

@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;


-(void)setBorderWithCornerRadius:(CGFloat)cornerRadius type:(UIViewCornerType)type;


@end


