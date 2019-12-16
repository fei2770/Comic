//
//  ReadRecordsViewController.m
//  Comic
//
//  Created by vision on 2019/11/15.
//  Copyright © 2019 vision. All rights reserved.
//

#import "ReadRecordsViewController.h"
#import "ReadDetailsViewController.h"
#import "ReadRecordTableViewCell.h"
#import "BookRecordModel.h"
#import "BlankView.h"
#import <MJRefresh/MJRefresh.h>

@interface ReadRecordsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIButton    *deleteBtn;
}

@property (nonatomic,strong) UITableView *recordTableView;
@property (nonatomic,strong) UIView      *bottomView;
@property (nonatomic,strong) BlankView   *blankView;

@property (nonatomic,assign) NSInteger  page;

@property (nonatomic,strong) NSMutableArray  *datesArray;
@property (nonatomic,strong) NSMutableArray  *recordsArray;



@end

@implementation ReadRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"Riwayat penjelajahan";
    self.rigthTitleName = @"Edit";
    
    self.page = 1;
    
    [self.view addSubview:self.recordTableView];
    [self.recordTableView addSubview:self.blankView];
    self.blankView.hidden = YES;
    
    [self loadReadRecordsData];
}

#pragma mark UITableViewDataSource and UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datesArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *timeStr = self.datesArray[section];
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (BookRecordModel *recordModel in self.recordsArray) {
        NSString *recordTime = [[ComicManager sharedComicManager] timeWithTimeIntervalNumber:recordModel.create_time format:@"yyyy-MM-dd"];
        if ([recordTime isEqualToString:timeStr]) {
            [tempArr addObject:recordModel];
        }
    }
    return tempArr.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.datesArray.count>0) {
        return self.datesArray[section];
    }else{
        return nil;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ReadRecordTableViewCell";
    ReadRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[ReadRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.multipleSelectionBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    cell.multipleSelectionBackgroundView.backgroundColor = [UIColor clearColor];
    
    NSString *timeStr = self.datesArray[indexPath.section];
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (BookRecordModel *recordModel in self.recordsArray) {
        NSString *recordTime = [[ComicManager sharedComicManager] timeWithTimeIntervalNumber:recordModel.create_time format:@"yyyy-MM-dd"];
        if ([recordTime isEqualToString:timeStr]) {
            [tempArr addObject:recordModel];
        }
    }
    BookRecordModel *model = tempArr[indexPath.row];
    [cell reloadCellWithObject:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.isEditing) {
        return;
    }
    NSString *timeStr = self.datesArray[indexPath.section];
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (BookRecordModel *recordModel in self.recordsArray) {
        NSString *recordTime = [[ComicManager sharedComicManager] timeWithTimeIntervalNumber:recordModel.create_time format:@"yyyy-MM-dd"];
        if ([recordTime isEqualToString:timeStr]) {
            [tempArr addObject:recordModel];
        }
    }
    BookRecordModel *model = tempArr[indexPath.row];
    ReadDetailsViewController *readDetailsVC = [[ReadDetailsViewController alloc] init];
    readDetailsVC.bookId = model.book_id;
    readDetailsVC.catalogue_id = model.catalogue_id;
    [self.navigationController pushViewController:readDetailsVC animated:YES];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


#pragma mark -- Event response
#pragma mark 编辑
-(void)rightNavigationItemAction{
    if (self.recordsArray.count==0) {
        return;
    }
    
    if ([self.rigthTitleName isEqualToString:@"Batal"]) {
        self.rigthTitleName = @"Edit";
        [self.recordTableView setEditing:NO animated:YES];
        
        CGRect tableFrame = self.recordTableView.frame;
        tableFrame.size.height = kScreenHeight-kNavHeight;
        self.recordTableView.frame = tableFrame;
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect bottomRect = self.bottomView.frame;
            bottomRect.origin.y = kScreenHeight;
            self.bottomView.frame = bottomRect;
        } completion:^(BOOL finished) {
            [self.bottomView removeFromSuperview];
        }];
    }else{
        self.rigthTitleName = @"Batal";
        
        [self.recordTableView setEditing:YES animated:YES];
        
        CGRect tableFrame = self.recordTableView.frame;
        tableFrame.size.height = kScreenHeight-kNavHeight-52;
        self.recordTableView.frame = tableFrame;
        
        [self.view addSubview:self.bottomView];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect bottomRect = self.bottomView.frame;
            bottomRect.origin.y = kScreenHeight-52;
            self.bottomView.frame = bottomRect;
        }];
    }
}

