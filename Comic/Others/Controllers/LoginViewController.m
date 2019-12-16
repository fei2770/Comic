//
//  LoginViewController.m
//  Comic
//
//  Created by vision on 2019/11/22.
//  Copyright © 2019 vision. All rights reserved.
//

#import "LoginViewController.h"
#import "BaseWebViewController.h"
#import "LoginView.h"
#import "TempLoginView.h"
#import "GoogleLoginManager.h"
#import <SVProgressHUD.h>
#import "APPInfoManager.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface LoginViewController ()<TempLoginViewDelegate>

@property (nonatomic,strong) UIButton       *backBtn;
@property (nonatomic,strong) UIImageView    *bgImgView;
@property (nonatomic,strong) UIImageView    *logoImgView;
@property (nonatomic,strong) UILabel        *welcomeLabel;
@property (nonatomic,strong) LoginView      *loginView;
@property (nonatomic,strong) TempLoginView  *tempLoginView;
@property (nonatomic,strong) UIButton       *agreeBtn;
@property (nonatomic,strong) UIButton       *serviceBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self initLoginView];
    
    [GIDSignIn sharedInstance].presentingViewController = self;
    
}

#pragma mark 状态栏样式
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark -- Event response
#pragma mark  返回
-(void)dismissLoginVCAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 登录
-(void)loginAction:(UIButton *)sender{
    if (!self.agreeBtn.selected) {
        return;
    }
    
    if (sender.tag==100) { //谷歌登录
        [self googleSignIn];
    }else{
        [self facebookLogin];
    }
}

#pragma mark 同意协议
-(void)agreeRegisterRuleAction:(UIButton *)sender{
    sender.selected = !sender.selected;
}

#pragma mark
-(void)choosesSrviceRulesAction:(UIButton *)sender{
    BaseWebViewController *webVC = [[BaseWebViewController alloc] init];
    webVC.urlStr = [NSString stringWithFormat:kHostTempURL,kUserAgreementURL];
    webVC.webTitle = @"Perjanjian registrasi pengguna";
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark TempLoginViewDelegate
#pragma mark 账号登录
-(void)tempLoginViewDidAccountLogin:(TempLoginView *)tempLoginview account:(NSString *)account password:(NSString *)password{
    NSNumber *gender = [NSUserDefaultsInfos getValueforKey:kUserGenderPreference];
    NSArray *types = [NSUserDefaultsInfos getValueforKey:kUserChannelPreference];
    NSString *typeStr = [[ComicManager sharedComicManager] getValueWithParams:types];
    NSDictionary *params = @{@"email":account,@"password":password,@"channel":gender,@"book_type":typeStr};
    [[HttpRequest sharedInstance] postWithURLString:kAccountSignInAPI showLoading:YES parameters:params success:^(id responseObject) {
        NSDictionary *userDict = [responseObject valueForKey:@"data"];
        [self parseUserInfo:userDict];
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark Google or Facebook login
-(void)tempLoginViewDidThirdLogin:(TempLoginView *)tempLoginview tag:(NSInteger)tag{
    if (tag==100) { //谷歌登录
        [self googleSignIn];
    }else{
        [self facebookLogin];
    }
}

#pragma mark -- Private methods
#pragma mark 初始化
-(void)initLoginView{
    [self.view addSubview:self.bgImgView];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.logoImgView];
    [self.view addSubview:self.welcomeLabel];
    
    BOOL loginSwitch = [[NSUserDefaultsInfos getValueforKey:kloginSwitch] boolValue];
    if (loginSwitch) {
        [self.view addSubview:self.tempLoginView];
    }else{
        [self.view addSubview:self.loginView];
    }
    
    [self.view addSubview:self.agreeBtn];
    [self.view addSubview:self.serviceBtn];
}


#pragma mark 谷歌登录
-(void)googleSignIn{
    [SVProgressHUD show];
    [[GoogleLoginManager sharedGoogleLoginManager] checkGoogleAccountStateWithCompletion:^(GoogleAccountState state) {
        MyLog(@"checkGoogleAccountState:%ld",state);
        switch (state) {
            case GoogleAccountStateOnline:
                {
                    GIDGoogleUser *user = [GoogleLoginManager sharedGoogleLoginManager].currentUser;
                    MyLog(@"state:%ld,User --------- id:%@,\n token:%@, \n fullname:%@,\n email:%@",state,user.userID,user.authentication.idToken,user.profile.name,user.profile.email);
                    [self googleLoginWithUserId:user.userID token:user.authentication.idToken];
                }
                break;
            case GoogleAccountStateHasPreviousSignIn:
            {
                [[GoogleLoginManager sharedGoogleLoginManager] autoLoginWithCompletion:^(GIDGoogleUser *user, NSError *error) {
                    if (!error) {
                        MyLog(@"------Google autoLogin---  User --------- id:%@,\n token:%@, \n fullname:%@,\n email:%@",user.userID,user.authentication.idToken,user.profile.name,user.profile.email);
                        [self googleLoginWithUserId:user.userID token:user.authentication.idToken];
                    }else{
                        MyLog(@"startGoogleLogin---fail,error:%@",error.localizedDescription);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [SVProgressHUD dismiss];
                        });
                    }
                }];
            }
                break;
            case GoogleAccountStateOffline:
            {
                [[GoogleLoginManager sharedGoogleLoginManager] startGoogleLoginWithCompletion:^(GIDGoogleUser *user, NSError *error) {
                    if (!error) {
                        MyLog(@"------Google startLogin--- User --------- id:%@,\n token:%@, \n fullname:%@,\n email:%@",user.userID,user.authentication.idToken,user.profile.name,user.profile.email);
                        [self googleLoginWithUserId:user.userID token:user.authentication.idToken];
                    }else{
                        MyLog(@"startGoogleLogin---fail,error:%@",error.localizedDescription);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [SVProgressHUD dismiss];
                        });
                    }
                }];
            }
            default:
                break;
        }
    }];
}


