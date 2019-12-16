//
//  UIView+Extend.m
//  HRLibrary
//
//  Created by vision on 2019/5/14.
//  Copyright © 2019 vision. All rights reserved.
//

#import "UIView+Extend.h"

@implementation UIView (Extend)



-(void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

-(CGFloat)x{
    return self.frame.origin.x;
}

-(CGFloat)y{
    return self.frame.origin.y;
}

-(void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

-(CGFloat)centerX{
    return self.center.x;
}

-(void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

-(CGFloat)centerY{
    return self.center.y;
}

-(void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

-(void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(CGFloat)height{
    return self.frame.size.height;
}

-(CGFloat)width{
    return self.frame.size.width;
}

-(void)setSize:(CGSize)size{
    CGRect freme = self.frame;
    freme.size = size;
    self.frame = freme;
}

-(CGSize)size{
    return self.frame.size;
}

-(void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame   = frame;
}

-(CGPoint)origin{
    return self.frame.origin;
}

- (CGFloat) top{
    return self.frame.origin.y;
}

- (void) setTop: (CGFloat) newtop{
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat) left{
    return self.frame.origin.x;
}

- (void) setLeft: (CGFloat) newleft{
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat) bottom{
    return self.frame.origin.y + self.frame.size.height;
}

- (void) setBottom: (CGFloat) newbottom{
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat) right{
    return self.frame.origin.x + self.frame.size.width;
}

- (void) setRight: (CGFloat) newright{
    CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

#pragma mark -- Private Methods
-(void)setBorderWithCornerRadius:(CGFloat)cornerRadius type:(UIViewCornerType)type{
    UIRectCorner corners;
    if (type == UIViewCornerTypeLeft) {
        corners = UIRectCornerTopLeft | UIRectCornerBottomLeft;
    } else if (type == UIViewCornerTypeTop) {
        corners = UIRectCornerTopLeft | UIRectCornerTopRight;
    }else if (type == UIViewCornerTypeBottom){
        corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    }else{
        corners = UIRectCornerAllCorners;
    }
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
