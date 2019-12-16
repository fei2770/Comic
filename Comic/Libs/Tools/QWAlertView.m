
//
//  QWAlertView.m
//  AlertTest
//
//  Created by jonh on 2017/10/26.
//  Copyright © 2017年 jonh. All rights reserved.
//

#import "QWAlertView.h"

#define ANIMATION_TIME 0.5

@interface QWAlertView ()
///遮罩层
@property (nonatomic, strong) UIView *maskLayer;
//保存弹出视图
@property (nonatomic, strong) UIView *contentView;
///弹出模式
@property (nonatomic, assign) QWAlertViewStyle alertStyle;
///动画前的位置
@property (nonatomic, assign) CGAffineTransform starTransForm;

@end

@implementation QWAlertView

+ (QWAlertView *)sharedMask{
    static QWAlertView *alertView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!alertView) {
            alertView = [[QWAlertView alloc] init];
        }
    });
    return alertView;
}

#pragma mark -- Public Methods
#pragma mark 弹出视图
- (void)show:(UIView *)contentView withType:(QWAlertViewStyle)style{
    //判断是否赋于大小
    CGFloat contentViewHeight =  contentView.frame.size.height;
    CGFloat contentViewWidth  =  contentView.frame.size.width;
    if(contentViewHeight == 0.00||contentViewWidth == 0.00){
        MyLog(@"弹出视图 必须 赋予宽高");
        return;
    }
    _contentView = contentView;
    _contentView.center = kKeyWindow.center;
    _alertStyle = style;
    if (!_maskLayer) {
        [self addMaskLayer];
        // 根据弹出模式 添加动画
        switch (_alertStyle) {
            case QWAlertViewStyleAlert:
                _starTransForm = CGAffineTransformMakeScale(0.01, 0.01);
                break;
            case QWAlertViewStyleActiAlertLeft:
                _starTransForm = CGAffineTransformMakeTranslation(-kScreenWidth, 0);
                break;
            case QWAlertViewStyleActiAlertRight:
                _starTransForm = CGAffineTransformMakeTranslation(kScreenWidth, 0);
                break;
            case QWAlertViewStyleActionSheetTop:
                _starTransForm = CGAffineTransformMakeTranslation(0, -_contentView.frame.size.height);
                break;
            case QWAlertViewStyleActionSheetDown:
                _starTransForm = CGAffineTransformMakeTranslation(0, kScreenHeight);
                break;
            default:
                break;
        }
        [self alertAnimatedPrensent];
    }else {
        _maskLayer = nil;
    }
}

#pragma mark  自定义的alert或actionSheet内容view必须初始化大小
- (void)show:(UIView *)contentView withType:(QWAlertViewStyle)style animationFinish:(showBlock)show dismissHandle:(dismissBlock)dismiss {
    if (show) {
        _showBlock = [show copy];
    }
    if(dismiss){
        _dismissBlock = [dismiss copy];
    }
    [self show:contentView withType:style];
}

#pragma mark 移除弹出视图
- (void)dismiss{
    //设置初始值
    // 移除遮罩
    if (_maskLayer) {
        [_maskLayer removeFromSuperview];
        _maskLayer = nil;
    }
    //移除弹出框
    [self alertAnimatedOut];
    //回调动画完成回调
    if (_dismissBlock) {
        _dismissBlock();
    }
}

#pragma mark -- Private methods
#pragma mark 添加遮罩
- (void)addMaskLayer{
    _maskLayer = [UIView new];
    [_maskLayer setFrame:[[UIScreen mainScreen] bounds]];
    if (self.maskColor) {
        [_maskLayer setBackgroundColor:self.maskColor];
    }else{
       [_maskLayer setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.50]];
    }
    [kKeyWindow  addSubview:_maskLayer];
}

#pragma mark 弹出视图
- (void)alertAnimatedPrensent{
    _contentView.transform = _starTransForm;
    [kKeyWindow addSubview:_contentView];
    [UIView animateWithDuration:ANIMATION_TIME delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
        kKeyWindow.userInteractionEnabled = NO;
    } completion:^(BOOL finished) {
        kKeyWindow.userInteractionEnabled = YES;
        if (self.showBlock) {
            //动画完成后回调
            self.showBlock();
        }
    }];
}

#pragma mark 移除视图
- (void)alertAnimatedOut{
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.transform = self.starTransForm;
        kKeyWindow.userInteractionEnabled = NO;
    } completion:^(BOOL finished) {
        kKeyWindow.userInteractionEnabled = YES;
        [self.contentView removeFromSuperview];
        self.contentView = nil;
    }];
    
}

@end
