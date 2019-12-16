//
//  CommentTableViewCell.m
//  Comic
//
//  Created by vision on 2019/11/13.
//  Copyright © 2019 vision. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "PhotosContainerView.h"
#import "MYCoreTextLabel.h"

#define kImgHeight (kScreenWidth-84-2*10)/3.0

@interface CommentTableViewCell ()<MYCoreTextLabelDelegate>

@property (nonatomic,strong) UIImageView  *headImgView;
@property (nonatomic,strong) UILabel      *nameLabel;
@property (nonatomic,strong) UILabel      *timeLabel;
@property (nonatomic,strong) UILabel      *contentLabel;
@property (nonatomic,strong) PhotosContainerView   *photosView;
@property (nonatomic,strong) UIView       *replyView;
@property (nonatomic,strong) UIButton     *moreReplyBtn;

@property (nonatomic,strong) NSMutableArray *replysArray;

@end

@implementation CommentTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headImgView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.likeBtn];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.photosView];
        self.photosView.hidden = YES;
        [self.contentView addSubview:self.replyView];
        [self.replyView addSubview:self.moreReplyBtn];
        self.replyView.hidden = YES;
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

#pragma mark 填充数据
-(void)setCommentModel:(CommentModel *)commentModel{
    _commentModel = commentModel;
    if (kIsEmptyString(commentModel.head_portrait)) {
        self.headImgView.image = [UIImage imageNamed:@"default_head"];
    }else{
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:commentModel.head_portrait] placeholderImage:[UIImage imageNamed:@"default_head"]];
    }
    self.nameLabel.text = commentModel.name;
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%@",commentModel.like] forState:UIControlStateNormal];
    if ([commentModel.is_like boolValue]) {
        self.likeBtn.selected = YES;
        self.likeBtn.userInteractionEnabled = NO;
    }else{
        self.likeBtn.selected = NO;
        self.likeBtn.userInteractionEnabled = YES;
    }
    self.timeLabel.text = [[ComicManager sharedComicManager] timeWithTimeIntervalNumber:commentModel.comment_time format:@"yyyy-MM-dd hh:mm"];
    
    self.contentLabel.text = commentModel.content;
    CGFloat contentH = [commentModel.content boundingRectWithSize:CGSizeMake(kScreenWidth-84, CGFLOAT_MAX) withTextFont:self.contentLabel.font].height;
    self.contentLabel.frame = CGRectMake(self.headImgView.right+10,self.timeLabel.bottom, kScreenWidth-84, contentH);
    
    CGFloat replyOriginY = self.contentLabel.bottom+10;
    if (commentModel.pics.count>0) {
        self.photosView.hidden = NO;
        self.photosView.picUrlsArray = [NSMutableArray arrayWithArray:commentModel.pics];
        if (commentModel.pics.count>1) {
            self.photosView.frame = CGRectMake(self.headImgView.right+10, self.contentLabel.bottom+10, kScreenWidth-80,kImgHeight*((commentModel.pics.count/3)+1)+10*(commentModel.pics.count/3));
            replyOriginY = self.photosView.bottom+10;
        }else{
            self.photosView.frame = CGRectMake(self.headImgView.right+10, self.contentLabel.bottom+10,120, 85);
            replyOriginY = self.photosView.bottom+10;
        }
    }else{
        self.photosView.hidden = YES;
    }
    
    NSArray *replyArr = commentModel.review;
    if (replyArr.count>0) {
        self.replyView.hidden = NO;
        
        for (UIView *view in self.replyView.subviews) {   //删除子视图
            if ([view isKindOfClass:[MYCoreTextLabel class]]) {
                [view removeFromSuperview];
            }
        }
        [self.replysArray removeAllObjects];
        
        CGFloat replyHeight = 10.0;
        for (NSInteger i=0; i<replyArr.count; i++) {
            NSDictionary *replyDict = replyArr[i];
            ReplyModel *replyModel = [[ReplyModel alloc] init];
            [replyModel setValues:replyDict];
            [self.replysArray addObject:replyModel];
            
            MYCoreTextLabel *replyLab = [[MYCoreTextLabel alloc] initWithFrame:CGRectZero];
            replyLab.tag = i;
            //设置普通文本的属性
            replyLab.textFont = [UIFont regularFontWithSize:12.0f];   //设置普通内容文字大小
            replyLab.textColor = [UIColor commonColor_black];   // 设置普通内容文字颜色
            replyLab.delegate = self;   //设置代理 , 用于监听点击事件 以及接收点击内容等
            
            //设置指定文本的属性
            replyLab.customLinkFont = [UIFont regularFontWithSize:12.0f];
            replyLab.customLinkColor = [UIColor colorWithHexString:@"#738BBC"];
            replyLab.customLinkBackColor = [UIColor commonColor_black];
            
            NSString *replyStr = nil;
            if ([replyModel.be_user_id integerValue]==[commentModel.user_id integerValue]) {
                replyStr = [NSString stringWithFormat:@"%@：%@",replyModel.user_name,replyModel.content];
                [replyLab setText:replyStr customLinks:@[replyModel.user_name] keywords:@[@"reply"]];
            }else{
                replyStr = [NSString stringWithFormat:@"%@ Balasan %@：%@",replyModel.user_name,replyModel.be_user_name,replyModel.content];
                [replyLab setText:replyStr customLinks:@[replyModel.user_name,replyModel.be_user_name] keywords:@[@"reply"]];
            }
            
            CGSize labSize = [replyLab sizeThatFits:CGSizeMake(kScreenWidth-105, CGFLOAT_MAX)];
            replyLab.frame = CGRectMake(5, replyHeight, kScreenWidth-105, labSize.height);
            [self.replyView addSubview:replyLab];
            
            replyHeight += labSize.height;
        }
        NSInteger replyCount = [commentModel.review_count integerValue];
        if (replyCount>3) {
            self.moreReplyBtn.hidden = NO;
            NSString *titleStr = [NSString stringWithFormat:@"Melihat semua %ld balasan>",(long)replyCount];
            CGFloat btnW = [titleStr boundingRectWithSize:CGSizeMake(kScreenWidth-105, 25) withTextFont:[UIFont regularFontWithSize:10.0f]].width;
            self.moreReplyBtn.frame = CGRectMake(10, replyHeight, btnW, 25);
            [self.moreReplyBtn setTitle:titleStr forState:UIControlStateNormal];
            self.replyView.frame = CGRectMake(self.headImgView.right+10,replyOriginY, kScreenWidth-self.headImgView.right-30, replyHeight+30);
        }else{
            self.moreReplyBtn.hidden = YES;
            self.replyView.frame = CGRectMake(self.headImgView.right+10,replyOriginY, kScreenWidth-self.headImgView.right-30, replyHeight+10);
        }
        [self.replyView setBorderWithCornerRadius:4.0 type:UIViewCornerTypeAll];
        self.lineView.frame = CGRectMake(0, self.replyView.bottom+15, kScreenWidth, 1);
    }else{
        self.replyView.hidden = YES;
        self.lineView.frame = CGRectMake(0, replyOriginY+5, kScreenWidth, 1);
    }
}

