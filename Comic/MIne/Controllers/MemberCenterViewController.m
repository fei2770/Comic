//
//  MemberCenterViewController.m
//  Comic
//
//  Created by vision on 2019/11/15.
//  Copyright © 2019 vision. All rights reserved.
//

#import "MemberCenterViewController.h"
#import "BaseWebViewController.h"
#import "MemberTypeButton.h"
#import "PurchaseToastView.h"
#import "MemberTypeModel.h"
#import "CustomButton.h"
#import "UserModel.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "PurchaseManger.h"

@interface MemberCenterViewController (){
    NSArray   *rightsContents;
    NSArray   *rightsImages;
    NSInteger  selectedIndex;
}

@property (nonatomic,strong) UIView       *narbarView;
@property (nonatomic,strong) UIScrollView *rootScrollView;
@property (nonatomic,strong) UIImageView  *bgImgView;
@property (nonatomic,strong) UIImageView  *headImgView;
@property (nonatomic,strong) UILabel      *nameLabel;
@property (nonatomic,strong) UIButton     *openBtn;
@property (nonatomic,strong) UILabel      *openTipsLabel;
@property (nonatomic,strong) UILabel      *tipsLabel;
@property (nonatomic,strong) UIButton     *getKoinBtn;
@property (nonatomic,strong) UIView       *typeView;
@property (nonatomic,strong) UILabel      *renewalTitleLab; //自动续费服务声明
@property (nonatomic,strong) UILabel      *renewalDescLab;
@property (nonatomic,strong) UILabel      *descTitleLab;
@property (nonatomic,strong) UIView       *rightsView;
@property (nonatomic,strong) UIImageView  *triangleImgView;
@property (nonatomic,strong) UILabel      *rightsDescLab;
@property (nonatomic,strong) UIImageView  *rightsImgView;
@property (nonatomic,strong) UIView       *agreeView; //服务协议
@property (nonatomic,strong) UIView       *bottomView;

@property (nonatomic,strong) MemberTypeModel   *selTypeModel;
@property (nonatomic,strong) NSMutableArray    *typeModelsArray;

@property (nonatomic,strong) MemberTypeButton  *selTypeBtn;
@property (nonatomic,strong) UILabel        *priceLab;
@property (nonatomic,strong) UserModel      *userModel;

@end

@implementation MemberCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavBar = YES;
    
    rightsContents = @[@"Anggota setiap harinya gratis mengambil hadiah koin",@"Anggota bisa menikmati membaca gratis karya populer yang ditetapkan",@"Anggota mendapatkan keuntungan dan potongan untuk seluruh chapter komik",@"Model komentar langsung spesial yang bisa dinikmati untuk anggota",@"Anggota akan memiliki simbol spesial dan bisa dimunculkan semau anggota"];
    rightsImages = @[@"vip_money_image",@"vip_free_works_image",@"vip_discount_image",@"vip_barrage_image",@"vip_honorable_status_image"];
    
    selectedIndex = 0;
    
    [self initMemberCenterView];
    [self loadMemberInfoData];
}

