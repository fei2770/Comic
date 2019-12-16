//
//  RechargeDetailsTableViewCell.m
//  Comic
//
//  Created by vision on 2019/11/18.
//  Copyright © 2019 vision. All rights reserved.
//

#import "RechargeDetailsTableViewCell.h"

@interface RechargeDetailsTableViewCell ()

@property (nonatomic,strong) UILabel  *nameLab;
@property (nonatomic,strong) UILabel  *timeLab;
@property (nonatomic,strong) UILabel  *koinLab;

@end

@implementation RechargeDetailsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.koinLab];
    }
    return self;
}

-(void)setDetails:(DetailsModel *)details{
    _details = details;
    
    self.nameLab.text = [self getNameWithStatus:details.status];
    self.timeLab.text = [[ComicManager sharedComicManager] timeWithTimeIntervalNumber:details.create_time format:@"yyyy-MM-dd HH:mm"];
    NSString *str = [NSString stringWithFormat:@"+%ld Koin",(long)[details.count integerValue]];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont mediumFontWithSize:24] range:NSMakeRange(0, str.length-5)];
    self.koinLab.attributedText = attributedStr;
}


#pragma mark 获取
-(NSString *)getNameWithStatus:(NSNumber *)status{
    NSInteger state = [status integerValue];
    NSString *name = nil;
    switch (state) {
        case 1:
            name = @"Isi ulang";
            break;
        case 2:
            name = @"Pembelian isi ulang";
            break;
        case 3:
            name = @"";
            break;
        case 4:
            name = @"Hadiah tugas";
            break;
        case 5:
            name = @"Diambil anggota";
            break;
        case 6:
            name = @"Hadiah untuk anggota";
            break;
        default:
            break;
    }
    return name;
}

#pragma mark 名称
-(UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(24, 15, kScreenWidth-180, 16)];
        _nameLab.textColor = [UIColor commonColor_black];
        _nameLab.font = [UIFont mediumFontWithSize:15];
    }
    return _nameLab;
}

#pragma mark 时间
-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(24, self.nameLab.bottom+5, 120, 16)];
        _timeLab.textColor = [UIColor colorWithHexString:@"#9495A0"];
        _timeLab.font = [UIFont regularFontWithSize:13.0f];
    }
    return _timeLab;
}

#pragma mark 金币
-(UILabel *)koinLab{
    if (!_koinLab) {
        _koinLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-160, 15, 140, 35)];
        _koinLab.textColor = [UIColor colorWithHexString:@"#FF9100"];
        _koinLab.font = [UIFont regularFontWithSize:13.0f];
        _koinLab.textAlignment = NSTextAlignmentRight;
    }
    return _koinLab;
}


@end
