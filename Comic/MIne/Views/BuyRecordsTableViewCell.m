//
//  BuyRecordsTableViewCell.m
//  Comic
//
//  Created by vision on 2019/12/12.
//  Copyright © 2019 vision. All rights reserved.
//

#import "BuyRecordsTableViewCell.h"

@interface BuyRecordsTableViewCell ()

@property (nonatomic,strong) UIImageView *coverImgView;
@property (nonatomic,strong) UILabel     *nameLabel;
@property (nonatomic,strong) UILabel     *progressLabel;
@property (nonatomic,strong) UILabel     *wordsLabel;

@end

@implementation BuyRecordsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.coverImgView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.progressLabel];
        [self.contentView addSubview:self.wordsLabel];
    }
    return self;
}

-(void)reloadCellWithModel:(BuyBookModel *)model{
    if (kIsEmptyString(model.oblong_cover)) {
      self.coverImgView.image = [UIImage imageNamed:@"default_graph_2"];
   }else{
       [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:model.oblong_cover] placeholderImage:[UIImage imageNamed:@"default_graph_2"]];
   }
   self.nameLabel.text = model.book_name;
   self.progressLabel.text = [NSString stringWithFormat:@"Telah membeli %ld chapter",(long)[model.buy_words integerValue]];
   self.wordsLabel.text = [NSString stringWithFormat:@"Total semua %ld chapter",(long)[model.words integerValue]];
}

#pragma mark -- Getters
#pragma mark 漫画图
-(UIImageView *)coverImgView{
    if (!_coverImgView) {
        _coverImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 130, 80)];
        [_coverImgView setBorderWithCornerRadius:4.0 type:UIViewCornerTypeAll];
    }
    return _coverImgView;
}

#pragma mark 书名
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.coverImgView.right+10,15,kScreenWidth-self.coverImgView.right-20,40)];
        _nameLabel.textColor = [UIColor commonColor_black];
        _nameLabel.font = [UIFont mediumFontWithSize:14.0f];
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

#pragma mark 已购买
-(UILabel *)progressLabel{
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.coverImgView.right+10,self.nameLabel.bottom, _nameLabel.width, 20)];
        _progressLabel.textColor = [UIColor colorWithHexString:@"#6D6D6D"];
        _progressLabel.font = [UIFont regularFontWithSize:12.0f];
    }
    return _progressLabel;
}

#pragma mark 总话数
-(UILabel *)wordsLabel{
    if (!_wordsLabel) {
        _wordsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.coverImgView.right+10,self.progressLabel.bottom, _nameLabel.width, 20)];
        _wordsLabel.textColor = [UIColor colorWithHexString:@"#6D6D6D"];
        _wordsLabel.font = [UIFont regularFontWithSize:12.0f];
    }
    return _wordsLabel;
}

@end
