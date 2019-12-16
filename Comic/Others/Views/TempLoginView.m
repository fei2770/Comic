//
//  TempLoginView.m
//  Comic
//
//  Created by vision on 2019/12/5.
//  Copyright © 2019 vision. All rights reserved.
//

#import "TempLoginView.h"

@interface TempLoginView ()<UITextFieldDelegate>

@property (nonatomic,strong) UIView            *accountView;
@property (nonatomic,strong) UITextField       *accountTextField;
@property (nonatomic,strong) UIView            *passwordView;
@property (nonatomic,strong) UITextField       *passwordTextField;
@property (nonatomic,strong) UIButton          *loginBtn;
@property (nonatomic,strong) UIButton          *googleLoginBtn;
@property (nonatomic,strong) UIButton          *fbLoginBtn;

@end

@implementation TempLoginView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.accountView];
        [self addSubview:self.passwordView];
        [self addSubview:self.loginBtn];
        [self addSubview:self.googleLoginBtn];
        [self addSubview:self.fbLoginBtn];
    }
    return self;
}

#pragma mark -- Event response
#pragma mark login
-(void)accountLoginAction:(UIButton *)sender{
    if (kIsEmptyString(self.accountTextField.text)) {
        [self makeToast:@"Akun tidak boleh kosong" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if (kIsEmptyString(self.passwordTextField.text)) {
        [self makeToast:@"Password tidak boleh kosong" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(tempLoginViewDidAccountLogin:account:password:)]) {
        [self.delegate tempLoginViewDidAccountLogin:self account:self.accountTextField.text password:self.passwordTextField.text];
    }
    
}

#pragma mark - google or fb login
-(void)loginAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(tempLoginViewDidThirdLogin:tag:)]) {
        [self.delegate tempLoginViewDidThirdLogin:self tag:sender.tag];
    }
}

#pragma mark UITextFieldDelegate
#pragma mark - return
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.accountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    return YES;
}

#pragma mark account
-(UIView *)accountView{
    if (!_accountView) {
        _accountView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-246)/2.0,IS_IPHONE_5?0:15, 246, 48)];
        
        UIImageView  *accountImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 16, 24)];
        accountImgView.image = [UIImage imageNamed:@"login_user_name"];
        [_accountView addSubview:accountImgView];
        
        self.accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(accountImgView.right+18, 12, _accountView.width-accountImgView.right-20, 24)];
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"Masukan akun" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#808080"]}];
        self.accountTextField.attributedPlaceholder = attr;
        self.accountTextField.textColor = [UIColor whiteColor];
        self.accountTextField.font = [UIFont regularFontWithSize:15.0f];
        self.accountTextField.returnKeyType = UIReturnKeyDone;
        self.accountTextField.delegate = self;
        self.accountTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        [_accountView addSubview:self.accountTextField];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 47, _accountView.width, 1.0)];
        lineView.backgroundColor = [UIColor whiteColor];
        [_accountView addSubview:lineView];
        
    }
    return _accountView;
}

#pragma mark password
-(UIView *)passwordView{
    if (!_passwordView) {
        _passwordView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-246)/2.0, self.accountView.bottom, 246, 48)];
        
        UIImageView  *pswImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 18, 22)];
        pswImgView.image = [UIImage imageNamed:@"login_user_password"];
        [_passwordView addSubview:pswImgView];
        
        self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(pswImgView.right+18, 12, _accountView.width-pswImgView.right-20, 24)];
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"Masukan password" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#808080"]}];
        self.passwordTextField.attributedPlaceholder = attr;
        self.passwordTextField.textColor = [UIColor whiteColor];
        self.passwordTextField.font = [UIFont regularFontWithSize:15.0f];
        self.passwordTextField.returnKeyType = UIReturnKeyDone;
        self.passwordTextField.delegate = self;
        self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        [_passwordView addSubview:self.passwordTextField];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 47, _accountView.width, 1.0)];
        lineView.backgroundColor = [UIColor whiteColor];
        [_passwordView addSubview:lineView];
    }
    return _passwordView;
}

#pragma mark login
-(UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-172)/2.0, self.passwordView.bottom+20, 172, 40)];
        [_loginBtn setTitle:@"Login" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
        _loginBtn.backgroundColor = [UIColor colorWithHexString:@"#FFF651"];
        [_loginBtn setBorderWithCornerRadius:20 type:UIViewCornerTypeAll];
        [_loginBtn addTarget:self action:@selector(accountLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

#pragma mark google login
-(UIButton *)googleLoginBtn{
    if (!_googleLoginBtn) {
        _googleLoginBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2.0-80, self.loginBtn.bottom+30, 50, 50)];
        [_googleLoginBtn setImage:[UIImage imageNamed:@"temp_google_login"] forState:UIControlStateNormal];
        _googleLoginBtn.tag = 100;
        [_googleLoginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _googleLoginBtn;
}

#pragma mark facebook login
-(UIButton *)fbLoginBtn{
    if (!_fbLoginBtn) {
        _fbLoginBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2.0+30.0, self.loginBtn.bottom+30, 50, 50)];
        [_fbLoginBtn setImage:[UIImage imageNamed:@"temp_facebook_login"] forState:UIControlStateNormal];
        _fbLoginBtn.tag = 101;
        [_fbLoginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fbLoginBtn;
}

@end
