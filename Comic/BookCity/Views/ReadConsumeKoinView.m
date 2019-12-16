//
//  ReadConsumeKoinView.m
//  Comic
//
//  Created by vision on 2019/11/28.
//  Copyright © 2019 vision. All rights reserved.
//

#import "ReadConsumeKoinView.h"
#import "QWAlertView.h"

@interface ReadConsumeKoinView ()

@property (nonatomic,strong) UILabel       *titleLabel;
@property (nonatomic,strong) UIImageView   *vipImgView;
@property (nonatomic,strong) UILabel       *descLabel;
@property (nonatomic,strong) UILabel       *tipsLabel;
@property (nonatomic,strong) UIImageView   *bottomImgView;
@property (nonatomic,strong) UIButton      *cnfirmBtn;
@property (nonatomic,strong) UIButton      *closeBtn;

@property (nonatomic,assign) NSInteger     costKoin;
@property (nonatomic,assign) NSInteger     vipKoin;
@property (nonatomic, copy ) ConsumeConfirmBlock confirmBlock;
@property (nonatomic, copy ) CancelBlock  cancelBlock;
@property (nonatomic,assign) BOOL         isPaying;

@end

@implementation ReadConsumeKoinView

-(instancetype)initWithFrame:(CGRect)frame costKoin:(NSInteger)costKoin vipCoin:(NSInteger)vipCoin  isPaying:(BOOL)isPaying confirmAction:(ConsumeConfirmBlock)confrim  cancelAction:(CancelBlock)cancelBlock{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setBorderWithCornerRadius:18 type:UIViewCornerTypeAll];
        
        self.costKoin = costKoin;
        self.vipKoin = vipCoin;
        self.confirmBlock = confrim;
        self.cancelBlock = cancelBlock;
        self.isPaying = isPaying;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.closeBtn];
        [self addSubview:self.vipImgView];
        [self addSubview:self.descLabel];
        [self addSubview:self.tipsLabel];
        [self addSubview:self.bottomImgView];
        [self addSubview:self.cnfirmBtn];
        
    }
    return self;
}

+(void)showConsumeKoinWithFrame:(CGRect)frame costKoin:(NSInteger)costKoin vipCoin:(NSInteger)vipCoin isPaying:(BOOL)isPaying confirmAction:(ConsumeConfirmBlock)confrim cancelAction:(CancelBlock)cancelBlock{
    ReadConsumeKoinView *toastView = [[ReadConsumeKoinView alloc] initWithFrame:frame costKoin:costKoin vipCoin:vipCoin isPaying:isPaying confirmAction:confrim cancelAction:cancelBlock];
    [toastView showKoinView];
}

#pragma mark -- Event response
#pragma mark 确认消耗金币
-(void)confirmConsumeKoinActon:(UIButton *)sender{
    [[QWAlertView sharedMask] dismiss];
    self.confirmBlock();
}

#pragma mark 关闭
-(void)cancelConsumeKoinActon:(UIButton *)sender{
    [[QWAlertView sharedMask] dismiss];
    self.cancelBlock();
}

#pragma mark-- Private methods
#pragma mark 显示
-(void)showKoinView{
    [[QWAlertView sharedMask] show:self withType:QWAlertViewStyleAlert];
}

#pragma mark -- Getters
#pragma mark 标题
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10,self.width-40, 60)];
        _titleLabel.text = [NSString stringWithFormat:@"%ld koin yang harus dibayarkan",(long)self.costKoin];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#915AFF"];
        _titleLabel.font = [UIFont mediumFontWithSize:18.0f];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

#pragma mark 取消
-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width-40,0, 30, 30)];
        [_closeBtn setImage:[UIImage drawImageWithName:@"popup_close" size:CGSizeMake(20, 20)] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(cancelConsumeKoinActon:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

#pragma mark vip
-(UIImageView *)vipImgView{
    if (!_vipImgView) {
        _vipImgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-53)/2.0, self.titleLabel.bottom, 53, 21)];
        _vipImgView.image = [UIImage imageNamed:@"recharge_vip"];
    }
    return _vipImgView;
}

#pragma mark vip提示
-(UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.vipImgView.bottom, self.width-20, 20)];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.textColor = [UIColor colorWithHexString:@"#00D08D"];
        _descLabel.font = [UIFont regularFontWithSize:13.0f];
        _descLabel.text = [NSString stringWithFormat:@"Harga %ld koin untuk anggota",(long)self.vipKoin];
    }
    return _descLabel;
}

#pragma mark 提示
-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.descLabel.bottom, self.width-20, 20)];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.textColor = [UIColor colorWithHexString:@"#00D08D"];
        _tipsLabel.font = [UIFont regularFontWithSize:13.0f];
        NSInteger myKoin = [[NSUserDefaultsInfos getValueforKey:kMyKoin] integerValue];
        _tipsLabel.text = [NSString stringWithFormat:@"%ld Koin yang bisa digunakan",(long)myKoin];
    }
    return _tipsLabel;
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
-(UIButton *)cnfirmBtn{
    if (!_cnfirmBtn) {
        _cnfirmBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.width-150)/2.0, self.tipsLabel.bottom+15, 150, 40)];
        _cnfirmBtn.backgroundColor = [UIColor bm_colorGradientChangeWithSize:_cnfirmBtn.size direction:IHGradientChangeDirectionVertical startColor:[UIColor colorWithHexString:@"#8FFF82"] endColor:[UIColor colorWithHexString:@"#4EEB97"]];
        [_cnfirmBtn setTitle:self.isPaying?@"Yakin":@"Isi ulang koin" forState:UIControlStateNormal];
        [_cnfirmBtn setTitleColor:[UIColor colorWithHexString:@"#007538"] forState:UIControlStateNormal];
        _cnfirmBtn.titleLabel.font = [UIFont mediumFontWithSize:17.0f];
        [_cnfirmBtn setBorderWithCornerRadius:20 type:UIViewCornerTypeAll];
        [_cnfirmBtn addTarget:self action:@selector(confirmConsumeKoinActon:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cnfirmBtn;
}

@end
