//
//  ChooseChannelView.m
//  Comic
//
//  Created by vision on 2019/11/22.
//  Copyright © 2019 vision. All rights reserved.
//

#import "ChooseChannelView.h"
#import "ReadCateCollectionView.h"
#import "ReadCateModel.h"

#define kChannelBtnWidth  (kScreenWidth-28*2-16*2)/3.0

@interface ChooseChannelView ()<ReadCateCollectionViewDelegate>

@property (nonatomic,strong) UIImageView     *headImgView;
@property (nonatomic,strong) ReadCateCollectionView  *channelCollectionView;
@property (nonatomic,strong) UILabel             *countLab;
@property (nonatomic,strong) UIButton    *confirmBtn;

@property (nonatomic,strong) NSMutableArray *selChannels;

@end

@implementation ChooseChannelView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.headImgView];
        [self addSubview:self.channelCollectionView];
        [self addSubview:self.countLab];
        [self addSubview:self.confirmBtn];
        
        [self loadFirtChannelPreferenceData];
    }
    return self;
}

#pragma mark -- ReadCateCollectionViewDelegate
#pragma mark 已选类型
-(void)readCateCollectionViewDidChooseChannels:(NSMutableArray *)selChannelsArray{
    self.selChannels = selChannelsArray;
    self.countLab.text = [NSString stringWithFormat:@"%lu/3",(unsigned long)self.selChannels.count];
}

#pragma mark  确定选择
-(void)confirmChooseAction:(UIButton *)sender{
    if (self.selChannels.count<1) {
        [self makeToast:@"Pilihlah paling sedikit satu genre" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    self.sureBlock(self.selChannels);
}


#pragma mark 加载分类数据
-(void)loadFirtChannelPreferenceData{
    NSArray *typesArr = [ComicManager sharedComicManager].comicTypesArray;
    if (typesArr.count>0) {
        [self parseChanneclPreferenceData:typesArr];
    }else{
        [[HttpRequest sharedInstance] postWithURLString:kCartoonTypesAPI showLoading:YES parameters:nil success:^(id responseObject) {
            NSArray *data = [responseObject objectForKey:@"data"];
            [self parseChanneclPreferenceData:data];
        } failure:^(NSString *errorStr) {
            MyLog(@"接口：%@， 请求失败---error:%@",kCartoonTypesAPI,errorStr);
        }];
    }
}

#pragma mark 解析分类数据
-(void)parseChanneclPreferenceData:(NSArray *)typesArr{
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in typesArr) {
        ReadCateModel *cateModel = [[ReadCateModel alloc] init];
        [cateModel setValues:dict];
        [tempArr addObject:cateModel];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.channelCollectionView.channelArray = tempArr;
    });
}

#pragma mark --Getters
-(UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView   = [[UIImageView alloc] initWithFrame:CGRectMake(0,IS_IPHONE_5?KStatusHeight:44, 329, 196)];
        _headImgView.image = [UIImage imageNamed:@"first_into_preference_channel"];
    }
    return _headImgView;
}

#pragma mark
-(ReadCateCollectionView *)channelCollectionView{
    if (!_channelCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(kChannelBtnWidth+6, kChannelBtnWidth+36);
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 25,10);
           
        _channelCollectionView = [[ReadCateCollectionView alloc] initWithFrame:CGRectMake(28,self.headImgView.bottom, kScreenWidth-40,(kChannelBtnWidth+36)*2+10) collectionViewLayout:layout];
        _channelCollectionView.textColor = [UIColor whiteColor];
        _channelCollectionView.viewDelegate = self;
    }
    return _channelCollectionView;
}

#pragma mark 数量
-(UILabel *)countLab{
    if (!_countLab) {
        _countLab = [[UILabel alloc] initWithFrame:CGRectMake((self.width-100)/2.0, self.channelCollectionView.bottom, 100, 20)];
        _countLab.textColor = [UIColor whiteColor];
        _countLab.font = [UIFont mediumFontWithSize:14.0f];
        _countLab.textAlignment = NSTextAlignmentCenter;
        _countLab.text = @"0/3";
    }
    return _countLab;
}


#pragma mark 确定
-(UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-260)/2.0,IS_IPHONE_5?kScreenHeight-80:kScreenHeight-110, 260, 52)];
        [_confirmBtn setTitle:@"Diciptakan sesuai halaman utama yang anda suka" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont mediumFontWithSize:14];
        _confirmBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _confirmBtn.layer.borderWidth = 2;
        _confirmBtn.layer.cornerRadius = 26;
        _confirmBtn.titleLabel.numberOfLines = 0;
        _confirmBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _confirmBtn.tag = 101;
        [_confirmBtn addTarget:self action:@selector(confirmChooseAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

-(NSMutableArray *)selChannels{
    if (!_selChannels) {
        _selChannels = [[NSMutableArray alloc] init];
    }
    return _selChannels;
}


@end
