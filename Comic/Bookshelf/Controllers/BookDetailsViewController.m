//
//  BookDetailsViewController.m
//  Comic
//
//  Created by vision on 2019/11/13.
//  Copyright © 2019 vision. All rights reserved.
//

#import "BookDetailsViewController.h"
#import "CommentsViewController.h"
#import "ReadDetailsViewController.h"
#import "CommentDetailsViewController.h"
#import "DetailHeaderView.h"
#import "SlideMenuView.h"
#import "CommentHeaderView.h"
#import "CommentTableView.h"
#import "SelectionTableView.h"
#import "BookModel.h"
#import "CommentModel.h"
#import "CommentTool.h"
#import "BookSelectionModel.h"
#import <MJRefresh/MJRefresh.h>

@interface BookDetailsViewController ()<UIScrollViewDelegate,DetailHeaderViewDelegate,SlideMenuViewDelegate,SelectionTableViewDelegate,CommentTableViewDelegate>

@property (nonatomic,strong) UIScrollView       *detailsScrollView;
@property (nonatomic,strong) DetailHeaderView   *headerView;
@property (nonatomic,strong) UIButton           *backBtn;       //返回
@property (nonatomic,strong) SlideMenuView      *menuView;      //详情、选集
@property (nonatomic,strong) SlideMenuView      *tempMenuView;
//详情
@property (nonatomic,strong) CommentHeaderView  *infoView;
@property (nonatomic,strong) CommentTableView   *commentTableView;
//选集
@property (nonatomic,strong) SelectionTableView *selectionTableView;

@property (nonatomic,strong) UIView           *bottomView;

@property (nonatomic,strong) BookModel        *bookInfo;
@property (nonatomic,strong) NSNumber         *last_catalogue_id;
@property (nonatomic,strong) NSMutableArray   *myCommentsArray;
@property (nonatomic,strong) NSMutableArray   *selectionsArray;

@property (nonatomic,assign) NSInteger        page;
@property (nonatomic, copy ) NSString         *orderType;
@property (nonatomic,assign) NSInteger        selectIndex;

@end

@implementation BookDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavBar = YES;
    
    self.page = 1;
    self.orderType = @"asc";
    
    [self initBookDetailsView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([ComicManager sharedComicManager].isBookDetailsLoad) {
        [self loadComicInfo];
        [ComicManager sharedComicManager].isBookDetailsLoad = NO;
    }
    if ([ComicManager sharedComicManager].isBookSelectionsLoad) {
        [self loadBookSelectionsData];
        [ComicManager sharedComicManager].isBookSelectionsLoad = NO;
    }
}

#pragma mark 状态栏样式
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark -- Delegate
#pragma mark  SlideMenuViewDelegate
-(void)slideMenuView:(SlideMenuView *)menuView didSelectedWithIndex:(NSInteger)index{
    MyLog(@"didSelectedWithIndex:%ld",(long)index);
    if (menuView==self.menuView) {
        self.tempMenuView.currentIndex = index;
    }else{
        self.menuView.currentIndex = index;
    }
    self.selectIndex = index;
    if (index==0) {
        [self loadComicInfo];
    }else{
        [self loadNewSelectionsListData];
    }
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.detailsScrollView) {
        if (scrollView.contentOffset.y>self.headerView.bottom) {
            self.tempMenuView.hidden = NO;
            self.menuView.hidden = YES;
        }else{
            self.tempMenuView.hidden = YES;
            self.menuView.hidden = NO;
        }
    }
}

#pragma mark DetailHeaderViewDelegate
#pragma mark 加入书架
-(void)detailHeaderViewDidAddToBookShelf{
    if ([ComicManager hasSignIn]) {
        [[HttpRequest sharedInstance] postWithURLString:kAddBookShelfAPI showLoading:YES parameters:@{@"token":kUserTokenValue,@"book_id":self.bookId} success:^(id responseObject) {
            self.bookInfo.state = [NSNumber numberWithBool:YES];
            [ComicManager sharedComicManager].isBookShelfLoad = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToast:@"Telah masuk rak buku" duration:1.0 position:CSToastPositionCenter];
                self.headerView.bookModel = self.bookInfo;
            });
        } failure:^(NSString *errorStr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
            });
        }];
    }else{
        [self presentLoginVC];
    }
}

#pragma mark SelectionTableViewDelegate
#pragma mark 查看详情
-(void)selectionTableViewDidSelectedCellWithModel:(BookSelectionModel *)model{
    ReadDetailsViewController *readDetailsVC = [[ReadDetailsViewController alloc] init];
    readDetailsVC.bookId = self.bookId;
    readDetailsVC.catalogue_id = model.catalogue_id;
    [self.navigationController pushViewController:readDetailsVC animated:YES];
}

