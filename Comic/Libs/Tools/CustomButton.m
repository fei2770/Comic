//
//  CustomButton.m
//  Comic
//
//  Created by vision on 2019/11/21.
//  Copyright © 2019 vision. All rights reserved.
//

#import "CustomButton.h"

@interface CustomButton (){
    CGSize  _imgSize;
}

@property (nonatomic,strong) UIImageView *myImgView;
@property (nonatomic,strong) UILabel    *myLab;

@end

@implementation CustomButton

-(instancetype)initWithFrame:(CGRect)frame imgSize:(CGSize)imgSize{
    self = [super initWithFrame:frame];
    if (self) {
        _imgSize = imgSize;
        self.adjustsImageWhenHighlighted = NO;
        
        [self addSubview:self.myImgView];
        [self addSubview:self.myLab];
    }
    return self;
}

-(void)setImgName:(NSString *)imgName{
    _imgName = imgName;
    self.myImgView.image = [UIImage imageNamed:imgName];
}

-(void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    self.myLab.text = titleString;
}

-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.myLab.textColor = textColor;
}

-(void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
    self.myLab.font = titleFont;
}

#pragma mark -- Getters
-(UIImageView *)myImgView{
    if (!_myImgView) {
        _myImgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-_imgSize.width)/2.0, 0, _imgSize.width, _imgSize.height)];
    }
    return _myImgView;
}

-(UILabel *)myLab{
    if (!_myLab) {
        _myLab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.myImgView.bottom, self.width, self.height-_imgSize.height)];
        _myLab.textAlignment = NSTextAlignmentCenter;
        _myLab.numberOfLines = 0;
        _myLab.font = [UIFont regularFontWithSize:11.0f];
        _myLab.textColor = [UIColor commonColor_black];
    }
    return _myLab;
}

@end
