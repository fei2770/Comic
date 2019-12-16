//
//  SelectionTableViewCell.m
//  Comic
//
//  Created by vision on 2019/11/19.
//  Copyright © 2019 vision. All rights reserved.
//

#import "SelectionTableViewCell.h"

@interface SelectionTableViewCell ()

@property (nonatomic,strong) UIImageView  *headImgView;
@property (nonatomic,strong) UIImageView  *coverImgView;
@property (nonatomic,strong) UILabel      *nameLabel;
@property (nonatomic,strong) UILabel      *timeLabel;

@end

@implementation SelectionTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headImgView];
        [self.contentView addSubview:self.coverImgView];
        self.coverImgView.hidden = YES;
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.likeBtn];
    }
    return self;
}

-(void)displayCellWithModel:(BookSelectionModel *)selectionModel vipCost:(NSInteger)vipCost{
    
    if (kIsEmptyString(selectionModel.catalogue_cover)) {
        self.headImgView.image = [UIImage imageNamed:@"default_graph_3"];
    }else{
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:selectionModel.catalogue_cover] placeholderImage:[UIImage imageNamed:@"default_graph_3"]];
    }
    if (![selectionModel.type boolValue]) {
        self.coverImgView.hidden = YES;
    }else{
        BOOL isVip = [[NSUserDefaultsInfos getValueforKey:kUserVip] boolValue];
        if (isVip&&vipCost==0) {
            self.coverImgView.hidden = YES;
        }else{
            self.coverImgView.hidden = NO;
        }
    }
    
    self.nameLabel.text = selectionModel.catalogue_name;
    self.timeLabel.text = [[ComicManager sharedComicManager] timeWithTimeIntervalNumber:selectionModel.create_time format:@"yyyy-MM-dd"];
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%@",selectionModel.like] forState:UIControlStateNormal];
   
    self.likeBtn.selected = [selectionModel.is_like boolValue];
    self.likeBtn.userInteractionEnabled = ![selectionModel.is_like boolValue];
}

#pragma mark -- Getters
#pragma mark 封面
-(UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 133, 80)];
        [_headImgView setBorderWithCornerRadius:4 type:UIViewCornerTypeAll];
    }
    return _headImgView;
}

#pragma mark 锁
-(UIImageView *)coverImgView{
    if (!_coverImgView) {
        _coverImgView = [[UIImageView alloc] initWithFrame:self.headImgView.frame];
        _coverImgView.image = [UIImage imageNamed:@"book_selection_lock"];
    }
    return _coverImgView;
}

#pragma mark 名称
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headImgView.right+10, 5, kScreenWidth-self.headImgView.right-20, 50)];
        _nameLabel.textColor = [UIColor commonColor_black];
        _nameLabel.font = [UIFont mediumFontWithSize:16.0f];
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

#pragma mark 时间
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headImgView.right+10,self.nameLabel.bottom+10, kScreenWidth-self.headImgView.right-20, 20)];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#6D6D6D"];
        _timeLabel.font = [UIFont regularFontWithSize:11.0f];
    }
    return _timeLabel;
}

#pragma mark 点赞
-(UIButton *)likeBtn{
    if (!_likeBtn) {
        _likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-70,self.nameLabel.bottom+5, 55, 20)];
        [_likeBtn setImage:[UIImage imageNamed:@"title_praise_gray"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"title_praise_purple"] forState:UIControlStateSelected];
        [_likeBtn setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateNormal];
        [_likeBtn setTitleColor:[UIColor colorWithHexString:@"#915AFF"] forState:UIControlStateSelected];
        _likeBtn.titleLabel.font = [UIFont regularFontWithSize:11.0f];
        _likeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return _likeBtn;
}

@end
