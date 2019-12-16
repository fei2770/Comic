//
//  FooterRecommandView.m
//  Comic
//
//  Created by vision on 2019/11/22.
//  Copyright © 2019 vision. All rights reserved.
//

#import "FooterRecommandView.h"
#import "FootBookCollectionViewCell.h"

@interface FooterRecommandView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UIView           *lineView;
@property (nonatomic,strong) UILabel          *titleLab;
@property (nonatomic,strong) UIButton         *recommandBtn;
@property (nonatomic,strong) UICollectionView *booksCollectionView;



@end

@implementation FooterRecommandView

-(instancetype)initWithFrame:(CGRect)frame isRecommanded:(BOOL)isRecommanded{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        if (isRecommanded) {
            [self addSubview:self.recommandBtn];
        }else{
            [self addSubview:self.lineView];
            [self addSubview:self.titleLab];
        }
        [self addSubview:self.booksCollectionView];
    }
    return self;
}

#pragma mark UICollectionViewDataSource and UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.booksArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FootBookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FootBookCollectionViewCell" forIndexPath:indexPath];
    FooterBookModel *model = self.booksArray[indexPath.row];
    cell.bookModel = model;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FooterBookModel *model = self.booksArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(footerRecommandViewDidSelectedBook:)]) {
        [self.delegate footerRecommandViewDidSelectedBook:model];
    }
}

-(void)setBooksArray:(NSMutableArray *)booksArray{
    _booksArray = booksArray;
    [self.booksCollectionView reloadData];
}

#pragma mark -- Getters
#pragma mark 线
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 4, 17)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#915AFF"];
        [_lineView setBorderWithCornerRadius:2 type:UIViewCornerTypeAll];
    }
    return _lineView;
}

#pragma mark 标题
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.lineView.right+5, 18, kScreenWidth-50,20)];
        _titleLab.font = [UIFont mediumFontWithSize:17.0f];
        _titleLab.textColor = [UIColor commonColor_black];
        _titleLab.text = @"Yang sedang dilihat orang lain";
    }
    return _titleLab;
}

-(UIButton *)recommandBtn{
    if (!_recommandBtn) {
        _recommandBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 220, 18)];
        [_recommandBtn setImage:[UIImage imageNamed:@"bookcity_recommend"] forState:UIControlStateNormal];
        [_recommandBtn setTitle:@"Rekomendasi untukmu" forState:UIControlStateNormal];
        [_recommandBtn setTitleColor:[UIColor commonColor_black] forState:UIControlStateNormal];
        _recommandBtn.titleLabel.font = [UIFont mediumFontWithSize:17];
        _recommandBtn.adjustsImageWhenHighlighted = NO;
        _recommandBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    }
    return _recommandBtn;
}

#pragma mark 推荐书籍
-(UICollectionView *)booksCollectionView{
    if (!_booksCollectionView) {
        // 1.创建流水布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(100, 160);
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
        
        _booksCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,self.titleLab.bottom+10,kScreenWidth,170) collectionViewLayout:layout];
        _booksCollectionView.delegate = self;
        _booksCollectionView.dataSource = self;
        _booksCollectionView.backgroundColor = [UIColor whiteColor];
        _booksCollectionView.showsHorizontalScrollIndicator = NO;
        [_booksCollectionView registerClass:[FootBookCollectionViewCell class] forCellWithReuseIdentifier:@"FootBookCollectionViewCell"];
    }
    return _booksCollectionView;
}


@end
