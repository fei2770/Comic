//
//  TaskTableViewCell.m
//  Comic
//
//  Created by vision on 2019/11/19.
//  Copyright © 2019 vision. All rights reserved.
//

#import "TaskTableViewCell.h"

@interface TaskTableViewCell ()

@property (nonatomic,strong) UIImageView  *iconImageView;
@property (nonatomic,strong) UILabel      *titleLabel;
@property (nonatomic,strong) UILabel      *tipsLabel;



@end

@implementation TaskTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.tipsLabel];
        self.tipsLabel.hidden = YES;
        [self.contentView addSubview:self.receiveBtn];
    }
    return self;
}

-(void)setTaskModel:(TaskModel *)taskModel{
    _taskModel = taskModel;
    self.iconImageView.image = [UIImage imageNamed:taskModel.icon];
    self.titleLabel.text = taskModel.quest_name;
    if (!kIsEmptyString(taskModel.tips)) {
        self.tipsLabel.hidden = NO;
        self.tipsLabel.text = taskModel.tips;
    }else{
        self.tipsLabel.hidden = YES;
    }
    if ([taskModel.status integerValue]==1) {
        [self.receiveBtn setBackgroundImage:[UIImage imageNamed:@"beans_incomplete"] forState:UIControlStateNormal];
        [self.receiveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.receiveBtn setTitle:[NSString stringWithFormat:@"+%@ koin",taskModel.bean] forState:UIControlStateNormal];
        self.receiveBtn.userInteractionEnabled = NO;
    }else if ([taskModel.status integerValue]==2){
        [self.receiveBtn setBackgroundImage:[UIImage imageNamed:@"beans_receive"] forState:UIControlStateNormal];
        [self.receiveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.receiveBtn setTitle:[NSString stringWithFormat:@"Ambil %@ koin",taskModel.bean] forState:UIControlStateNormal];
        self.receiveBtn.userInteractionEnabled = YES;
    }else{
        [self.receiveBtn setBackgroundImage:[UIImage imageNamed:@"beans_completed"] forState:UIControlStateNormal];
        [self.receiveBtn setTitleColor:[UIColor colorWithHexString:@"#83848D"] forState:UIControlStateNormal];
        [self.receiveBtn setTitle:@"Selesai" forState:UIControlStateNormal];
        self.receiveBtn.userInteractionEnabled = NO;
    }
}

#pragma mark -- Getters
#pragma mark  icon
-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(22, 14, 24, 24)];
    }
    return _iconImageView;
}

#pragma mark 标题
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImageView.right+10, 16, 240, 20)];
        _titleLabel.textColor = [UIColor commonColor_black];
        _titleLabel.font = [UIFont regularFontWithSize:14];
    }
    return _titleLabel;
}

#pragma mark 描述
-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImageView.right+10,self.titleLabel.bottom, 200, 14)];
        _tipsLabel.font = [UIFont regularFontWithSize:11];
        _tipsLabel.textColor = [UIColor colorWithHexString:@"#808080"];
    }
    return _tipsLabel;
}

#pragma mark  领取
-(UIButton *)receiveBtn{
    if (!_receiveBtn) {
        _receiveBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-90, 12, 88, 34)];
        [_receiveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _receiveBtn.titleLabel.font = [UIFont mediumFontWithSize:12];
        _receiveBtn.titleEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, 0);
    }
    return _receiveBtn;
}

@end
