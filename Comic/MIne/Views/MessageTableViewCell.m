//
//  MessageTableViewCell.m
//  Comic
//
//  Created by vision on 2019/11/23.
//  Copyright © 2019 vision. All rights reserved.
//

#import "MessageTableViewCell.h"

@interface MessageTableViewCell ()

@property (nonatomic,strong) UILabel           *timeLabel;
@property (nonatomic,strong) UIView            *bgView;
@property (nonatomic,strong) UIImageView       *headImgView;
@property (nonatomic,strong) UILabel           *nameLabel;
@property (nonatomic,strong) UIView            *lineView;
@property (nonatomic,strong) UILabel           *contentLabel;



@end

@implementation MessageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F6F6FA"];
        
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.headImgView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}

-(void)setMessage:(MessageModel *)message{
    self.nameLabel.text = message.title;
    
    self.timeLabel.text = [[ComicManager sharedComicManager] timeWithTimeIntervalNumber:message.send_time format:@"yyyy-MM-dd hh:mm"];
    self.contentLabel.text = message.content;
    CGFloat contentH = [message.content boundingRectWithSize:CGSizeMake(kScreenWidth-76, CGFLOAT_MAX) withTextFont:self.contentLabel.font].height;
    self.contentLabel.frame = CGRectMake(38,self.headImgView.bottom+24, kScreenWidth-76, contentH);
    
    self.bgView.frame = CGRectMake(18, self.timeLabel.bottom+10, kScreenWidth-36, contentH+75);
}

#pragma mark 计算高度
+(CGFloat)getMessageCellHeightWithModel:(MessageModel *)model{
    CGFloat contentH = [model.content boundingRectWithSize:CGSizeMake(kScreenWidth-76, CGFLOAT_MAX) withTextFont:[UIFont regularFontWithSize:13.0f]].height;
    return contentH+115;
}

#pragma mark -- Getters
#pragma mark 时间
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, kScreenWidth-60, 20)];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#808080"];
        _timeLabel.font = [UIFont regularFontWithSize:12.0f];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

#pragma mark 背景
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(18, self.timeLabel.bottom+10, kScreenWidth-36, 80)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 6.0;
    }
    return _bgView;
}

#pragma mark 头像
-(UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(38,self.timeLabel.bottom+20,26, 26)];
        _headImgView.image = [UIImage imageNamed:@"message_assistant"];
        [_headImgView setBorderWithCornerRadius:13 type:UIViewCornerTypeAll];
    }
    return _headImgView;
}

#pragma mark 名称
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headImgView.right+10,self.timeLabel.bottom+25, kScreenWidth-self.headImgView.right-20, 16)];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#262626"];
        _nameLabel.font = [UIFont mediumFontWithSize:15.0f];
    }
    return _nameLabel;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(18, self.headImgView.bottom+10, kScreenWidth-36, 1)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#EAEBF0"];
    }
    return _lineView;
}

#pragma mark 内容
-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, self.headImgView.bottom+24, kScreenWidth-76, 20)];
        _contentLabel.font = [UIFont regularFontWithSize:13.0f];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor colorWithHexString:@"#6D6D6D"];
    }
    return _contentLabel;
}



@end
