//
//  RechargeViewController.m
//  Comic
//
//  Created by vision on 2019/11/18.
//  Copyright © 2019 vision. All rights reserved.
//

#import "RechargeViewController.h"
#import "KoinDetailsViewController.h"
#import "ReadDetailsViewController.h"
#import "RechargeTypeButton.h"
#import "InvalidRemindView.h"
#import "PurchaseToastView.h"
#import "KoinTypeModel.h"
#import "NSDate+Extend.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "PurchaseManger.h"

@interface RechargeViewController ()

@property (nonatomic,strong) UIView       *narbarView;
@property (nonatomic,strong) UIScrollView *rootScrollView;
@property (nonatomic,strong) UIImageView  *bgImgView;
@property (nonatomic,strong) UILabel      *beansCountLab;
@property (nonatomic,strong) UILabel      *beansTitlelab;
@property (nonatomic,strong) UILabel      *beansTipslab;
@property (nonatomic,strong) UIButton     *beansDetailBtn;
@property (nonatomic,strong) UIView       *typeView;
@property (nonatomic,strong) UILabel      *descTitleLab;
@property (nonatomic,strong) UILabel      *descLab;
@property (nonatomic,strong) UIView       *bottomView;
@property (nonatomic,strong) UILabel      *priceLab;

@property (nonatomic,strong) RechargeTypeButton  *selTypeBtn;

@property (nonatomic,strong) KoinTypeModel   *selTypeModel;
@property (nonatomic,strong) NSMutableArray  *typeModelsArray;

@property (nonatomic,assign) NSInteger    myKoin;


@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHiddenNavBar = YES;
    [self initRechargeView];
    [self loadRechargeInfo];
    
    MyLog(@"vcs:%@,count:%ld",self.navigationController.viewControllers,self.navigationController.viewControllers.count);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark 状态栏样式
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark -- Event response
#pragma mark 明细
-(void)rightNavigationItemAction{
    KoinDetailsViewController *detailsVC = [[KoinDetailsViewController alloc] init];
    [self.navigationController pushViewController:detailsVC animated:YES];
}

