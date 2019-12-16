//
//  PurchaseToastView.m
//  Comic
//
//  Created by vision on 2019/12/4.
//  Copyright © 2019 vision. All rights reserved.
//

#import "PurchaseToastView.h"
#import "QWAlertView.h"

@interface PurchaseToastView ()

@property (nonatomic,strong) UILabel       *titleLabel;
@property (nonatomic,strong) UIButton      *closeBtn;
@property (nonatomic,strong) UILabel       *descLabel;
@property (nonatomic,strong) UIButton      *loginBtn;
@property (nonatomic,strong) UIButton      *confirmBtn;
 
@property (nonatomic, copy ) NSString       *content;
@property (nonatomic, copy ) ButtonClickBlock clickBlock;

@end

@implementation PurchaseToastView


-(instancetype)initWithFrame:(CGRect)frame content:(NSString *)content clickAction:(ButtonClickBlock)clickBlock{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setBorderWithCornerRadius:10 type:UIViewCornerTypeAll];
        
        self.content = content;
        self.clickBlock = clickBlock;
        [self addSubview:self.titleLabel];
        [self addSubview:self.closeBtn];
        [self addSubview:self.descLabel];
        [self addSubview:self.loginBtn];
        [self addSubview:self.confirmBtn];
    }
    return self;
}

+(void)showConsumeKoinWithFrame:(CGRect)frame content:(NSString *)content clickAction:(ButtonClickBlock)clickBlock{
    PurchaseToastView *toastView = [[PurchaseToastView alloc] initWithFrame:frame content:content clickAction:clickBlock];
    [toastView showPurchaseToastView];
}

#pragma mark -- Event response
#pragma mark 关闭
-(void)closeToastViewActon:(UIButton *)sender{
    [[QWAlertView sharedMask] dismiss];
}

#pragma mark 登录或确定
-(void)toastViewClickActon:(UIButton *)sender{
    self.clickBlock(sender.tag);
    [[QWAlertView sharedMask] dismiss];
}

#pragma mark-- Private methods
#pragma mark 显示
-(void)showPurchaseToastView{
    [[QWAlertView sharedMask] show:self withType:QWAlertViewStyleAlert];
}

#pragma mark -- Getters
#pragma mark 标题
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 26, self.width-20, 20)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"Penjelasan mode pengunjung";
        _titleLabel.textColor = [UIColor colorWithHexString:@"#FF9100"];
        _titleLabel.font = [UIFont mediumFontWithSize:16.0f];
    }
    return _titleLabel;
}

#pragma mark 取消
-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width-30,0, 30, 30)];
        [_closeBtn setImage:[UIImage drawImageWithName:@"popup_close" size:CGSizeMake(20, 20)] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeToastViewActon:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

#pragma mark vip提示
-(UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.numberOfLines = 0;
        _descLabel.textColor = [UIColor colorWithHexString:@"#00D08D"];
        _descLabel.font = [UIFont regularFontWithSize:13.0f];
        _descLabel.text = self.content;
        CGFloat descH = [self.content boundingRectWithSize:CGSizeMake(self.width-40, self.height) withTextFont:_descLabel.font].height;
        _descLabel.frame = CGRectMake(20, self.titleLabel.bottom+12, self.width-40, descH+10);
    }
    return _descLabel;
}

#pragma mark 登录
-(UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.width-200)/2.0, self.descLabel.bottom+20, 200, 36)];
        _loginBtn.backgroundColor = [UIColor colorWithHexString:@"#6941FF"];
        [_loginBtn setTitle:@"Log in" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont mediumFontWithSize:18.0f];
        [_loginBtn setBorderWithCornerRadius:18 type:UIViewCornerTypeAll];
        _loginBtn.tag = 0;
        [_loginBtn addTarget:self action:@selector(toastViewClickActon:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

#pragma mark 开通
-(UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.width-200)/2.0, self.loginBtn.bottom+15, 200, 36)];
        _confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#FF844D"];
        [_confirmBtn setTitle:@"Pembelian" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont mediumFontWithSize:18.0f];
        [_confirmBtn setBorderWithCornerRadius:18 type:UIViewCornerTypeAll];
        _confirmBtn.tag = 1;
        [_confirmBtn addTarget:self action:@selector(toastViewClickActon:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

@end
