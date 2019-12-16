//
//  CheckDayView.m
//  Comic
//
//  Created by vision on 2019/11/19.
//  Copyright © 2019 vision. All rights reserved.
//

#import "CheckDayView.h"

@interface CheckDayView ()

@property (nonatomic,strong) UIImageView *bgImgView;
@property (nonatomic,strong) UIView      *maskView;
@property (nonatomic,strong) UIButton    *receivedBtn;

@end

@implementation CheckDayView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgImgView];
        [self addSubview:self.koinLab];
        [self addSubview:self.dayLab];
        [self addSubview:self.maskView];
        [self addSubview:self.receivedBtn];
        self.maskView.hidden = self.receivedBtn.hidden = YES;
    }
    return self;
}

-(void)setIs_received:(BOOL)is_received{
    _is_received = is_received;
    self.maskView.hidden = self.receivedBtn.hidden = !is_received;
}

#pragma mark 背景
-(UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bgImgView.image = [UIImage imageNamed:@"daily_attendance_beans"];
    }
    return _bgImgView;
}

#pragma mark 金币
-(UILabel *)koinLab{
    if (!_koinLab) {
        _koinLab = [[UILabel alloc] initWithFrame:CGRectMake(0,15, self.width, 16)];
        _koinLab.font = [UIFont mediumFontWithSize:IS_IPHONE_5?12.0f:14.0f];
        _koinLab.textColor = [UIColor colorWithHexString:@"#FF7B43"];
        _koinLab.textAlignment = NSTextAlignmentCenter;
    }
    return _koinLab;
}

#pragma mark 天数
-(UILabel *)dayLab{
    if (!_dayLab) {
        _dayLab = [[UILabel alloc] initWithFrame:CGRectMake(0,self.koinLab.bottom+10, self.width, 16)];
        _dayLab.font = [UIFont regularFontWithSize:11.0f];
        _dayLab.textColor = [UIColor whiteColor];
        _dayLab.textAlignment = NSTextAlignmentCenter;
    }
    return _dayLab;
}

#pragma mark 蒙层
-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = kRGBColor(0, 0, 0, 0.5);
        [_maskView setBorderWithCornerRadius:8.0 type:UIViewCornerTypeAll];
    }
    return _maskView;
}

#pragma mark 已领
-(UIButton *)receivedBtn{
    if (!_receivedBtn) {
        _receivedBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.width-30)/2.0, (self.height-30)/2.0, 30, 30)];
        _receivedBtn.backgroundColor = [UIColor colorWithHexString:@"#37C7FF"];
        _receivedBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _receivedBtn.layer.borderWidth = 1.0;
        _receivedBtn.layer.cornerRadius = 15;
        [_receivedBtn setTitle:@"已领" forState:UIControlStateNormal];
        [_receivedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _receivedBtn.titleLabel.font = [UIFont mediumFontWithSize:12.0f];
    }
    return _receivedBtn;
}

@end
