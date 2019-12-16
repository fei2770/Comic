//
//  MyCommentTableViewCell.m
//  Comic
//
//  Created by vision on 2019/11/23.
//  Copyright © 2019 vision. All rights reserved.
//

#import "MyCommentTableViewCell.h"
#import "MYCoreTextLabel.h"

@interface MyCommentTableViewCell ()

@property (nonatomic,strong) UILabel           *contentLabel;
@property (nonatomic,strong) UIView            *bgView;
@property (nonatomic,strong) MYCoreTextLabel   *replyLabel;
@property (nonatomic,strong) UIView            *bookBgView;
@property (nonatomic,strong) UIImageView       *coverImgView;
@property (nonatomic,strong) UILabel           *nameLabel;
@property (nonatomic,strong) UILabel           *chapterLabel;
@property (nonatomic,strong) UILabel           *timeLabel;
@property (nonatomic,strong) UIButton          *likeBtn;
@property (nonatomic,strong) UIView            *lineView;


@end

@implementation MyCommentTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.replyLabel];
        [self.contentView addSubview:self.bookBgView];
        [self.contentView addSubview:self.coverImgView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.chapterLabel];
        [self.contentView addSubview:self.chapterLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.likeBtn];
        [self.contentView addSubview:self.deleteBtn];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

#pragma mark 填充数据
-(void)setCommentModel:(MyCommentModel *)commentModel{
    _commentModel = commentModel;
    self.contentLabel.text = commentModel.content;
    CGFloat contentH = [commentModel.content boundingRectWithSize:CGSizeMake(kScreenWidth-40, CGFLOAT_MAX) withTextFont:self.contentLabel.font].height;
    self.contentLabel.frame = CGRectMake(20, 15, kScreenWidth-40, contentH);
    
    if (!kIsEmptyString(commentModel.comment_content)) {
        self.replyLabel.hidden = NO;
        NSString *replyStr = nil;
        if (kIsEmptyString(commentModel.commented_nick)) {
            replyStr = [NSString stringWithFormat:@"%@：%@",commentModel.comment_nick,commentModel.comment_content];
            [self.replyLabel setText:replyStr customLinks:@[commentModel.comment_nick] keywords:@[@"reply"]];
        }else{
            replyStr = [NSString stringWithFormat:@"%@ Balasan %@：%@",commentModel.comment_nick,commentModel.commented_nick,commentModel.comment_content];
            [self.replyLabel setText:replyStr customLinks:@[commentModel.comment_nick,commentModel.commented_nick] keywords:@[@"reply"]];
        }
        CGSize labSize = [self.replyLabel sizeThatFits:CGSizeMake(kScreenWidth-50, CGFLOAT_MAX)];
        self.replyLabel.frame = CGRectMake(25, self.contentLabel.bottom+15, kScreenWidth-50, labSize.height);
        self.bgView.frame = CGRectMake(20, self.contentLabel.bottom+10, kScreenWidth-40, labSize.height+80);
        self.bookBgView.frame = CGRectMake(20, self.replyLabel.bottom+5, kScreenWidth-50, 60);
        self.bookBgView.backgroundColor = [UIColor whiteColor];
    }else{
        self.replyLabel.hidden = YES;
        self.bgView.frame = CGRectMake(20, self.contentLabel.bottom+10, kScreenWidth-40, 60);
        self.bookBgView.frame = CGRectMake(20, self.contentLabel.bottom+10, kScreenWidth-40, 60);
        self.bookBgView.backgroundColor = [UIColor colorWithHexString:@"#F6F6FA"];
    }
    self.coverImgView.frame = CGRectMake(20, self.bookBgView.top, 60, 60);
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:commentModel.detail_cover] placeholderImage:[UIImage imageNamed:@"default_graph_1"]];
    
    //书名 章节
    if (kIsEmptyString(commentModel.catalogue_name)) {
        self.nameLabel.text = commentModel.book_name;
        self.nameLabel.frame = CGRectMake(self.coverImgView.right+10, self.bookBgView.top+20, kScreenWidth-self.coverImgView.right-30, 20);
        self.chapterLabel.hidden = YES;
    }else{
        self.nameLabel.text = commentModel.catalogue_name;
        self.nameLabel.frame = CGRectMake(self.coverImgView.right+10, self.bookBgView.top+5, kScreenWidth-self.coverImgView.right-30, 20);
        self.chapterLabel.hidden = NO;
        self.chapterLabel.text = commentModel.book_name;
        self.chapterLabel.frame = CGRectMake(self.coverImgView.right+10, self.nameLabel.bottom, self.nameLabel.width, 20);
    }
    
    self.timeLabel.frame = CGRectMake(20, self.bgView.bottom+15, 150, 14);
    self.timeLabel.text = [[ComicManager sharedComicManager] timeWithTimeIntervalNumber:commentModel.comment_time format:@"MM-dd hh:mm"];
    
    self.likeBtn.frame = CGRectMake(kScreenWidth-160, self.bgView.bottom+5, 80, 30);
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)[commentModel.like integerValue]] forState:UIControlStateNormal];
    
    self.deleteBtn.frame = CGRectMake(self.likeBtn.right+10, self.bgView.bottom+5, 60, 30);
    
    self.lineView.frame = CGRectMake(0, self.timeLabel.bottom+15, kScreenWidth, 1);
}