#pragma mark 状态栏样式
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark -- Event response
#pragma mark 领取金币
-(void)getKoinAction:(UIButton *)sender{
    BOOL isVip = [self.userModel.vip boolValue];
    if (!isVip) {
        [self.view makeToast:@"Daftar anggota bisa ambil" duration:1.0 position:CSToastPositionCenter];
        return ;
    }
    
    [[HttpRequest sharedInstance] postWithURLString:kGetDailyKoinAPI showLoading:YES parameters:@{@"token":kUserTokenValue} success:^(id responseObject) {
        [ComicManager sharedComicManager].isMineReload = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.getKoinBtn setTitle:@"Diklaim" forState:UIControlStateNormal];
            self.getKoinBtn.enabled = NO;
            [self.view makeToast:@"Anggota berhasil mengambil 20 koin" duration:1.0 position:CSToastPositionCenter];
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark 选择会员类型
-(void)didSelectedMemberTypeAction:(MemberTypeButton *)sender{
    if (self.selTypeBtn) {
          self.selTypeBtn.is_selected = NO;
    }
    sender.is_selected = YES;
    self.selTypeBtn = sender;
   
    self.selTypeModel = self.typeModelsArray[sender.tag];
    self.priceLab.text = [NSString stringWithFormat:@"$%.2f",[self.selTypeModel.price doubleValue]];
    [self refreshViewWithBtnTag:sender.tag];
}

#pragma mark 选择权益
-(void)chooseRightsAction:(CustomButton *)sender{
    selectedIndex = sender.tag;
    self.rightsDescLab.text = rightsContents[selectedIndex];
    self.rightsImgView.image = [UIImage imageNamed:rightsImages[selectedIndex]];
    
    CGRect frame = self.triangleImgView.frame;
    if (selectedIndex==0) {
        frame.origin.x = (kScreenWidth/5.0-11)/2.0+20;
    }else if (selectedIndex==4){
        frame.origin.x = 4*(kScreenWidth/5.0)+(kScreenWidth/5.0-11)/2.0-20;
    }else{
        frame.origin.x = selectedIndex*(kScreenWidth/5.0)+(kScreenWidth/5.0-11)/2.0;
    }
    
    self.triangleImgView.frame = frame;
}

#pragma mark 开通会员
-(void)openMemberAction:(UIButton *)sender{
    if ([ComicManager hasSignIn]) {
        [self confirmPurchaseVip];
    }else{
        [PurchaseToastView showConsumeKoinWithFrame:CGRectMake(0, 0, 295, 282) content:@"anggota yang membeli dengan mode pengunjung hanya berlaku saat digunakan saja, Setelah APP diuninstall keuntungan yang didapat juga akan hilang. " clickAction:^(NSInteger tag) {
            if (tag==0) {
                [self presentLoginVC];
            }else{
                [self confirmPurchaseVip];
            }
        }];
    }
}

#pragma mark 续费协议
-(void)tapAgreeAction:(UITapGestureRecognizer *)gesture{
    NSInteger viewTag = gesture.view.tag;
    BaseWebViewController *webVC = [[BaseWebViewController alloc] init];
    webVC.urlStr = [NSString stringWithFormat:kHostTempURL,viewTag==0?kRenewUrl:kPrivacyUrl];
    webVC.webTitle = viewTag==0?@"Perjanjian Biaya Pembaruan":@"Perjanjian Privasi Pengguna";
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark -Private methods
#pragma mark 初始化
-(void)initMemberCenterView{
    [self.view addSubview:self.rootScrollView];
    [self.rootScrollView addSubview:self.bgImgView];
    [self.rootScrollView addSubview:self.headImgView];
    [self.rootScrollView addSubview:self.nameLabel];
    [self.rootScrollView addSubview:self.openBtn];
    [self.rootScrollView addSubview:self.openTipsLabel];
    [self.rootScrollView addSubview:self.tipsLabel];
    [self.rootScrollView addSubview:self.getKoinBtn];
    self.getKoinBtn.hidden = YES;
    [self.rootScrollView addSubview:self.typeView];
    [self.rootScrollView addSubview:self.renewalTitleLab];
    [self.rootScrollView addSubview:self.renewalDescLab];
    [self.rootScrollView addSubview:self.descTitleLab];
    [self.rootScrollView addSubview:self.rightsView];
    [self.rootScrollView addSubview:self.triangleImgView];
    [self.rootScrollView addSubview:self.rightsDescLab];
    [self.rootScrollView addSubview:self.rightsImgView];
    [self.rootScrollView addSubview:self.agreeView];
    
    [self.view addSubview:self.narbarView];
    [self.view addSubview:self.bottomView];
}

#pragma mark 加载会员数据
-(void)loadMemberInfoData{
    [[HttpRequest sharedInstance] postWithURLString:kMemberCenterAPI showLoading:YES parameters:@{@"token":kUserTokenValue} success:^(id responseObject) {
        NSDictionary *data = [responseObject objectForKey:@"data"];
        //用户信息
        NSDictionary *userInfo = [data valueForKey:@"userinfo"];
        [self.userModel setValues:userInfo];
        [NSUserDefaultsInfos putKey:kUserVip andValue:self.userModel.vip];
        
        //领取状态
        BOOL hasGotKoin = [[data valueForKey:@"vipget_state"] boolValue];
        
        //会员信息
        NSArray *vipsArr = [data valueForKey:@"vipinfo"];
        CGFloat btnW = (kScreenWidth-18*2-8)/2.0;
        CGFloat btnH = 90.0;
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSInteger i=0; i<vipsArr.count; i++) {
            NSDictionary *dict = vipsArr[i];
            MemberTypeModel *typeModel = [[MemberTypeModel alloc] init];
            [typeModel setValues:dict];
            [tempArr addObject:typeModel];
        }
        self.typeModelsArray = tempArr;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.rootScrollView.hidden = NO;
            [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.userModel.head_portrait] placeholderImage:[UIImage imageNamed:@"default_head"]];
            BOOL isVip = [self.userModel.vip boolValue];
            if (isVip) {
                self.nameLabel.hidden = NO;
                self.nameLabel.text = self.userModel.name;
                [self.openBtn setImage:[UIImage imageNamed:@"recharge_vip"] forState:UIControlStateNormal];
                self.openBtn.frame = CGRectMake(self.headImgView.right+10, self.nameLabel.bottom, 53, 21);
                self.openTipsLabel.hidden = YES;
                self.tipsLabel.text = @"Anggota setiap bulan hemat $25";
                if (hasGotKoin) {
                    [self.getKoinBtn setTitle:@"Diklaim" forState:UIControlStateNormal];
                    self.getKoinBtn.enabled = NO;
                }else{
                    [self.getKoinBtn setTitle:@"Ambil koin" forState:UIControlStateNormal];
                    self.getKoinBtn.enabled = YES;
                }
            }else{
                self.nameLabel.hidden = YES;
                [self.openBtn setImage:[UIImage imageNamed:@"recharge_vip_opening"] forState:UIControlStateNormal];
                self.openBtn.frame = CGRectMake(self.headImgView.right+10, self.headImgView.top+5, 69, 21);
                self.openTipsLabel.hidden = NO;
                self.tipsLabel.text = @"Daftar anggota setiap bulan hemat $25";
            }
            
            for (NSInteger i=0; i<self.typeModelsArray.count;i++) {
                MemberTypeModel *typeModel = self.typeModelsArray[i];
                MemberTypeButton *btn = [[MemberTypeButton alloc] initWithFrame:CGRectMake(18+(i%2)*(btnW+8), 10+(i/2)*(btnH+10), btnW, btnH)];
                btn.typeModel = typeModel;
                if (i==0) {
                    btn.is_selected = YES;
                    self.selTypeBtn = btn;
                    self.selTypeModel = typeModel;
                }else{
                    btn.is_selected = NO;
                }
                btn.tag = i;
                [btn addTarget:self action:@selector(didSelectedMemberTypeAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.typeView addSubview:btn];
            }
            self.priceLab.text = [NSString stringWithFormat:@"$%.2f",[self.selTypeModel.price doubleValue]];
            [self refreshViewWithBtnTag:0];
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark 确定购买
-(void)confirmPurchaseVip{
    NSDictionary *params = @{@"token":kUserTokenValue,@"type":@"1",@"relation_id":self.selTypeModel.vipinfo_id,@"money":self.selTypeModel.price,@"from":@"ios"};
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
                self.userModel.vip = [NSNumber numberWithBool:YES];
                [NSUserDefaultsInfos putKey:kUserVip andValue:self.userModel.vip];
                NSInteger myBean = [[NSUserDefaultsInfos getValueforKey:kMyKoin] integerValue];
                NSInteger giveBean = [self.selTypeModel.bean integerValue];
                myBean += giveBean;
                [NSUserDefaultsInfos putKey:kMyKoin andValue:[NSNumber numberWithInteger:myBean]];
                
                [ComicManager sharedComicManager].isMineReload = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.nameLabel.hidden = NO;
                    self.nameLabel.text = self.userModel.name;
                    [self.openBtn setImage:[UIImage imageNamed:@"recharge_vip"] forState:UIControlStateNormal];
                    self.openBtn.frame = CGRectMake(self.headImgView.right+10, self.nameLabel.bottom, 53, 21);
                    self.openTipsLabel.hidden = YES;
                    self.tipsLabel.text = @"Anggota setiap bulan hemat $25";
                    
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

#pragma mark 刷新界面
-(void)refreshViewWithBtnTag:(NSInteger)tag{
    CGFloat originY = 0.0;
    if (tag==0) {
        self.renewalTitleLab.hidden = self.renewalDescLab.hidden = NO;
        originY = self.renewalDescLab.bottom + 15;
    }else{
        self.renewalTitleLab.hidden = self.renewalDescLab.hidden = YES;
        originY = self.typeView.bottom + 15;
    }
    self.descTitleLab.frame = CGRectMake(20, originY,kScreenWidth-50, 20);
    self.rightsView.frame = CGRectMake(0, self.descTitleLab.bottom, kScreenWidth, 115);
    
    CGFloat originX = 0.0;
    if (selectedIndex==0) {
        originX = (kScreenWidth/5.0-11)/2.0+20;
    }else if (selectedIndex==4){
        originX = 4*(kScreenWidth/5.0)+(kScreenWidth/5.0-11)/2.0-20;
    }else{
        originX = selectedIndex*(kScreenWidth/5.0)+(kScreenWidth/5.0-11)/2.0;
    }
    self.triangleImgView.frame = CGRectMake(originX, self.rightsView.bottom, 11, 10);
    self.rightsDescLab.frame = CGRectMake(28, self.triangleImgView.bottom, kScreenWidth-55, 59);
    self.rightsImgView.frame = CGRectMake((kScreenWidth-280)/2.0, self.rightsDescLab.bottom+15, 280, 139);
    self.agreeView.frame = CGRectMake(0, self.rightsImgView.bottom+10, kScreenWidth, 100);
    
    self.rootScrollView.contentSize = CGSizeMake(kScreenWidth, self.agreeView.top+self.agreeView.height+10);
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
        titleLabel.text = @"Pusat keanggotaan";
        [_narbarView addSubview:titleLabel];
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
        _bgImgView.image = [UIImage imageNamed:@"vip_center_background"];
    }
    return _bgImgView;
}

#pragma mark 头像
-(UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(40,kNavHeight+25, 44, 44)];
        _headImgView.image = [UIImage imageNamed:@"default_head"];
        [_headImgView setBorderWithCornerRadius:22 type:UIViewCornerTypeAll];
    }
    return _headImgView;
}

#pragma mark 姓名
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headImgView.right+10,self.headImgView.top,kScreenWidth-100, 20)];
        _nameLabel.font = [UIFont mediumFontWithSize:18.0f];
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

#pragma mark 是否会员
-(UIButton *)openBtn{
    if (!_openBtn) {
        _openBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.headImgView.right+10, self.headImgView.top+5, 53, 21)];
    }
    return _openBtn;
}

