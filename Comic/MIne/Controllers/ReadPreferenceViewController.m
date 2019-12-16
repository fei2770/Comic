//
//  ReadPreferenceViewController.m
//  Comic
//
//  Created by vision on 2019/11/15.
//  Copyright © 2019 vision. All rights reserved.
//

#import "ReadPreferenceViewController.h"
#import "ReadCateCollectionView.h"
#import "CustomButton.h"
#import "ReadCateModel.h"

#define kCateBtnWidth  (kScreenWidth-28*2-16*2)/3.0

@interface ReadPreferenceViewController ()<ReadCateCollectionViewDelegate>

@property (nonatomic,strong) UIImageView     *bgImgView;
@property (nonatomic,strong) CustomButton    *girlBtn;
@property (nonatomic,strong) CustomButton    *boyBtn;
@property (nonatomic,strong) UIImageView     *coverImgView;
@property (nonatomic,strong) ReadCateCollectionView  *cateCollectionView;

@end

@implementation ReadPreferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"Peferensi membaca";
    
    [self initReadingPreferenceView];
    [self loadReadingPreferenceCateData];
}

#pragma mark - Delegate
#pragma mark ReadCateCollectionViewDelegate
-(void)readCateCollectionViewDidChooseChannels:(NSMutableArray *)selChannelsArray{
    if (selChannelsArray.count>0) {
        MyLog(@"readCateCollectionViewDidChooseChannels");
        NSNumber *gender = [NSUserDefaultsInfos getValueforKey:kUserGenderPreference];
        [self setUserReadPreferenceWithGender:gender types:selChannelsArray];
    }
}

#pragma mark -- Event response
#pragma mark 选择性别
-(void)chooseGenderAction:(UIButton *)sender{
    if (sender.tag==0) {
        self.coverImgView.origin = self.boyBtn.origin;
        self.boyBtn.textColor = [UIColor colorWithHexString:@"#FF4F73"];
        self.girlBtn.textColor = [UIColor colorWithHexString:@"#83848D"];
    }else{
        self.coverImgView.origin = self.girlBtn.origin;
        self.boyBtn.textColor = [UIColor colorWithHexString:@"#83848D"];
        self.girlBtn.textColor = [UIColor colorWithHexString:@"#FF4F73"];
    }
    NSArray *types = [NSUserDefaultsInfos getValueforKey:kUserChannelPreference];
    [self setUserReadPreferenceWithGender:[NSNumber numberWithInteger:sender.tag+1] types:types];
    
}

#pragma mark -- Private methods
#pragma mark 初始化
-(void)initReadingPreferenceView{
    [self.view addSubview:self.bgImgView];
    [self.view addSubview:self.girlBtn];
    [self.view addSubview:self.boyBtn];
    [self.view addSubview:self.coverImgView];
    [self.view addSubview:self.cateCollectionView];
    
    
}

#pragma mark 加载分类数据
-(void)loadReadingPreferenceCateData{
    //设置性别
    NSInteger genderPreference = [[NSUserDefaultsInfos getValueforKey:kUserGenderPreference] integerValue];
    if (genderPreference==1) { //男频
        self.boyBtn.textColor = [UIColor colorWithHexString:@"#FF4F73"];
        self.girlBtn.textColor = [UIColor colorWithHexString:@"#83848D"];
        CGRect frame = self.coverImgView.frame;
        frame.origin = self.boyBtn.origin;
        self.coverImgView.frame = frame;
    }else{
        self.boyBtn.textColor = [UIColor colorWithHexString:@"#83848D"];
        self.girlBtn.textColor = [UIColor colorWithHexString:@"#FF4F73"];
        CGRect frame = self.coverImgView.frame;
        frame.origin = self.girlBtn.origin;
        self.coverImgView.frame = frame;
    }
    
    NSArray *channels = [NSUserDefaultsInfos getValueforKey:kUserChannelPreference];
    self.cateCollectionView.selectedChannelIdsArray = [NSMutableArray arrayWithArray:channels];
    
    NSArray *typesArr = [ComicManager sharedComicManager].comicTypesArray;
    if (typesArr.count>0) {
        [self parseChanneclPreferenceData:typesArr];
    }else{
        [[HttpRequest sharedInstance] postWithURLString:kCartoonTypesAPI showLoading:YES parameters:nil success:^(id responseObject) {
            NSArray *data = [responseObject objectForKey:@"data"];
            [self parseChanneclPreferenceData:data];
        } failure:^(NSString *errorStr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
            });
        }];
    }
}

