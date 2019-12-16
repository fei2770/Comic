//
//  BookShelfViewController.m
//  Comic
//
//  Created by vision on 2019/11/13.
//  Copyright © 2019 vision. All rights reserved.
//

#import "BookShelfViewController.h"
#import "MemberCenterViewController.h"
#import "ReadDetailsViewController.h"
#import "BookDetailsViewController.h"
#import "ReadRecordsViewController.h"
#import "EditBookShelfViewController.h"
#import "ReadRecordsView.h"
#import "BookShelfCollectionView.h"
#import "FooterRecommandView.h"
#import "CustomButton.h"
#import "LoginBlankView.h"
#import "BookRecordModel.h"
#import "ShelfBookModel.h"
#import <MJRefresh/MJRefresh.h>

#define kImageW  (kScreenWidth-50)/2.0
#define kCellImageW (kScreenWidth-2*20-2*16)/3.0

@interface BookShelfViewController ()<UISearchBarDelegate,FooterRecommandViewDelegate,BookShelfCollectionViewDelegate>

@property (nonatomic,strong) UILabel                   *titleLab;
@property (nonatomic,strong) UIScrollView              *rootScrollView;
@property (nonatomic,strong) UIImageView               *headBgImgView;
@property (nonatomic,strong) CustomButton              *userCenterBtn;
@property (nonatomic,strong) ReadRecordsView           *recordView;
@property (nonatomic,strong) UIView                    *shelfBgView;
@property (nonatomic,strong) BookShelfCollectionView   *bookShelfView;
@property (nonatomic,strong) UIView                    *lineView;
@property (nonatomic,strong) FooterRecommandView       *recommandView;

@property (nonatomic,strong) LoginBlankView            *loginView;

@property (nonatomic,strong) BookRecordModel        *recordModel;
@property (nonatomic,strong) NSMutableArray         *shelfBooksArray;

@end

@implementation BookShelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenBackBtn = YES;
    
    [self initBookShelfView];
    [self loadReadRecordsData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([ComicManager sharedComicManager].isBookShelfLoad) {
        [self loadReadRecordsData];
        [ComicManager sharedComicManager].isBookShelfLoad = NO;
    }
}

#pragma mark 状态栏样式
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Delegate
#pragma mark BookShelfCollectionViewDelegate
#pragma mark 选择书
-(void)bookShelfCollectionViewDidSelectBook:(ShelfBookModel *)book{
    ReadDetailsViewController *readDetailsVC = [[ReadDetailsViewController alloc] init];
    readDetailsVC.bookId = book.book_id;
    readDetailsVC.catalogue_id = book.catalogue_id;
    [self.navigationController pushViewController:readDetailsVC animated:YES];
}

#pragma mark 查看更多书
-(void)bookShelfCollectionViewGetMoreBooks{
    self.tabBarController.selectedIndex = 0;
}

#pragma mark 长按
-(void)bookShelfCollectionViewLongPressGesutre{
    EditBookShelfViewController *editBookShelfVC = [[EditBookShelfViewController alloc] init];
    editBookShelfVC.myBooksArray = self.shelfBooksArray;
    [self.navigationController pushViewController:editBookShelfVC animated:YES];
}

#pragma mark FooterRecommandViewDelegate
#pragma mark 查看书详情
-(void)footerRecommandViewDidSelectedBook:(FooterBookModel *)bookModel{
    BookDetailsViewController *bookDetailsVC = [[BookDetailsViewController alloc] init];
    bookDetailsVC.bookId = bookModel.book_id;
    bookDetailsVC.currentIndex = 0;
    [self.navigationController pushViewController:bookDetailsVC animated:YES];
}

#pragma mark -- Event response
#pragma mark 会员中心
-(void)gotoUserCenterAction:(UIButton *)sender{
    if ([ComicManager hasSignIn]) {
        MemberCenterViewController *memberCenterVC = [[MemberCenterViewController alloc] init];
        [self.navigationController pushViewController:memberCenterVC animated:YES];
    }else{
        [self presentLoginVC];
    }
}

#pragma mark 继续阅读
-(void)continueReadComicAction:(UIButton *)sender{
    ReadDetailsViewController *readDetailsVC = [[ReadDetailsViewController alloc] init];
    readDetailsVC.bookId = self.recordModel.book_id;
    readDetailsVC.catalogue_id = self.recordModel.catalogue_id;
    [self.navigationController pushViewController:readDetailsVC animated:YES];
}

