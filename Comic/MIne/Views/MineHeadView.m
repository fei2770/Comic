//
//  MineHeadView.m
//  Comic
//
//  Created by vision on 2019/11/15.
//  Copyright © 2019 vision. All rights reserved.
//

#import "MineHeadView.h"
#import "PPBadgeView.h"

@interface MineHeadView ()


@property (nonatomic,strong) UIImageView *bgImgView;
@property (nonatomic,strong) UIImageView *headImgView;    //头像
@property (nonatomic,strong) UILabel     *nameLabel;      //姓名
@property (nonatomic,strong) UIButton    *vipBtn;
@property (nonatomic,strong) UIButton    *signInBtn;      //登录
@property (nonatomic,strong) UIButton    *messageBtn;     //消息
@property (nonatomic,strong) UIButton    *setUpBtn;       //设置
@property (nonatomic,strong) UILabel     *beansLab;       //漫豆
@property (nonatomic,strong) UIView      *lineView;       //线
@property (nonatomic,strong) UIButton    *rechargeBtn;    //充值
@property (nonatomic,strong) UIImageView *iconImgView;     //开通会员
@property (nonatomic,strong) UILabel     *tipsLab;      //开通会员
@property (nonatomic,strong) UIButton    *memberBtn;      //开通会员

@end

@implementation MineHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgImgView];
        [self addSubview:self.headImgView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.vipBtn];
        [self addSubview:self.signInBtn];
        self.signInBtn.hidden = self.vipBtn.hidden  = YES;
        [self addSubview:self.messageBtn];
        [self addSubview:self.setUpBtn];
        [self addSubview:self.beansLab];
        [self addSubview:self.lineView];
        [self addSubview:self.rechargeBtn];
        [self addSubview:self.iconImgView];
        [self addSubview:self.tipsLab];
        [self addSubview:self.memberBtn];
    }
    return self;
}

#pragma mark


#pragma mark -- Event response
#pragma mark 点击头像
-(void)headViewClickAction:(UITapGestureRecognizer *)sender{
    if ([self.delegate respondsToSelector:@selector(mineHeadViewDidSelecteduserInfo)]) {
        [self.delegate mineHeadViewDidSelecteduserInfo];
    }
}

-(void)mineHeadBtnClickAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(mineHeadViewDidClickBtnWithTag:)]) {
        [self.delegate mineHeadViewDidClickBtnWithTag:sender.tag];
    }
}

#pragma mark 填充数据
-(void)setUserModel:(UserModel *)userModel{
    self.vipBtn.hidden = NO;
    BOOL isVip = [userModel.vip boolValue];
    if (isVip) {
        self.bgImgView.image = [UIImage imageNamed:@"my_background2"];
        [self.vipBtn setImage:[UIImage imageNamed:@"recharge_vip"] forState:UIControlStateNormal];
        self.vipBtn.frame = CGRectMake(self.headImgView.right+10, self.nameLabel.bottom+5, 53, 21);
        self.iconImgView.hidden = self.tipsLab.hidden = self.memberBtn.hidden = YES;
        self.bgImgView.frame = CGRectMake(0, 0, kScreenWidth, 190);
    }else{
        self.bgImgView.image = [UIImage imageNamed:@"my_background"];
        [self.vipBtn setImage:[UIImage imageNamed:@"recharge_vip_opening"] forState:UIControlStateNormal];
        self.vipBtn.frame = CGRectMake(self.headImgView.right+10, self.nameLabel.bottom+5, 69, 21);
        self.iconImgView.hidden = self.tipsLab.hidden = self.memberBtn.hidden = NO;
        self.bgImgView.frame = CGRectMake(0, 0, kScreenWidth, 280);
    }
    
    self.signInBtn.hidden = [ComicManager hasSignIn];
    self.signInBtn.frame = CGRectMake(self.vipBtn.right+10, self.nameLabel.bottom+7, 54, 17);
    
    if (kIsEmptyString(userModel.head_portrait)) {
        self.headImgView.image = [UIImage imageNamed:@"default_head"];
    }else{
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:userModel.head_portrait] placeholderImage:[UIImage imageNamed:@"default_head"]];
    }
    self.nameLabel.text = userModel.name;
    NSString *beansStr = [NSString stringWithFormat:@"%ld koin",(long)[userModel.bean integerValue]];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:beansStr];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont mediumFontWithSize:26] range:NSMakeRange(0, beansStr.length-4)];
    self.beansLab.attributedText = attributedStr;
}

-(void)setUnreadMsgState:(BOOL)unreadMsgState{
    if (unreadMsgState) {
        [self.messageBtn pp_moveBadgeWithX:0 Y:0];
        [self.messageBtn pp_setBadgeHeightPoints:8];
        [self.messageBtn pp_showBadge];
    }else{
        [self.messageBtn pp_hiddenBadge];
    }
}

#pragma mark -- Getters
#pragma mark  封面
-(UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bgImgView.image = [UIImage imageNamed:@"my_background"];
    }
    return _bgImgView;
}

#pragma mark  头像
-(UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(22, KStatusHeight+25, 59, 59)];
        [_headImgView setBorderWithCornerRadius:29.5 type:UIViewCornerTypeAll];
        _headImgView.userInteractionEnabled = YES;
        _headImgView.image = [UIImage imageNamed:@"default_head"];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headViewClickAction:)];
        [_headImgView addGestureRecognizer:tapGesture];
    }
    return _headImgView;
}