#pragma mark 返回
-(void)leftNavigationItemAction{
    BOOL flag = NO;
    for (BaseViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ReadDetailsViewController class]]) {
            flag = YES;
            break;
        }
    }
    if (flag == YES) {
        NSInteger count = self.navigationController.viewControllers.count;
        BaseViewController *vc = [self.navigationController.viewControllers objectAtIndex:count-3];
        [self.navigationController popToViewController:vc animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 显示失效详情
-(void)showInvalidBeansDetailAction:(UIButton *)sender{
    [InvalidRemindView showEvaluateViewWithFrame:CGRectMake(0, 0, 280, 180) time:@"09-09 00:00" beans:1000];
}

#pragma mark 选择类型
-(void)didSelectedKoinTypeAction:(RechargeTypeButton *)sender{
    if (self.selTypeBtn) {
           self.selTypeBtn.is_selected = NO;
    }
    sender.is_selected = YES;
    self.selTypeBtn = sender;
    
    self.selTypeModel = self.typeModelsArray[sender.tag];
    self.priceLab.text = [NSString stringWithFormat:@"$%.2f",[self.selTypeModel.price doubleValue]];
}

#pragma mark 购买
-(void)buyForRechargeAction:(UIButton *)sender{
    if ([ComicManager hasSignIn]) {
        [self confirmPurchase];
    }else{
        [PurchaseToastView showConsumeKoinWithFrame:CGRectMake(0, 0, 295, 272) content:@"koin yang diisi ulang dengan mode pengunjung hanya berlaku saat digunakan saja, setelah APP diunistall koin juga akan hilang." clickAction:^(NSInteger tag) {
            if (tag==0) {
                [self presentLoginVC];
            }else{
                [self confirmPurchase];
            }
        }];
    }
}

#pragma mark -- Private methods
#pragma mark 初始化
-(void)initRechargeView{
    [self.view addSubview:self.rootScrollView];
    [self.rootScrollView addSubview:self.bgImgView];
    [self.rootScrollView addSubview:self.beansCountLab];
    [self.rootScrollView addSubview:self.beansTitlelab];
    [self.rootScrollView addSubview:self.beansTipslab];
    [self.rootScrollView addSubview:self.beansDetailBtn];
    [self.rootScrollView addSubview:self.typeView];
    [self.rootScrollView addSubview:self.descTitleLab];
    [self.rootScrollView addSubview:self.descLab];
    self.rootScrollView.hidden = YES;
    
    [self.view addSubview:self.narbarView];
    [self.view addSubview:self.bottomView];
}

#pragma mark 获取钱包信息
-(void)loadRechargeInfo{
    [[HttpRequest sharedInstance] postWithURLString:kVoucherCenterAPI showLoading:YES parameters:@{@"token":kUserTokenValue} success:^(id responseObject) {
        NSDictionary *data = [responseObject objectForKey:@"data"];
        
        NSNumber *beans = [data valueForKey:@"bean"];
        [NSUserDefaultsInfos putKey:kMyKoin andValue:beans];
        self.myKoin = [beans integerValue];
        
        //到期时间
        NSNumber *expireTime = [data valueForKey:@"expire_time"];
        //过期金币
        NSInteger expireBeans = [[data valueForKey:@"expire_bean"] integerValue];
        
        //金币
        NSArray *beansArr = [data valueForKey:@"beaninfo"];
        CGFloat btnW = (kScreenWidth-18*2-8*2)/3.0;
        CGFloat btnH = 140.0;
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSInteger i=0; i<beansArr.count; i++) {
            NSDictionary *dict = beansArr[i];
            KoinTypeModel *typeModel = [[KoinTypeModel alloc] init];
            [typeModel setValues:dict];
            [tempArr addObject:typeModel];
        }
        self.typeModelsArray = tempArr;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.rootScrollView.hidden = NO;
            self.beansCountLab.text = [NSString stringWithFormat:@"%ld",(long)self.myKoin];
            if (expireBeans>0) {
                self.beansTipslab.hidden = self.beansDetailBtn.hidden = NO;
                
                NSString *currentDate = [NSDate currentDateTimeWithFormat:@"yyyy-MM-dd"];
                NSString *expireTimeStr = [[ComicManager sharedComicManager] timeWithTimeIntervalNumber:expireTime format:@"yyyy-MM-dd"];
                NSInteger days = [self pleaseInsertStarTimeo:currentDate andInsertEndTime:expireTimeStr];
                
                self.beansTipslab.text = [NSString stringWithFormat:@"%ld koin, setelah %ld hari gagal",(long)expireBeans,(long)days];
            }else{
                self.beansTipslab.hidden = self.beansDetailBtn.hidden = YES;
            }
            
            CGFloat tipsW = [self.beansTipslab.text boundingRectWithSize:CGSizeMake(kScreenWidth, 14) withTextFont:self.beansTipslab.font].width;
            self.beansTipslab.frame = CGRectMake((kScreenWidth-tipsW-50)/2.0, self.beansTitlelab.bottom+10, tipsW, 18);
            self.beansDetailBtn.frame = CGRectMake(self.beansTipslab.right+5, self.beansTitlelab.bottom+10, 50, 18);
            [self.beansDetailBtn setBorderWithCornerRadius:9 type:UIViewCornerTypeAll];
            
            for (NSInteger i=0; i<self.typeModelsArray .count; i++) {
                KoinTypeModel *typeModel = self.typeModelsArray[i];
                RechargeTypeButton *btn = [[RechargeTypeButton alloc] initWithFrame:CGRectMake(18+(i%3)*(btnW+8), 10+(i/3)*(btnH+10), btnW, btnH)];
                btn.typeModel = typeModel;
                if (i==0) {
                    btn.is_selected = YES;
                    self.selTypeBtn = btn;
                    self.selTypeModel = typeModel;
                }else{
                    btn.is_selected = NO;
                }
                btn.tag = i;
                [btn addTarget:self action:@selector(didSelectedKoinTypeAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.typeView addSubview:btn];
            }
            self.typeView.frame = CGRectMake(0, self.bgImgView.bottom, kScreenWidth,((beansArr.count-1)/3+1)*150);
            self.descTitleLab.frame = CGRectMake(20, self.typeView.bottom+20, kScreenWidth-50, 20);
            
            self.descLab.text = @"Koin yang dihadiahkan untuk isi ulang terbatas di bulan tersebut selama satu hari sampai 24:00";
            CGFloat descH = [self.descLab.text boundingRectWithSize:CGSizeMake(kScreenWidth-40, CGFLOAT_MAX) withTextFont:self.descLab.font].height;
            self.descLab.frame = CGRectMake(20, self.descTitleLab.bottom+5, kScreenWidth-40, descH);
            self.rootScrollView.contentSize = CGSizeMake(kScreenWidth, self.descLab.top+self.descLab.height);
            
            self.priceLab.text = [NSString stringWithFormat:@"$%.2f",[self.selTypeModel.price doubleValue]];
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

- (NSInteger)pleaseInsertStarTimeo:(NSString *)time1 andInsertEndTime:(NSString *)time2{
    // 1.将时间转换为date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date1 = [formatter dateFromString:time1];
    NSDate *date2 = [formatter dateFromString:time2];
    // 2.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 3.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
    return cmps.month*30+cmps.day;
}

#pragma mark 确定购买
-(void)confirmPurchase{
    NSDictionary *params = @{@"token":kUserTokenValue,@"type":@"2",@"relation_id":self.selTypeModel.beans_id,@"money":self.selTypeModel.price,@"from":@"ios"};
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD show];
    });
    [[HttpRequest sharedInstance] postWithURLString:kCreatOrderAPI showLoading:NO parameters:params success:^(id responseObject) {
        NSDictionary *data = [responseObject objectForKey:@"data"];
        NSString *productID = [data valueForKey:@"product_id"];
        NSString *ord_sn = [data valueForKey:@"order_no"];
        PurchaseManger *manager = [PurchaseManger sharedPurchaseManger];
        manager.orderSn = ord_sn;
        [manager purchaseWithProductID:productID payResult:^(BOOL isSuccess, NSString *certificate, NSString *errorMsg) {
            MyLog(@"票据信息---%@",certificate);
            MyLog(@"错误信息---%@",errorMsg);
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            if (isSuccess) {
                MyLog(@"内购成功");
                NSInteger koin = [self.selTypeModel.beans integerValue];
                self.myKoin += koin;
                NSInteger giveBean = [self.selTypeModel.presenter_beans integerValue];
                self.myKoin += giveBean;
                [NSUserDefaultsInfos putKey:kMyKoin andValue:[NSNumber numberWithInteger:self.myKoin]];
                [ComicManager sharedComicManager].isMineReload = YES;
                [ComicManager sharedComicManager].isReadDetailsLoad = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.beansCountLab.text = [NSString stringWithFormat:@"%ld",(long)self.myKoin];
                    [self.view makeToast:@"Pembelian berhasil" duration:1.0 position:CSToastPositionCenter];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view makeToast:errorMsg duration:1.0 position:CSToastPositionCenter];
                });
            }
        }];
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
        
        UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-180)/2, KStatusHeight+12, 180, 22)];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.font=[UIFont mediumFontWithSize:18];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.text = @"Pusat Pembayaran";
        [_narbarView addSubview:titleLabel];
        
        UIButton *saveBtn=[[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-65, KStatusHeight+2, 55, 40)];
        [saveBtn setTitle:@"Detail" forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        saveBtn.titleLabel.font=[UIFont regularFontWithSize:16];
        [saveBtn addTarget:self action:@selector(rightNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
        [_narbarView addSubview:saveBtn];
    }
    return _narbarView;
}

#pragma mark 滚动视图
-(UIScrollView *)rootScrollView{
    if (!_rootScrollView) {
        _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-52)];
        _rootScrollView.showsVerticalScrollIndicator = NO;
        
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
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 193)];
        _bgImgView.image = [UIImage imageNamed:@"voucher_center_background"];
    }
    return _bgImgView;
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

