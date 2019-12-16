//
//  PurchasedComicsViewController.m
//  Comic
//
//  Created by vision on 2019/11/15.
//  Copyright © 2019 vision. All rights reserved.
//

#import "PurchasedComicsViewController.h"
#import "BuyRecordsTableViewCell.h"
#import "BlankView.h"
#import "BuyBookModel.h"
#import <MJRefresh/MJRefresh.h>

@interface PurchasedComicsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *paidTableView;
@property (nonatomic,strong) BlankView   *blankView;
@property (nonatomic,strong) NSMutableArray *paidBooksArray;

@property (nonatomic,assign) NSInteger  page;

@end

@implementation PurchasedComicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"Komik yang telah dibeli";
    
    self.page = 1;
    
    [self.view addSubview:self.paidTableView];
    [self.paidTableView addSubview:self.blankView];
    self.blankView.hidden = YES;
    
    [self loadPaidBooksRecrodsData];
}


#pragma mark UITableViewDataSource and UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.paidBooksArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"BuyRecordsTableViewCell";
    BuyRecordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[BuyRecordsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BuyBookModel *model = self.paidBooksArray[indexPath.row];
    [cell reloadCellWithModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}


#pragma mark -- Private methods
#pragma mark 加载数据
-(void)loadPaidBooksRecrodsData{
    [[HttpRequest sharedInstance] postWithURLString:kPurchasedBooksAPI showLoading:YES parameters:@{@"token":kUserTokenValue,@"page":[NSNumber numberWithInteger:self.page],@"pagesize":@15} success:^(id responseObject) {
        NSArray *data = [responseObject objectForKey:@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in data) {
            BuyBookModel *model = [[BuyBookModel alloc] init];
            [model setValues:dict];
            [tempArr addObject:model];
        }
        if (self.page==1) {
            self.paidBooksArray = tempArr;
        }else{
            [self.paidBooksArray addObjectsFromArray:tempArr];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.paidTableView.mj_footer.hidden = tempArr.count<15;
            self.blankView.hidden = self.paidBooksArray.count>0;
            [self.paidTableView.mj_header endRefreshing];
            [self.paidTableView.mj_footer endRefreshing];
            [self.paidTableView reloadData];
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.paidTableView.mj_header endRefreshing];
            [self.paidTableView.mj_footer endRefreshing];
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark 加载最新
-(void)loadNewPurchaseRecordsListData{
    self.page = 1;
    [self loadPaidBooksRecrodsData];
}

#pragma mark 加载更多
-(void)loadMorePurchaseRecordsListData{
    self.page ++;
    [self loadPaidBooksRecrodsData];
}

#pragma mark -- Getters
#pragma mark 购买记录
-(UITableView *)paidTableView{
    if (!_paidTableView) {
        _paidTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight) style:UITableViewStylePlain];
        _paidTableView.dataSource = self;
        _paidTableView.delegate = self;
        _paidTableView.showsVerticalScrollIndicator = NO;
        _paidTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _paidTableView.tableFooterView = [[UIView alloc] init];
        
        //  下拉加载最新
        MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewPurchaseRecordsListData)];
        header.automaticallyChangeAlpha=YES;
        header.lastUpdatedTimeLabel.hidden=YES;
        _paidTableView.mj_header=header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMorePurchaseRecordsListData)];
        footer.automaticallyRefresh = NO;
        _paidTableView.mj_footer = footer;
        footer.hidden=YES;
    }
    return _paidTableView;
}

#pragma mark 空白页
-(BlankView *)blankView{
    if (!_blankView) {
        _blankView = [[BlankView alloc] initWithFrame:CGRectMake(0,60, kScreenWidth, 200) img:@"default_page_cartoon" msg:@"Kamu belum membeli komik"];
    }
    return _blankView;
}

-(NSMutableArray *)paidBooksArray{
    if (!_paidBooksArray) {
        _paidBooksArray = [[NSMutableArray alloc] init];
    }
    return _paidBooksArray;
}

@end
