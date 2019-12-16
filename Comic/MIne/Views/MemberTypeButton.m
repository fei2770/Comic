//
//  MemberTypeButton.m
//  Comic
//
//  Created by vision on 2019/11/18.
//  Copyright © 2019 vision. All rights reserved.
//

#import "MemberTypeButton.h"

@interface MemberTypeButton ()

@property (nonatomic,strong) UILabel     *nameLabel;
@property (nonatomic,strong) UILabel     *priceLabel;
@property (nonatomic,strong) UILabel     *originalPriceLabel;
@property (nonatomic,strong) UILabel     *koinLabel;

@end

@implementation MemberTypeButton

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F2F3F7"];
        self.layer.cornerRadius = 8.0;
        
        [self addSubview:self.nameLabel];
        [self addSubview:self.priceLabel];
        [self addSubview:self.originalPriceLabel];
        [self addSubview:self.koinLabel];
    }
    return self;
}

#pragma mark 填充数据
-(void)setTypeModel:(MemberTypeModel *)typeModel{
    self.nameLabel.text = typeModel.name;
    self.priceLabel.text = [NSString stringWithFormat:@"$%.2f",[typeModel.price doubleValue]];

    NSString *textStr = [NSString stringWithFormat:@"$%.2f", [typeModel.original_price doubleValue]];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:textStr attributes:attribtDic];
    self.originalPriceLabel.attributedText = attribtStr;
    
    self.koinLabel.text = [NSString stringWithFormat:@"%@ koin",typeModel.bean];
}

-(void)setIs_selected:(BOOL)is_selected{
    if (is_selected) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F5F2FF"];
        self.layer.borderColor = [UIColor colorWithHexString:@"#946EFF"].CGColor;
        self.layer.borderWidth = 2.0;
        
        self.nameLabel.textColor = [UIColor colorWithHexString:@"#8981B3"];
        self.priceLabel.textColor = [UIColor colorWithHexString:@"#915AFF"];
        self.originalPriceLabel.textColor = [UIColor colorWithHexString:@"#915AFF"];
        self.koinLabel.textColor = [UIColor colorWithHexString:@"#915AFF"];
    }else{
        self.backgroundColor = [UIColor colorWithHexString:@"#F2F3F7"];
        self.layer.borderWidth = 0.0;
        
        self.nameLabel.textColor = [UIColor colorWithHexString:@"#83848D"];
        self.priceLabel.textColor = [UIColor colorWithHexString:@"#83848D"];
        self.originalPriceLabel.textColor = [UIColor colorWithHexString:@"#83848D"];
        self.koinLabel.textColor = [UIColor colorWithHexString:@"#83848D"];
    }
}


#pragma mark appstore订阅 1个月 3个月 12个月
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.width, 20)];
        _nameLabel.font = [UIFont mediumFontWithSize:12.0f];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#83848D"];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

#pragma mark 价格
-(UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.nameLabel.bottom+5, self.width/2.0, 20)];
        _priceLabel.font = [UIFont mediumFontWithSize:IS_IPHONE_5?16.0f:18.0f];
        _priceLabel.textColor = [UIColor colorWithHexString:@"#83848D"];
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}

#pragma mark 原始价格
-(UILabel *)originalPriceLabel{
    if (!_originalPriceLabel) {
        _originalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width/2.0+10, self.nameLabel.bottom+5, self.width/2.0-10, 20)];
        _originalPriceLabel.font = [UIFont regularFontWithSize:12.0f];
        _originalPriceLabel.textColor = [UIColor colorWithHexString:@"#83848D"];
    }
    return _originalPriceLabel;
}

#pragma mark 金币
-(UILabel *)koinLabel{
    if (!_koinLabel) {
        _koinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,self.priceLabel.bottom+5, self.width, 20)];
        _koinLabel.font = [UIFont regularFontWithSize:12.0f];
        _koinLabel.textColor = [UIColor colorWithHexString:@"#83848D"];
        _koinLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _koinLabel;
}


@end
