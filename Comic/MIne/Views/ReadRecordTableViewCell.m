//
//  ReadRecordTableViewCell.m
//  Comic
//
//  Created by vision on 2019/11/19.
//  Copyright © 2019 vision. All rights reserved.
//

#import "ReadRecordTableViewCell.h"

@interface ReadRecordTableViewCell ()


@property (nonatomic,strong) UIImageView *coverImgView;
@property (nonatomic,strong) UILabel     *nameLabel;
@property (nonatomic,strong) UILabel     *progressLabel;
@property (nonatomic,strong) UILabel     *lastLabel;

@end

@implementation ReadRecordTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.coverImgView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.progressLabel];
        [self.contentView addSubview:self.lastLabel];
    }
    return self;
}

#pragma mark 填充数据
-(void)reloadCellWithObject:(BookRecordModel *)recordModel{
    if (kIsEmptyString(recordModel.oblong_cover)) {
        self.coverImgView.image = [UIImage imageNamed:@"default_graph_1"];
    }else{
        [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:recordModel.oblong_cover] placeholderImage:[UIImage imageNamed:@"default_graph_1"]];
    }
    self.nameLabel.text = recordModel.book_name;
    self.progressLabel.text = [NSString stringWithFormat:@"Membaca sampai :%@",recordModel.catalogue_name];
    self.lastLabel.text = [NSString stringWithFormat:@"Masih tersisa %ld chapter yang belum dibaca",(long)[recordModel.residue_words integerValue]];
    
}

#pragma mark -- Getters
#pragma mark 漫画图
-(UIImageView *)coverImgView{
    if (!_coverImgView) {
        _coverImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 80, 80)];
        [_coverImgView setBorderWithCornerRadius:4.0 type:UIViewCornerTypeAll];
    }
    return _coverImgView;
}

#pragma mark 书名
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.coverImgView.right+10,15,kScreenWidth-self.coverImgView.right-20,14)];
        _nameLabel.textColor = [UIColor commonColor_black];
        _nameLabel.font = [UIFont mediumFontWithSize:14.0f];
    }
    return _nameLabel;
}

#pragma mark 阅读进度
-(UILabel *)progressLabel{
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.coverImgView.right+10,self.nameLabel.bottom, _nameLabel.width, 40)];
        _progressLabel.numberOfLines = 0;
        _progressLabel.textColor = [UIColor colorWithHexString:@"#6D6D6D"];
        _progressLabel.font = [UIFont regularFontWithSize:12.0f];
    }
    return _progressLabel;
}

#pragma mark 剩余
-(UILabel *)lastLabel{
    if (!_lastLabel) {
        _lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.coverImgView.right+10,self.progressLabel.bottom, _nameLabel.width, 20)];
        _lastLabel.textColor = [UIColor colorWithHexString:@"#6D6D6D"];
        _lastLabel.font = [UIFont regularFontWithSize:IS_IPHONE_5?10.0f:12.0f];
    }
    return _lastLabel;
}

@end