#pragma mark -- Getters
#pragma mark 内容
-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.font = [UIFont regularFontWithSize:15.0f];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor commonColor_black];
    }
    return _contentLabel;
}

#pragma mark 背景
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor colorWithHexString:@"#F6F6FA"];
    }
    return _bgView;
}

#pragma mark 回复
-(MYCoreTextLabel *)replyLabel{
    if (!_replyLabel) {
        _replyLabel = [[MYCoreTextLabel alloc] initWithFrame:CGRectZero];
        _replyLabel.textFont = [UIFont regularFontWithSize:14.0f];   //设置普通内容文字大小
        _replyLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];   // 设置普通内容文字颜色
                   
        //设置指定文本的属性
        _replyLabel.customLinkFont = [UIFont regularFontWithSize:14.0f];
        _replyLabel.customLinkColor = [UIColor colorWithHexString:@"#738BBC"];
        _replyLabel.customLinkBackColor = [UIColor colorWithHexString:@"#4A4A4A"];
    }
    return _replyLabel;
}

#pragma mark 图书背景
-(UIView *)bookBgView{
    if (!_bookBgView) {
        _bookBgView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _bookBgView;
}

#pragma mark 封面
-(UIImageView *)coverImgView{
    if (!_coverImgView) {
        _coverImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _coverImgView;
}

#pragma mark 名称
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        _nameLabel.font = [UIFont mediumFontWithSize:14.0f];
    }
    return _nameLabel;
}

#pragma mark 章节名
-(UILabel *)chapterLabel{
    if (!_chapterLabel) {
        _chapterLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _chapterLabel.textColor = [UIColor colorWithHexString:@"#6D6D6D"];
        _chapterLabel.font = [UIFont regularFontWithSize:13.0f];
    }
    return _chapterLabel;
}

#pragma mark 时间
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#808080"];
        _timeLabel.font = [UIFont regularFontWithSize:12.0f];
    }
    return _timeLabel;
}

#pragma mark 点赞
-(UIButton *)likeBtn{
    if (!_likeBtn) {
        _likeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_likeBtn setImage:[UIImage imageNamed:@"title_praise_gray"] forState:UIControlStateNormal];
        [_likeBtn setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateNormal];
        _likeBtn.titleLabel.font = [UIFont regularFontWithSize:12.0f];
        _likeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _likeBtn.enabled = NO;
    }
    return _likeBtn;
}

#pragma mark 删除
-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_deleteBtn setImage:[UIImage imageNamed:@"delete_comments"] forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateNormal];
        [_deleteBtn setTitle:@"Hapus" forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = [UIFont regularFontWithSize:12.0f];
        _deleteBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return _deleteBtn;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#EAEBF0"];
    }
    return _lineView;
}

@end