#pragma mark 查看阅读记录
-(void)checkReadRecordsAction:(UIButton *)sender{
    ReadRecordsViewController *readRecordsVC = [[ReadRecordsViewController alloc] init];
    [self.navigationController pushViewController:readRecordsVC animated:YES];
}

#pragma mark -- Private Methods
#pragma mark 初始化
-(void)initBookShelfView{
    [self.view addSubview:self.rootScrollView];
    [self.rootScrollView addSubview:self.headBgImgView];
    [self.rootScrollView addSubview:self.recordView];
    [self.rootScrollView addSubview:self.shelfBgView];
    [self.rootScrollView addSubview:self.bookShelfView];
    [self.rootScrollView addSubview:self.lineView];
    [self.rootScrollView addSubview:self.recommandView];
    [self.rootScrollView addSubview:self.loginView];
    self.recordView.hidden = self.recommandView.hidden = self.bookShelfView.hidden = self.lineView.hidden = self.loginView.hidden = YES;
    
    [self.view addSubview:self.titleLab];
    [self.view addSubview:self.userCenterBtn];
}

#pragma mark 加载数据
-(void)loadReadRecordsData{
    [[HttpRequest sharedInstance] postWithURLString:kBookShelfAPI showLoading:YES parameters:@{@"token":kUserTokenValue} success:^(id responseObject) {
        NSDictionary *data = [responseObject objectForKey:@"data"];
        //阅读记录
        NSDictionary *readDict = [data valueForKey:@"last_read"];
        self.recordModel = [[BookRecordModel alloc] init];
        [self.recordModel setValues:readDict];
        //书架书籍
        NSArray *books = [data valueForKey:@"bookrack"];
        NSMutableArray *booksArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in books) {
            ShelfBookModel *model = [[ShelfBookModel alloc] init];
            [model setValues:dict];
            [booksArr addObject:model];
        }
        self.shelfBooksArray = booksArr;
        
        //推荐书籍
        NSMutableArray *footerBooksArr = [ComicManager sharedComicManager].recommandBooksArray;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.rootScrollView.mj_header endRefreshing];
            CGFloat originY = 0.0;
            if ([self.recordModel.book_id integerValue]>0) {
                self.recordView.hidden = NO;
                self.recordView.recordModel = self.recordModel;
                self.recordView.frame = CGRectMake(0, self.userCenterBtn.bottom-15, kScreenWidth, 110);
                originY = self.recordView.bottom+10;
            }else{
                self.recordView.hidden = YES;
                originY = self.userCenterBtn.bottom;
            }
            
            if ([ComicManager hasSignIn]) {
                self.bookShelfView.hidden = NO;
                self.loginView.hidden = YES;
                self.bookShelfView.booksArray = self.shelfBooksArray;
                self.bookShelfView.frame = CGRectMake(10, originY+20, kScreenWidth-10,self.shelfBooksArray.count>0?(self.shelfBooksArray.count/2+1)*(kImageW+130):kImageW+20);
                self.shelfBgView.frame = CGRectMake(0, originY, kScreenWidth,self.bookShelfView.height+20);
            }else{
                self.bookShelfView.hidden = YES;
                self.loginView.hidden = NO;
                self.loginView.frame = CGRectMake(10, originY+20, kScreenWidth-10,260);
                self.shelfBgView.frame = CGRectMake(0, originY, kScreenWidth,self.loginView.height+20);
            }
            [self.shelfBgView setBorderWithCornerRadius:8.0 type:UIViewCornerTypeTop];
            
            if (footerBooksArr.count>0) {
                self.recommandView.hidden = self.lineView.hidden = NO;
                self.lineView.frame = CGRectMake(0, self.shelfBgView.bottom, kScreenWidth, 10);
                self.recommandView.booksArray = footerBooksArr;
                self.recommandView.frame = CGRectMake(0, self.lineView.bottom, kScreenWidth,220);
                self.rootScrollView.contentSize = CGSizeMake(kScreenWidth, self.recommandView.top+self.recommandView.height);
            }else{
                self.lineView.frame = CGRectMake(0, self.shelfBgView.bottom, kScreenWidth, 0);
                self.recommandView.hidden = self.lineView.hidden = YES;
                self.recommandView.frame = CGRectMake(0, self.lineView.bottom, kScreenWidth,0);
                self.rootScrollView.contentSize = CGSizeMake(kScreenWidth, self.shelfBgView.top+self.shelfBgView.height);
            }
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.rootScrollView.mj_header endRefreshing];
           [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
       });
    }];
}


