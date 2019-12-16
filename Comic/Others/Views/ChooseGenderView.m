//
//  ChooseGenderView.m
//  Comic
//
//  Created by vision on 2019/11/22.
//  Copyright © 2019 vision. All rights reserved.
//

#import "ChooseGenderView.h"

@interface ChooseGenderView (){
    NSInteger selectedGender;
}

@property (nonatomic,strong) UIImageView    *headImgView;
@property (nonatomic,strong) UIButton       *boyBtn;
@property (nonatomic,strong) UIButton       *girlBtn;
@property (nonatomic,strong) UIImageView    *coverView;

@end

@implementation ChooseGenderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        selectedGender = 1;
        
        [self addSubview:self.headImgView];
        [self addSubview:self.boyBtn];
        [self addSubview:self.girlBtn];
        [self addSubview:self.coverView];
        self.coverView.hidden = YES;
    }
    return self;
}

#pragma mark -- Event response
#pragma mark 选择性别
-(void)chooseGenderAction:(UIButton *)sender{
    self.coverView.hidden = NO;
    if (sender.tag==101) {
        self.coverView.frame = self.boyBtn.frame;
    }else{
        self.coverView.frame = self.girlBtn.frame;
    }
    selectedGender = sender.tag-100;
    self.sureBlock(selectedGender);
}

#pragma mark --Getters
-(UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView   = [[UIImageView alloc] initWithFrame:CGRectMake(0,44, 329, 196)];
        _headImgView.image = [UIImage imageNamed:@"first_into_preference_gender"];
    }
    return _headImgView;
}

#pragma mark 性别男
-(UIButton *)boyBtn{
    if (!_boyBtn) {
        _boyBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-260)/2.0, self.headImgView.bottom+20, 260, 58)];
        [_boyBtn setBackgroundImage:[UIImage imageNamed:@"first_into_preference_male"] forState:UIControlStateNormal];
        _boyBtn.adjustsImageWhenHighlighted = NO;
        _boyBtn.tag = 101;
        [_boyBtn addTarget:self action:@selector(chooseGenderAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _boyBtn;
}

#pragma mark 性别女
-(UIButton *)girlBtn{
    if (!_girlBtn) {
        _girlBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-260)/2.0, self.boyBtn.bottom+35, 260, 58)];
        [_girlBtn setBackgroundImage:[UIImage imageNamed:@"first_into_preference_female"] forState:UIControlStateNormal];
        _girlBtn.adjustsImageWhenHighlighted = NO;
        _girlBtn.tag = 102;
        [_girlBtn addTarget:self action:@selector(chooseGenderAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _girlBtn;
}

-(UIImageView *)coverView{
    if (!_coverView) {
        _coverView = [[UIImageView alloc] initWithFrame:self.boyBtn.frame];
        _coverView.image = [UIImage imageNamed:@"choose_white"];
    }
    return _coverView;
}

@end