#pragma mark  失效说明
-(UILabel *)beansTipslab{
    if (!_beansTipslab) {
        _beansTipslab = [[UILabel alloc] initWithFrame:CGRectZero];
        _beansTipslab.font = [UIFont regularFontWithSize:12];
        _beansTipslab.textColor = [UIColor whiteColor];
    }
    return _beansTipslab;
}

#pragma mark 详情
-(UIButton *)beansDetailBtn{
    if (!_beansDetailBtn) {
        _beansDetailBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_beansDetailBtn setTitle:@"Detail" forState:UIControlStateNormal];
        _beansDetailBtn.backgroundColor = [UIColor colorWithHexString:@"#FFF952"];
        [_beansDetailBtn setTitleColor:[UIColor colorWithHexString:@"#CD7500"] forState:UIControlStateNormal];
        _beansDetailBtn.titleLabel.font = [UIFont mediumFontWithSize:11];
        [_beansDetailBtn addTarget:self action:@selector(showInvalidBeansDetailAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beansDetailBtn;
}

#pragma mark 充值类型
-(UIView *)typeView{
    if (!_typeView) {
        _typeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bgImgView.bottom, kScreenWidth, 300)];
        _typeView.backgroundColor = [UIColor whiteColor];
    }
    return _typeView;
}

