//
//  FootBookCollectionViewCell.m
//  Comic
//
//  Created by vision on 2019/11/23.
//  Copyright © 2019 vision. All rights reserved.
//

#import "FootBookCollectionViewCell.h"

@interface FootBookCollectionViewCell ()

@property (nonatomic,strong) UIImageView *coverImgView;
@property (nonatomic,strong) UILabel     *nameLabel;
@property (nonatomic,strong) UILabel     *tagsLabel;

@end

@implementation FootBookCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.coverImgView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.tagsLabel];
    }
    return self;
}

#pragma mark 填充数据
-(void)setBookModel:(FooterBookModel *)bookModel{
    if (kIsEmptyString(bookModel.square_cover)) {
        self.coverImgView.image = [UIImage imageNamed:@"default_graph_4"];
    }else{
        [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:bookModel.square_cover] placeholderImage:[UIImage imageNamed:@"default_graph_4"]];
    }
    self.nameLabel.text = bookModel.book_name;
    self.tagsLabel.text = [bookModel.label componentsJoinedByString:@" "];
}


#pragma mark -- Getters
#pragma mark 封面
-(UIImageView *)coverImgView{
    if (!_coverImgView) {
        _coverImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _coverImgView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImgView.clipsToBounds = YES;
        
    }
    return _coverImgView;
}

#pragma mark 书名
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.coverImgView.bottom,100, 40)];
        _nameLabel.font = [UIFont mediumFontWithSize:12];
        _nameLabel.textColor = [UIColor commonColor_black];
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

#pragma mark 标签
-(UILabel *)tagsLabel{
    if (!_tagsLabel) {
        _tagsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.nameLabel.bottom,100, 20)];
        _tagsLabel.font = [UIFont regularFontWithSize:10];
        _tagsLabel.textColor = [UIColor colorWithHexString:@"#989FAE"];
    }
    return _tagsLabel;
}

@end
