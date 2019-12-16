//
//  BookListView.m
//  Comic
//
//  Created by vision on 2019/11/20.
//  Copyright © 2019 vision. All rights reserved.
//

#import "BookListView.h"
#import "BookListCollectionViewCell.h"
#import <MJRefresh/MJRefresh.h>

@interface BookListView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView   *listCollcetionView;
@property (nonatomic,strong) UIButton           *lastWordBtn;  //上一话
@property (nonatomic,strong) UISlider           *progress;
@property (nonatomic,strong) UIButton           *nextWordBtn;  //下一话
@property (nonatomic,strong) UILabel            *progressLab;

@property (nonatomic,assign) NSInteger          currentIndex;


@end

@implementation BookListView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.listCollcetionView];
        [self addSubview:self.lastWordBtn];
        [self addSubview:self.progress];
        [self addSubview:self.nextWordBtn];
        [self addSubview:self.progressLab];
    }
    return self;
}

#pragma mark UICollectionViewDataSource and UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BookListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookListCollectionViewCell" forIndexPath:indexPath];
    BookSelectionModel *model = self.listArray[indexPath.row];
    [cell displaySelectionCellWithModel:model vipCost:self.vipCost];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BookSelectionModel *model = self.listArray[indexPath.row];
    [self setCurrentcatalogueId:model.catalogue_id];
    if ([self.viewDelegate respondsToSelector:@selector(bookListViewDidChooseSelection:)]) {
        [self.viewDelegate bookListViewDidChooseSelection:model];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat originX = scrollView.contentOffset.x;
    CGFloat contentW = self.listCollcetionView.contentSize.width;
    if (contentW<kScreenWidth) {
        contentW = kScreenWidth;
    }
    CGFloat value = originX/contentW;
    self.progress.value = value;
    MyLog(@"scrollViewDidScroll---x:%.f,contentSize - w:%.f,value:%.f",originX,contentW,value);
}

#pragma mark 刷新界面
-(void)setListArray:(NSMutableArray *)listArray{
    _listArray = listArray;
    [self.listCollcetionView reloadData];
}

-(void)setVipCost:(NSInteger)vipCost{
    _vipCost = vipCost;
}

#pragma mark 当前页
-(void)setCurrentcatalogueId:(NSNumber *)currentcatalogueId{
    _currentcatalogueId = currentcatalogueId;
    for (NSInteger i=0; i<self.listArray.count; i++) {
        BookSelectionModel *model = self.listArray[i];
        if ([model.catalogue_id integerValue]==[currentcatalogueId integerValue]) {
            self.currentIndex = [model.sort integerValue];
        }
    }
    MyLog(@"currentIndex:%ld",(long)self.currentIndex);
    self.lastWordBtn.enabled = self.currentIndex>0;
    self.nextWordBtn.enabled = self.currentIndex<self.listArray.count;
    
    if (self.currentIndex-1==self.listArray.count) {
        self.currentIndex --;
    }
    BookSelectionModel *selModel = self.listArray[self.currentIndex-1];
    for (BookSelectionModel *model in self.listArray) {
        if ([model.catalogue_id integerValue]==[selModel.catalogue_id integerValue]) {
            model.is_selected = [NSNumber numberWithBool:YES];
        }else{
            model.is_selected = [NSNumber numberWithBool:NO];
        }
    }
    self.progress.value = (double)self.currentIndex/(double)self.listArray.count;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.currentIndex-1 inSection:0];
    [self.listCollcetionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    [self.listCollcetionView reloadData];
    
}

-(void)setProgressString:(NSString *)progressString{
    self.progressLab.text = progressString;
}

#pragma mark -- Event response
#pragma mark 上一话 下一话
-(void)showNewWordAction:(UIButton *)sender{
    if (sender.tag==0) {
        self.progress.value = 0;
    }else{
        self.progress.value = 1;
    }
    MyLog(@"value:%.f",self.progress.value);
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.progress.value*(self.listArray.count-1) inSection:0];
    [self.listCollcetionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
}

#pragma mark 滑动
-(void)setListProgressAction:(UISlider *)sender{
    MyLog(@"value:%.f",sender.value);
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:sender.value*(self.listArray.count-1) inSection:0];
    [self.listCollcetionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
}

#pragma mark -- Getters
#pragma mark 滚动
-(UICollectionView *)listCollcetionView{
    if (!_listCollcetionView) {
         // 1.创建流水布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(134, 120);
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 0);

        _listCollcetionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10,kScreenWidth, 120) collectionViewLayout:layout];
        _listCollcetionView.delegate = self;
        _listCollcetionView.dataSource = self;
        _listCollcetionView.backgroundColor = [UIColor whiteColor];
        _listCollcetionView.showsHorizontalScrollIndicator = NO;
        [_listCollcetionView registerClass:[BookListCollectionViewCell class] forCellWithReuseIdentifier:@"BookListCollectionViewCell"];
    }
    return _listCollcetionView;
}

#pragma mark 上一话
-(UIButton *)lastWordBtn{
    if (!_lastWordBtn) {
        _lastWordBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.listCollcetionView.bottom+5, 30, 30)];
        [_lastWordBtn setImage:[UIImage drawImageWithName:@"cartoon_last_chapter" size:CGSizeMake(10, 17)] forState:UIControlStateNormal];
        _lastWordBtn.tag = 0;
        [_lastWordBtn addTarget:self action:@selector(showNewWordAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lastWordBtn;
}

-(UISlider *)progress{
    if (!_progress) {
        _progress = [[UISlider alloc] initWithFrame:CGRectMake(self.lastWordBtn.right+20, self.listCollcetionView.bottom+10, kScreenWidth-120, 18)];
        _progress.minimumValue = 0.0;
        _progress.maximumValue = 1.0;
        _progress.minimumTrackTintColor = [UIColor colorWithHexString:@"#946EFF"];
        _progress.maximumTrackTintColor = [UIColor colorWithHexString:@"#D8D8D8"];
        UIImage *image = [UIImage imageNamed:@"slider_oval"];
        [_progress setThumbImage:image forState:UIControlStateNormal];
        [_progress addTarget:self action:@selector(setListProgressAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _progress;
}

#pragma mark 下一话
-(UIButton *)nextWordBtn{
    if (!_nextWordBtn) {
        _nextWordBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.progress.right+5, self.listCollcetionView.bottom+5, 30, 30)];
        [_nextWordBtn setImage:[UIImage drawImageWithName:@"cartoon_next_chapter" size:CGSizeMake(10, 17)] forState:UIControlStateNormal];
        _nextWordBtn.tag = 1;
        [_nextWordBtn addTarget:self action:@selector(showNewWordAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextWordBtn;
}

#pragma mark
-(UILabel *)progressLab{
    if (!_progressLab) {
        _progressLab = [[UILabel alloc] initWithFrame:CGRectMake(10, self.nextWordBtn.bottom, kScreenWidth-20, 14)];
        _progressLab.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
        _progressLab.font = [UIFont regularFontWithSize:11.0f];
        _progressLab.textAlignment = NSTextAlignmentCenter;
    }
    return _progressLab;
}

@end