#pragma mark Facebook 登录
-(void)facebookLogin{
    if ([FBSDKAccessToken currentAccessToken]) {
        [self loginCallbackWithFbToken:[FBSDKAccessToken currentAccessToken].tokenString];
    }else{
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logInWithReadPermissions: @[@"email",@"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            MyLog(@"facebook login result.grantedPermissions = %@,error = %@",result.grantedPermissions,error);
            if (error) {
                MyLog(@"Facebook login error");
            } else if (result.isCancelled) {
                MyLog(@"Facebook login cancelled");
            } else {
                MyLog(@"Facebook Logged in ------- token:%@,tokenString:%@",result.token,result.token.tokenString);
                [self loginCallbackWithFbToken:result.token.tokenString];
            }
        }];
    }
    
}


#pragma mark 谷歌登录成功处理
-(void)googleLoginWithUserId:(NSString *)gid token:(NSString *)idToken{
    NSString *devicID = [APPInfoManager sharedAPPInfoManager].deviceIdentifier;
    NSNumber *gender = [NSUserDefaultsInfos getValueforKey:kUserGenderPreference];
    NSArray *types = [NSUserDefaultsInfos getValueforKey:kUserChannelPreference];
    NSString *typeStr = [[ComicManager sharedComicManager] getValueWithParams:types];
    NSDictionary *params = @{@"access_token":idToken,@"deviceId":devicID,@"from":@"ios",@"id":gid,@"channel":gender,@"book_type":typeStr};
    [[HttpRequest sharedInstance] postWithURLString:kGoogleSignInAPI showLoading:YES parameters:params success:^(id responseObject) {
        NSDictionary *data = [responseObject objectForKey:@"data"];
        NSDictionary *userDict = [data valueForKey:@"userinfo"];
        [self parseUserInfo:userDict];
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark  - Facebook login callback
-(void)loginCallbackWithFbToken:(NSString *)token{
    NSString *devicID = [APPInfoManager sharedAPPInfoManager].deviceIdentifier;
    NSNumber *gender = [NSUserDefaultsInfos getValueforKey:kUserGenderPreference];
    NSArray *types = [NSUserDefaultsInfos getValueforKey:kUserChannelPreference];
    NSString *typeStr = [[ComicManager sharedComicManager] getValueWithParams:types];
    NSDictionary *params = @{@"access_token":token,@"deviceId":devicID,@"from":@"ios",@"channel":gender,@"book_type":typeStr};
    [[HttpRequest sharedInstance] postWithURLString:kFacebookSignInAPI showLoading:YES parameters:params success:^(id responseObject) {
        NSDictionary *data = [responseObject objectForKey:@"data"];
        NSDictionary *userDict = [data valueForKey:@"userinfo"];
        [self parseUserInfo:userDict];
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark 用户信息处理
-(void)parseUserInfo:(NSDictionary *)userDict{
    NSString *token = [userDict valueForKey:@"token"];
    [NSUserDefaultsInfos putKey:kUserToken andValue:token];
    [NSUserDefaultsInfos putKey:kIsLogin andValue:[NSNumber numberWithBool:YES]];
    [ComicManager sharedComicManager].isLogin = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- Getters
#pragma mark bg
-(UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _bgImgView.image = [UIImage imageNamed:@"login_background"];
    }
    return _bgImgView;
}

#pragma mark 返回
-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn=[[UIButton alloc] initWithFrame:CGRectMake(5,KStatusHeight + 2, 40, 40)];
        [_backBtn setImage:[UIImage drawImageWithName:@"return_white"size:CGSizeMake(12, 18)] forState:UIControlStateNormal];
        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-10.0, 0, 0)];
        [_backBtn addTarget:self action:@selector(dismissLoginVCAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

#pragma mark logo
-(UIImageView *)logoImgView{
    if (!_logoImgView) {
        _logoImgView = [[UIImageView alloc] initWithFrame:IS_IPHONE_5?CGRectMake((kScreenWidth-120.0)/2.0,60,120,124): CGRectMake((kScreenWidth-167.0)/2.0,90,167, 171)];
        _logoImgView.image = [UIImage imageNamed:@"login_logo"];
    }
    return _logoImgView;
}

#pragma mark  welcome
-(UILabel *)welcomeLabel{
    if (!_welcomeLabel) {
        _welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 ,self.logoImgView.bottom+20,kScreenWidth-40, 40)];
        _welcomeLabel.textColor = [UIColor whiteColor];
        _welcomeLabel.numberOfLines = 0;
        _welcomeLabel.font = [UIFont mediumFontWithSize:13.0f];
        _welcomeLabel.textAlignment = NSTextAlignmentCenter;
        _welcomeLabel.text = @"Selamat datang untuk check in,Silahkan pilih cara check in di bawah ini";
    }
    return _welcomeLabel;
}

#pragma mark 登录
-(LoginView *)loginView{
    if (!_loginView) {
        _loginView = [[LoginView alloc] initWithFrame:CGRectMake(0, self.welcomeLabel.bottom, kScreenWidth, 180)];
        [_loginView.googleLoginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        [_loginView.fbLoginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginView;
}

-(TempLoginView *)tempLoginView{
    if (!_tempLoginView) {
        _tempLoginView  = [[TempLoginView alloc] initWithFrame:CGRectMake(0, self.welcomeLabel.bottom, kScreenWidth, 280)];
        _tempLoginView.delegate = self;
    }
    return _tempLoginView;
}

#pragma mark  同意协议
-(UIButton *)agreeBtn{
    if (!_agreeBtn) {
        NSString *str = @"Registrasi dan setuju(Perjanjian registrasi pengguna)";
        CGFloat btnW = [str boundingRectWithSize:CGSizeMake(kScreenWidth, 20) withTextFont:[UIFont regularFontWithSize:IS_IPHONE_5?10:12]].width;
        CGFloat tempW = [@"Registrasi dan setuju" boundingRectWithSize:CGSizeMake(kScreenWidth,20) withTextFont:[UIFont regularFontWithSize:IS_IPHONE_5?10:12]].width;
        _agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-btnW)/2.0, kScreenHeight-55,tempW+30,20)];
        [_agreeBtn setImage:[UIImage imageNamed:@"clause_unchoose"] forState:UIControlStateNormal];
        [_agreeBtn setImage:[UIImage imageNamed:@"clause_choose"] forState:UIControlStateSelected];
        [_agreeBtn setTitle:@"Registrasi dan setuju" forState:UIControlStateNormal];
        [_agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _agreeBtn.titleLabel.font = [UIFont regularFontWithSize:IS_IPHONE_5?10:12];
        [_agreeBtn addTarget:self action:@selector(agreeRegisterRuleAction:) forControlEvents:UIControlEventTouchUpInside];
        _agreeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        _agreeBtn.selected = YES;
    }
    return _agreeBtn;
}

#pragma mark 服务协议
-(UIButton *)serviceBtn{
    if (!_serviceBtn) {
        NSString *str = @"(Perjanjian registrasi pengguna)";
        CGFloat btnW = [str boundingRectWithSize:CGSizeMake(kScreenWidth,20) withTextFont:[UIFont regularFontWithSize:IS_IPHONE_5?10:12]].width;
        _serviceBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.agreeBtn.right, kScreenHeight-55, btnW, 20)];
        [_serviceBtn setTitle:str forState:UIControlStateNormal];
        [_serviceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _serviceBtn.titleLabel.font = [UIFont regularFontWithSize:IS_IPHONE_5?10:12];
        [_serviceBtn addTarget:self action:@selector(choosesSrviceRulesAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _serviceBtn;
}

@end