#pragma mark -- Event response
#pragma mark 查看评论详情
-(void)checkCommentDetailsAction:(UIButton *)sender{
    MyLog(@"--------checkCommentDetails------");
    if ([self.cellDelegate respondsToSelector:@selector(commentTableViewCellDidCheckCommentDetails:)]) {
        [self.cellDelegate commentTableViewCellDidCheckCommentDetails:self.commentModel];
    }
}

#pragma mark -- Delegate
#pragma mark MYCoreTextLabelDelegate
-(void)linkText:(NSString *)clickString type:(MYLinkType)linkType tag:(NSInteger)tag{
    MyLog(@"------------clickString : %@ linkType %ld  -------------tag:%ld",clickString,linkType,tag);
    
    ReplyModel *model = self.replysArray[tag];
    NSNumber *userId = nil;
    if ([clickString isEqualToString:model.user_name]) {
        userId = model.user_id;
    }else{
        userId = model.be_user_id;
    }
    if ([self.cellDelegate respondsToSelector:@selector(commentTableViewCellDidReplyWithModel:commentedUserId:replyId:commented_nick:)]) {
        [self.cellDelegate commentTableViewCellDidReplyWithModel:self.commentModel commentedUserId:userId replyId:model.review_id commented_nick:clickString];
    }
}

