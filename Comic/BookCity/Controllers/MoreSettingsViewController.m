//
//  MoreSettingsViewController.m
//  Comic
//
//  Created by vision on 2019/11/22.
//  Copyright © 2019 vision. All rights reserved.
//

#import "MoreSettingsViewController.h"
#import "ReadSettingsView.h"

@interface MoreSettingsViewController ()<ReadSettingsViewDelegate>{
    double    transparency;
    double    speed;
}

@property (nonatomic,strong) UIView  *navbarView;
@property (nonatomic,strong) ReadSettingsView *settingView;
@property (nonatomic,strong) UILabel  *barrageLabel;
@property (nonatomic,strong) UIView   *barrageSettingView;

@property (nonatomic,strong) UISlider *transparencySlider;
@property (nonatomic,strong) UILabel  *transparencyValueLab;
@property (nonatomic,strong) UISlider *speedSlider;
@property (nonatomic,strong) UILabel  *speedValueLab;


@end

@implementation MoreSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    transparency = [[NSUserDefaultsInfos getValueforKey:kBarrageTransparency] doubleValue];
    speed = [[NSUserDefaultsInfos getValueforKey:kBarrageSpeed] doubleValue];
    
    [self initMoreSettingsView];
}

#pragma mark - Delegate
#pragma mark ReadSettingsViewDelegate
#pragma mark 设置成功
-(void)readSettingsViewDidSetSuccess{
    self.setBlock();
}

#pragma mark --Event response
#pragma mark 退出
-(void)backCurrentController:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 恢复默认
-(void)resetAction:(UIButton *)sender{
    [NSUserDefaultsInfos removeObjectForKey:kClickPageTurn];
    [NSUserDefaultsInfos removeObjectForKey:kNightMode];
    [NSUserDefaultsInfos removeObjectForKey:kBarrageSwitch];
    
    [self.settingView reloadSettingsInfo];
    
    transparency = 60.0;
    speed = 1.0;
    self.transparencySlider.value = 60;
    self.barrageLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:60.0/100.0];
    self.transparencyValueLab.text = @"60%";
    [NSUserDefaultsInfos putKey:kBarrageTransparency andValue:[NSNumber numberWithDouble:60]];
    
    self.speedSlider.value = 1.0;
    self.speedValueLab.text = @"1.0x";
    [NSUserDefaultsInfos putKey:kBarrageSpeed andValue:[NSNumber numberWithDouble:1.0]];
    
    
    self.setBlock();
}

#pragma mark 设置弹幕
-(void)barrageSettingAction:(UISlider *)sender{
    double value = sender.value;
    MyLog(@"barrageSettingAction:%.f",value);
    if (sender.tag==0) { //设置透明度
        self.barrageLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:value/100.0];
        self.transparencyValueLab.text = [NSString stringWithFormat:@"%ld%%",(long)value];
        [NSUserDefaultsInfos putKey:kBarrageTransparency andValue:[NSNumber numberWithDouble:value]];
    }else{ //设置时间
        self.speedValueLab.text = [NSString stringWithFormat:@"%.1fx",value];
        [NSUserDefaultsInfos putKey:kBarrageSpeed andValue:[NSNumber numberWithInteger:value]];
    }
    self.setBlock();
}

#pragma mark -- Private methods
#pragma mark 初始化
-(void)initMoreSettingsView{
    [self.view addSubview:self.navbarView];
    [self.view addSubview:self.settingView];
    [self.view addSubview:self.barrageLabel];
    [self.view addSubview:self.barrageSettingView];
}

