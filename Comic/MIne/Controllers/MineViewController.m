//
//  MineViewController.m
//  Comic
//
//  Created by vision on 2019/11/13.
//  Copyright © 2019 vision. All rights reserved.
//

#import "MineViewController.h"
#import "UserInfoViewController.h"
#import "MemberCenterViewController.h"
#import "MessagesViewController.h"
#import "InstallViewController.h"
#import "RechargeViewController.h"
#import "CheckInViewController.h"
#import "MineHeadView.h"
#import "CustomButton.h"
#import "UserModel.h"
#import <MJRefresh/MJRefresh.h>

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,MineHeadViewDelegate>{
    NSArray  *titles;
    NSArray  *classes;
}

@property (nonatomic,strong) MineHeadView   *headView;
@property (nonatomic,strong) UITableView    *mineTableView;
@property (nonatomic,strong) UserModel      *userInfo;

@property (nonatomic,assign) BOOL   msgState;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenBackBtn = YES;
    
    titles = @[@"Area hadiah",@"Peferensi membaca",@"Lainnya"];
    classes = @[@"CheckIn",@"MemberCenter",@"ReadPreference",@"ReadRecords",@"PurchasedComics",@"Feedback"];
    
    [self.view addSubview:self.mineTableView];
    [self loadUserInfoData];
    [self loadUnreadMessagesData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([ComicManager sharedComicManager].isMineReload) {
        [self loadUserInfoData];
        [ComicManager sharedComicManager].isMineReload = NO;
    }
    if ([ComicManager sharedComicManager].isMessagesReload) {
        self.headView.unreadMsgState = NO;
        [self loadUnreadMessagesData];
        [ComicManager sharedComicManager].isMessagesReload = NO;
    }
}