#pragma mark 排序
-(void)selectionTableViewSortByOrder:(NSString *)type{
    self.orderType = type;
    self.page = 1;
    [self loadBookSelectionsData];
}

#pragma mark 点赞章节
-(void)selectionTableViewDidClickLikeWithSelectionId:(NSNumber *)selectionId{
    [self setLikeWithRelationId:selectionId type:2];
}

#pragma mark CommentTableViewDelegate
#pragma mark 点赞书本评论
-(void)commentTableViewDidSetLikeWithCommentId:(NSNumber *)commentId{
    [self setLikeWithRelationId:commentId type:3];
}

#pragma mark -- Event response
#pragma mark 开始阅读
-(void)startReadBookAction:(UIButton *)sender{
    if ([self.last_catalogue_id integerValue]<1) {
        return;
    }
    ReadDetailsViewController *readDetailsVC = [[ReadDetailsViewController alloc] init];
    readDetailsVC.bookId = self.bookId;
    readDetailsVC.catalogue_id = self.last_catalogue_id;
    [self.navigationController pushViewController:readDetailsVC animated:YES];
}

#pragma mark 发表评论
-(void)submitCommentAction:(UIButton *)sender{
    CommentsViewController *commentsVC = [[CommentsViewController alloc] init];
    commentsVC.book_id = self.bookId;
    commentsVC.type = 1;
    [self.navigationController pushViewController:commentsVC animated:YES];
}

#pragma mark -- Private Methods
#pragma mark 初始化界面
-(void)initBookDetailsView{
    [self.view addSubview:self.detailsScrollView];
    [self.detailsScrollView addSubview:self.headerView];
    [self.detailsScrollView addSubview:self.backBtn];
    [self.detailsScrollView addSubview:self.menuView];
    [self.view addSubview:self.tempMenuView];
    self.tempMenuView.hidden = YES;
    
    [self.detailsScrollView addSubview:self.infoView];
    [self.detailsScrollView addSubview:self.commentTableView];
    
    [self.detailsScrollView addSubview:self.selectionTableView];
    self.selectionTableView.hidden = self.infoView.hidden = self.commentTableView.hidden = YES;
    
    [self.view addSubview:self.bottomView];
}

