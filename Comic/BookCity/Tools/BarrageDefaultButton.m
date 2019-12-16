//
//  BarrageDefaultButton.m
//  Comic
//
//  Created by vision on 2019/11/20.
//  Copyright © 2019 vision. All rights reserved.
//

#import "BarrageDefaultButton.h"

@interface BarrageDefaultButton ()

@property (nonatomic,strong) UIImageView   *typeImgView;
@property (nonatomic,strong) UILabel       *contentLab;


@end

@implementation BarrageDefaultButton

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F9F8FF"];
        self.layer.cornerRadius = 8.0;
        self.layer.borderColor = [UIColor colorWithHexString:@"#915AFF"].CGColor;
        self.layer.borderWidth = 2.0;
        
        [self addSubview:self.typeImgView];
        [self addSubview:self.contentLab];
    }
    return self;
}

#pragma mark
-(UIImageView *)typeImgView{
    if (!_typeImgView) {
        _typeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 19)];
        _typeImgView.image = [UIImage imageNamed:@"barrage_choose_style"];
    }
    return _typeImgView;
}

#pragma mark
-(UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] initWithFrame:CGRectMake((self.width-96)/2.0, (self.height-32)/2.0, 96, 32)];
        _contentLab.backgroundColor = kRGBColor(0, 0, 0, 0.8);
        [_contentLab setBorderWithCornerRadius:22 type:UIViewCornerTypeAll];
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.text = @"Mode diam";
        _contentLab.font = [UIFont mediumFontWithSize:14];
        _contentLab.textColor = [UIColor whiteColor];
    }
    return _contentLab;
}

@end