#pragma mark 解析分类数据
-(void)parseChanneclPreferenceData:(NSArray *)typesArr{
    NSArray *selTypes = [NSUserDefaultsInfos getValueforKey:kUserChannelPreference];
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in typesArr) {
        ReadCateModel *cateModel = [[ReadCateModel alloc] init];
        [cateModel setValues:dict];
        for (NSNumber *typeId in selTypes) {
            if ([cateModel.type_id integerValue]==[typeId integerValue]) {
                cateModel.is_selected = [NSNumber numberWithBool:YES];
                break;
            }
        }
        [tempArr addObject:cateModel];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.cateCollectionView.channelArray = tempArr;
    });
}

#pragma mark 设置偏好
-(void)setUserReadPreferenceWithGender:(NSNumber *)gender types:(NSArray *)types{
    NSString *typeStr = [[ComicManager sharedComicManager] getValueWithParams:types];
    NSDictionary *params = @{@"token":kUserTokenValue,@"channel":gender,@"book_type":typeStr};
    [[HttpRequest sharedInstance] postWithURLString:kSetReadPeferenceAPI showLoading:YES parameters:params success:^(id responseObject) {
        [NSUserDefaultsInfos putKey:kUserGenderPreference andValue:gender];
        [NSUserDefaultsInfos putKey:kUserChannelPreference andValue:types];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cateCollectionView reloadData];
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark -- getters
#pragma mark 背景
-(UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight)];
        _bgImgView.image = [UIImage imageNamed:@"reading_preference_background"];
    }
    return _bgImgView;
}

#pragma mark 男
-(CustomButton *)boyBtn{
    if (!_boyBtn) {
        _boyBtn = [[CustomButton alloc] initWithFrame:CGRectMake(kScreenWidth/2.0-115, kNavHeight+27, 94, 85) imgSize:CGSizeMake(94, 58)];
        _boyBtn.imgName = @"reading_preference_male";
        _boyBtn.titleString = @"Laki-laki";
        _boyBtn.textColor = [UIColor colorWithHexString:@"#FF4F73"];
        _boyBtn.titleFont = [UIFont mediumFontWithSize:16.0f];
        _boyBtn.tag = 0;
        [_boyBtn addTarget:self action:@selector(chooseGenderAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _boyBtn;
}

#pragma mark 女
-(CustomButton *)girlBtn{
    if (!_girlBtn) {
        _girlBtn = [[CustomButton alloc] initWithFrame:CGRectMake( kScreenWidth/2.0+21, kNavHeight+27, 94, 85) imgSize:CGSizeMake(94, 58)];
        _girlBtn.imgName = @"reading_preference_female";
        _girlBtn.titleString = @"Perempuan";
        _girlBtn.textColor = [UIColor colorWithHexString:@"#83848D"];
        _girlBtn.titleFont = [UIFont mediumFontWithSize:16.0f];
        _girlBtn.tag = 1;
        [_girlBtn addTarget:self action:@selector(chooseGenderAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _girlBtn;
}

#pragma mark 蒙层
-(UIImageView *)coverImgView{
    if (!_coverImgView) {
        _coverImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 94, 58)];
        _coverImgView.origin = self.boyBtn.origin;
        _coverImgView.image = [UIImage imageNamed:@"choose_white"];
    }
    return _coverImgView;
}

#pragma mark
-(ReadCateCollectionView *)cateCollectionView{
    if (!_cateCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(kCateBtnWidth+6, kCateBtnWidth+36);
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 25,10);
           
        _cateCollectionView = [[ReadCateCollectionView alloc] initWithFrame:CGRectMake(28,self.boyBtn.bottom+40, kScreenWidth-40,kScreenHeight-self.boyBtn.bottom-20) collectionViewLayout:layout];
        _cateCollectionView.textColor = [UIColor commonColor_black];
        _cateCollectionView.viewDelegate = self;
    }
    return _cateCollectionView;
}

@end
