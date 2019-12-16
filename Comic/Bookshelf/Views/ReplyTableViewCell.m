//
//  ReplyTableViewCell.m
//  Comic
//
//  Created by vision on 2019/11/14.
//  Copyright © 2019 vision. All rights reserved.
//

#import "ReplyTableViewCell.h"
#import "MYCoreTextLabel.h"

@interface ReplyTableViewCell ()<MYCoreTextLabelDelegate>

@property (nonatomic,strong) UIImageView     *headImgView;
@property (nonatomic,strong) UILabel         *nameLabel;
@property (nonatomic,strong) UILabel         *timeLabel;
@property (nonatomic,strong) MYCoreTextLabel *contentLabel;
@property (nonatomic,strong) UIView          *lineView;

@end

@implementation ReplyTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headImgView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.likeBtn];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

#pragma mark 填充数据
-(void)displayTableViewCellWithCommentId:(NSNumber *)commentId reply:(ReplyModel *)replyModel{
    if (kIsEmptyString(replyModel.user_head_portrait)) {
        self.headImgView.image = [UIImage imageNamed:@"default_head"];
    }else{
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:replyModel.user_head_portrait] placeholderImage:[UIImage imageNamed:@"default_head"]];
    }
    self.nameLabel.text = replyModel.user_name;
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%@",replyModel.like] forState:UIControlStateNormal];
    if ([replyModel.is_like boolValue]) {
        self.likeBtn.selected = YES;
        self.likeBtn.userInteractionEnabled = NO;
    }else{
        self.likeBtn.selected = NO;
        self.likeBtn.userInteractionEnabled = YES;
    }
    self.timeLabel.text = [[ComicManager sharedComicManager] timeWithTimeIntervalNumber:replyModel.review_time format:@"yyyy-MM-dd HH:mm"];
    
    self.contentLabel.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    self.contentLabel.textFont = [UIFont regularFontWithSize:14.0f];
    self.contentLabel.delegate = self;   //设置代理 , 用于监听点击事件 以及接收点击内容等
    
    //设置指定文本的属性
    self.contentLabel.customLinkFont = [UIFont regularFontWithSize:14.0f];
    self.contentLabel.customLinkColor = [UIColor colorWithHexString:@"#738BBC"];
    self.contentLabel.customLinkBackColor = [UIColor commonColor_black];
    
    if ([replyModel.be_user_id integerValue]==[commentId integerValue]) {
        [self.contentLabel setText:replyModel.content customLinks:nil keywords:nil];
    }else{
        NSString *replyStr = [NSString stringWithFormat:@"@%@ %@",replyModel.be_user_name,replyModel.content];
        [self.contentLabel setText:replyStr customLinks:@[[NSString stringWithFormat:@"@%@",replyModel.be_user_name]] keywords:@[@"reply"]];
    }
    
    CGSize labSize = [self.contentLabel sizeThatFits:CGSizeMake(kScreenWidth-74, CGFLOAT_MAX)];
    self.contentLabel.frame = CGRectMake(self.headImgView.right+5, self.timeLabel.bottom+10, kScreenWidth-74, labSize.height);
    
    self.lineView.frame = CGRectMake(0, self.contentLabel.bottom+10, kScreenWidth, 1.0);
}

#pragma mark 获取评论高度
+(CGFloat)getReplyViewCellWithCommentId:(NSNumber *)commentId reply:(ReplyModel *)replyModel{
    NSString *content = nil;
    if ([replyModel.be_user_id integerValue]==[commentId integerValue]) {
        content = replyModel.content;
    }else{
        content = [NSString stringWithFormat:@"@%@ %@",replyModel.be_user_name,replyModel.content];
    }
    CGFloat contentH = [content boundingRectWithSize:CGSizeMake(kScreenWidth-84, CGFLOAT_MAX) withTextFont:[UIFont regularFontWithSize:14.0]].height;
    return contentH+80;
}

#pragma mark -- Delegate
#pragma mark MYCoreTextLabelDelegate
-(void)linkText:(NSString *)clickString type:(MYLinkType)linkType tag:(NSInteger)tag{
    MyLog(@"------------点击内容是 : %@--------------",clickString);
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
-(MYCoreTextLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[MYCoreTextLabel alloc] initWithFrame:CGRectZero];
        
    }
    return _contentLabel;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#EAEBF0"];
    }
    return _lineView;
}

@end
