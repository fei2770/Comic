//
//  CheckInViewController.m
//  Comic
//
//  Created by vision on 2019/11/15.
//  Copyright © 2019 vision. All rights reserved.
//

#import "CheckInViewController.h"
#import "BookDetailsViewController.h"
#import "TaskTableViewCell.h"
#import "FooterRecommandView.h"
#import "CheckDayView.h"
#import "TaskModel.h"
#import "FooterBookModel.h"
#import "SignModel.h"

#define kCellImageW (kScreenWidth-2*20-2*16)/3.0

@interface CheckInViewController ()<UITableViewDelegate,UITableViewDataSource,FooterRecommandViewDelegate>

@property (nonatomic,strong) UIView       *narbarView;
@property (nonatomic,strong) UIScrollView *rootScrollView;
@property (nonatomic,strong) UIImageView  *bgImgView;
@property (nonatomic,strong) UIButton     *receiveBtn; //领取
@property (nonatomic,strong) UILabel      *beansCountLab;
@property (nonatomic,strong) UILabel      *beansTitlelab;
@property (nonatomic,strong) UILabel      *checkDaysLab; //签到天数
@property (nonatomic,strong) UIView       *daysView;
@property (nonatomic,strong) UITableView  *checkTableView;
@property (nonatomic,strong) UIView       *lineView;
@property (nonatomic,strong) FooterRecommandView *recommandView;

@property (nonatomic,assign) NSInteger       checkDays;
@property (nonatomic,strong) NSMutableArray  *checkDayViewsArray;
@property (nonatomic,strong) NSMutableArray  *taskArray;
@property (nonatomic, copy ) NSArray         *signArr;
@property (nonatomic,assign) NSInteger       myKoin;

@end

@implementation CheckInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavBar = YES;
    
    [self initCheckInView];
    [self loadCheckTasksData];
}