#pragma mark -- Getters
#pragma mark 导航栏
-(UIView *)navbarView{
    if (!_navbarView) {
        _navbarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
        
        UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(5,KStatusHeight + 2, 40, 40)];
        [backBtn setImage:[UIImage drawImageWithName:@"settings_close"size:CGSizeMake(17, 10)] forState:UIControlStateNormal];
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-10.0, 0, 0)];
        [backBtn addTarget:self action:@selector(backCurrentController:) forControlEvents:UIControlEventTouchUpInside];
        [_navbarView addSubview:backBtn];
        
        UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-180)/2, KStatusHeight+12, 180, 22)];
        titleLabel.textColor=[UIColor commonColor_black];
        titleLabel.font=[UIFont mediumFontWithSize:18];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.text = @"Pengaturan";
        [_navbarView addSubview:titleLabel];
        
        UIButton *saveBtn=[[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-75, KStatusHeight+2, 70, 40)];
        [saveBtn setTitle:@"Reset" forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor commonColor_black] forState:UIControlStateNormal];
        saveBtn.titleLabel.font=[UIFont regularFontWithSize:16];
        [saveBtn addTarget:self action:@selector(resetAction:) forControlEvents:UIControlEventTouchUpInside];
        [_navbarView addSubview:saveBtn];
    }
    return _navbarView;
}

#pragma mark 设置
-(ReadSettingsView *)settingView{
    if (!_settingView) {
        _settingView = [[ReadSettingsView alloc] initWithFrame:CGRectMake(0,self.navbarView.bottom, kScreenWidth, 320)];
        _settingView.delegate = self;
        _settingView.noMore = YES;
    }
    return _settingView;
}

#pragma mark 弹幕
-(UILabel *)barrageLabel{
    if (!_barrageLabel) {
        _barrageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.settingView.bottom+10, kScreenWidth-20, 40)];
        _barrageLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:transparency>0?(transparency/100.0):0.6];
        _barrageLabel.text = @"Tolong perhatikan dalam bersikap dan berbahasa di komentar langsung";
        _barrageLabel.textAlignment = NSTextAlignmentCenter;
        _barrageLabel.font = [UIFont regularFontWithSize:12];
        _barrageLabel.textColor = [UIColor whiteColor];
        _barrageLabel.numberOfLines = 0;
        [_barrageLabel setBorderWithCornerRadius:15 type:UIViewCornerTypeAll];
    }
    return _barrageLabel;
}

#pragma mark 弹幕设置
-(UIView *)barrageSettingView{
    if (!_barrageSettingView) {
        _barrageSettingView = [[UIView alloc] initWithFrame:CGRectMake(0, self.barrageLabel.bottom+20, kScreenWidth, 180)];
        
        NSArray *titles = @[@"Tingkat kecerahan",@"Kecepatan memainkan"];
        for (NSInteger i=0; i<titles.count; i++) {
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(22, i*75, kScreenWidth-44, 18)];
            lab.text = titles[i];
            lab.font = [UIFont mediumFontWithSize:16];
            lab.textColor = [UIColor commonColor_black];
            [_barrageSettingView addSubview:lab];
            
            UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(68, lab.bottom+15, 190, 16)];
            
            slider.thumbTintColor = [UIColor whiteColor];
            slider.minimumTrackTintColor = [UIColor colorWithHexString:@"#946EFF"];
            slider.maximumTrackTintColor = [UIColor colorWithHexString:@"#D8D8D8"];
            
            slider.tag = i;
            [slider addTarget:self action:@selector(barrageSettingAction:) forControlEvents:UIControlEventValueChanged];
            [_barrageSettingView addSubview:slider];
            if (i==0) {
                slider.minimumValue = 10.0;
                slider.maximumValue = 60.0;
                slider.value = transparency>0.0?transparency:60.0;
                self.transparencySlider = slider;
            }else{
                slider.minimumValue = 0.5;
                slider.maximumValue = 1.5;
                slider.value = speed>0.0?speed:1.0;
                self.speedSlider = slider;
            }
            
            UILabel *valueLab = [[UILabel alloc] initWithFrame:CGRectMake(slider.right+20, slider.top, 35, 15)];
            valueLab.textColor = [UIColor colorWithHexString:@"#808080"];
            valueLab.font = [UIFont regularFontWithSize:13.0f];
            [_barrageSettingView addSubview:valueLab];
            if (i==0) {
                valueLab.text = [NSString stringWithFormat:@"%ld%%",(long)(transparency>0.0?(NSInteger)transparency:60)];
                self.transparencyValueLab = valueLab;
            }else{
                valueLab.text = [NSString stringWithFormat:@"%.1fx",speed>0.0?speed:1.0];
                self.speedValueLab = valueLab;
            }
        }
        
    }
    return _barrageSettingView;
}

@end
