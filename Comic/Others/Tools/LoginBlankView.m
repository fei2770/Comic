//
//  LoginBlankView.m
//  Comic
//
//  Created by vision on 2019/11/26.
//  Copyright © 2019 vision. All rights reserved.
//

#import "LoginBlankView.h"

@implementation LoginBlankView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-78)/2,40, 78, 70)];
        imgView.image=[UIImage imageNamed:@"unable_view"];
        [self addSubview:imgView];
        
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(20, imgView.bottom+15, kScreenWidth-40, 20)];
        lab.textAlignment=NSTextAlignmentCenter;
        lab.text=@"Silahkan masuk untuk melihat konten";
        lab.font=[UIFont regularFontWithSize:16.0f];
        lab.textColor=[UIColor colorWithHexString:@"#8981B3"];
        [self addSubview:lab];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-143)/2.0, lab.bottom+20, 143, 47)];
        [btn setImage:[UIImage imageNamed:@"public_login"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

-(void)loginAction:(UIButton *)sender{
    self.loginBlock();
}

@end