#pragma mark 开通会员提示
-(UILabel *)openTipsLabel{
    if (!_openTipsLabel) {
        _openTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headImgView.right+10, self.openBtn.bottom,kScreenWidth-100, 20)];
        _openTipsLabel.font = [UIFont regularFontWithSize:10.0f];
        _openTipsLabel.textColor = [UIColor whiteColor];
        _openTipsLabel.numberOfLines = 0;
    }
    return _openTipsLabel;
}

#pragma mark
-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, self.headImgView.bottom+10,kScreenWidth-50, 20)];
        _tipsLabel.font = [UIFont regularFontWithSize:10.0f];
        _tipsLabel.textColor = [UIColor colorWithHexString:@"#FFD775"];
    }
    return _tipsLabel;
}

#pragma mark 领取金币
-(UIButton *)getKoinBtn{
    if (!_getKoinBtn) {
        _getKoinBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-110, self.headImgView.bottom+5, 80, 26)];
        _getKoinBtn.backgroundColor = [UIColor bm_colorGradientChangeWithSize:_getKoinBtn.size direction:IHGradientChangeDirectionVertical startColor:[UIColor colorWithHexString:@"#C66CFF"] endColor:[UIColor colorWithHexString:@"#636FFF "]];
        [_getKoinBtn setTitle:@"Ambil koin" forState:UIControlStateNormal];
        [_getKoinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _getKoinBtn.titleLabel.font = [UIFont mediumFontWithSize:13];
        [_getKoinBtn setBorderWithCornerRadius:13 type:UIViewCornerTypeAll];
        [_getKoinBtn addTarget:self action:@selector(getKoinAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getKoinBtn;
}

#pragma mark 会员类型
-(UIView *)typeView{
    if (!_typeView) {
        _typeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bgImgView.bottom+10, kScreenWidth, 200)];
        _typeView.backgroundColor = [UIColor whiteColor];
    }
    return _typeView;
}