#pragma mark 更多
-(void)linkMoretag:(NSInteger)tag{
    MyLog(@"linkMoretag:%ld",tag);
    if ([self.cellDelegate respondsToSelector:@selector(commentTableViewCellDidCheckCommentDetails:)]) {
        [self.cellDelegate commentTableViewCellDidCheckCommentDetails:self.commentModel];
    }
}

#pragma mark -- Getters
#pragma mark 头像
-(UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 18, 34, 34)];
        _headImgView.backgroundColor = [UIColor bgColor_Gray];
        [_headImgView setBorderWithCornerRadius:17 type:UIViewCornerTypeAll];
    }
    return _headImgView;
}

#pragma mark 昵称
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headImgView.right+10, 18, kScreenWidth-self.headImgView.right-70, 20)];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#262626"];
        _nameLabel.font = [UIFont mediumFontWithSize:13.0f];
    }
    return _nameLabel;
}

#pragma mark 点赞
-(UIButton *)likeBtn{
    if (!_likeBtn) {
        _likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-70, 20, 55, 20)];
        [_likeBtn setImage:[UIImage imageNamed:@"title_praise_gray"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"title_praise_purple"] forState:UIControlStateSelected];
        [_likeBtn setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateNormal];
        [_likeBtn setTitleColor:[UIColor colorWithHexString:@"#915AFF"] forState:UIControlStateSelected];
        _likeBtn.titleLabel.font = [UIFont regularFontWithSize:11.0f];
        _likeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return _likeBtn;
}

#pragma mark 时间
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headImgView.right+10,self.nameLabel.bottom, kScreenWidth-self.headImgView.right-70, 20)];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#808080"];
        _timeLabel.font = [UIFont regularFontWithSize:11.0f];
    }
    return _timeLabel;
}

#pragma mark 评论内容
-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headImgView.right+10,self.timeLabel.bottom, kScreenWidth-84, 20)];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        _contentLabel.font = [UIFont regularFontWithSize:14.0f];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

#pragma mark 多张图片
-(PhotosContainerView *)photosView{
    if (!_photosView) {
        _photosView = [[PhotosContainerView alloc] initWithFrame:CGRectMake(self.headImgView.right+10, self.contentLabel.bottom+10, kScreenWidth-80, kImgHeight+10)];
    }
    return _photosView;
}


#pragma mark 回复
-(UIView *)replyView{
    if (!_replyView) {
        _replyView = [[UIView alloc] initWithFrame:CGRectZero];
        _replyView.backgroundColor = [UIColor colorWithHexString:@"#F6F6FA"];
    }
    return _replyView;
}

#pragma mark 更多回复
-(UIButton *)moreReplyBtn{
    if (!_moreReplyBtn) {
        _moreReplyBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_moreReplyBtn setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateNormal];
        _moreReplyBtn.titleLabel.font = [UIFont regularFontWithSize:10.0f];
        [_moreReplyBtn addTarget:self action:@selector(checkCommentDetailsAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreReplyBtn;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-1, kScreenWidth, 1)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#EAEBF0"];
    }
    return _lineView;
}

-(NSMutableArray *)replysArray{
    if (!_replysArray) {
        _replysArray = [[NSMutableArray alloc] init];
    }
    return _replysArray;
}

@end
