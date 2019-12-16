//
//  InstallViewController.m
//  Comic
//
//  Created by vision on 2019/11/18.
//  Copyright © 2019 vision. All rights reserved.
//

#import "InstallViewController.h"
#import "BaseWebViewController.h"
#import "AboutUsViewController.h"
#import "APPInfoManager.h"
#import "GoogleLoginManager.h"
#import <SDImageCache.h>
#import "ConfirmToastView.h"
#import <SVProgressHUD.h>

@interface InstallViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *titles;
}

@property (nonatomic,strong) UITableView *installTableView;

@property (nonatomic,strong) UIButton    *signOutBtn;

@end

@implementation InstallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseTitle = @"Pengaturan";
    
    titles = @[@"Bersihkan Cache",@"Update terbaru",@"Perjanjian Pengguna",@"Tentang Kami"];
    
    [self.view addSubview:self.installTableView];
    [self.view addSubview:self.signOutBtn];
    self.signOutBtn.hidden = ![ComicManager hasSignIn];
}

#pragma mark UITableViewDataSource and UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = titles[indexPath.row];
    if (indexPath.row==0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        CGFloat fileValue = [[ComicManager sharedComicManager] getTotalCacheSize];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.fM",fileValue];
    }else if (indexPath.row==1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = [APPInfoManager sharedAPPInfoManager].appBundleVersion;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        [self clearCache];
    }else if (indexPath.row==2){
        BaseWebViewController *webVC = [[BaseWebViewController alloc] init];
        webVC.urlStr = [NSString stringWithFormat:kHostTempURL,kUserAgreementURL]; 
        webVC.webTitle = @"Perjanjian registrasi pengguna";
        [self.navigationController pushViewController:webVC animated:YES];
    }else if (indexPath.row==3){
        AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc] init];
        [self.navigationController pushViewController:aboutUsVC animated:YES];
    }
}

#pragma mark -- Event Response
#pragma mark 退出
-(void)signoutAction:(UIButton *)sender{
    [ConfirmToastView showConfirmToastWithFrame:CGRectMake(0, 0, 265, 185) message:@"Anda yakin ingin keluar?" sureBlock:^{
    
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD show];
        NSString *deviceId = [[APPInfoManager sharedAPPInfoManager] deviceIdentifier];
        NSDictionary *params = @{@"deviceId":deviceId,@"platform":@"ios"};
        [[HttpRequest sharedInstance] postWithURLString:kTouristSignInAPI showLoading:NO parameters:params success:^(id responseObject) {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            NSDictionary *userInfo = [data valueForKey:@"userinfo"];
            NSString *token = [userInfo valueForKey:@"token"];
            [NSUserDefaultsInfos putKey:kUserToken andValue:token];
            [NSUserDefaultsInfos putKey:kIsLogin andValue:[NSNumber numberWithBool:NO]];
            
            [[GoogleLoginManager sharedGoogleLoginManager] signOut];
            [ComicManager sharedComicManager].isLogin = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                self.signOutBtn.hidden = YES;
            });
        } failure:^(NSString *errorStr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            MyLog(@"接口：%@----请求失败，error：%@",kTouristSignInAPI,errorStr);
        }];
    } cancelBlock:^{
        
    }];
    
    
}

#pragma mark -- Private methods
#pragma mark 清除缓存
-(void)clearCache{
    //删除自己缓存
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];
    for (NSString *p in files) {
        NSError *error;
        NSString *Path = [path stringByAppendingPathComponent:p];
        if ([[NSFileManager defaultManager] fileExistsAtPath:Path]) {
            //清理缓存，保留Preference，里面含有NSUserDefaults保存的信息
            if (![Path containsString:@"Preferences"]) {
                [[NSFileManager defaultManager] removeItemAtPath:Path error:&error];
            }
        }
    }
    
    //先清除内存中的图片缓存
    [[SDImageCache sharedImageCache] clearMemory];
    //清除磁盘的缓存
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.installTableView reloadData];
        });
    }];
}

#pragma mark -- Getters
#pragma mark 设置
-(UITableView *)installTableView{
    if (!_installTableView) {
        _installTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight) style:UITableViewStylePlain];
        _installTableView.delegate = self;
        _installTableView.dataSource = self;
        _installTableView.showsVerticalScrollIndicator = NO;
        _installTableView.tableFooterView = [[UIView alloc] init];
        _installTableView.scrollEnabled = NO;
        
    }
    return _installTableView;
}

#pragma mark 退出登录
-(UIButton *)signOutBtn{
    if (!_signOutBtn) {
        _signOutBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-305)/2.0, kScreenHeight-70, 305,40)];
        _signOutBtn.backgroundColor = [UIColor bm_colorGradientChangeWithSize:_signOutBtn.size direction:IHGradientChangeDirectionVertical startColor:[UIColor colorWithHexString:@"#C66CFF"] endColor:[UIColor colorWithHexString:@"#636FFF"]];
        [_signOutBtn setTitle:@"Keluar dari akun " forState:UIControlStateNormal];
        [_signOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _signOutBtn.titleLabel.font = [UIFont mediumFontWithSize:16.0f];
        [_signOutBtn setBorderWithCornerRadius:8 type:UIViewCornerTypeAll];
        [_signOutBtn addTarget:self action:@selector(signoutAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signOutBtn;
}


@end
