//
//  ReadSettingsView.m
//  Comic
//
//  Created by vision on 2019/11/22.
//  Copyright © 2019 vision. All rights reserved.
//

#import "ReadSettingsView.h"
#import "SettingsTableViewCell.h"

@interface ReadSettingsView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView     *settingTableView;
@property (nonatomic,strong) UIButton        *moreSettingBtn;
@property (nonatomic,strong) NSMutableArray  *settingInfo;


@end

@implementation ReadSettingsView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.settingTableView];
        [self addSubview:self.moreSettingBtn];
        
        [self reloadSettingsInfo];
    }
    return self;
}

#pragma mark UITableViewDataSource and UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.settingInfo.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingsTableViewCell *cell = [[SettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = self.settingInfo[indexPath.row];
    cell.dict = dict;
    if (indexPath.row==0) {
        cell.mySwitch.hidden = YES;
    }else{
        cell.mySwitch.hidden = NO;
        cell.mySwitch.tag = indexPath.row;
        [cell.mySwitch addTarget:self action:@selector(settingSwitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark -- Event response
#pragma mark 更多设置
-(void)getMoreSettingsAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(readSettingsViewDidMoreSettings)]) {
        [self.delegate readSettingsViewDidMoreSettings];
    }
}

#pragma mark 开关
-(void)settingSwitchAction:(UISwitch *)sender{
    BOOL isOpen = sender.isOn;
    MyLog(@"settingSwitchAction-------tage:%ld,isOpen:%d",sender.tag,isOpen);
    if (sender.tag==1) {
        NSNumber *pageTurn = [NSNumber numberWithBool:!isOpen];
        [NSUserDefaultsInfos putKey:kClickPageTurn andValue:pageTurn];
    }else if (sender.tag==2){
        [NSUserDefaultsInfos putKey:kNightMode andValue:[NSNumber numberWithBool:isOpen]];
    }else{
        [NSUserDefaultsInfos putKey:kBarrageSwitch andValue:[NSNumber numberWithBool:!isOpen]];
    }
    if ([self.delegate respondsToSelector:@selector(readSettingsViewDidSetSuccess)]) {
        [self.delegate readSettingsViewDidSetSuccess];
    }
}

#pragma mark 不显示更f多
-(void)setNoMore:(BOOL)noMore{
    _noMore = noMore;
    self.moreSettingBtn.hidden = noMore;
}

#pragma mark -- Methods
#pragma mark 刷新数据
-(void)reloadSettingsInfo{
    BOOL pageTurn = [[NSUserDefaultsInfos getValueforKey:kClickPageTurn] boolValue];
    BOOL nightMode = [[NSUserDefaultsInfos getValueforKey:kNightMode] boolValue];
    BOOL barrageSwitch = [[NSUserDefaultsInfos getValueforKey:kBarrageSwitch] boolValue];
    
    NSArray *info = @[@{@"title":@"Mode balik halaman",@"desc":@"",@"tips":@"Komik ini hanya mendukung membuka halaman selanjutn -ya dan halaman sebelumnya",@"value":[NSNumber numberWithBool:NO]},@{@"title":@"Klik balik halaman",@"desc":@"Setelah membuka silahkan klik halaman selanjutnya dan halaman sebelumnya di layar",@"tips":@"",@"value":[NSNumber numberWithBool:!pageTurn]},@{@"title":@"Mode malam",@"desc":@"",@"tips":@"",@"value":[NSNumber numberWithBool:nightMode]},@{@"title":@"aktif nonaktif komentar langsung",@"desc":@"Kalau tidak melihat komentar langsung, akan banyak hal menarik dan berbeda yang dilewatkan lho",@"tips":@"",@"value":[NSNumber numberWithBool:!barrageSwitch]}];
    self.settingInfo = [NSMutableArray arrayWithArray:info];
    [self.settingTableView reloadData];
}

#pragma mark --Getters
#pragma mark 设置
-(UITableView *)settingTableView{
    if (!_settingTableView) {
        _settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 320) style:UITableViewStylePlain];
        _settingTableView.dataSource = self;
        _settingTableView.delegate = self;
        _settingTableView.tableFooterView = [[UIView alloc] init];
        _settingTableView.showsVerticalScrollIndicator = NO;
        _settingTableView.scrollEnabled = NO;
        _settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _settingTableView;
}

#pragma makr 更多设置
-(UIButton *)moreSettingBtn{
    if (!_moreSettingBtn) {
        _moreSettingBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-250)/2.0, self.settingTableView.bottom+10, 250, 20)];
        [_moreSettingBtn setImage:[UIImage imageNamed:@"barrage_more_settings"] forState:UIControlStateNormal];
        [_moreSettingBtn setTitle:@"Pengaturan lebih banyak komentar langsung" forState:UIControlStateNormal];
        [_moreSettingBtn setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateNormal];
        _moreSettingBtn.titleLabel.font = [UIFont regularFontWithSize:10];
        [_moreSettingBtn addTarget:self action:@selector(getMoreSettingsAction:) forControlEvents:UIControlEventTouchUpInside];
        _moreSettingBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
    }
    return _moreSettingBtn;
}

-(NSMutableArray *)settingInfo{
    if (!_settingInfo) {
        _settingInfo = [[NSMutableArray alloc] init];
    }
    return _settingInfo;
}


@end
