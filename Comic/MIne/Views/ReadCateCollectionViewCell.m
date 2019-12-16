//
//  ReadCateCollectionViewCell.m
//  Comic
//
//  Created by vision on 2019/11/19.
//  Copyright © 2019 vision. All rights reserved.
//

#import "ReadCateCollectionViewCell.h"

#define kCateImageWidth  (kScreenWidth-28*2-16*2)/3.0

@interface ReadCateCollectionViewCell ()

@property (nonatomic,strong) UIImageView  *myImgView;
@property (nonatomic,strong) UILabel      *cateLab;
@property (nonatomic,strong) UIButton     *selCateBtn;

@end

@implementation ReadCateCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.myImgView];
        [self.contentView addSubview:self.cateLab];
        [self.contentView addSubview:self.selCateBtn];
    }
    return self;
}

-(void)setCateModel:(ReadCateModel *)cateModel{
    if (kIsEmptyString(cateModel.type_cover)) {
        self.myImgView.image = [UIImage imageNamed:@"default_graph_1"];
    }else{
        [self.myImgView sd_setImageWithURL:[NSURL URLWithString:cateModel.type_cover] placeholderImage:[UIImage imageNamed:@"default_graph_1"]];
    }
    self.cateLab.text = cateModel.type_name;
    
    self.selCateBtn.selected = [cateModel.is_selected boolValue];
}

-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.cateLab.textColor = textColor;
}


#pragma mark -- Getters
#pragma mark 封面
-(UIImageView *)myImgView{
    if (!_myImgView) {
        _myImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6, kCateImageWidth, kCateImageWidth)];
        [_myImgView setBorderWithCornerRadius:8 type:UIViewCornerTypeAll];
    }
    return _myImgView;
}

#pragma mark 分类
-(UILabel *)cateLab{
    if (!_cateLab) {
        _cateLab = [[UILabel alloc] initWithFrame:CGRectMake(0,self.myImgView.bottom+5,self.width, 22)];
        _cateLab.textColor = [UIColor whiteColor];
        _cateLab.font = [UIFont mediumFontWithSize:14.0f];
        _cateLab.textAlignment = NSTextAlignmentCenter;
    }
    return _cateLab;
}

#pragma mark 选择
-(UIButton *)selCateBtn{
    if (!_selCateBtn) {
        _selCateBtn = [[UIButton alloc] initWithFrame:CGRectMake(kCateImageWidth-12, 0, 18, 18)];
        [_selCateBtn setImage:[UIImage imageNamed:@"preference_unchoose"] forState:UIControlStateNormal];
        [_selCateBtn setImage:[UIImage imageNamed:@"preference_choose"] forState:UIControlStateSelected];
    }
    return _selCateBtn;
}

@end