#pragma mark 自动续费服务声明
-(UILabel *)renewalTitleLab{
    if (!_renewalTitleLab) {
        _renewalTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, self.typeView.bottom+15, kScreenWidth-40, 50)];
        _renewalTitleLab.numberOfLines = 0;
        _renewalTitleLab.textColor = [UIColor colorWithHexString:@"#303030"];
        _renewalTitleLab.font = [UIFont mediumFontWithSize:17.0f];
        _renewalTitleLab.text = @"Penjelasan penggunaan layanan biaya pembaruan otomatis";
    }
    return _renewalTitleLab;
}

-(UILabel *)renewalDescLab{
    if (!_renewalDescLab) {
        _renewalDescLab = [[UILabel alloc] initWithFrame:CGRectMake(20, self.renewalTitleLab.bottom+12, kScreenWidth-40, 270)];
        _renewalDescLab.textColor = [UIColor colorWithHexString:@"#6D6D6D"];
        _renewalDescLab.font = [UIFont regularFontWithSize:11];
        _renewalDescLab.numberOfLines = 0;
        _renewalDescLab.text = @"Pembayaran : Setelah pengguna memutuskan mengkonfirmasi pembelian dan membayarnya maka secara otomatis tercatat pada akun iTunes;\nPembatalan berlangganan : Jika anda ingin membatalkan berlangganan, silahkan masuk ke manajemen pengaturan iTunes/ Apple ID lalu me-nonaktifkan fungsi biaya pembaruan otomatis dalam 24 jam sebelum masa aktif berakhir, , layanan ini akan dibatalkan dalam waktu 24 jam sebelum masa aktif berakhir, dan pengguna akan mendapatkan biaya berlangganan. \nBiaya pembaruan : akan ada biaya pemotongan pada pengguna Apple iTunes sebelum 24 jam masa aktif berakhir, setelah pemotongan berakhir secara otomatis memperpanjang masa aktif berlangganan. \nMasa berlaku biaya pembaruan otomatis: Anda dapat memilih membatalkan atau tidak membatalkan layanan ini, jika anda memilih tidak membatalkan, maka akan dibuka biaya penagihan selanjutnya untuk layanan anggota ini.";
    }
    return _renewalDescLab;
}

