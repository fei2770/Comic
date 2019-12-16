//
//  OpenVipToastView.m
//  Comic
//
//  Created by vision on 2019/11/21.
//  Copyright © 2019 vision. All rights reserved.
//

#import "OpenVipToastView.h"
#import "QWAlertView.h"

@interface OpenVipToastView ()

@property (nonatomic,strong) UIImageView   *coverImgView;
@property (nonatomic,strong) UIView        *rootView;
@property (nonatomic,strong) UIButton      *closeBtn;
@property (nonatomic,strong) UILabel       *titleLabel;
@property (nonatomic,strong) UILabel       *descLabel;
@property (nonatomic,strong) UIImageView   *bottomImgView;
@property (nonatomic,strong) UIButton      *openBtn;

@property (nonatomic, copy ) ConfirmBlock confirmBlock;

@end

@implementation OpenVipToastView

-(instancetype)initWithFrame:(CGRect)frame confirmAction:(ConfirmBlock)confrim{
    self = [super initWithFrame:frame];
    if (self) {
        self.confirmBlock = confrim;
        
        [self addSubview:self.coverImgView];
        [self addSubview:self.rootView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.closeBtn];
        [self addSubview:self.descLabel];
        [self addSubview:self.bottomImgView];
        [self addSubview:self.openBtn];
    }
    return self;
}

#pragma mark Public methods
+(void)showOpenVipToastWithFrame:(CGRect)frame confirmAction:(ConfirmBlock)confrim{
    OpenVipToastView *aView = [[OpenVipToastView alloc] initWithFrame:frame confirmAction:confrim];
    [aView showVipToastView];
}

#pragma mark -- Event response
#pragma mark 开通会员
-(void)openVipActon:(UIButton *)sender{
    [[QWAlertView sharedMask] dismiss];
    self.confirmBlock();
}

#pragma mark 关闭
-(void)closeCurrentToastViewActon:(UIButton *)sender{
    [[QWAlertView sharedMask] dismiss];
}

#pragma mark-- Private methods
#pragma mark 显示
-(void)showVipToastView{
    [[QWAlertView sharedMask] show:self withType:QWAlertViewStyleAlert];
}

#pragma mark -- Getters
-(UIImageView *)coverImgView{
    if (!_coverImgView) {
        _coverImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 90)];
        _coverImgView.image = [UIImage imageNamed:@"popup_beans_barrage"];
    }
    return _coverImgView;
}

#pragma mark root
-(UIView *)rootView{
    if (!_rootView) {
        _rootView = [[UIView alloc] initWithFrame:CGRectMake(0,self.coverImgView.bottom, self.width, self.height-84)];
        _rootView.backgroundColor = [UIColor whiteColor];
        [_rootView setBorderWithCornerRadius:18 type:UIViewCornerTypeAll];
    }
    return _rootView;
}

#pragma mark 关闭
-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width-30, self.rootView.top, 30, 30)];
        [_closeBtn setImage:[UIImage drawImageWithName:@"popup_close" size:CGSizeMake(20, 20)] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeCurrentToastViewActon:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

#pragma mark 标题
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, self.rootView.top+20, self.width-60, 45)];
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = @"Komentar langsung ekslusif untuk anggota";
        _titleLabel.textColor = [UIColor colorWithHexString:@"#915AFF"];
        _titleLabel.font = [UIFont mediumFontWithSize:16.0f];
    }
    return _titleLabel;
}

#pragma mark 描述
-(UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.titleLabel.bottom+12, self.width-20, 60)];
        _descLabel.numberOfLines = 0;
        _descLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        _descLabel.font = [UIFont regularFontWithSize:14.0f];
        _descLabel.text = @"kamu bukan anggota, daftar anggota dan nikmati berbagai macam komentar langsung ";
    }
    return _descLabel;
}

#pragma mark 底部图片
-(UIImageView *)bottomImgView{
    if (!_bottomImgView) {
        _bottomImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height-55, self.width, 60)];
        _bottomImgView.image = [UIImage imageNamed:@"popup_beans_barrage_background"];
        _bottomImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bottomImgView;
}

#pragma mark 开通
-(UIButton *)openBtn{
    if (!_openBtn) {
        _openBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.width-150)/2.0, self.descLabel.bottom+15, 150, 40)];
        _openBtn.backgroundColor = [UIColor bm_colorGradientChangeWithSize:_openBtn.size direction:IHGradientChangeDirectionVertical startColor:[UIColor colorWithHexString:@"#D086FF"] endColor:[UIColor colorWithHexString:@"#737DFF"]];
        [_openBtn setTitle:@"Daftar anggota" forState:UIControlStateNormal];
        [_openBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _openBtn.titleLabel.font = [UIFont mediumFontWithSize:17.0f];
        [_openBtn setBorderWithCornerRadius:20 type:UIViewCornerTypeAll];
        [_openBtn addTarget:self action:@selector(openVipActon:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openBtn;
}

@end
