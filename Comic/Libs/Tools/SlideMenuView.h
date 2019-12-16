//
//  SlideMenuView.h
//  ZuoYe
//
//  Created by vision on 2018/9/11.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SlideMenuView;
@protocol SlideMenuViewDelegate<NSObject>

@optional

- (void)slideMenuView:(SlideMenuView *)menuView didSelectedWithIndex:(NSInteger)index;

@end

@interface SlideMenuView : UIView

@property (nonatomic, weak ) id<SlideMenuViewDelegate> delegate;

@property (nonatomic, assign ) CGFloat btnCapWidth;

@property (nonatomic, assign ) CGFloat lineWidth;

@property (nonatomic, strong) UIFont   *selectTitleFont;

@property (nonatomic, strong)  NSMutableArray  *myTitleArray;

@property (nonatomic, assign ) NSInteger currentIndex;



-(instancetype)initWithFrame:(CGRect)frame btnTitleFont:(UIFont *)titleFont color:(UIColor *)color selColor:(UIColor *)selcolor;




@end
