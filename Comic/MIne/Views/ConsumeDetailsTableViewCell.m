//
//  ConsumeDetailsTableViewCell.m
//  Comic
//
//  Created by vision on 2019/11/18.
//  Copyright © 2019 vision. All rights reserved.
//

#import "ConsumeDetailsTableViewCell.h"

@interface ConsumeDetailsTableViewCell ()

@property (nonatomic,strong) UILabel  *nameLab;
@property (nonatomic,strong) UILabel  *chapterLab;
@property (nonatomic,strong) UILabel  *timeLab;
@property (nonatomic,strong) UILabel  *koinLab;

@end

@implementation ConsumeDetailsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.chapterLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.koinLab];
    }
    return self;
}

-(void)setDetails:(DetailsModel *)details{
    _details = details;
    
    if ([details.status integerValue]==8) { //兑换弹幕样式
        self.nameLab.text = @"Beli koin komentar langusng";
        self.nameLab.frame = CGRectMake(24, 5, kScreenWidth-140, 50);
        self.chapterLab.hidden = YES;
        self.timeLab.frame = CGRectMake(24, self.nameLab.bottom+5, 120, 16);
    }else{
        self.nameLab.text = details.book_name;
        self.nameLab.frame = CGRectMake(24, 15, kScreenWidth-140, 16);
        
        self.chapterLab.text = [NSString stringWithFormat:@"Pembelian %@",details.catalogue_name];
        self.chapterLab.hidden = NO;
        self.chapterLab.frame = CGRectMake(24,self.nameLab.bottom+5, kScreenWidth-140, 16);
        self.timeLab.frame = CGRectMake(24, self.chapterLab.bottom+5, 120, 16);
    }
    
    self.timeLab.text = [[ComicManager sharedComicManager] timeWithTimeIntervalNumber:details.create_time format:@"yyyy-MM-dd HH:mm"];
    NSString *str = [NSString stringWithFormat:@"-%ld Koin",(long)[details.count integerValue]];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont mediumFontWithSize:24] range:NSMakeRange(0, str.length-5)];
    self.koinLab.attributedText = attributedStr;
}

#pragma mark 书名
-(UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(24, 15, kScreenWidth-180, 16)];
        _nameLab.textColor = [UIColor commonColor_black];
        _nameLab.font = [UIFont mediumFontWithSize:15];
        _nameLab.numberOfLines = 0;
    }
    return _nameLab;
}

#pragma mark 章节
-(UILabel *)chapterLab{
    if (!_chapterLab) {
        _chapterLab = [[UILabel alloc] initWithFrame:CGRectMake(24,self.nameLab.bottom+5, kScreenWidth-180, 16)];
        _chapterLab.textColor = [UIColor colorWithHexString:@"#6D6D6D"];
        _chapterLab.font = [UIFont regularFontWithSize:15];
    }
    return _chapterLab;
}

#pragma mark 时间
-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(24, self.bottom-27, 120, 16)];
        _timeLab.textColor = [UIColor colorWithHexString:@"#9495A0"];
        _timeLab.font = [UIFont regularFontWithSize:13.0f];
    }
    return _timeLab;
}

#pragma mark 金币
-(UILabel *)koinLab{
    if (!_koinLab) {
        _koinLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-116, 26, 100, 35)];
        _koinLab.textColor = [UIColor colorWithHexString:@"#FF9100"];
        _koinLab.font = [UIFont regularFontWithSize:13.0f];
        _koinLab.textAlignment = NSTextAlignmentRight;
    }
    return _koinLab;
}

@end
