//
//  BookCityTableViewCell.m
//  Comic
//
//  Created by vision on 2019/11/13.
//  Copyright © 2019 vision. All rights reserved.
//

#import "BookCityTableViewCell.h"
#import "BookTagsView.h"

@interface BookCityTableViewCell ()

@property (nonatomic,strong) UIImageView   *coverImgView;
@property (nonatomic,strong) UILabel       *nameLabel;
@property (nonatomic,strong) BookTagsView  *tagsView;

@end

@implementation BookCityTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.coverImgView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.tagsView];
    }
    return self;
}

-(void)setBookModel:(BookModel *)bookModel{
    _bookModel = bookModel;
    
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:bookModel.oblong_cover] placeholderImage:[UIImage imageNamed:@"default_graph_2"]];
    
    self.nameLabel.text = bookModel.book_name;
    CGFloat nameH = [bookModel.book_name boundingRectWithSize:CGSizeMake(kScreenWidth-36, CGFLOAT_MAX) withTextFont:self.nameLabel.font].height;
    self.nameLabel.frame = CGRectMake(18, self.coverImgView.bottom+10, kScreenWidth-36, nameH);
    
    self.tagsView.frame = CGRectMake(18, self.nameLabel.bottom+10, kScreenWidth-30, 20);
    self.tagsView.labelsArray = bookModel.label;
}

#pragma mark -- Getters
#pragma nark 封面
-(UIImageView *)coverImgView{
    if (!_coverImgView) {
        _coverImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,kScreenWidth-20,215)];
        _coverImgView.backgroundColor = [UIColor bgColor_Gray];
        [_coverImgView setBorderWithCornerRadius:5.0 type:UIViewCornerTypeAll];
    }
    return _coverImgView;
}

#pragma mark 书名
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(18,self.coverImgView.bottom+10,kScreenWidth-36, 20)];
        _nameLabel.font = [UIFont mediumFontWithSize:16];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textColor = [UIColor colorWithHexString:@"#303030"];
    }
    return _nameLabel;
}

#pragma mark 标签
-(BookTagsView *)tagsView{
    if (!_tagsView) {
        _tagsView = [[BookTagsView alloc] initWithFrame:CGRectMake(18, self.nameLabel.bottom+10,kScreenWidth-30, 20)];
    }
    return _tagsView;
}





@end
