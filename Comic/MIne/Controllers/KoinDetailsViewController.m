//
//  KoinDetailsViewController.m
//  Comic
//
//  Created by vision on 2019/11/18.
//  Copyright © 2019 vision. All rights reserved.
//

#import "KoinDetailsViewController.h"
#import "SlideMenuView.h"
#import "RechargeDetailsTableViewCell.h"
#import "ConsumeDetailsTableViewCell.h"
#import "DetailsModel.h"
#import "BlankView.h"
#import <MJRefresh/MJRefresh.h>

@interface KoinDetailsViewController ()<SlideMenuViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView        *navBarView;
@property (nonatomic,strong) UITableView   *detailsTableView;
@property (nonatomic,strong) BlankView   *blankView;

@property (nonatomic,strong) NSMutableArray  *detailsData;

@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic,assign) NSInteger  page;

@end

@implementation KoinDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHiddenNavBar = YES;
    
    self.selectedIndex = 0;
    self.page = 1;
    
    [self.view addSubview:self.navBarView];
    [self.view addSubview:self.detailsTableView];
    [self.detailsTableView addSubview:self.blankView];
    self.blankView.hidden = YES;
    

    [self loadDetailsData];
}

#pragma mark UITableViewDataSource and UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.detailsData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedIndex==0) {
        static NSString *cellIdentifier = @"RechargeDetailsTableViewCell";
        RechargeDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[RechargeDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        DetailsModel *model = self.detailsData[indexPath.row];
        cell.details = model;
        
        return cell;
    }else{
        static NSString *cellIdentifier = @"ConsumeDetailsTableViewCell";
        ConsumeDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[ConsumeDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        DetailsModel *model = self.detailsData[indexPath.row];
        cell.details = model;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.selectedIndex==0?65:87;
}

#pragma mark - Delegate
#pragma mark SlideMenuViewDelegate
-(void)slideMenuView:(SlideMenuView *)menuView didSelectedWithIndex:(NSInteger)index{
    self.selectedIndex = index;
    [self loadNewDetailsListData];
}

#pragma mark -- Private Methods
#pragma mark 加载充值记录
-(void)loadDetailsData{
    NSDictionary *params = @{@"token":kUserTokenValue,@"label":[NSNumber numberWithInteger:self.selectedIndex+1],@"page":[NSNumber numberWithInteger:self.page],@"pagesize":@20};
    [[HttpRequest sharedInstance] postWithURLString:kTransactionRecordsAPI showLoading:YES parameters:params success:^(id responseObject) {
        NSArray *data = [responseObject objectForKey:@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in data) {
            DetailsModel *model = [[DetailsModel alloc] init];
            [model setValues:dict];
            [tempArr addObject:model];
        }
        
        if (self.page==1) {
            self.detailsData = tempArr;
        }else{
            [self.detailsData addObjectsFromArray:tempArr];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.detailsTableView.mj_footer.hidden = tempArr.count<20;
            self.blankView.hidden = self.detailsData.count>0;
            [self.detailsTableView.mj_header endRefreshing];
            [self.detailsTableView.mj_footer endRefreshing];
            [self.detailsTableView reloadData];
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.detailsTableView.mj_header endRefreshing];
            [self.detailsTableView.mj_footer endRefreshing];
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark 加载最新
-(void)loadNewDetailsListData{
    self.page = 1;
    [self loadDetailsData];
}

#pragma mark 加载更多
-(void)loadMoreDetailsListData{
    self.page ++;
    [self loadDetailsData];
}


#pragma mark -- Getters
#pragma mark 导航栏
-(UIView *)navBarView{
    if (!_navBarView) {
        _navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
        _navBarView.backgroundColor = [UIColor whiteColor];
        
       UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(5,KStatusHeight + 2, 40, 40)];
        [backBtn setImage:[UIImage drawImageWithName:@"return_black"size:CGSizeMake(12, 18)] forState:UIControlStateNormal];
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-10.0, 0, 0)];
        [backBtn addTarget:self action:@selector(leftNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:backBtn];
        
        SlideMenuView *menuView = [[SlideMenuView alloc] initWithFrame:CGRectMake(60, KStatusHeight+2,kScreenWidth-80, 40) btnTitleFont:[UIFont regularFontWithSize:14] color:[UIColor colorWithHexString:@"#9B9B9B"] selColor:[UIColor commonColor_black]];
        menuView.backgroundColor = [UIColor whiteColor];
        menuView.selectTitleFont = [UIFont mediumFontWithSize:14.0f];
        menuView.lineWidth = 16.0;
        menuView.myTitleArray =[NSMutableArray arrayWithArray:@[@"Riwayat isi ulang",@"Riwayat isi ulang"]];
        menuView.currentIndex = self.selectedIndex;
        menuView.delegate = self;
        [_navBarView addSubview:menuView];
        
    }
    return _navBarView;
}


#pragma mark 明细列表
-(UITableView *)detailsTableView{
    if (!_detailsTableView) {
        _detailsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,kNavHeight, kScreenWidth, kScreenHeight-kNavHeight) style:UITableViewStylePlain];
        _detailsTableView.delegate = self;
        _detailsTableView.dataSource = self;
        _detailsTableView.tableFooterView = [[UIView alloc] init];
        _detailsTableView.showsVerticalScrollIndicator = NO;
        
        //  下拉加载最新
        MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDetailsListData)];
        header.automaticallyChangeAlpha=YES;
        header.lastUpdatedTimeLabel.hidden=YES;
        _detailsTableView.mj_header=header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDetailsListData)];
        footer.automaticallyRefresh = NO;
        _detailsTableView.mj_footer = footer;
        footer.hidden=YES;
    }
    return _detailsTableView;
}

#pragma mark 空白页
-(BlankView *)blankView{
    if (!_blankView) {
        _blankView = [[BlankView alloc] initWithFrame:CGRectMake(0,60, kScreenWidth, 200) img:@"default_page_money" msg:@"Tidak ada riwayat transaksi"];
    }
    return _blankView;
}

-(NSMutableArray *)detailsData{
    if (!_detailsData) {
        _detailsData = [[NSMutableArray alloc] init];
    }
    return _detailsData;
}

@end