#pragma mark 加载漫画信息
-(void)loadComicInfo{
    [[HttpRequest sharedInstance] postWithURLString:kBookDetailsAPI showLoading:YES parameters:@{@"token":kUserTokenValue,@"book_id":self.bookId} success:^(id responseObject) {
        NSDictionary *data = [responseObject objectForKey:@"data"];
        //书籍
        NSDictionary *booksDetailDict = [data valueForKey:@"detail"];
        [self.bookInfo setValues:booksDetailDict];
        
        //上次阅读章节Id
        self.last_catalogue_id = [data valueForKey:@"last_catalogue_id"];
        
        //评论
        NSArray *comments = [data valueForKey:@"comment"];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        CGFloat commentViewHeight = 0.0;
        for (NSDictionary *dict in comments) {
            CommentModel *model = [[CommentModel alloc] init];
            [model setValues:dict];
            [tempArr addObject:model];
            CGFloat height = [CommentTool getCommentCellHeightWithModel:model];
            commentViewHeight += height;
        }
        self.myCommentsArray = tempArr;
        if (self.myCommentsArray.count==0) {
            commentViewHeight = 150;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.detailsScrollView.mj_footer.hidden = YES;
            [self.detailsScrollView.mj_header endRefreshing];
            [self.detailsScrollView.mj_footer endRefreshing];
            
            self.infoView.hidden = self.commentTableView.hidden = NO;
            self.selectionTableView.hidden = YES;
            
            self.headerView.bookModel = self.bookInfo;
            self.infoView.book = self.bookInfo;
            CGFloat introHeight = [self.bookInfo.des boundingRectWithSize:CGSizeMake(kScreenWidth-40, CGFLOAT_MAX) withTextFont:[UIFont regularFontWithSize:13.0f]].height;
            self.infoView.frame = CGRectMake(0, self.menuView.bottom, kScreenWidth, introHeight+205);
            
            self.commentTableView.commentsArray = self.myCommentsArray;
            self.commentTableView.frame = CGRectMake(0, self.infoView.bottom, kScreenWidth, commentViewHeight);
            self.detailsScrollView.contentSize = CGSizeMake(kScreenWidth, self.commentTableView.top+self.commentTableView.height);
            [self.commentTableView reloadData];
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.detailsScrollView.mj_header endRefreshing];
            [self.detailsScrollView.mj_footer endRefreshing];
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark 加载最新选集
-(void)loadNewSelectionsListData{
    if (self.selectIndex==0) {
        [self loadComicInfo];
    }else{
        self.page = 1;
        [self loadBookSelectionsData];
    }
    
}

#pragma mark 加载更多选集
-(void)loadMoreSelectionsListData{
    self.page ++;
    [self loadBookSelectionsData];
}

#pragma mark 加载选集
-(void)loadBookSelectionsData{
    NSDictionary *params = @{@"token":kUserTokenValue,@"book_id":self.bookId,@"orderby":kIsEmptyString(self.orderType)?@"asc":self.orderType ,@"page":[NSNumber numberWithInteger:self.page],@"pagesize":@20};
    [[HttpRequest sharedInstance] postWithURLString:kBookSelectionAPI showLoading:YES parameters:params success:^(id responseObject) {
        NSDictionary  *data = [responseObject objectForKey:@"data"];
        //上次阅读章节Id
        self.last_catalogue_id = [data valueForKey:@"last_catalogue_id"];
        NSInteger vip_cost = [[data valueForKey:@"vip_cost"] integerValue];
        
        //章节数组
        NSArray *selectionsArr = [data valueForKey:@"anthology"];
        NSMutableArray *tempSelectionsArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in selectionsArr) {
            BookSelectionModel *model = [[BookSelectionModel alloc] init];
            [model setValues:dict];
            [tempSelectionsArr addObject:model];
        }
        if (self.page==1) {
            self.selectionsArray = tempSelectionsArr;
        }else{
            [self.selectionsArray addObjectsFromArray:tempSelectionsArr];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.infoView.hidden = self.commentTableView.hidden = YES;
            self.selectionTableView.hidden = NO;
            
            self.detailsScrollView.mj_footer.hidden = tempSelectionsArr.count<20;
            [self.detailsScrollView.mj_header endRefreshing];
            [self.detailsScrollView.mj_footer endRefreshing];
            self.selectionTableView.vipCost = vip_cost;
            self.selectionTableView.selectionsArray = self.selectionsArray;
            self.selectionTableView.frame = CGRectMake(0, self.menuView.bottom, kScreenWidth, self.selectionsArray.count*100+50);
            self.detailsScrollView.contentSize = CGSizeMake(kScreenWidth, self.selectionTableView.top+self.selectionTableView.height);
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.selectionTableView.mj_header endRefreshing];
            [self.selectionTableView.mj_footer endRefreshing];
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark 点赞
//relationId  书本id 章节id 书本主评论id 章节评论id 评论的评论id
// type 1点赞书本 2点赞章节 3点赞书本评论 4点赞章节评论 5点赞评论的回复
-(void)setLikeWithRelationId:(NSNumber *)relationId type:(NSInteger)type{
    NSDictionary *params = @{@"token":kUserTokenValue,@"relation_id":relationId,@"type":[NSNumber numberWithInteger:type]};
    [[HttpRequest sharedInstance] postWithURLString:kSetLikeBookAPI showLoading:NO parameters:params success:^(id responseObject) {
         
    } failure:^(NSString *errorStr) {
        
    }];
}

#pragma mark -- Setters
-(void)setCurrentIndex:(NSInteger)currentIndex{
    MyLog(@"setCurrentIndex:%ld",(long)currentIndex);
    _currentIndex = currentIndex;
    self.menuView.currentIndex = currentIndex;
    self.tempMenuView.currentIndex = currentIndex;
    if (currentIndex==0) {
        [self loadComicInfo];
    }else{
        [self loadBookSelectionsData];
    }
}

#pragma mark -- Getters
#pragma mark 根滚动视图
-(UIScrollView *)detailsScrollView{
    if (!_detailsScrollView) {
        _detailsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-58)];
        _detailsScrollView.delegate = self;
        
        if (@available(iOS 11.0, *)) {
            _detailsScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        //  下拉加载最新
       MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewSelectionsListData)];
       header.automaticallyChangeAlpha=YES;
       header.lastUpdatedTimeLabel.hidden=YES;
       _detailsScrollView.mj_header=header;
       
       MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSelectionsListData)];
       footer.automaticallyRefresh = NO;
       _detailsScrollView.mj_footer = footer;
       footer.hidden=YES;
    }
    return _detailsScrollView;
}

#pragma mark 头部视图
-(DetailHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[DetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 210)];
        _headerView.delegate = self;
    }
    return _headerView;
}