#pragma mark 姓名
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headImgView.right+10, self.headImgView.top+5, 180, 16)];
        _nameLabel.textColor = [UIColor commonColor_black];
        _nameLabel.font = [UIFont mediumFontWithSize:IS_IPHONE_5?16:18];
        _nameLabel.text = @"";
    }
    return _nameLabel;
}

#pragma mark 开通vip
-(UIButton *)vipBtn{
    if (!_vipBtn) {
        _vipBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.headImgView.right+10, self.nameLabel.bottom+5, 69, 21)];
        [_vipBtn setImage:[UIImage imageNamed:@"recharge_vip_opening"] forState:UIControlStateNormal];
        _vipBtn.tag =0;
        [_vipBtn addTarget:self action:@selector(mineHeadBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _vipBtn;
}

#pragma mark 登录
-(UIButton *)signInBtn{
    if (!_signInBtn) {
        _signInBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.vipBtn.right+10, self.nameLabel.bottom+7, 54, 17)];
        [_signInBtn setImage:[UIImage imageNamed:@"my_login"] forState:UIControlStateNormal];
        _signInBtn.tag = 5;
        [_signInBtn addTarget:self action:@selector(mineHeadBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signInBtn;
}

#pragma mark 消息
-(UIButton *)messageBtn{
    if (!_messageBtn) {
        _messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-90, self.nameLabel.top, 24, 22)];
        [_messageBtn setImage:[UIImage imageNamed:@"my_notices"] forState:UIControlStateNormal];
        _messageBtn.tag =1;
        [_messageBtn addTarget:self action:@selector(mineHeadBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageBtn;
}

#pragma mark 设置
-(UIButton *)setUpBtn{
    if (!_setUpBtn) {
        _setUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.messageBtn.right+20, self.nameLabel.top, 24, 22)];
        [_setUpBtn setImage:[UIImage imageNamed:@"my_install"] forState:UIControlStateNormal];
        _setUpBtn.tag =2;
        [_setUpBtn addTarget:self action:@selector(mineHeadBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setUpBtn;
}

#pragma mark 漫豆
-(UILabel *)beansLab{
    if (!_beansLab) {
        _beansLab = [[UILabel alloc] initWithFrame:CGRectMake(20, self.headImgView.bottom+20, kScreenWidth/2.0-30, 30)];
        _beansLab.font = [UIFont regularFontWithSize:14.0f];
        _beansLab.textColor = [UIColor commonColor_black];
        _beansLab.textAlignment = NSTextAlignmentCenter;
        NSString *beansStr = @"0 koin";
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:beansStr];
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont mediumFontWithSize:26] range:NSMakeRange(0, beansStr.length-4)];
        self.beansLab.attributedText = attributedStr;
    }
    return _beansLab;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2.0, self.headImgView.bottom+20, 1, 25)];
        _lineView.backgroundColor = [UIColor commonColor_black];
    }
    return _lineView;
}

#pragma mark 充值
-(UIButton *)rechargeBtn{
    if (!_rechargeBtn) {
        _rechargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2.0+20, self.headImgView.bottom+20, kScreenWidth/2.0-30, 30)];
        [_rechargeBtn setImage:[UIImage imageNamed:@"my_recharge"] forState:UIControlStateNormal];
        [_rechargeBtn setTitle:@"Isi ulang" forState:UIControlStateNormal];
        [_rechargeBtn setTitleColor:[UIColor commonColor_black] forState:UIControlStateNormal];
        _rechargeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _rechargeBtn.tag =3;
        [_rechargeBtn addTarget:self action:@selector(mineHeadBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rechargeBtn;
}

#pragma mark
-(UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(40, self.rechargeBtn.bottom+45, 191, 28)];
        _iconImgView.image = [UIImage imageNamed:@"recharge_vip_photo"];
    }
    return _iconImgView;
}

#pragma mark 漫豆
-(UILabel *)tipsLab{
    if (!_tipsLab) {
        _tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(40, self.iconImgView.bottom+10, 220, 14)];
        _tipsLab.font = [UIFont regularFontWithSize:12.0f];
        _tipsLab.textColor = [UIColor colorWithHexString:@"#E1C277"];
        _tipsLab.text = @"bisa menikmati banyak hak istimewa";
    }
    return _tipsLab;
}

#pragma mark 会员
-(UIButton *)memberBtn{
    if (!_memberBtn) {
        _memberBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-111, self.rechargeBtn.bottom+40, 88, 36)];
        _memberBtn.backgroundColor = [UIColor bm_colorGradientChangeWithSize:_memberBtn.size direction:IHGradientChangeDirectionLevel startColor:[UIColor colorWithHexString:@"#EDC156"] endColor:[UIColor colorWithHexString:@"#FFE39C"]];
        [_memberBtn setTitle:@"Daftar Langsung" forState:UIControlStateNormal];
        [_memberBtn setTitleColor:[UIColor colorWithHexString:@"#7A4500"] forState:UIControlStateNormal];
        _memberBtn.titleLabel.font = [UIFont mediumFontWithSize:13.0f];
        _memberBtn.titleLabel.numberOfLines = 0;
        _memberBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_memberBtn setBorderWithCornerRadius:18 type:UIViewCornerTypeLeft];
        _memberBtn.tag = 4;
        [_memberBtn addTarget:self action:@selector(mineHeadBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _memberBtn;
}


@end