#pragma mark UITableViewDataSource and UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(22, 10, kScreenWidth-60, 18)];
    titleLab.textColor = [UIColor commonColor_black];
    titleLab.font = [UIFont mediumFontWithSize:18];
    titleLab.text = titles[indexPath.row];
    [cell.contentView addSubview:titleLab];
    
    if (indexPath.row==0) {
        NSArray *bgImages = @[@"my_daily_attendance_beans",@"my_vip_beans"];
        NSArray *titles = @[@"Mengambil koin",@"koin yang diambil anggota"];
        NSString *checkNum = [NSString stringWithFormat:@"%ld orang yang mengambil",(long)[self.userInfo.sign_count integerValue]];
        NSString *memberNum = [NSString stringWithFormat:@"%ld orang yang mengambil",(long)[self.userInfo.vip_get_count integerValue]];
        NSArray *texts = @[checkNum,memberNum];
        CGFloat btnW = (kScreenWidth-68)/2.0;
        for (NSInteger i=0; i<2; i++) {
            UIButton *getBtn = [[UIButton alloc] initWithFrame:CGRectMake(24+i*(btnW+20), titleLab.bottom+10, btnW, 78)];
            [getBtn setBackgroundImage:[UIImage imageNamed:bgImages[i]] forState:UIControlStateNormal];
            getBtn.tag = i;
            getBtn.adjustsImageWhenHighlighted = NO;
            [getBtn addTarget:self action:@selector(gotoMyInfoAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:getBtn];
            
            UILabel *aLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, getBtn.width-20, 40)];
            aLab.numberOfLines = 0;
            aLab.textColor = [UIColor colorWithHexString:i==0?@"#2E78FF":@"#FF7600"];
            aLab.font = [UIFont mediumFontWithSize:13.0f];
            aLab.text = titles[i];
            [getBtn addSubview:aLab];
            
            UILabel *tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(10,aLab.bottom, getBtn.width-40, 40)];
            tipsLab.numberOfLines = 0;
            tipsLab.textColor = [UIColor colorWithHexString:i==0?@"#2E78FF":@"#FF7600"];
            tipsLab.font = [UIFont mediumFontWithSize:11.0f];
            tipsLab.text = texts[i];
            [getBtn addSubview:tipsLab];
            
        }
    }else if (indexPath.row==1){
        NSArray *values = @[@"Peferensi membaca",@"Riwayat membaca",@"Telah membeli komik"];
        NSArray *images = @[@"my_reading_preference",@"my_reading_record",@"my_purchased_comics"];
        for (NSInteger i=0; i<values.count; i++) {
            CustomButton *btn = [[CustomButton alloc] initWithFrame:CGRectMake(22+80*i, titleLab.bottom+20, 80, 70) imgSize:CGSizeMake(34, 28)];
            btn.imgName = images[i];
            btn.titleString = values[i];
            btn.tag = indexPath.row*2+i;
            [btn addTarget:self action:@selector(gotoMyInfoAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
        }
    }else{
        CustomButton *btn = [[CustomButton alloc] initWithFrame:CGRectMake(22, titleLab.bottom+20, 80, 70) imgSize:CGSizeMake(34, 28)];
        btn.imgName = @"my_feedback";
        btn.titleString = @"Pendapat dan umpan balik";
        btn.tag = 5;
        [btn addTarget:self action:@selector(gotoMyInfoAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 128;
}

#pragma mark MineHeadViewDelegate
#pragma mark  个人信息
-(void)mineHeadViewDidSelecteduserInfo{
    if ([ComicManager hasSignIn]) {
        UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
        userInfoVC.useInfo = self.userInfo;
        [self.navigationController pushViewController:userInfoVC animated:YES];
    }else{
        [self presentLoginVC];
    }
}

#pragma mark 会员中心、消息、设置、充值
-(void)mineHeadViewDidClickBtnWithTag:(NSInteger)tag{
    if (tag==0||tag==4) {
        MemberCenterViewController *memberCenterVC = [[MemberCenterViewController alloc] init];
        [self.navigationController pushViewController:memberCenterVC animated:YES];
    }else if (tag==1){
        if ([ComicManager hasSignIn]) {
            MessagesViewController *messagesVC = [[MessagesViewController alloc] init];
            messagesVC.hasUnreadMsg = self.msgState;
            [self.navigationController pushViewController:messagesVC animated:YES];
        }else{
            [self presentLoginVC];
        }
    }else if (tag==2){
        InstallViewController *installVC = [[InstallViewController alloc] init];
        [self.navigationController pushViewController:installVC animated:YES];
    }else if(tag==3){
        RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
        [self.navigationController pushViewController:rechargeVC animated:YES];
    }else{
        [self presentLoginVC];
    }
}

#pragma mark -- Event response
#pragma mark 跳转事件
-(void)gotoMyInfoAction:(UIButton*)sender{
    NSString *str = classes[sender.tag];
    if ([str isEqualToString:@"CheckIn"]) {
        if ([ComicManager hasSignIn]) {
            CheckInViewController *checkVC = [[CheckInViewController alloc] init];
            [self.navigationController pushViewController:checkVC animated:YES];
        }else{
            [self presentLoginVC];
        }
    }else{
        NSString *classStr = [NSString stringWithFormat:@"%@ViewController",str];
        Class aClass = NSClassFromString(classStr);
        BaseViewController *vc = (BaseViewController *)[[aClass alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark -- Private methods
#pragma mark 加载个人信息
-(void)loadUserInfoData{
    [[HttpRequest sharedInstance] postWithURLString:kMineAPI showLoading:YES parameters:@{@"token":kUserTokenValue} success:^(id responseObject) {
        NSDictionary *data = [responseObject objectForKey:@"data"];
        NSDictionary *userDict = [data valueForKey:@"userinfo"];
        self.userInfo = [[UserModel alloc] init];
        [self.userInfo setValues:userDict];
        
        [NSUserDefaultsInfos putKey:kUserVip andValue:self.userInfo.vip];
        [NSUserDefaultsInfos putKey:kMyKoin andValue:self.userInfo.bean];
        
        self.userInfo.sign_count = [data valueForKey:@"sign_count"];
        self.userInfo.vip_get_count = [data valueForKey:@"vip_get_count"];
        
        
        NSString *endTime = [[ComicManager sharedComicManager] timeWithTimeIntervalNumber:self.userInfo.vip_end_time format:@"yyyy-MM-dd"];
        MyLog(@"vip到期时间：%@",endTime);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mineTableView.mj_header endRefreshing];
            self.headView.userModel = self.userInfo;
            self.headView.frame = CGRectMake(0, 0, kScreenWidth, [self.userInfo.vip boolValue]?190:280);
            [self.mineTableView reloadData];
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mineTableView.mj_header endRefreshing];
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark 加载未读消息
-(void)loadUnreadMessagesData{
    [[HttpRequest sharedInstance] postWithURLString:kUnreadMessagesAPI showLoading:NO parameters:@{@"token":kUserTokenValue} success:^(id responseObject) {
        NSDictionary *data = [responseObject objectForKey:@"data"];
        self.msgState = [[data valueForKey:@"state"] boolValue];
        dispatch_async(dispatch_get_main_queue(), ^{
           self.headView.unreadMsgState = self.msgState;
        });
    } failure:^(NSString *errorStr) {
        
    }];
}

#pragma mark 创建按钮
-(UIButton *)createButtonWithFrame:(CGRect)frame ImageName:(NSString *)imgName title:(NSString *)titleStr tag:(NSInteger)tag{
    UIButton *btn  = [[UIButton alloc] initWithFrame:frame];
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn setTitle:titleStr forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor commonColor_black] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont regularFontWithSize:11.0f];
    btn.adjustsImageWhenHighlighted = NO;
    btn.imageEdgeInsets = UIEdgeInsetsMake(-(btn.height - btn.titleLabel.height- btn.titleLabel.y),(btn.width-btn.imageView.width)/2.0, 0, 0);
    btn.titleEdgeInsets = UIEdgeInsetsMake(btn.imageView.height+btn.imageView.y+15, -btn.imageView.width, 0, 0);
    btn.tag = tag;
    [btn addTarget:self action:@selector(gotoMyInfoAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark -- Getters
#pragma mark 头部视图
-(MineHeadView *)headView{
    if (!_headView) {
        _headView = [[MineHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 280)];
        _headView.delegate = self;
    }
    return _headView;
}

#pragma mark 我的
-(UITableView *)mineTableView{
    if (!_mineTableView) {
        _mineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabHeight) style:UITableViewStylePlain];
        _mineTableView.delegate = self;
        _mineTableView.dataSource = self;
        _mineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mineTableView.showsVerticalScrollIndicator = NO;
        _mineTableView.tableFooterView = [[UIView alloc] init];
        _mineTableView.tableHeaderView = self.headView;
        
        if (@available(iOS 11.0, *)) {
            _mineTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadUserInfoData)];
        header.automaticallyChangeAlpha=YES;
        header.lastUpdatedTimeLabel.hidden=YES;
        _mineTableView.mj_header=header;
    }
    return _mineTableView;
}

@end