#pragma mark 会员权益说明
-(UILabel *)descTitleLab{
    if (!_descTitleLab) {
        _descTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, self.renewalDescLab.bottom+20,kScreenWidth-50, 20)];
        _descTitleLab.font = [UIFont mediumFontWithSize:17.0f];
        _descTitleLab.textColor = [UIColor commonColor_black];
        _descTitleLab.text = @"Penjelasan hak istimewa anggota";
    }
    return _descTitleLab;
}

#pragma mark 权益
-(UIView *)rightsView{
    if (!_rightsView) {
        _rightsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.descTitleLab.bottom, kScreenWidth, 115)];
        
        CGFloat capW = (kScreenWidth-64*5)/2.0;
        NSArray  *imagesArr = @[@"vip_money",@"vip_free_works",@"vip_discount",@"vip_barrage",@"vip_honorable_status"];
        NSArray  *titlesArr = @[@"Koin setiap hari",@"Batasan gratis",@"Potonga untuk anggota",@"Komentar langsung anggota",@"Identitas"];
        for (NSInteger i=0; i<imagesArr.count; i++) {
            CustomButton *btn = [[CustomButton alloc] initWithFrame:CGRectMake(capW+64*i, 10, 54, 100) imgSize:CGSizeMake(40, 36)];
            btn.imgName = imagesArr[i];
            btn.titleString = titlesArr[i];
            btn.textColor = [UIColor colorWithHexString:@"#B9976D"];
            btn.tag = i;
            [btn addTarget:self action:@selector(chooseRightsAction:) forControlEvents:UIControlEventTouchUpInside];
            [_rightsView addSubview:btn];
        }
    }
    return _rightsView;
}

#pragma mark 箭头
-(UIImageView *)triangleImgView{
    if (!_triangleImgView) {
        _triangleImgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth/5.0-11)/2.0+20, self.rightsView.bottom, 11, 10)];
        _triangleImgView.image = [UIImage imageNamed:@"vip_triangle"];
    }
    return _triangleImgView;
}