#pragma mark 返回
-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn=[[UIButton alloc] initWithFrame:CGRectMake(5,KStatusHeight + 2, 40, 40)];
        [_backBtn setImage:[UIImage drawImageWithName:@"return_black"size:CGSizeMake(12, 18)] forState:UIControlStateNormal];
        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-10.0, 0, 0)];
        [_backBtn addTarget:self action:@selector(leftNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

#pragma mark 详情或选择
-(SlideMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[SlideMenuView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, kScreenWidth, 40) btnTitleFont:[UIFont regularFontWithSize:18.0f] color:[UIColor colorWithHexString:@"#9B9B9B"] selColor:[UIColor commonColor_black]];
        _menuView.backgroundColor = [UIColor whiteColor];
        _menuView.selectTitleFont = [UIFont mediumFontWithSize:18.0f];
        _menuView.lineWidth = 16.0;
        _menuView.myTitleArray =[NSMutableArray arrayWithArray:@[@"Detail",@"Pilih Episode"]];
        _menuView.currentIndex = 0;
        _menuView.delegate = self;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, kScreenWidth, 1.0)];
        line.backgroundColor = [UIColor colorWithHexString:@"#EAEBF0"];
        [_menuView addSubview:line];
    }
    return _menuView;
}

#pragma mark
-(SlideMenuView *)tempMenuView{
    if (!_tempMenuView) {
        _tempMenuView = [[SlideMenuView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,40) btnTitleFont:[UIFont regularFontWithSize:18.0f] color:[UIColor colorWithHexString:@"#9B9B9B"] selColor:[UIColor commonColor_black]];
        _tempMenuView.backgroundColor = [UIColor whiteColor];
        _tempMenuView.selectTitleFont = [UIFont mediumFontWithSize:18.0f];
        _tempMenuView.lineWidth = 16.0;
        _tempMenuView.myTitleArray =[NSMutableArray arrayWithArray:@[@"Detail",@"Pilih Episode"]];
        _tempMenuView.currentIndex = 0;
        _tempMenuView.delegate = self;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, kScreenWidth, 1.0)];
        line.backgroundColor = [UIColor colorWithHexString:@"#EAEBF0"];
        [_tempMenuView addSubview:line];
    }
    return _tempMenuView;
}

#pragma mark 漫画信息
-(CommentHeaderView *)infoView{
    if (!_infoView) {
        _infoView = [[CommentHeaderView alloc] initWithFrame:CGRectMake(0, self.menuView.bottom, kScreenWidth, 160)];
        [_infoView.commentBtn addTarget:self action:@selector(submitCommentAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _infoView;
}

#pragma mark 评论列表
-(CommentTableView *)commentTableView{
    if (!_commentTableView) {
        _commentTableView = [[CommentTableView alloc] initWithFrame:CGRectMake(0, self.infoView.bottom, kScreenWidth, 200) style:UITableViewStylePlain];
        _commentTableView.scrollEnabled = NO;
        _commentTableView.viewDelegate = self;
    }
    return _commentTableView;
}

#pragma mark 选集
-(SelectionTableView *)selectionTableView{
    if (!_selectionTableView) {
        _selectionTableView = [[SelectionTableView alloc] initWithFrame:CGRectMake(0, self.menuView.bottom, kScreenWidth, kScreenHeight-self.menuView.bottom-60) style:UITableViewStylePlain];
        _selectionTableView.viewDelegate = self;
    }
    return _selectionTableView;
}


#pragma mark 底部视图
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenHeight-58, kScreenWidth, 58)];
        
        UIButton *readBtn = [[UIButton alloc] initWithFrame:CGRectMake(35, 5, kScreenWidth-70, 40)];
        [readBtn setTitle:@"Mulai membaca" forState:UIControlStateNormal];
        [readBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        readBtn.backgroundColor = [UIColor bm_colorGradientChangeWithSize:readBtn.size direction:IHGradientChangeDirectionLevel startColor:[UIColor colorWithHexString:@"#C66CFF"] endColor:[UIColor colorWithHexString:@"#636FFF"]];
        readBtn.titleLabel.font = [UIFont mediumFontWithSize:16.0f];
        [readBtn setBorderWithCornerRadius:8 type:UIViewCornerTypeAll];
        [readBtn addTarget:self action:@selector(startReadBookAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:readBtn];
    }
    return _bottomView;
}

-(BookModel *)bookInfo{
    if (!_bookInfo) {
        _bookInfo = [[BookModel alloc] init];
    }
    return _bookInfo;
}

-(NSMutableArray *)myCommentsArray{
    if (!_myCommentsArray) {
        _myCommentsArray = [[NSMutableArray alloc] init];
    }
    return _myCommentsArray;
}

-(NSMutableArray *)selectionsArray{
    if (!_selectionsArray) {
        _selectionsArray = [[NSMutableArray alloc] init];
    }
    return _selectionsArray;
}


@end
