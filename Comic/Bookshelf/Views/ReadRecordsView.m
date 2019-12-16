//
//  ReadRecordsView.m
//  Comic
//
//  Created by vision on 2019/11/15.
//  Copyright © 2019 vision. All rights reserved.
//

#import "ReadRecordsView.h"


@interface ReadRecordsView ()

@property (nonatomic,strong) UILabel      *titleLab;
@property (nonatomic,strong) UIImageView  *bgImgView;
@property (nonatomic,strong) UIImageView  *headImgView; //头像
@property (nonatomic,strong) UILabel      *nameLabel;   //书名
@property (nonatomic,strong) UILabel      *descLabel;   //描述
@property (nonatomic,strong) UIButton      *readBtn;     //
@property (nonatomic,strong) UIView       *lineView;     //


@end

@implementation ReadRecordsView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLab];
        [self addSubview:self.bgImgView];
        [self addSubview:self.headImgView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.descLabel];
        [self addSubview:self.readBtn];
        [self addSubview:self.contineBtn];
        [self addSubview:self.lineView];
        [self addSubview:self.recordBtn];
    }
    return self;
}

#pragma mark 填充数据
-(void)setRecordModel:(BookRecordModel *)recordModel{
    if (kIsEmptyString(recordModel.oblong_cover)) {
        self.headImgView.image = [UIImage imageNamed:@"default_graph_1"];
    }else{
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:recordModel.oblong_cover] placeholderImage:[UIImage imageNamed:@"default_graph_1"]];
    }
    self.nameLabel.text = recordModel.book_name;
    self.descLabel.text = [NSString stringWithFormat:@"Terakhir membaca sampai Chapter %ld",(long)[recordModel.catalogue_id integerValue]];
}

#pragma mark -- Getters
#pragma mark 最近阅读
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, kScreenWidth-80, 20)];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = [UIFont regularFontWithSize:12.0f];
        _titleLab.text = @"Akhir-akhir ini yang dibaca";
    }
    return _titleLab;
}

#pragma mark 背景
-(UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.titleLab.bottom+5, kScreenWidth-30, 72)];
        _bgImgView.backgroundColor = [UIColor bm_colorGradientChangeWithSize:_bgImgView.size direction:IHGradientChangeDirectionVertical startColor:kRGBColor(255, 255, 255, 0.25) endColor:kRGBColor(255, 255, 255, 0)];
        [_bgImgView setBorderWithCornerRadius:4.0 type:UIViewCornerTypeAll];
    }
    return _bgImgView;
}

#pragma mark 漫画图
-(UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bgImgView.left+6, self.bgImgView.top+6, 60, 60)];
        [_headImgView setBorderWithCornerRadius:4.0 type:UIViewCornerTypeAll];
    }
    return _headImgView;
}

#pragma mark 书名
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headImgView.right+10,self.bgImgView.top+10,kScreenWidth-self.headImgView.right-108,16)];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont mediumFontWithSize:14.0f];
    }
    return _nameLabel;
}

#pragma mark 阅读进度
-(UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headImgView.right+10,self.nameLabel.bottom+5, _nameLabel.width, 13)];
        _descLabel.textColor = [UIColor whiteColor];
        _descLabel.font = [UIFont regularFontWithSize:10.0f];
    }
    return _descLabel;
}

#pragma mark 继续阅读
-(UIButton *)readBtn{
    if (!_readBtn) {
        _readBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.headImgView.right+10,self.descLabel.bottom+5,110, 13)];
        [_readBtn setTitle:@"Lanjutkan membaca" forState:UIControlStateNormal];
        [_readBtn setTitleColor:[UIColor colorWithHexString:@"#FAFF5C"] forState:UIControlStateNormal];
        _readBtn.titleLabel.font = [UIFont regularFontWithSize:11.0f];
    }
    return _readBtn;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-98, self.bgImgView.top+10, 1, 50)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#9E9AFF"];
    }
    return _lineView;
}

#pragma mark 继续阅读
-(UIButton *)contineBtn{
    if (!_contineBtn) {
        _contineBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, self.titleLab.bottom+5, kScreenWidth-115, 72)];
    }
    return _contineBtn;
}

#pragma mark 阅读记录
-(CustomButton *)recordBtn{
    if (!_recordBtn) {
        _recordBtn = [[CustomButton alloc] initWithFrame:CGRectMake(kScreenWidth-95,self.bgImgView.top+10, 76, 62) imgSize:CGSizeMake(25, 26)];
        _recordBtn.imgName = @"bookshelf_reading_record";
        _recordBtn.titleString = @"Riwayat membaca";
        _recordBtn.textColor = [UIColor whiteColor];
        _recordBtn.titleFont = [UIFont regularFontWithSize:12];
    }
    return _recordBtn;
}




@end