#pragma mark -- Getters
#pragma mark -- 根滚动视图
-(UIScrollView *)rootScrollView{
    if (!_rootScrollView) {
        _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabHeight)];
        if (@available(iOS 11.0, *)) {
            _rootScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        //  下拉加载最新
        MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadReadRecordsData)];
        header.automaticallyChangeAlpha=YES;
        header.lastUpdatedTimeLabel.hidden=YES;
        _rootScrollView.mj_header=header;
    }
    return _rootScrollView;
}

#pragma mark 标题
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab =[[UILabel alloc] initWithFrame:CGRectMake(60, KStatusHeight+12,kScreenWidth-120, 22)];
        _titleLab.textColor=[UIColor whiteColor];
        _titleLab.font=[UIFont mediumFontWithSize:18];
        _titleLab.textAlignment=NSTextAlignmentCenter;
        _titleLab.text = @"Rak buku";
    }
    return _titleLab;
}

#pragma mark 会员中心
-(CustomButton *)userCenterBtn{
    if (!_userCenterBtn) {
        _userCenterBtn = [[CustomButton alloc] initWithFrame:CGRectMake(kScreenWidth-45, KStatusHeight+12, 40, 40) imgSize:CGSizeMake(20, 17)];
        _userCenterBtn.imgName = @"bookshelf_member_center";
        [_userCenterBtn addTarget:self action:@selector(gotoUserCenterAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userCenterBtn;
}

#pragma mark 头部背景
-(UIImageView *)headBgImgView{
    if (!_headBgImgView) {
        _headBgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 205)];
        _headBgImgView.image = [UIImage imageNamed:@"bookshelf_background"];
    }
    return _headBgImgView;
}

#pragma mark 阅读记录
-(ReadRecordsView *)recordView{
    if (!_recordView) {
        _recordView = [[ReadRecordsView alloc] initWithFrame:CGRectZero];
        [_recordView.contineBtn addTarget:self action:@selector(continueReadComicAction:) forControlEvents:UIControlEventTouchUpInside];
        [_recordView.recordBtn addTarget:self action:@selector(checkReadRecordsAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordView;
}

#pragma mark 书架背景
-(UIView *)shelfBgView{
    if (!_shelfBgView) {
        _shelfBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.userCenterBtn.bottom, kScreenWidth,kScreenHeight-self.userCenterBtn.bottom)];
        _shelfBgView.backgroundColor = [UIColor whiteColor];
        [_shelfBgView setBorderWithCornerRadius:8.0 type:UIViewCornerTypeTop];
    }
    return _shelfBgView;
}

#pragma mark 书架
-(BookShelfCollectionView *)bookShelfView{
    if (!_bookShelfView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(kImageW, kImageW+130);
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 20);
        
        _bookShelfView = [[BookShelfCollectionView alloc] initWithFrame:CGRectMake(10,self.shelfBgView.top+20, kScreenWidth-10,kImageW+20) collectionViewLayout:layout];
        _bookShelfView.backgroundColor = [UIColor whiteColor];
        _bookShelfView.viewDeletage = self;
    }
    return _bookShelfView;
}

#pragma mark 登录
-(LoginBlankView *)loginView{
    if (!_loginView) {
        _loginView = [[LoginBlankView alloc] initWithFrame:CGRectMake(0,self.shelfBgView.top+20, kScreenWidth, 260)];
        kSelfWeak;
        _loginView.loginBlock = ^{
            [weakSelf presentLoginVC];
        };
    }
    return _loginView;
}

#pragma mark 线条
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bookShelfView.bottom, kScreenWidth, 10)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#F6F6FA"];
    }
    return _lineView;
}

#pragma mark 推荐
-(FooterRecommandView *)recommandView{
    if (!_recommandView) {
        _recommandView = [[FooterRecommandView alloc] initWithFrame:CGRectMake(0, self.lineView.bottom, kScreenWidth, 220) isRecommanded:YES];
        _recommandView.delegate = self;
    }
    return _recommandView;
}

-(NSMutableArray *)shelfBooksArray{
    if (!_shelfBooksArray) {
        _shelfBooksArray = [[NSMutableArray alloc] init];
    }
    return _shelfBooksArray;
}

@end
