//
//  MyTabBarController.m
//  Homework
//
//  Created by vision on 2019/9/5.
//  Copyright © 2019 vision. All rights reserved.
//

#import "MyTabBarController.h"
#import "BookCityViewController.h"
#import "BookShelfViewController.h"
#import "MineViewController.h"
#import "BaseNavigationController.h"
#import "ChooseGenderView.h"
#import "ChooseChannelView.h"
#import "APPInfoManager.h"


@interface MyTabBarController ()

@property (nonatomic,strong) UIView            *contentView;
@property (nonatomic,strong) ChooseGenderView  *genderView;
@property (nonatomic,strong) ChooseChannelView *channelView;
@property (nonatomic,strong) BookCityViewController *bookCityVC;

@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#6D6D6D"],NSFontAttributeName:[UIFont mediumFontWithSize:10]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#6A00FF"],NSFontAttributeName:[UIFont mediumFontWithSize:10]} forState:UIControlStateSelected];
    
    [UITabBar appearance].translucent = NO;
    
    self.tabBar.barStyle = UIBarStyleDefault;
    
    [self setTabbarBackView];
    [self initMyTabBar];
    [self showFirstPreferenceView];
    [self loadPublicData];
    [self touristSignIn];
}

-(void)viewWillLayoutSubviews{
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = kTabHeight;
    tabFrame.origin.y = kScreenHeight - kTabHeight;
    self.tabBar.frame = tabFrame;
}

