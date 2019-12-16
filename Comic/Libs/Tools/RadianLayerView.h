//
//  RadianLayerView.h
//  Comic
//
//  Created by vision on 2019/11/14.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RadianDirectionBottom    = 0,
    RadianDirectionTop       = 1,
    RadianDirectionLeft      = 2,
    RadianDirectionRight     = 3,
} RadianDirection;

@interface RadianLayerView : UIView

// 圆弧方向, 默认在下方
@property (nonatomic) RadianDirection direction;
// 圆弧高/宽, 可为负值。 正值凸, 负值凹
@property (nonatomic) CGFloat radian;

@end


