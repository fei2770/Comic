//
//  BookCityViewController.m
//  Comic
//
//  Created by vision on 2019/11/13.
//  Copyright © 2019 vision. All rights reserved.
//

#import "BookCityViewController.h"
#import "BaseWebViewController.h"
#import "BookDetailsViewController.h"
#import "RechargeViewController.h"
#import "SDCycleScrollView.h"
#import "BookCityTableViewCell.h"
#import "APPInfoManager.h"
#import "BookModel.h"
#import "BannerModel.h"
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD.h>
#import <UIImage+GIF.h>

@interface BookCityViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

@property (nonatomic,strong) SDCycleScrollView *bannerScrollView;
@property (nonatomic,strong) UITableView *mainTableView;

@property (nonatomic,strong) NSMutableArray *booksArray; //课程
@property (nonatomic,strong) NSMutableArray *bannerArray; //banner

@end

@implementation BookCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavBar = YES;
    
    [self.view addSubview:self.mainTableView];
    
    [self loadBookCityData];
}

#pragma mark 状态栏样式
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark -- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.booksArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"BookCityTableViewCell";
    BookCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[BookCityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BookModel *model = self.booksArray[indexPath.row];
    cell.bookModel = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookModel *model = self.booksArray[indexPath.row];
    CGFloat nameH = [model.book_name boundingRectWithSize:CGSizeMake(kScreenWidth-36, CGFLOAT_MAX) withTextFont:[UIFont mediumFontWithSize:16]].height;
    return 275+nameH;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BookModel *model = self.booksArray[indexPath.row];
    BookDetailsViewController *bookDetailsVC = [[BookDetailsViewController alloc] init];
    bookDetailsVC.bookId = model.book_id;
    bookDetailsVC.currentIndex = 0;
    [self.navigationController pushViewController:bookDetailsVC animated:YES];
}

#pragma mark -- Custom Delegate
#pragma mark SDCycleScrollViewDelegate
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    BannerModel *banner = self.bannerArray[index];
    if ([banner.banner_cate integerValue]==1) {
        BaseWebViewController *webVC = [[BaseWebViewController alloc] init];
        webVC.webTitle = banner.banner_name;
        webVC.urlStr = banner.banner_url;
        [self.navigationController pushViewController:webVC animated:YES];
    }else if ([banner.banner_cate integerValue]==3){
        if ([banner.custom isEqualToString:@"experience"]) {
            RechargeViewController *rechargeVc = [[RechargeViewController alloc] init];
            [self.navigationController pushViewController:rechargeVc animated:YES];
        }
    }
}


#pragma mark -- Private Methods
#pragma mark 加载数据
-(void)loadBookCityData{
    BOOL showLoading = NO;
    NSDictionary *params;
    NSString *token = [NSUserDefaultsInfos getValueforKey:kUserToken];
    if (!kIsEmptyString(token)) {
        showLoading = YES;
        params = @{@"token":kUserTokenValue};
    }else{
        NSNumber *gender = [NSUserDefaultsInfos getValueforKey:kUserGenderPreference];
        NSArray *types = [NSUserDefaultsInfos getValueforKey:kUserChannelPreference];
        if ([gender integerValue]>0&&types.count>0) {
            showLoading = YES;
            NSString *typeStr = [[ComicManager sharedComicManager] getValueWithParams:types];
            params = @{@"channel":gender,@"book_type":typeStr};
        }else{
            showLoading = NO;
            NSArray *arr = @[@1];
            NSString *str = [[ComicManager sharedComicManager] getValueWithParams:arr];
            params = @{@"channel":@1,@"book_type":str};
        }
    }
    [[HttpRequest sharedInstance] postWithURLString:kBookCityHomeAPI showLoading:showLoading parameters:params success:^(id responseObject) {
        NSDictionary *data = [responseObject objectForKey:@"data"];
        NSArray *banners = [data valueForKey:@"banner"];
        //banner
        NSMutableArray *tempBannerArr = [[NSMutableArray alloc] init];
        NSMutableArray *tempBannerImgArr  = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in banners) {
            BannerModel *banner = [[BannerModel alloc] init];
            [banner setValues:dict];
            [tempBannerArr addObject:banner];
            [tempBannerImgArr addObject:banner.banner_pic];
        }
        self.bannerArray = tempBannerArr;
        //书
        NSArray *books = [data objectForKey:@"books"];
        NSMutableArray *booksArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in books) {
            BookModel *model = [[BookModel alloc] init];
            [model setValues:dict];
            [booksArr addObject:model];
        }
        self.booksArray = booksArr;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mainTableView.mj_header endRefreshing];
            self.mainTableView.tableHeaderView = self.bannerScrollView;
            self.bannerScrollView.imageURLStringsGroup = tempBannerImgArr;
            [self.mainTableView reloadData];
        });
    } failure:^(NSString *errorStr) {
        if (showLoading) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainTableView.mj_header endRefreshing];
                [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
            });
        }
    }];
}


#pragma mark -- Getters
#pragma mark  主页
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabHeight) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.estimatedSectionHeaderHeight = 0.0;
        _mainTableView.estimatedSectionFooterHeight = 0.0;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = [UIColor colorWithHexString:@"#FAFBFC"];
        _mainTableView.showsVerticalScrollIndicator = NO;
        
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        //  下拉加载最新
        MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadBookCityData)];
        header.automaticallyChangeAlpha=YES;
        header.lastUpdatedTimeLabel.hidden=YES;
        _mainTableView.mj_header=header;
    }
    return _mainTableView;
}

#pragma mark 广告位
-(SDCycleScrollView *)bannerScrollView{
    if (!_bannerScrollView) {
        _bannerScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0,kScreenWidth,210) delegate:self placeholderImage:[UIImage imageNamed:@"default_graph_3"]];
        _bannerScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _bannerScrollView.autoScrollTimeInterval = 4;
        _bannerScrollView.currentPageDotColor = [UIColor whiteColor];
        _bannerScrollView.pageDotColor = [UIColor lightGrayColor];
        _bannerScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    }
    return _bannerScrollView;
}

- (NSMutableArray *)booksArray{
    if (!_booksArray) {
        _booksArray = [[NSMutableArray alloc] init];
    }
    return _booksArray;
}

-(NSMutableArray *)bannerArray{
    if (!_bannerArray) {
        _bannerArray = [[NSMutableArray alloc] init];
    }
    return _bannerArray;
}

@end