#pragma mark -- Private Methods
#pragma mark 初始化
- (void)initMyTabBar{
    self.bookCityVC = [[BookCityViewController alloc] init];
    BaseNavigationController * nav1 = [[BaseNavigationController alloc] initWithRootViewController:self.bookCityVC];
    
    UITabBarItem * mainItem = [[UITabBarItem alloc] initWithTitle:@"Beranda" image:[[UIImage imageNamed:@"bottom_bar_bookcity"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"bottom_bar_bookcity_choose"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [nav1 setTabBarItem:mainItem];
    
    BookShelfViewController *bookShelfVC = [[BookShelfViewController alloc] init];
    BaseNavigationController * nav2 = [[BaseNavigationController alloc] initWithRootViewController:bookShelfVC];
    UITabBarItem * shelfItem = [[UITabBarItem alloc] initWithTitle:@"Rak buku" image:[[UIImage imageNamed:@"bottom_bar_bookshelf"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"bottom_bar_bookshelf_choose"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [nav2 setTabBarItem:shelfItem];
    
    MineViewController *mineVC = [[MineViewController alloc] init];
    BaseNavigationController * nav3 = [[BaseNavigationController alloc] initWithRootViewController:mineVC];
    UITabBarItem * mineItem = [[UITabBarItem alloc] initWithTitle:@"Saya" image:[[UIImage imageNamed:@"bottom_bar_my"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"bottom_bar_my_choose"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [nav3 setTabBarItem:mineItem];
    
    self.viewControllers = @[nav1,nav2,nav3];
}

#pragma mark 设置tabbar
-(void)setTabbarBackView{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTabHeight)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:backView atIndex:0];
    self.tabBar.opaque = YES;
}


#pragma mark 首次显示蒙层
-(void)showFirstPreferenceView{
    BOOL showFirst = [[NSUserDefaultsInfos getValueforKey:kShowFirstPreference] boolValue];
    if (!showFirst) {
        [self.view addSubview:self.contentView];
        [self.view addSubview:self.genderView];
    }
}

#pragma mark 跳转到类型
-(void)showChooseChannelView{
    [self.genderView removeFromSuperview];
    self.genderView = nil;
    [self.view addSubview:self.channelView];
}

#pragma mark 确认选择
-(void)confirmFirstSettingPreference{
    [NSUserDefaultsInfos putKey:kShowFirstPreference andValue:[NSNumber numberWithBool:YES]];
    [self.channelView removeFromSuperview];
    self.channelView = nil;
    [self.contentView removeFromSuperview];
    self.contentView = nil;
    if (self.bookCityVC) {
        [self.bookCityVC loadBookCityData];
    }
    //加载推荐书籍
    [[ComicManager sharedComicManager] loadRecommandBooksData];
}

#pragma mark 加载公共数据
-(void)loadPublicData{
    NSArray *typesArr = [NSUserDefaultsInfos getValueforKey:kComicTypes];
    NSArray *channels = [NSUserDefaultsInfos getValueforKey:kUserChannelPreference];
    if (typesArr.count>0&&channels.count>0) {
        [ComicManager sharedComicManager].comicTypesArray = typesArr;
    }else{
        //加载书籍类型
        [[HttpRequest sharedInstance] postWithURLString:kCartoonTypesAPI showLoading:NO parameters:nil success:^(id responseObject) {
            NSArray *data = [responseObject objectForKey:@"data"];
            [NSUserDefaultsInfos putKey:kComicTypes andValue:data];
            [ComicManager sharedComicManager].comicTypesArray = data;
        } failure:^(NSString *errorStr) {
            MyLog(@"接口：%@， 请求失败---error:%@",kCartoonTypesAPI,errorStr);
        }];
    }
    
    //加载推荐书籍
    [[ComicManager sharedComicManager] loadRecommandBooksData];
}

#pragma mark 游客模式登录
-(void)touristSignIn{
    NSString *token = [NSUserDefaultsInfos getValueforKey:kUserToken];
    if (kIsEmptyString(token)) {
        NSString *deviceId = [[APPInfoManager sharedAPPInfoManager] deviceIdentifier];
        NSDictionary *params = @{@"deviceId":deviceId,@"platform":@"ios"};
        [[HttpRequest sharedInstance] postWithURLString:kTouristSignInAPI showLoading:NO parameters:params success:^(id responseObject) {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            NSDictionary *userInfo = [data valueForKey:@"userinfo"];
            NSString *token = [userInfo valueForKey:@"token"];
            [NSUserDefaultsInfos putKey:kUserToken andValue:token];
            [NSUserDefaultsInfos putKey:kIsLogin andValue:[NSNumber numberWithBool:NO]];
            [self loadLoginSwitch];
        } failure:^(NSString *errorStr) {
            MyLog(@"接口：%@----请求失败，error：%@",kTouristSignInAPI,errorStr);
        }];
    }else{
        [self loadLoginSwitch];
    }
}

#pragma mark 获取苹果开关
-(void)loadLoginSwitch{
    NSString *appVersion = [[APPInfoManager sharedAPPInfoManager] appBundleVersion];
    [[HttpRequest sharedInstance] postWithURLString:kLoginSwitchAPI showLoading:NO parameters:@{@"token":kUserTokenValue,@"version":appVersion} success:^(id responseObject) {
        NSDictionary *data = [responseObject objectForKey:@"data"];
        NSNumber *loginSwitch = [data valueForKey:@"pay_switch"];
        [NSUserDefaultsInfos putKey:kloginSwitch andValue:loginSwitch];
    } failure:^(NSString *errorStr) {
        
    }];
}


#pragma mark -- Getters
#pragma mark 蒙版
-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
        _contentView.backgroundColor = kRGBColor(0, 0, 0, 0.8);
    }
    return _contentView;
}

#pragma mark 性别
-(ChooseGenderView *)genderView{
    if (!_genderView) {
        _genderView = [[ChooseGenderView alloc] initWithFrame:self.view.bounds];
        kSelfWeak;
        _genderView.sureBlock = ^(NSInteger gender) {
            [NSUserDefaultsInfos putKey:kUserGenderPreference andValue:[NSNumber numberWithInteger:gender]];
            MyLog(@"gender:%ld",gender);
            [weakSelf showChooseChannelView];
        };
    }
    return _genderView;
}

#pragma mark 类型
-(ChooseChannelView *)channelView{
    if (!_channelView) {
        _channelView = [[ChooseChannelView alloc] initWithFrame:self.view.bounds];
        kSelfWeak;
        _channelView.sureBlock = ^(NSArray *channls) {
            [NSUserDefaultsInfos putKey:kUserChannelPreference andValue:channls];
            MyLog(@"channls:%@",channls);
            [weakSelf confirmFirstSettingPreference];
        };
    }
    return _channelView;
}


@end
