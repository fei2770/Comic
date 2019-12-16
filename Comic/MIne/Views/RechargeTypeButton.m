//
//  RechargeTypeBtn.m
//  Comic
//
//  Created by vision on 2019/11/18.
//  Copyright © 2019 vision. All rights reserved.
//

#import "RechargeTypeButton.h"

@interface RechargeTypeButton ()

@property (nonatomic,strong) UIImageView *beansImgView;
@property (nonatomic,strong) UILabel     *koinLabel;
@property (nonatomic,strong) UILabel     *giveKoinLabel;
@property (nonatomic,strong) UILabel     *priceLabel;

@end

@implementation RechargeTypeButton

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor colorWithHexString:@"#D5D7DE"].CGColor;
        self.layer.borderWidth = 2.0;
        [self setBorderWithCornerRadius:8.0 type:UIViewCornerTypeBottom];
        
        
        [self addSubview:self.beansImgView];
        [self addSubview:self.koinLabel];
        [self addSubview:self.giveKoinLabel];
        [self addSubview:self.priceLabel];
    }
    return self;
}

#pragma mark 填充数据
-(void)setTypeModel:(KoinTypeModel *)typeModel{
    NSInteger beans = [typeModel.beans integerValue];
    self.koinLabel.text = [NSString stringWithFormat:@"%ld koin",(long)beans];
    self.giveKoinLabel.text = [NSString stringWithFormat:@"hadiah %ld koin",(long)[typeModel.presenter_beans integerValue]];
    self.priceLabel.text = [NSString stringWithFormat:@"$%.2f",[typeModel.price doubleValue]];
}

-(void)setIs_selected:(BOOL)is_selected{
    _is_selected = is_selected;
    if (is_selected) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFF2E2"];
        self.layer.borderColor = [UIColor colorWithHexString:@"#FF844D"].CGColor;
        self.priceLabel.backgroundColor = [UIColor colorWithHexString:@"#FF844D"];
    }else{
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor colorWithHexString:@"#D5D7DE"].CGColor;
        self.priceLabel.backgroundColor = [UIColor colorWithHexString:@"#D5D7DE"];
    }
}

#pragma mark koin
-(UIImageView *)beansImgView{
    if (!_beansImgView) {
        _beansImgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-30)/2.0, 20, 30, 30)];
        _beansImgView.image = [UIImage imageNamed:@"recharge_gold"];
    }
    return _beansImgView;
}

#pragma mark 金币
-(UILabel *)koinLabel{
    if (!_koinLabel) {
        _koinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.beansImgView.bottom+16, self.width, 20)];
        _koinLabel.font = [UIFont mediumFontWithSize:IS_IPHONE_5?15.0f:17.0f];
        _koinLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        _koinLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _koinLabel;
}

#pragma mark 送金币
-(UILabel *)giveKoinLabel{
    if (!_giveKoinLabel) {
        _giveKoinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.koinLabel.bottom, self.width, 16)];
        _giveKoinLabel.font = [UIFont regularFontWithSize:11.0f];
        _giveKoinLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        _giveKoinLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _giveKoinLabel;
}

#pragma mark 价格
-(UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.giveKoinLabel.bottom+5, self.width, 36)];
        _priceLabel.font = [UIFont mediumFontWithSize:18.0f];
        _priceLabel.textColor = [UIColor whiteColor];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.backgroundColor = [UIColor colorWithHexString:@"#D5D7DE"];
        [_priceLabel setBorderWithCornerRadius:8 type:UIViewCornerTypeBottom];
    }
    return _priceLabel;
}

@end