#pragma mark   权益描述
-(UILabel *)rightsDescLab{
    if (!_rightsDescLab) {
        _rightsDescLab = [[UILabel alloc] initWithFrame:CGRectMake(28, self.triangleImgView.bottom, kScreenWidth-55, 59)];
        _rightsDescLab.backgroundColor = [UIColor colorWithHexString:@"#FFECC1"];
        [_rightsDescLab setBorderWithCornerRadius:24.5 type:UIViewCornerTypeAll];
        _rightsDescLab.textAlignment = NSTextAlignmentCenter;
        _rightsDescLab.numberOfLines = 0;
        _rightsDescLab.textColor = [UIColor colorWithHexString:@"#B9976D"];
        _rightsDescLab.font = [UIFont regularFontWithSize:13];
        _rightsDescLab.text = rightsContents[selectedIndex];
    }
    return _rightsDescLab;
}

#pragma mark 权益
-(UIImageView *)rightsImgView{
    if (!_rightsImgView) {
        _rightsImgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-280)/2.0, self.rightsDescLab.bottom+15, 280, 139)];
        _rightsImgView.image = [UIImage imageNamed:rightsImages[selectedIndex]];
    }
    return _rightsImgView;
}

#pragma mark 续费协议
-(UIView *)agreeView{
    if (!_agreeView) {
        _agreeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.rightsImgView.bottom+4, kScreenWidth, 120)];
        
        NSArray *titles = @[@"Perjanjian Layanan Biaya Pembaruan Otomatis Anggota Pulau Komik",@"Perjanjian Privasi Pengguna"];
        CGFloat tempContentHeight = 5.0;
        for (NSInteger i=0; i<titles.count; i++) {
            UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
            contentView.backgroundColor = [UIColor colorWithHexString:@"#F2F3F7"];
            [_agreeView addSubview:contentView];
            
            UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 11, 13)];
            iconImgView.image = [UIImage imageNamed:@"member_agreement"];
            [contentView addSubview:iconImgView];
            
            NSString *contentStr = titles[i];
            CGFloat contentH = [contentStr boundingRectWithSize:CGSizeMake(kScreenWidth-iconImgView.right-80, 100) withTextFont:[UIFont regularFontWithSize:11]].height;
            UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(iconImgView.right,5, kScreenWidth-iconImgView.right-80, contentH+10)];
            contentLab.textAlignment = NSTextAlignmentCenter;
            contentLab.numberOfLines = 0;
            contentLab.textColor = [UIColor colorWithHexString:@"#83848D"];
            contentLab.font = [UIFont regularFontWithSize:11];
            contentLab.text = contentStr;
            [contentView addSubview:contentLab];
            
            contentView.frame = CGRectMake(25, tempContentHeight, kScreenWidth-50, contentH+20);
            [contentView setBorderWithCornerRadius:8 type:UIViewCornerTypeAll];
            
            contentView.tag = i;
            contentView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAgreeAction:)];
            [contentView addGestureRecognizer:tapGesture];
            
            tempContentHeight += contentH+30;
        }
    }
    return _agreeView;
}

#pragma mark
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-52, kScreenWidth, 52)];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#F5F2FF"];
        
        self.priceLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 134, 32)];
        self.priceLab.font = [UIFont mediumFontWithSize:20];
        self.priceLab.textColor = [UIColor colorWithHexString:@"#915AFF"];
        self.priceLab.textAlignment = NSTextAlignmentCenter;
        [_bottomView addSubview:self.priceLab];
        
        UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(154, 0, kScreenWidth-154, 52)];
        buyBtn.backgroundColor = [UIColor bm_colorGradientChangeWithSize:buyBtn.size direction:IHGradientChangeDirectionLevel startColor:[UIColor colorWithHexString:@"#A55EFF"] endColor:[UIColor colorWithHexString:@"#5864FF"]];
        [buyBtn setTitle:@"Daftar langsung" forState:UIControlStateNormal];
        [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buyBtn.titleLabel.font = [UIFont mediumFontWithSize:18];
        [buyBtn addTarget:self action:@selector(openMemberAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:buyBtn];
    }
    return _bottomView;
}

-(UserModel *)userModel{
    if (!_userModel) {
        _userModel = [[UserModel alloc] init];
    }
    return _userModel;
}

-(NSMutableArray *)typeModelsArray{
    if (!_typeModelsArray) {
        _typeModelsArray = [[NSMutableArray alloc] init];
    }
    return _typeModelsArray;
}

-(MemberTypeModel *)selTypeModel{
    if (!_selTypeModel) {
        _selTypeModel = [[MemberTypeModel alloc] init];
    }
    return _selTypeModel;
}

@end
