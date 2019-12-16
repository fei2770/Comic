//
//  LoginView.m
//  Comic
//
//  Created by vision on 2019/12/5.
//  Copyright © 2019 vision. All rights reserved.
//

#import "LoginView.h"



@implementation LoginView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.googleLoginBtn];
        [self addSubview:self.fbLoginBtn];
    }
    return self;
}


#pragma mark google login
-(UIButton *)googleLoginBtn{
    if (!_googleLoginBtn) {
        _googleLoginBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-255)/2.0, 30, 255, 60)];
        [_googleLoginBtn setImage:[UIImage imageNamed:@"login_google"] forState:UIControlStateNormal];
        _googleLoginBtn.tag = 100;
    }
    return _googleLoginBtn;
}

#pragma mark facebook login
-(UIButton *)fbLoginBtn{
    if (!_fbLoginBtn) {
        _fbLoginBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-255)/2.0, self.googleLoginBtn.bottom+30, 255, 60)];
        [_fbLoginBtn setImage:[UIImage imageNamed:@"login_facebook"] forState:UIControlStateNormal];
        _fbLoginBtn.tag = 101;
    }
    return _fbLoginBtn;
}

@end