#pragma mark 删除
-(void)deleteReadRecordsDataAction:(UIButton *)sender{
    NSArray *indexPathsArr = [self.recordTableView indexPathsForSelectedRows];
    MyLog(@"indexPaths:%@",indexPathsArr);
    if (indexPathsArr.count==0) {
        return;
    }
    NSMutableArray *selRecordsArray = [[NSMutableArray alloc] init];
    NSMutableArray *selBookIdsArray = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in indexPathsArr) {
        NSString *timeStr = self.datesArray[indexPath.section];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (BookRecordModel *recordModel in self.recordsArray) {
            NSString *recordTime = [[ComicManager sharedComicManager] timeWithTimeIntervalNumber:recordModel.create_time format:@"yyyy-MM-dd"];
            if ([recordTime isEqualToString:timeStr]) {
                [tempArr addObject:recordModel];
            }
        }
        BookRecordModel *model = tempArr[indexPath.row];
        [selRecordsArray addObject:model];
        [selBookIdsArray addObject:model.book_id];
    }
    NSString *idsJson = [[ComicManager sharedComicManager] getValueWithParams:selBookIdsArray];
    [[HttpRequest sharedInstance] postWithURLString:kDelReadHistoryAPI showLoading:YES parameters:@{@"token":kUserTokenValue,@"history_ids":idsJson} success:^(id responseObject) {
        [self.recordsArray removeObjectsInArray:selRecordsArray];
        [ComicManager sharedComicManager].isBookShelfLoad = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.recordTableView deleteRowsAtIndexPaths:indexPathsArr withRowAnimation:UITableViewRowAnimationFade];
            if (self.recordsArray.count==0) { //清空
                [self rightNavigationItemAction];
                self.blankView.hidden = NO;
            }
            [self.recordTableView reloadData];
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}


#pragma mark -- Private methods
#pragma mark 加载阅读记录
-(void)loadReadRecordsData{
    [[HttpRequest sharedInstance] postWithURLString:kReadHistoryAPI showLoading:YES parameters:@{@"token":kUserTokenValue,@"page":[NSNumber numberWithInteger:self.page],@"pagesize":@20} success:^(id responseObject) {
        NSArray *data = [responseObject objectForKey:@"data"];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        NSMutableArray *tempTimeArr=[[NSMutableArray alloc] init];
        for (NSDictionary *dict in data) {
            BookRecordModel *model = [[BookRecordModel alloc] init];
            [model setValues:dict];
            NSString *timeStr = [[ComicManager sharedComicManager] timeWithTimeIntervalNumber:model.create_time format:@"yyyy-MM-dd"];
            [tempTimeArr addObject:timeStr];
            [tempArr addObject:model];
        }
        if (self.page==1) {
            self.recordsArray = tempArr;
            self.datesArray = tempTimeArr;
        }else{
            [self.recordsArray addObjectsFromArray:tempArr];
            [self.datesArray addObjectsFromArray:tempTimeArr];
        }
        //时间去重
        NSSet *set = [NSSet setWithArray:self.datesArray]; //去重
        NSArray *timesArr=[set allObjects];
        timesArr=[timesArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj2 compare:obj1]; //降序
        }];
        self.datesArray = [NSMutableArray arrayWithArray:timesArr];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.recordTableView.mj_footer.hidden = tempArr.count<20;
            self.blankView.hidden = self.recordsArray.count>0;
            [self.recordTableView.mj_header endRefreshing];
            [self.recordTableView.mj_footer endRefreshing];
            [self.recordTableView reloadData];
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.recordTableView.mj_header endRefreshing];
            [self.recordTableView.mj_footer endRefreshing];
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark 最新
-(void)loadNewReadRecordsListData{
    self.page = 1;
    [self loadReadRecordsData];
}

#pragma mark 更多
-(void)loadMoreReadRecordsListData{
    self.page ++;
    [self loadReadRecordsData];
}

#pragma mark -- Getters
#pragma mark 阅读记录
-(UITableView *)recordTableView{
    if (!_recordTableView) {
        _recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight) style:UITableViewStyleGrouped];
        _recordTableView.dataSource = self;
        _recordTableView.delegate = self;
        _recordTableView.showsVerticalScrollIndicator = NO;
        _recordTableView.estimatedSectionFooterHeight = 0;
        _recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //  下拉加载最新
        MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewReadRecordsListData)];
        header.automaticallyChangeAlpha=YES;
        header.lastUpdatedTimeLabel.hidden=YES;
        _recordTableView.mj_header=header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreReadRecordsListData)];
        footer.automaticallyRefresh = NO;
        _recordTableView.mj_footer = footer;
        footer.hidden=YES;
    }
    return _recordTableView;
}

#pragma mark 底部视图
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 52)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 42)];
        [deleteBtn setTitle:@"Hapus" forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor colorWithHexString:@"#FF9100"] forState:UIControlStateNormal];
        deleteBtn.titleLabel.font = [UIFont mediumFontWithSize:16];
        [deleteBtn addTarget:self action:@selector(deleteReadRecordsDataAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:deleteBtn];
    }
    return _bottomView;
}

#pragma mark 空白页
-(BlankView *)blankView{
    if (!_blankView) {
        _blankView = [[BlankView alloc] initWithFrame:CGRectMake(0,60, kScreenWidth, 200) img:@"default_page_history" msg:@"Sementara tidak ada riwayat pencarian"];
    }
    return _blankView;
}

-(NSMutableArray *)datesArray{
    if (!_datesArray) {
        _datesArray = [[NSMutableArray alloc] init];
    }
    return _datesArray;
}

-(NSMutableArray *)recordsArray{
    if (!_recordsArray) {
        _recordsArray = [[NSMutableArray alloc] init];
    }
    return _recordsArray;
}

@end