#pragma mark 充值说明
-(UILabel *)descTitleLab{
    if (!_descTitleLab) {
        _descTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, self.typeView.bottom+20,kScreenWidth-50, 20)];
        _descTitleLab.font = [UIFont mediumFontWithSize:17.0f];
        _descTitleLab.textColor = [UIColor commonColor_black];
        _descTitleLab.text = @"Penjelasan cara isi ulang";
    }
    return _descTitleLab;
}

-(UILabel *)descLab{
    if (!_descLab) {
        _descLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLab.textColor = [UIColor colorWithHexString:@"#6D6D6D"];
        _descLab.font = [UIFont regularFontWithSize:13.0f];
        _descLab.numberOfLines = 0;
    }
    return _descLab;
}

#pragma mark
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-52, kScreenWidth, 52)];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#FFF2E2"];
        
        self.priceLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 134, 32)];
        self.priceLab.font = [UIFont mediumFontWithSize:20];
        self.priceLab.textColor = [UIColor colorWithHexString:@"#FF9100"];
        self.priceLab.textAlignment = NSTextAlignmentCenter;
        self.priceLab.text = @"$0.00";
        [_bottomView addSubview:self.priceLab];
        
        UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(154, 0, kScreenWidth-154, 52)];
        buyBtn.backgroundColor = [UIColor bm_colorGradientChangeWithSize:buyBtn.size direction:IHGradientChangeDirectionLevel startColor:[UIColor colorWithHexString:@"#FF8155"] endColor:[UIColor colorWithHexString:@"#FFBB00"]];
        [buyBtn setTitle:@"Pembelian" forState:UIControlStateNormal];
        [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buyBtn.titleLabel.font = [UIFont mediumFontWithSize:18];
        [buyBtn addTarget:self action:@selector(buyForRechargeAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:buyBtn];
    }
    return _bottomView;
}

-(NSMutableArray *)typeModelsArray{
    if (!_typeModelsArray) {
        _typeModelsArray = [[NSMutableArray alloc] init];
    }
    return _typeModelsArray;
}

-(KoinTypeModel *)selTypeModel{
    if (!_selTypeModel) {
        _selTypeModel = [[KoinTypeModel alloc] init];
    }
    return _selTypeModel;
}

@end