#pragma mark 状态栏样式
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark UITableViewDataSource and UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.taskArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 48)];
    aView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(22, 25, kScreenWidth-40, 18)];
    titleLab.textColor = [UIColor commonColor_black];
    titleLab.font = [UIFont mediumFontWithSize:16.0f];
    titleLab.text = @"Lakukan tugasnya dan ambil poinnya";
    [aView addSubview:titleLab];
    
    return aView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskTableViewCell *cell = [[TaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    TaskModel *model = self.taskArray[indexPath.row];
    cell.taskModel = model;
    
    cell.receiveBtn.tag = indexPath.row;
    [cell.receiveBtn addTarget:self action:@selector(receiveTaskAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 48;
}

#pragma mark FooterRecommandViewDelegate
-(void)footerRecommandViewDidSelectedBook:(FooterBookModel *)bookModel{
    BookDetailsViewController *detailsVC = [[BookDetailsViewController alloc] init];
    detailsVC.bookId = bookModel.book_id;
    detailsVC.currentIndex = 0;
    [self.navigationController pushViewController:detailsVC animated:YES];
}

#pragma mark -- Event response
#pragma mark  签到
-(void)checkinForReceivingKoinAction:(UIButton *)sender{
    
    NSDictionary *signDict;
    if (self.checkDays==7) {
        signDict = [self.signArr objectAtIndex:0];
    }else{
        signDict = [self.signArr objectAtIndex:self.checkDays];
    }
    NSNumber *bean = signDict[@"bean"];
    [[HttpRequest sharedInstance] postWithURLString:kCheckInAPI showLoading:YES parameters:@{@"token":kUserTokenValue,@"bean":bean} success:^(id responseObject) {
        [ComicManager sharedComicManager].isMineReload = YES;
        self.myKoin += [bean integerValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.receiveBtn.hidden = YES;
            self.beansCountLab.hidden = self.beansTitlelab.hidden = NO;
            self.beansCountLab.text = [NSString stringWithFormat:@"%ld",(long)self.myKoin];
            
            CheckDayView *dayView = (CheckDayView *)[self.daysView viewWithTag:self.checkDays+1];
            dayView.is_received = YES;
            [self.view makeToast:@"Berhasil masuk" duration:1.0 position:CSToastPositionCenter];
        });
        
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark 领取任务
-(void)receiveTaskAction:(UIButton *)sender{
    TaskModel *model = self.taskArray[sender.tag];
    [[HttpRequest sharedInstance] postWithURLString:kReceiveTaskAPI showLoading:YES parameters:@{@"token":kUserTokenValue,@"quest_id":model.quest_id} success:^(id responseObject) {
        [ComicManager sharedComicManager].isMineReload = YES;
        NSInteger koin = 0;
        for (TaskModel *task in self.taskArray) {
            if ([task.quest_id integerValue]==[model.quest_id integerValue]) {
                task.status = [NSNumber numberWithInt:3];
                koin = [task.bean integerValue];
                break;
            }
        }
        self.myKoin += koin;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.beansCountLab.text = [NSString stringWithFormat:@"%ld",self.myKoin];
            [self.checkTableView reloadData];
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark -- Private methods
#pragma mark 初始化
-(void)initCheckInView{
    [self.view addSubview:self.rootScrollView];
    [self.rootScrollView addSubview:self.bgImgView];
    [self.rootScrollView addSubview:self.receiveBtn];
    [self.rootScrollView addSubview:self.beansCountLab];
    [self.rootScrollView addSubview:self.beansTitlelab];
    [self.rootScrollView addSubview:self.checkDaysLab];
    [self.rootScrollView addSubview:self.daysView];
    [self.rootScrollView addSubview:self.checkTableView];
    [self.rootScrollView addSubview:self.lineView];
    [self.rootScrollView addSubview:self.recommandView];
    
    self.beansCountLab.hidden =  self.beansTitlelab.hidden = self.lineView.hidden = self.recommandView.hidden = YES;
    
    [self.view addSubview:self.narbarView];
}

#pragma mark 加载任务信息
-(void)loadCheckTasksData{
    [[HttpRequest sharedInstance] postWithURLString:kCheckInPageAPI showLoading:YES parameters:@{@"token":kUserTokenValue} success:^(id responseObject) {
        NSDictionary *data = [responseObject objectForKey:@"data"];
        //我的金币数
        self.myKoin = [[data valueForKey:@"bean"] integerValue];
        
        BOOL checked = [[data valueForKey:@"user_today_sign"] boolValue];
        
        //连续签到天数
        self.checkDays = [[data valueForKey:@"continuous_day"] integerValue];
        //签到内容
        self.signArr = [data valueForKey:@"sign"];
        
        //任务列表
        NSArray *taskArr = [data valueForKey:@"quest"];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        NSArray *iconsArr = @[@"beans_task_read",@"beans_task_comment",@"beans_task_join_bookshelves",@"beans_task_share"];
        for (NSInteger i=0;i<taskArr.count;i++) {
            NSDictionary *dict = taskArr[i];
            TaskModel *model = [[TaskModel alloc] init];
            [model setValues:dict];
            model.icon = iconsArr[i];
            if (i==0) {
                model.tips = [NSString stringWithFormat:@"Total hari ini %@ chapter",model.num];
            }
            [tempArr addObject:model];
        }
        self.taskArray = tempArr;
        
        //推荐书籍
        NSMutableArray *recommdBooks = [ComicManager sharedComicManager].recommandBooksArray;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (checked) {
                self.receiveBtn.hidden = YES;
                self.beansCountLab.hidden = self.beansTitlelab.hidden = NO;
                self.beansCountLab.text = [NSString stringWithFormat:@"%ld",(long)self.myKoin];
            }else{
                self.receiveBtn.hidden = NO;
                self.beansCountLab.hidden = self.beansTitlelab.hidden = YES;
            }
            self.checkDaysLab.text = [NSString stringWithFormat:@"Telah diperpanjang sampai %ld hari",(long)self.checkDays];
    
            CGFloat viewW = (kScreenWidth-30-6*5)/7.0;
            for (NSInteger i=0; i<self.signArr.count; i++) {
                NSDictionary *signDict = self.signArr[i];
                CheckDayView *dayView = [[CheckDayView alloc] initWithFrame:CGRectMake(15+(viewW+5)*i, 0, viewW, 66)];
                dayView.dayLab.text = signDict[@"sign_name"];
                dayView.koinLab.text = [NSString stringWithFormat:@"+%@",signDict[@"bean"]];
                if (i<self.checkDays) {
                    dayView.is_received = YES;
                }else{
                    dayView.is_received = NO;
                }
                dayView.tag = i+1;
                [self.daysView addSubview:dayView];
            }
            
            [self.checkTableView reloadData];
            self.checkTableView.frame = CGRectMake(0, self.daysView.bottom+35, kScreenWidth, 54*self.taskArray.count+48);
            
            if (recommdBooks.count>0) {
                self.recommandView.hidden = self.lineView.hidden = NO;
                self.recommandView.booksArray = recommdBooks;
                self.recommandView.frame = CGRectMake(0, self.checkTableView.bottom+10, kScreenWidth,250);
                self.rootScrollView.contentSize = CGSizeMake(kScreenWidth, self.recommandView.top+self.recommandView.height);
            }else{
                self.recommandView.hidden = self.lineView.hidden = YES;
                self.rootScrollView.contentSize = CGSizeMake(kScreenWidth, self.checkTableView.top+self.checkTableView.height);
            }
            
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark -- Getters
#pragma mark 导航栏
-(UIView *)narbarView{
    if (!_narbarView) {
        _narbarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
        
       UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(5,KStatusHeight + 2, 40, 40)];
        [backBtn setImage:[UIImage drawImageWithName:@"return_white"size:CGSizeMake(12, 18)] forState:UIControlStateNormal];
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-10.0, 0, 0)];
        [backBtn addTarget:self action:@selector(leftNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
        [_narbarView addSubview:backBtn];
        
        UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(60, KStatusHeight+12,kScreenWidth-120, 22)];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.font=[UIFont mediumFontWithSize:18];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.text = @"Riwayat isi ulang";
        [_narbarView addSubview:titleLabel];
    }
    return _narbarView;
}

#pragma mark 滚动视图
-(UIScrollView *)rootScrollView{
    if (!_rootScrollView) {
        _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _rootScrollView.showsVerticalScrollIndicator = NO;
        _rootScrollView.backgroundColor = [UIColor whiteColor];
        
        if (@available(iOS 11.0, *)) {
            _rootScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _rootScrollView;
}

#pragma mark 背景
-(UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,325)];
        _bgImgView.image = [UIImage imageNamed:@"daily_attendance_background"];
    }
    return _bgImgView;
}

#pragma mark 领取
-(UIButton *)receiveBtn{
    if (!_receiveBtn) {
        _receiveBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-102)/2.0, kNavHeight+10, 102, 102)];
        [_receiveBtn setBackgroundImage:[UIImage imageNamed:@"daily_attendance_receive"] forState:UIControlStateNormal];
        [_receiveBtn setTitle:@"Ambil" forState:UIControlStateNormal];
        [_receiveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _receiveBtn.titleLabel.font = [UIFont mediumFontWithSize:20];
        [_receiveBtn addTarget:self action:@selector(checkinForReceivingKoinAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _receiveBtn;
}

#pragma mark  漫豆
-(UILabel *)beansCountLab{
    if (!_beansCountLab) {
        _beansCountLab = [[UILabel alloc] initWithFrame:CGRectMake(30, kNavHeight+10, kScreenWidth-60, 44)];
        _beansCountLab.textAlignment = NSTextAlignmentCenter;
        _beansCountLab.font = [UIFont mediumFontWithSize:44];
        _beansCountLab.textColor = [UIColor whiteColor];
    }
    return _beansCountLab;
}

#pragma mark  漫豆
-(UILabel *)beansTitlelab{
    if (!_beansTitlelab) {
        _beansTitlelab = [[UILabel alloc] initWithFrame:CGRectMake(50, self.beansCountLab.bottom+5, kScreenWidth-100, 20)];
        _beansTitlelab.textAlignment = NSTextAlignmentCenter;
        _beansTitlelab.font = [UIFont mediumFontWithSize:16];
        _beansTitlelab.textColor = [UIColor whiteColor];
        _beansTitlelab.text = @"koin";
    }
    return _beansTitlelab;
}

#pragma mark 签到天数说明
-(UILabel *)checkDaysLab{
    if (!_checkDaysLab) {
        _checkDaysLab = [[UILabel alloc] initWithFrame:CGRectMake(22, self.receiveBtn.bottom, kScreenWidth-40, 20)];
        _checkDaysLab.font = [UIFont mediumFontWithSize:14];
        _checkDaysLab.textColor = [UIColor whiteColor];
    }
    return _checkDaysLab;
}

#pragma mark 签到天数
-(UIView *)daysView{
    if (!_daysView) {
        _daysView = [[UIView alloc] initWithFrame:CGRectMake(0, self.checkDaysLab.bottom+10, kScreenWidth, 66)];
    }
    return _daysView;
}

#pragma mark 做任务
-(UITableView *)checkTableView{
    if (!_checkTableView) {
        _checkTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.daysView.bottom+35, kScreenWidth, 264) style:UITableViewStylePlain];
        _checkTableView.dataSource = self;
        _checkTableView.delegate = self;
        _checkTableView.tableFooterView = [[UIView alloc] init];
        _checkTableView.showsVerticalScrollIndicator = NO;
        _checkTableView.scrollEnabled = NO;
        _checkTableView.backgroundColor = [UIColor whiteColor];
        [_checkTableView setBorderWithCornerRadius:16 type:UIViewCornerTypeTop];
    }
    return _checkTableView;
}

#pragma mark 分割线
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.checkTableView.bottom, kScreenWidth, 10)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#F6F6FA"];
    }
    return _lineView;
}

#pragma mark 推荐书籍
-(FooterRecommandView *)recommandView{
    if (!_recommandView) {
        _recommandView = [[FooterRecommandView alloc] initWithFrame:CGRectMake(0, self.lineView.bottom, kScreenWidth, 250) isRecommanded:YES];
        _recommandView.delegate = self;
    }
    return _recommandView;
}

- (NSMutableArray *)checkDayViewsArray{
    if (!_checkDayViewsArray) {
        _checkDayViewsArray = [[NSMutableArray alloc] init];
    }
    return _checkDayViewsArray;
}

-(NSMutableArray *)taskArray{
    if (!_taskArray) {
        _taskArray = [[NSMutableArray alloc] init];
    }
    return _taskArray;
}


@end
