//
//  SettingsTableViewCell.m
//  Comic
//
//  Created by vision on 2019/11/22.
//  Copyright © 2019 vision. All rights reserved.
//

#import "SettingsTableViewCell.h"

@interface SettingsTableViewCell ()

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *descLab;
@property (nonatomic,strong) UILabel *tipsLab;


@end

@implementation SettingsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.descLab];
        [self.contentView addSubview:self.tipsLab];
        [self.contentView addSubview:self.mySwitch];
    }
    return self;
}

#pragma mark 填充数据
-(void)setDict:(NSDictionary *)dict{
    self.titleLab.text = dict[@"title"];
    
    NSString *desc = dict[@"desc"];
    self.descLab.text = desc;
    self.descLab.hidden = kIsEmptyString(desc);
    
    NSString *tips = dict[@"tips"];
    self.tipsLab.text = tips;
    self.tipsLab.hidden = kIsEmptyString(tips);
    
    BOOL isOn = [dict[@"value"] boolValue];
    [self.mySwitch setOn:isOn];
}

#pragma mark -- Getters
#pragma mark 标题
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 10,260, 20)];
        _titleLab.font = [UIFont mediumFontWithSize:16];
        _titleLab.textColor = [UIColor commonColor_black];
    }
    return _titleLab;
}

#pragma mark 描述
-(UILabel *)descLab{
    if (!_descLab) {
        _descLab = [[UILabel alloc] initWithFrame:CGRectMake(20, self.titleLab.bottom,self.titleLab.width, 40)];
        _descLab.font = [UIFont regularFontWithSize:10];
        _descLab.textColor = [UIColor colorWithHexString:@"#808080"];
        _descLab.numberOfLines = 0;
    }
    return _descLab;
}

#pragma mark 提示
-(UILabel *)tipsLab{
    if (!_tipsLab) {
        _tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-180, 10,165, 60)];
        _tipsLab.font = [UIFont regularFontWithSize:10];
        _tipsLab.textColor = [UIColor colorWithHexString:@"#808080"];
        _tipsLab.numberOfLines = 0;
    }
    return _tipsLab;
}

-(UISwitch *)mySwitch{
    if (!_mySwitch) {
        _mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth-70, 20, 50, 26)];
        _mySwitch.onTintColor = [UIColor colorWithHexString:@"#915AFF"];
    }
    return _mySwitch;
}

@end
