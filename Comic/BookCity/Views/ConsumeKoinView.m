//
//  ConsumeKoinView.m
//  Comic
//
//  Created by vision on 2019/11/21.
//  Copyright © 2019 vision. All rights reserved.
//

#import "ConsumeKoinView.h"
#import "QWAlertView.h"

@interface ConsumeKoinView (){
    NSInteger type;
    NSInteger _myKoin;
}

@property (nonatomic,strong) UIImageView   *coverImgView;
@property (nonatomic,strong) UIView        *rootView;
@property (nonatomic,strong) UIButton      *closeBtn;
@property (nonatomic,strong) UILabel       *titleLabel;
@property (nonatomic,strong) UILabel       *descLabel;
@property (nonatomic,strong) UIImageView   *bottomImgView;
@property (nonatomic,strong) UIButton      *openBtn;
@property (nonatomic,strong) UILabel       *tipsLab;

@property (nonatomic, copy ) ConsumeConfirmBlock confirmBlock;

@end

@implementation ConsumeKoinView

-(instancetype)initWithFrame:(CGRect)frame confirmAction:(ConsumeConfirmBlock)confrim{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.confirmBlock = confrim;
        _myKoin = [[NSUserDefaultsInfos getValueforKey:kMyKoin] integerValue];
        type = _myKoin>100?0:1;
        
        [self addSubview:self.coverImgView];
        [self addSubview:self.rootView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.closeBtn];
        [self addSubview:self.descLabel];
        [self addSubview:self.bottomImgView];
        [self addSubview:self.openBtn];
        [self addSubview:self.tipsLab];
    }
    return self;
}

#pragma mark -- Public methods
+(void)showConsumeKoinWithFrame:(CGRect)frame confirmAction:(ConsumeConfirmBlock)confrim{
    ConsumeKoinView *view = [[ConsumeKoinView alloc] initWithFrame:frame confirmAction:confrim];
    [view showKoinView];
}

#pragma mark -- Event response
#pragma mark 确认消耗金币
-(void)confirmConsumeKoinActon:(UIButton *)sender{
    [[QWAlertView sharedMask] dismiss];
    self.confirmBlock(type);
}

#pragma mark 关闭
-(void)closeCurrentToastViewActon:(UIButton *)sender{
    [[QWAlertView sharedMask] dismiss];
}

#pragma mark-- Private methods
#pragma mark 显示
-(void)showKoinView{
    [[QWAlertView sharedMask] show:self withType:QWAlertViewStyleAlert];
}

#pragma mark -- Getters
-(UIImageView *)coverImgView{
    if (!_coverImgView) {
        _coverImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 90)];
        _coverImgView.image = [UIImage imageNamed:@"popup_vip_barrage"];
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
        _titleLabel.text = @"Koin ditukar dengan komentar langsung";
        _titleLabel.textColor = [UIColor colorWithHexString:@"#00D08D"];
        _titleLabel.font = [UIFont mediumFontWithSize:16.0f];
    }
    return _titleLabel;
}

#pragma mark 描述
-(UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.titleLabel.bottom+12, self.width-20, 60)];
        _descLabel.numberOfLines = 0;
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        _descLabel.font = [UIFont regularFontWithSize:14.0f];
        _descLabel.text = @"tukar 100 koin, hanya bisa dipakai 30 hari";
    }
    return _descLabel;
}

#pragma mark 底部图片
-(UIImageView *)bottomImgView{
    if (!_bottomImgView) {
        _bottomImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height-55, self.width, 60)];
        _bottomImgView.image = [UIImage imageNamed:@"popup_vip_barrage_background"];
        _bottomImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bottomImgView;
}

#pragma mark 开通
-(UIButton *)openBtn{
    if (!_openBtn) {
        _openBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.width-150)/2.0, self.descLabel.bottom+15, 150, 40)];
        _openBtn.backgroundColor = [UIColor bm_colorGradientChangeWithSize:_openBtn.size direction:IHGradientChangeDirectionVertical startColor:[UIColor colorWithHexString:@"#8FFF82"] endColor:[UIColor colorWithHexString:@"#4EEB97"]];
        [_openBtn setTitle:_myKoin>100?@"Yakin tukar":@"Isi ulang koin" forState:UIControlStateNormal];
        [_openBtn setTitleColor:[UIColor colorWithHexString:@"#007538"] forState:UIControlStateNormal];
        _openBtn.titleLabel.font = [UIFont mediumFontWithSize:17.0f];
        [_openBtn setBorderWithCornerRadius:20 type:UIViewCornerTypeAll];
        [_openBtn addTarget:self action:@selector(confirmConsumeKoinActon:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openBtn;
}

#pragma mark 提示
-(UILabel *)tipsLab{
    if (!_tipsLab) {
        _tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(10, self.openBtn.bottom+6, self.width-20, 20)];
        _tipsLab.textAlignment = NSTextAlignmentCenter;
        _tipsLab.textColor = [UIColor colorWithHexString:@"#00D08D"];
        _tipsLab.font = [UIFont regularFontWithSize:11.0f];
        _tipsLab.text = _myKoin>100?[NSString stringWithFormat:@"%ld koin",(long)_myKoin]:@"Koin tidak cukup";
    }
    return _tipsLab;
}

@end
