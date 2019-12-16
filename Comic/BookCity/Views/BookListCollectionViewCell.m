//
//  BookListCollectionViewCell.m
//  Comic
//
//  Created by vision on 2019/11/20.
//  Copyright © 2019 vision. All rights reserved.
//

#import "BookListCollectionViewCell.h"

@interface BookListCollectionViewCell ()

@property (nonatomic,strong) UIImageView *coverImgView;
@property (nonatomic,strong) UIView      *maskView; // 蒙层
@property (nonatomic,strong) UILabel     *chapterLabel;
@property (nonatomic,strong) UIImageView *lockImgView;

@end

@implementation BookListCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.coverImgView];
        [self.contentView addSubview:self.chapterLabel];
        [self.contentView addSubview:self.maskView];
        self.maskView.hidden = YES;
        [self.contentView addSubview:self.lockImgView];
        self.lockImgView.hidden = YES;
    }
    return self;
}

-(void)displaySelectionCellWithModel:(BookSelectionModel *)selectionModel vipCost:(NSInteger)vipCost{
    if (kIsEmptyString(selectionModel.catalogue_cover)) {
        self.coverImgView.image = [UIImage imageNamed:@"default_graph_3"];
    }else{
        [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:selectionModel.catalogue_cover] placeholderImage:[UIImage imageNamed:@"default_graph_3"]];
    }
    self.chapterLabel.text = selectionModel.catalogue_name;
    self.maskView.hidden = ![selectionModel.is_selected boolValue];
    
    if (![selectionModel.type boolValue]) {
        self.lockImgView.hidden = YES;
    }else{
        BOOL isVip = [[NSUserDefaultsInfos getValueforKey:kUserVip] boolValue];
        if (isVip&&vipCost==0) {
            self.lockImgView.hidden = YES;
        }else{
            self.lockImgView.hidden = NO;
        }
    }
}

#pragma mark -- Getters
-(UIImageView *)coverImgView{
    if (!_coverImgView) {
        _coverImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 134, 80)];
        _coverImgView.backgroundColor = [UIColor bgColor_Gray];
    }
    return _coverImgView;
}

-(UILabel *)chapterLabel{
    if (!_chapterLabel) {
        _chapterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.coverImgView.bottom+5,134, 20)];
        _chapterLabel.font = [UIFont mediumFontWithSize:12];
        _chapterLabel.textColor = [UIColor commonColor_black];
    }
    return _chapterLabel;
}

-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.coverImgView.bounds];
        _maskView.backgroundColor = kRGBColor(238, 238, 238, 0.8);
    }
    return _maskView;
}

#pragma mark 锁
-(UIImageView *)lockImgView{
    if (!_lockImgView) {
        _lockImgView = [[UIImageView alloc] initWithFrame:self.coverImgView.frame];
        _lockImgView.image = [UIImage imageNamed:@"book_selection_lock"];
    }
    return _lockImgView;
}

@end
